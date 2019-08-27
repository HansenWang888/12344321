//
//  ReportForms2ViewController.m
//  Project
//
//  Created by fy on 2019/1/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ReportForms2ViewController.h"
#import "ExchangeBtnView.h"
#import "ActivityView.h"
#import "ReportFormsView.h"
#import "MyReportFormsView.h"

@interface ReportForms2ViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)ExchangeBtnView *exchangeBtnView;
@property(nonatomic,strong)UIScrollView *scrollView;

@end

@implementation ReportForms2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTranslucent:NO];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.title = @"查看详情";
    WEAK_OBJ(weakSelf, self);
    if(self.isAgent){
        ExchangeBtnView *btnView = [[ExchangeBtnView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        btnView.btnTitleArray = @[@"个人报表",@"代理报表"];
        btnView.callbackBlock = ^(id object) {
            NSInteger tag = [object integerValue];
            [weakSelf selectIndex:tag];
        };
        [self.view addSubview:btnView];
        self.exchangeBtnView = btnView;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, btnView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - btnView.frame.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        [self.view addSubview:scrollView];
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width *2, scrollView.frame.size.height);
        self.scrollView = scrollView;
        
//        ActivityView *activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, scrollView.frame.size.height)];
//        activityView.userId = self.userId;
//        activityView.hiddenGetRewardBtn = YES;
//        [scrollView addSubview:activityView];
        
        MyReportFormsView *myReportFormsView = [[MyReportFormsView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, scrollView.frame.size.height)];
        myReportFormsView.userId = self.userId;
        [scrollView addSubview:myReportFormsView];
        
        ReportFormsView *reportFormsView = [[ReportFormsView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, scrollView.frame.size.height)];
        reportFormsView.userId = self.userId;
        [scrollView addSubview:reportFormsView];
    }else{
//        ActivityView *activityView = [[ActivityView alloc] init];
//        [self.view addSubview:activityView];
//        activityView.hiddenGetRewardBtn = YES;
//        [activityView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
//        }];
//        activityView.userId = self.userId;
        self.title = @"个人报表";
        MyReportFormsView *myReportFormsView = [[MyReportFormsView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        myReportFormsView.userId = self.userId;
        [self.view addSubview:myReportFormsView];
        [myReportFormsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
}

-(void)selectIndex:(NSInteger)index{
    [self.scrollView setContentOffset:CGPointMake(index * self.view.frame.size.width, 0) animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(delayOffset) withObject:nil afterDelay:0.3];
}

-(void)delayOffset{
    CGPoint point = self.scrollView.contentOffset;
    float i = (point.x + 30)/self.view.frame.size.width;
    [self.exchangeBtnView setSelectIndex:i];
}
@end
