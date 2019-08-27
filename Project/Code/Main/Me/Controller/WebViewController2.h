//
//  WebViewController.h
//  KamSun
//
//  Created by hzx on 14-9-3.
//  Copyright (c) 2014年 Coffee. All rights reserved.
//

@interface WebViewController2 : SuperViewController{
    UIWebView *_webView;
}

-(void)loadWithURL:(NSString *)url;
@end
