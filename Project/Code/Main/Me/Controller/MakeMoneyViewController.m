//
//  MakeMoneyViewController.m
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "MakeMoneyViewController.h"
#import "WXShareModel.h"
#import "WXManage.h"

@interface MakeMoneyViewController (){
    UIView *_guideView;
    UITableView *_tableView;
}

@end

@implementation MakeMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
    [self initLayout];
}

#pragma mark ----- Data
- (void)initData{
    
}

#pragma mark ----- Layout
- (void)initLayout{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_guideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(CD_Scal(15, 667));
        make.right.equalTo(self.view).offset(CD_Scal(-15, 667));
        //        make.height.equalTo(self->_guideView.mas_width).multipliedBy(1.236);
        make.height.equalTo(@(CD_Scal(443, 667)));
        make.top.equalTo(self->_tableView.mas_top).offset(CD_Scal(25, 667));
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    self.navigationItem.title = @"分享赚钱";
    
    _tableView = [UITableView normalTable];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = MBTNColor;
    
    _guideView = [UIView new];
    _tableView.tableHeaderView = _guideView;
    _guideView.backgroundColor = CDCOLOR(246, 246, 245);
    _guideView.layer.cornerRadius = 8.0f;
    _guideView.layer.masksToBounds = YES;
    _guideView.clipsToBounds = YES;
    
    UIImageView *lheadIcon = [UIImageView new];
    [_guideView addSubview:lheadIcon];
    lheadIcon.layer.cornerRadius = CD_Scal(40, 667)/2;
    lheadIcon.layer.masksToBounds = YES;
    [lheadIcon cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:APP_MODEL.userInfo.avatar]] placeholderImage:[UIImage imageNamed:@"user-default"]];
//    lheadIcon.backgroundColor = [UIColor randColor];
    
    [lheadIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self-> _guideView.mas_left).offset(CD_Scal(20, 667));
        make.top.equalTo(self-> _guideView.mas_top).offset(CD_Scal(16, 667));
        make.height.width.equalTo(@(CD_Scal(40, 667)));
    }];
    
    UIImageView *backImage = [UIImageView new];
    [_guideView addSubview:backImage];
    backImage.image = [[UIImage imageNamed:@"my-paopao"] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
    
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lheadIcon.mas_right);
        make.right.equalTo(self->_guideView.mas_right).offset(-12);
        make.height.equalTo(@80);
        //        make.height.equalTo(@(ScalValue(69, 667)));
        make.top.equalTo(self-> _guideView.mas_top).offset(CD_Scal(11, 667));
    }];
    
    UILabel *title = [UILabel new];
    [backImage addSubview:title];
    title.font = [UIFont systemFontOfSize2:16];
    title.text = [FUNCTION_MANAGER getApplicationName];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImage).offset(20);
        make.top.equalTo(backImage).offset(12);
    }];
    
//    UIImageView *rheadIcon = [UIImageView new];
//    [backImage addSubview:rheadIcon];
//    rheadIcon.layer.cornerRadius = CD_Scal(40, 667)/2;
//    rheadIcon.layer.masksToBounds = YES;
//    [rheadIcon cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:APP_MODEL.user.avatar]] placeholderImage:[UIImage imageNamed:@"user-default"]];
//
//    [rheadIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(backImage.mas_right).offset(CD_Scal(-20, 667));
//        make.bottom.equalTo(backImage.mas_bottom).offset(CD_Scal(-11, 667));
//        make.height.width.equalTo(@(CD_Scal(40, 667)));
//    }];
    NSDictionary *dic = APP_MODEL.commonInfo;
    UILabel *desc = [UILabel new];
    [backImage addSubview:desc];
    desc.font = [UIFont systemFontOfSize2:14];
    desc.text = dic[@"share.content"];
    desc.numberOfLines = 0;
    desc.textColor = [UIColor lightGrayColor];
    
    [desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title.mas_left);
        make.right.equalTo(backImage);
        make.top.equalTo(title.mas_bottom).offset(CD_Scal(2, 667));
        make.bottom.equalTo(backImage);
    }];
    
    UIView *qrView = [UIView new];
    [_guideView addSubview:qrView];
    qrView.backgroundColor = [UIColor whiteColor];
    
    [qrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImage.mas_bottom).offset(CD_Scal(10, 667));
        make.left.bottom.right.equalTo(self->_guideView);
    }];
    
    UILabel *lb4 = [UILabel new];
    [qrView addSubview:lb4];
    lb4.font = [UIFont boldSystemFontOfSize:16];
    lb4.textColor = [UIColor lightGrayColor];
    lb4.text = [NSString stringWithFormat:@"邀请码：%@",APP_MODEL.userInfo.invitecode];// ;
    lb4.textColor = MBTNColor;
    
    [lb4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(qrView.mas_centerX);
        make.bottom.equalTo(qrView.mas_bottom).offset(-7);
    }];
    
    UILabel *lb3 = [UILabel new];
    [qrView addSubview:lb3];
    lb3.font = [UIFont systemFontOfSize2:14];
    lb3.textColor = [UIColor lightGrayColor];
    lb3.text = @"下载完成输入以下邀请码进入";
    
    [lb3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(qrView.mas_centerX);
        make.bottom.equalTo(lb4.mas_top).offset(-7);
    }];
    
    UILabel *lb2 = [UILabel new];
    [qrView addSubview:lb2];
    lb2.font = [UIFont systemFontOfSize2:14];
    lb2.textColor = [UIColor lightGrayColor];
    lb2.text = @"安卓用户选择官方下载";
    
    [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(qrView.mas_centerX);
        make.bottom.equalTo(lb3.mas_top).offset(-5);
    }];
    
    UILabel *lb1 = [UILabel new];
    [qrView addSubview:lb1];
    lb1.text = @"扫一扫选择浏览器下载";
    lb1.font = [UIFont systemFontOfSize2:16];
    
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(qrView.mas_centerX);
        make.bottom.equalTo(lb2.mas_top).offset(-5);
    }];
    
    UIImageView *qrImage = [UIImageView new];
    qrImage.contentMode = UIViewContentModeScaleAspectFit;
    [qrView addSubview:qrImage];
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",APP_MODEL.commonInfo[@"share.url"],APP_MODEL.userInfo.invitecode];
    qrImage.image = CD_QrImg(shareUrl, 360);//CD_QrImg(@"www.baidu.com", CD_Scal(200, 667));
    
    NSInteger wid = 15;
    if(SCREEN_HEIGHT <= 667)
        wid = 7;
    [qrImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(qrView.mas_centerX);
        make.left.equalTo(qrView).offset(wid);
        make.right.equalTo(qrView).offset(-wid);
        make.top.equalTo(qrView.mas_top).offset(wid);
        make.bottom.equalTo(lb1.mas_top).offset(-wid);
    }];
    
    UILabel *share = [UILabel new];
    [self.view addSubview:share];
    share.textColor = [UIColor whiteColor];
    share.text = @"分享到";
    share.font = [UIFont systemFontOfSize2:15];
    
    [share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self-> _guideView.mas_bottom).offset(CD_Scal(21, 667));
    }];
    
    UIView *llineView = [UIView new];
    [self.view addSubview:llineView];
    llineView.backgroundColor = [UIColor whiteColor];
    
    [llineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(CD_Scal(15, 667));
        make.right.greaterThanOrEqualTo(share.mas_left).offset(-CD_Scal(15, 667));
        make.height.equalTo(@(1.0f));
        make.centerY.equalTo(share.mas_centerY);
    }];
    
    UIView *rlineView = [UIView new];
    [self.view addSubview:rlineView];
    rlineView.backgroundColor = [UIColor whiteColor];
    
    [rlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-CD_Scal(15, 667));
        make.left.equalTo(share.mas_right).offset(CD_Scal(15, 667));
        make.height.equalTo(@(1.0f));
        make.centerY.equalTo(share.mas_centerY);
    }];
    
    UIButton *wxFriend = [UIButton new];
    [self.view addSubview:wxFriend];
    [wxFriend addTarget:self action:@selector(action_shareWX) forControlEvents:UIControlEventTouchUpInside];
    [wxFriend setBackgroundImage:[UIImage imageNamed:@"s-wx"] forState:UIControlStateNormal];
    [wxFriend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).multipliedBy(0.5);
        make.top.equalTo(llineView.mas_bottom).offset(CD_Scal(24, 667));
        make.height.width.equalTo(@(CD_Scal(40, 667)));
    }];
    
    UILabel *wl = [UILabel new];
    [self.view addSubview:wl];
    wl.text = @"微信";
    wl.font = [UIFont systemFontOfSize2:12];
    wl.textColor = Color_F;
    
    [wl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wxFriend);
        make.top.equalTo(wxFriend.mas_bottom).offset(CD_Scal(4, 667));
    }];
    
    UIButton *savePhoto = [UIButton new];
    [self.view addSubview:savePhoto];
    [savePhoto addTarget:self action:@selector(action_saveImg) forControlEvents:UIControlEventTouchUpInside];
//    savePhoto.backgroundColor = [UIColor randColor];
    [savePhoto setBackgroundImage:[UIImage imageNamed:@"s-photo"] forState:UIControlStateNormal];
    [savePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(llineView.mas_bottom).offset(CD_Scal(24, 667));
        make.height.width.equalTo(@(CD_Scal(40, 667)));
    }];
    
    UILabel *sp = [UILabel new];
    [self.view addSubview:sp];
    sp.text = @"保存到手机";
    sp.font = [UIFont systemFontOfSize2:12];
    sp.textColor = Color_F;
    
    [sp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(savePhoto);
        make.top.equalTo(savePhoto.mas_bottom).offset(CD_Scal(4, 667));
    }];
    
    UIButton *wxRand = [UIButton new];
    [self.view addSubview:wxRand];
    [wxRand addTarget:self action:@selector(action_shareRand) forControlEvents:UIControlEventTouchUpInside];
    [wxRand setBackgroundImage:[UIImage imageNamed:@"s-wxrand"] forState:UIControlStateNormal];
//    wxRand.backgroundColor = [UIColor randColor];
    
    [wxRand mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).multipliedBy(1.5);
        make.top.equalTo(llineView.mas_bottom).offset(CD_Scal(24, 667));
        make.height.width.equalTo(@(CD_Scal(40, 667)));
    }];
    
    UILabel *wr = [UILabel new];
    [self.view addSubview:wr];
    wr.text = @"朋友圈";
    wr.font = [UIFont systemFontOfSize2:12];
    wr.textColor = Color_F;
    
    [wr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wxRand);
        make.top.equalTo(wxRand.mas_bottom).offset(CD_Scal(4, 667));
    }];
}

#pragma mark action
- (void)action_shareWX{
    WXShareModel *model = [[WXShareModel alloc]init];
    model.title = WXShareTitle;
    model.imageIcon = [UIImage imageNamed:[FUNCTION_MANAGER getAppIconName]];;
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",APP_MODEL.commonInfo[@"share.url"],APP_MODEL.userInfo.invitecode];
    model.link = shareUrl;
    model.content = WXShareDescription;
    model.WXShareType = WXSceneTimeline;
//    [[WXManage shareInstance] wxShareObj:model Success:^{
//        SVP_SUCCESS_STATUS(@"已分享到微信");
//    } Failure:^(NSError *error) {
//
//    }];
}

- (void)action_shareRand{
    WXShareModel *model = [[WXShareModel alloc]init];
    model.title = WXShareTitle;
    model.imageIcon = [UIImage imageNamed:[FUNCTION_MANAGER getAppIconName]];;
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",APP_MODEL.commonInfo[@"share.url"],APP_MODEL.userInfo.invitecode];
    model.link = shareUrl;
    model.content = WXShareDescription;
    model.WXShareType = WXSceneSession;
//    [[WXManage shareInstance] wxShareObj:model Success:^{
//        SVP_SUCCESS_STATUS(@"已分享到微信");
//    } Failure:^(NSError *error) {
//        
//    }];
}

- (void)action_saveImg{
    [self loadImageFinished:CD_Shot(self.view)];
}

- (void)loadImageFinished:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
//    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    
    if(error != NULL){
        SVP_ERROR_STATUS(@"保存图片失败");
    }else{
        SVP_SUCCESS_STATUS(@"保存图片成功");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
