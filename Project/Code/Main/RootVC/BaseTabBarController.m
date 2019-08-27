//
//  ViewController.m
//  Project
//
//  Created by zhyt on 2018/7/10.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "BaseTabBarController.h"
#import "TabbarButton.h"
#import "ActivityViewController.h"
#import "ActivityMainViewController.h"

@interface BaseTabBarController ()<UITabBarControllerDelegate>{
    TabbarButton *_tabbar[5];
}

// 记录上次数
@property (nonatomic,assign) NSInteger lastNum;

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initSubViewControllers];
    
    [UITabBar appearance].translucent = NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateValue:)name:kUnreadMessageNumberChange object:@"updateBadeValue"];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self test];
//    });
    
//    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 2);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [self.tabBar setBackgroundImage:img];
//    [self.tabBar setShadowImage:img];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.selectedIndex = _selectIndex;
}


#pragma mark 收到消息重新刷新
- (void)updateValue:(NSNotification *)noti {
//    NSString *info = [noti object];
//    if ([info isEqualToString:@"updateBadeValue"]) {
//
//    }
    
    BOOL isRefresh = YES;
    //
    if ((self.lastNum > 0 && [AppModel shareInstance].unReadCount > 0) || (self.lastNum == 0 && [AppModel shareInstance].unReadCount == 0)) {
        isRefresh = NO;
    }
    self.lastNum = [AppModel shareInstance].unReadCount;
    
    if (isRefresh) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_tabbar[0] setBadeValue:([AppModel shareInstance].unReadCount>0?@"1":@"null")];
        });
    }
}

- (void)initSubViewControllers{
    _selectIndex = 1;
    self.delegate = self;
    NSString *namespace = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
    
    NSArray *vcs = @[[NSString stringWithFormat:@"%@.SessionVC",namespace],@"GroupViewController",@"ActivityMainViewController",@"FYContactsController",@"MemberViewController"];

//    NSArray *vcs = @[@"MessageViewController",@"GroupViewController",@"ActivityMainViewController",@"FYContactsController",@"MemberViewController"];
    NSArray *titles = @[@"消息",@"群组",@"",@"通讯录",@"我的"];
    NSArray *nors = @[@"footer-icon-tip",@"footer-icon-group",@"tabbar2",@"tabar_find",@"footer-icon-my"];//@"footer-icon-jl"
    NSArray *ses = @[@"footer-icon-tip-on",@"footer-icon-group-on",@"tabbar1",@"tabar_find_on",@"footer-icon-my-on"];//@"footer-icon-jl-on"
    NSMutableArray *vs = [[NSMutableArray alloc]init];
    CGFloat w = (SCREEN_WIDTH - SCREEN_WIDTH * 0.1)/vcs.count;
    NSInteger m = 0;
    for (int i = 0; i<vcs.count; i++) {
        UIViewController *vc = [[NSClassFromString(vcs[i]) alloc]init];
        if([vc isKindOfClass:[ActivityViewController class]]){
            ActivityViewController *avc = (ActivityViewController *)vc;
            avc.vcTitle = titles[i];
            avc.userId = [AppModel shareInstance].userInfo.userId;
        }
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [vs addObject:nav];
        _tabbar[i] = [TabbarButton tabbar];
        
        [self.tabBar addSubview:_tabbar[i]];
        if(i == 2){
            _tabbar[i].frame = CGRectMake(m, 0, w + SCREEN_WIDTH * 0.1, 49);
            float rateY = 49/75.0;
            float rateX = (w + SCREEN_WIDTH * 0.1)/158.0;
            _tabbar[i].scaleX = rateX;
            _tabbar[i].scaleY = rateY;

        }
        else
            _tabbar[i].frame = CGRectMake(m, 0, w, 49);
        
        if(i == 2){
            _tabbar[i].iconImg.contentMode = UIViewContentModeScaleAspectFit;
            [_tabbar[i].iconImg mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self->_tabbar[i]);
                make.centerY.equalTo(self->_tabbar[i]).offset(-3);
                make.width.equalTo(@(w + SCREEN_WIDTH * 0.1 - 10));
            }];
        }
        
        _tabbar[i].title = titles[i];
        _tabbar[i].normalImg = [UIImage imageNamed:nors[i]];
        if(i != 2)
            _tabbar[i].selectImg = [UIImage imageNamed:ses[i]];
        _tabbar[i].tabbarSelected = (i == _selectIndex)?YES:NO;
        if(i == 3)
            _tabbar[i].animationType = 1;
        else if(i == 2)
            _tabbar[i].animationType = 5;
        else if(i == 0)
            _tabbar[i].animationType = 4;
        else
            _tabbar[i].animationType = 1;
        if (i == 0){
            [self updateValue:nil];
        }
        m += _tabbar[i].frame.size.width;
    }
    
    self.viewControllers = vs;
}

#pragma mark UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSUInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    if(_selectIndex == index){
        return;
    }
    [self hadSelectedIndex:index];
}
- (void)hadSelectedIndex:(NSUInteger)index{
    _tabbar[_selectIndex].tabbarSelected = NO;
    _tabbar[index].tabbarSelected = YES;
    _selectIndex = index;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
