//
//  WebViewController.h
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WebProgressView.h"

@interface WebViewController : SuperViewController{
    NSString *_url;
}
@property(nonatomic,assign)BOOL isForceEscapeWebVC;
@property(nonatomic,strong)WKWebView *webView;
- (void)actionBlock:(DataBlock)block;
- (instancetype)initWithUrl:(NSString *)url;
- (instancetype)initWithUrl:(NSString *)url withBodyDictionary:(NSDictionary *)params;
- (instancetype)initWithHtmlString:(NSString *)string;

@end
