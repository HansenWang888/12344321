//
//  WebViewController.m
//  KamSun
//
//  Created by hzx on 14-9-3.
//  Copyright (c) 2014年 Coffee. All rights reserved.
//

#import "WebViewController2.h"

@interface WebViewController2 ()<UIWebViewDelegate>{
    UIActivityIndicatorView *_indicatorView;
}
@property(nonatomic,copy)NSString *url;
@property(nonatomic,strong)UIImageView *qrCodeView;
@end

@implementation WebViewController2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *openBySafariBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [openBySafariBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    openBySafariBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
    [openBySafariBtn setTitle:@"Safari" forState:UIControlStateNormal];
    [openBySafariBtn addTarget:self action:@selector(openBySafari) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:openBySafariBtn];
    self.navigationItem.rightBarButtonItems = @[item];
}

-(void)loadWithURL:(NSString *)url{
    self.url = url;
    if(_webView == nil){
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    NSURL *u = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:u];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:u];
//    if([AppModel shareInstance].user.fullToken)
//        [request setValue:[AppModel shareInstance].user.fullToken forHTTPHeaderField:@"Authorization"];
    [_webView scalesPageToFit];
    [_webView loadRequest:request];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, self.view.frame.size.height)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    if(_indicatorView == nil){
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake((self.view.frame.size.width - 20)/2.0, (self.view.frame.size.height - 20)/2.0 - 40, 20, 20);
        indicator.autoresizingMask = UIViewAutoresizingNone;
        [indicator startAnimating];
        _indicatorView = indicator;
        [self.view addSubview:indicator];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if(_indicatorView){
        [_indicatorView stopAnimating];
        [_indicatorView removeFromSuperview];
        _indicatorView = nil;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = request.URL.absoluteString;
    NSLog(@"------|%@",url);
    return YES;

    if([url containsString:@"qr.alipay"]){
        if(_indicatorView){
            [_indicatorView stopAnimating];
            [_indicatorView removeFromSuperview];
            _indicatorView = nil;
        }
    }else if([url containsString:@"qrcode="]){
        NSArray *arr = [url componentsSeparatedByString:@"&"];
        for (NSString *s in arr) {
            if([s containsString:@"qrcode="]){
                NSRange range = [s rangeOfString:@"qrcode="];
                NSString *qrcode = [s substringFromIndex:range.location + range.length];
                if(qrcode){
                    UIImage *image = CD_QrImg(qrcode, 220);
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    [self.view addSubview:imageView];
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.view);
                        make.centerY.equalTo(self.view).offset(-70);
                    }];
                    self.qrCodeView = imageView;
                    _webView.hidden = YES;
                    UIButton *lbtn = [UIButton new];
                    [self.view addSubview:lbtn];
                    lbtn.layer.cornerRadius = 8;
                    lbtn.layer.masksToBounds = YES;
                    lbtn.backgroundColor = MBTNColor;
                    lbtn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
                    [lbtn setTitle:@"保存到相册" forState:UIControlStateNormal];
                    [lbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [lbtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
                    [lbtn delayEnable];
                    [lbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@180);
                        make.top.equalTo(imageView.mas_bottom).offset(30);
                        make.centerX.equalTo(self.view);
                        make.height.equalTo(@(44));
                    }];
                    
                    UILabel *tipLabel = [UILabel new];
                    [self.view addSubview:tipLabel];
                    tipLabel.font = [UIFont systemFontOfSize2:12];
                    tipLabel.numberOfLines = 0;
                    tipLabel.textColor = Color_6;
                    tipLabel.text = @"如果支付失败：\n1、保存此二维码到相册，在支付宝扫一扫中打开此二维码进行支付\n2、点击右上角按钮，尝试从浏览器打开支付";
                    [tipLabel setValue:@(20) forKey:@"lineSpacing"];
                    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.view.mas_left).offset(18);
                        make.right.equalTo(self.view.mas_right).offset(-18);
                        make.top.equalTo(lbtn.mas_bottom).offset(0);
                        make.height.equalTo(@80);
                    }];
                }else{
                    UILabel *tipLabel = [UILabel new];
                    [self.view addSubview:tipLabel];
                    tipLabel.font = [UIFont systemFontOfSize2:13];
                    tipLabel.numberOfLines = 0;
                    tipLabel.textColor = Color_6;
                    tipLabel.text = @"如果支付失败，也可点击右上角按钮，尝试从浏览器打开支付";
                    [tipLabel setValue:@(20) forKey:@"lineSpacing"];
                    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.view.mas_left).offset(18);
                        make.right.equalTo(self.view.mas_right).offset(-18);
                        make.top.equalTo(self.view).offset(0);
                    }];
                }
            }
        }
    }
    return YES;
}

- (void)action_info {
//    NSLog(@"111111");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if(_indicatorView){
        [_indicatorView stopAnimating];
        [_indicatorView removeFromSuperview];
        _indicatorView = nil;
    }
    //[self showTipWithStr:@"加载失败"];
}

-(void)openBySafari{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.url]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.url]];
    }
}

-(void)save{
    UIImageWriteToSavedPhotosAlbum(self.qrCodeView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error == nil)
        SVP_SUCCESS_STATUS(@"保存成功");
    else
        [[FunctionManager sharedInstance] handleFailResponse:error];
}

-(void)viewDidDisappear:(BOOL)animated{
    [NET_REQUEST_MANAGER requestUserInfoWithSuccess:nil fail:nil];
}
@end
