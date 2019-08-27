//
//  ShareDetailViewController.m
//  Project
//
//  Created by fy on 2019/1/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ShareDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "WXManage.h"
#import "WXShareModel.h"

@interface ShareDetailViewController ()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIImage *shareImage;

@end

@implementation ShareDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    // Do any additional setup after loading the view.
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = self.view.bounds;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(15, 15, self.view.frame.size.width - 30, self.view.frame.size.height - 30);
    self.imageView = imageView;
    [self.scrollView addSubview:imageView];
    WEAK_OBJ(weakSelf, self);
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.shareInfo[@"firstAvatar"]] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf resetImageView];
    }];

    [self createShareMenu];
    
    [NET_REQUEST_MANAGER addShareCountWithId:[[self.shareInfo objectForKey:@"id"] integerValue] success:nil fail:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序,(把程序放在后台执行其他操作)
}

-(void)resetImageView{
    UIImage *img = self.imageView.image;
    if(img == nil)
        return;
    self.imageView.frame = CGRectMake(0, 0,img.size.width, img.size.height);
    float qrWith = img.size.width * 0.230;
    UIImageView *qrImage = [UIImageView new];
    qrImage.contentMode = UIViewContentModeScaleAspectFit;
    NSString *shareUrl = self.shareUrl;
    qrImage.image = CD_QrImg(shareUrl, qrWith);
    qrImage.layer.masksToBounds = YES;
    qrImage.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
    qrImage.layer.borderWidth = 2.0;
    NSString *qrCodeFrame = self.shareInfo[@"codeImageFrame"];
    if(qrCodeFrame){
        NSArray *arr = [qrCodeFrame componentsSeparatedByString:@","];
        CGRect rect = CGRectMake([arr[0] integerValue], [arr[1] integerValue], [arr[2] integerValue], [arr[3] integerValue]);
        qrImage.frame = rect;
    }else
        qrImage.frame = CGRectMake((self.imageView.frame.size.width - qrWith)/2.0, 1010, qrWith, qrWith);
    [self.imageView addSubview:qrImage];
    
    NSInteger labelFontSize = 54;
    
    NSInteger labelX = 180;
    if(SCREEN_WIDTH == 320)
        labelX = 160;
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize2:labelFontSize];
    [self.imageView addSubview:label];
    label.text = [NSString stringWithFormat:@"邀请码   %@",[AppModel shareInstance].userInfo.invitecode];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(1, 1);
    NSString *codeFrame = self.shareInfo[@"codeFrame"];
    if(codeFrame){
        NSArray *arr = [qrCodeFrame componentsSeparatedByString:@","];
        CGRect rect = CGRectMake([arr[0] integerValue], [arr[1] integerValue], [arr[2] integerValue], [arr[3] integerValue]);
        label.frame = rect;
    }else
        label.frame = CGRectMake(labelX, 1315, self.imageView.frame.size.width - labelX * 2, 60);
    label.textAlignment = NSTextAlignmentCenter;
    [self.imageView addSubview:qrImage];
    
    self.shareImage = [self imageWithUIView:self.imageView];
    float rate = img.size.width/img.size.height;
    float x = 15;
    float width = SCREEN_WIDTH - x * 2;
    float height = width/rate;
    float xRate = width/self.shareImage.size.width;
    self.imageView.frame = CGRectMake(x, 15,width, height);
    qrImage.frame = CGRectMake(qrImage.frame.origin.x * xRate, qrImage.frame.origin.y * xRate, qrImage.frame.size.width * xRate, qrImage.frame.size.height * xRate);
    label.frame = CGRectMake(label.frame.origin.x * xRate, label.frame.origin.y * xRate, label.frame.size.width * xRate, label.frame.size.height * xRate);
    label.font = [UIFont boldSystemFontOfSize2:labelFontSize * xRate];
    CGPoint point = CGPointMake(label.frame.origin.x + self.imageView.frame.origin.x, (label.frame.origin.y + label.frame.size.height/2.0) + self.imageView.frame.origin.y);

    NSInteger mm = self.view.frame.size.height - height;
    NSInteger h = self.view.frame.size.height - mm + 150 + 30;
    if(h <= self.scrollView.frame.size.height)
        h = self.scrollView.frame.size.height + 1;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, h);
//    [qrImage removeFromSuperview];
//    [label removeFromSuperview];
    label.textAlignment = NSTextAlignmentLeft;

    
    NSInteger btnWidth = 90;
    NSInteger btnHeight = 40;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.scrollView.frame.size.width - btnWidth - point.x, point.y - btnHeight/2.0, btnWidth, btnHeight);
    btn.backgroundColor = [UIColor clearColor];
    btn.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [btn setImage:[UIImage imageNamed:@"copyBtn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(copyCode) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:btn];
}

-(void)createShareMenu{
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@150);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = Color_0;
    label.font = [UIFont boldSystemFontOfSize2:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"分享至";
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.height.equalTo(@24);
        make.top.equalTo(view).offset(20);
    }];
    
    NSInteger startX = 10;
    NSInteger width = 70;
    NSInteger inv = (SCREEN_WIDTH - width * 4 - startX * 2)/5;
    
    UIButton *tempBtn = nil;
    NSArray *arr = @[@{@"icon":@"weixin",@"title":@"分享图片"},
                     @{@"icon":@"1weixin",@"title":@"分享链接"},
                     @{@"icon":@"pengyouquan",@"title":@"分享图片"},
                     @{@"icon":@"ppengyouquan",@"title":@"分享链接"}
                     ];
    for (NSInteger i = 0; i < arr.count; i++) {
        NSDictionary *dict = arr[i];
        UIButton *btn = [self createBtn:dict[@"icon"] title:dict[@"title"]];
        [btn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 1;
        [view addSubview:btn];
        if(tempBtn){
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width));
                make.left.equalTo(tempBtn.mas_right).offset(inv);
                make.top.equalTo(label.mas_bottom).offset(20);
            }];
        }else{
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width));
                make.left.equalTo(view).offset(inv + startX);
                make.top.equalTo(label.mas_bottom).offset(20);
            }];
        }
        tempBtn = btn;
    }
}

-(UIButton *)createBtn:(NSString *)iconName title:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    [btn addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.top.equalTo(btn);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = Color_6;
    label.font = [UIFont systemFontOfSize2:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    [btn addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(btn);
        make.top.equalTo(imageView.mas_bottom).offset(5);
    }];
    return btn;
}

#pragma mark action
-(void)shareAction:(UIButton *)btn{
    NSInteger tag = btn.tag;
    NSInteger scene = WXSceneSession;
    MediaType mediaType = MediaType_image;//图片
    if(tag == 3 || tag == 4)
        scene = WXSceneTimeline;
    if(tag == 2 || tag == 4)
        mediaType = MediaType_url;//链接
    [self shareWithMediaType:mediaType scene:scene];
}

//contentType 1图片 2链接
- (void)shareWithMediaType:(MediaType)mediaType scene:(NSInteger)scene{
    WXShareModel *model = [[WXShareModel alloc]init];
    model.WXShareType = scene;//WXSceneTimeline;
    model.title = self.shareInfo[@"title"];
    model.imageIcon = [UIImage imageNamed:[[FunctionManager sharedInstance] getAppIconName]];
    model.content = WXShareDescription;
    //CGSize size = self.shareImage.size;
    if(mediaType == MediaType_url){
//        NSString *shareUrl = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].commonInfo[@"share.url"],[AppModel shareInstance].user.invitecode];
        model.link = self.shareUrl;
        NSLog(@"url= %@",model.link);
        model.imageData = UIImageJPEGRepresentation([UIImage imageNamed:[[FunctionManager sharedInstance] getAppIconName]],1.0);
    }
    else{
        model.imageData = UIImageJPEGRepresentation(self.shareImage, 1.0);
    }
//    if([WXManage isWXAppInstalled] == NO){
//        SVP_ERROR_STATUS(@"请先安装微信");
//        return;
//    }
    WEAK_OBJ(weakSelf, self);
    [[WXManage shareInstance] wxShareObj:model mediaType:mediaType Success:^{
        //SVP_SUCCESS_STATUS(@"分享成功");
        [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf];
    } Failure:^(NSError *error) {
        [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf];
    }];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(showAlert) withObject:nil afterDelay:2.0];
}

-(void)showAlert{
    SVP_ERROR_STATUS(@"请先安装微信");
}

- (UIImage*) imageWithUIView:(UIView*) view{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}

-(void)applicationWillResignActive:(NSNotification *)notification{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(void)copyCode{
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = [AppModel shareInstance].userInfo.invitecode;
    SVP_SUCCESS_STATUS(@"复制成功");
}
@end
