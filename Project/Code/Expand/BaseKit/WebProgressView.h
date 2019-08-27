//
//  WebProgressView.h
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebProgressView : UIView

@property (nonatomic) UIColor *progressColor;
@property (nonatomic) CGFloat proHeigh;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
