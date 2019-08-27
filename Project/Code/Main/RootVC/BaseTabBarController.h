//
//  ViewController.h
//  Project
//
//  Created by zhyt on 2018/7/10.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabBarController : UITabBarController
@property(nonatomic,assign)NSInteger selectIndex;
- (void)hadSelectedIndex:(NSUInteger)index;
@end

