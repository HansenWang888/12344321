//
//  WDDetailViewController.m
//  Project
//
//  Created by fangyuan on 2019/2/27.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "WDDetailViewController.h"

@interface WDDetailViewController ()

@end

@implementation WDDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现详情";
    self.view.backgroundColor = BaseColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTranslucent:NO];
    // Do any additional setup after loading the view from its nib.
    //self.scrollView.frame = self.view.bounds;
    [self fill];
}

-(void)fill{
    self.moneyLabel.text = [self.infoDic[@"money"] stringValue];
    self.money2Label.text = [self.infoDic[@"money"] stringValue];
    self.descLabel.text = self.infoDic[@"title"];
    self.orderLabel.text = self.infoDic[@"cashNo"];
    self.bankLabel.text = self.infoDic[@"bankName"];
    self.statusLabel.text = self.infoDic[@"strStatus"];
    self.time1Label.text = self.infoDic[@"createTime"];
    NSString *ot = self.infoDic[@"operatorTime"];
    if([ot isKindOfClass:[NSNull class]])
        ot = nil;
    if(ot.length == 0)
        ot = @"无";
    self.time2Label.text = ot;
    NSString *cause = self.infoDic[@"cause"];
    if([cause isKindOfClass:[NSNull class]])
        cause = nil;
    if(cause.length > 1)
        self.remarkLabel.text = cause;
    else
        self.remarkLabel.text = @"无";
    CGRect rectt = self.remarkLabel.frame;
    rectt.size.width = SCREEN_WIDTH - 151;
    self.remarkLabel.frame = rectt;
    CGSize size = [[FunctionManager sharedInstance] getFitSizeWithLabel:self.remarkLabel];
    rectt.size.height = size.height;
    self.remarkLabel.frame = rectt;
    NSInteger bottom = self.remarkLabel.frame.size.height + self.remarkLabel.frame.origin.y;
    UIView *view = self.remarkLabel.superview;
    CGRect rect = view.frame;
    rect.size.height = bottom + 20;
    view.frame = rect;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, view.frame.size.height + view.frame.origin.y + 33);
}
@end
