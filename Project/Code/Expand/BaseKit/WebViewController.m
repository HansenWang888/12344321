//
//  WebViewController.m
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<WKUIDelegate,WKNavigationDelegate,UINavigationBarDelegate>{
    WebProgressView *_progress;
    NSString *_htmlString;
    NSDictionary *_params;
}
@property (nonatomic, copy) ActionBlock block;
@end

@implementation WebViewController
- (void)actionBlock:(ActionBlock)block{
    self.block = block;
    
}
-(void)removeAndBack{
    
    if (self.isForceEscapeWebVC) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.block) {
            self.block(@1);
        }
    }
    else{
        if ([_webView canGoBack]) {
            [_webView goBack];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            if (self.block) {
                self.block(@1);
            }
        }
    }
    
}

- (instancetype)initWithUrl:(NSString *)url{
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (instancetype)initWithHtmlString:(NSString *)string{
    self = [super init];
    if (self) {
        _htmlString = string;
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)url withBodyDictionary:(NSDictionary*)params{
    self = [super init];
    if (self) {
        _url = url;
        _params = params;
    }
    return self;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_progress removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initSubviews];
    [self initLayout];
    
    UIButton *openBySafariBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [openBySafariBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    openBySafariBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
    [openBySafariBtn setTitle:@"Safari" forState:UIControlStateNormal];
    //[openBySafariBtn setImage:[UIImage imageNamed:@"safari"] forState:UIControlStateNormal];
    [openBySafariBtn addTarget:self action:@selector(openBySafari) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:openBySafariBtn];
    self.navigationItem.rightBarButtonItems = @[item];
}

#pragma mark Data
- (void)initData{
    
}

#pragma mark subView
- (void)initSubviews{
    
    //    UIBarButtonItem *leftItem = self.navigationItem.backBarButtonItem;
    
    _webView = [[WKWebView alloc]init];
    [self.view addSubview:_webView];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.backgroundColor = CDCOLOR(245, 245, 245);
    
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress"options:NSKeyValueObservingOptionNew context:NULL];
    
    CGRect frame = self.navigationController.navigationBar.bounds;
    _progress = [[WebProgressView alloc]initWithFrame:CGRectMake(0, frame.size.height-2, frame.size.width, 2)];
    [self.navigationController.navigationBar addSubview:_progress];
    [_progress setProgress:0 animated:NO];
}

#pragma mark Layout
- (void)initLayout{
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    if (_url.length) {
        [self loadUrl];
    }
    if (_htmlString) {
        [self loadHtml];
    }
    if (_url.length>0&&
        _params) {
        [self postUrl];
    }
    
}

- (void)loadUrl{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];
    [_webView loadRequest:req];
}

- (void)loadHtml{
    [_webView loadHTMLString:_htmlString baseURL:nil];
}

- (void)postUrl{
    NSURL *url = [NSURL URLWithString: _url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
//    NSString *body = @"";
//    for (NSString *key in _params.allKeys) {
//        if ([FunctionManager isEmpty:body]) {
//            body = [NSString stringWithFormat:@"%@=%@",key,_params[key]];
//        }else{
//            body = [NSString stringWithFormat:@"%@&%@=%@",body,key,_params[key]];
//        }
//    }
    request.timeoutInterval = 30;
//    NSData * bodyData   = [NSJSONSerialization dataWithJSONObject:_params options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *body = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
//    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:_params options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:bodyData];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:[AppModel shareInstance].userInfo.fullToken forHTTPHeaderField:@"Authorization"];
    [request setValue:GetUserDefaultWithKey(@"mobile") forHTTPHeaderField:@"userName"];
    [request setValue:[[FunctionManager sharedInstance] getApplicationVersion] forHTTPHeaderField:@"appVersion"];
    [request setValue:kNewTenant forHTTPHeaderField:@"tenant"];
    [request setValue:@"APP" forHTTPHeaderField:@"type"];
    [_webView loadRequest: request];
}

- (BOOL)navigationShouldPopOnBackButton {
    BOOL cangoBack = [_webView canGoBack];
    if (cangoBack) {
        [_webView goBack];
        return NO;
    }
    else{
        CDPop(self.navigationController, YES);
        return YES;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        //        NSLog(@"%.2f",_webView.estimatedProgress);
        [_progress setProgress:_webView.estimatedProgress animated:YES];
    }
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [_progress setProgress:0 animated:NO];
    //self.navigationItem.title = webView.title;
    //    NSLog(@"%@",webView.title);
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    self.navigationItem.title = @"加载失败，请检查网络";
    [_progress setProgress:0 animated:NO];
}

- (void)dealloc {
    [_progress removeFromSuperview];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

-(void)openBySafari{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_url]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
    }
}
@end
