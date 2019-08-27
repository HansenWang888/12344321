//
//  PayButton.h
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayButton : UIButton

@property (nonatomic ,strong) UIImage *payImg;
@property (nonatomic ,strong) NSString *payTitle;
@property (nonatomic ,strong) UIColor *normalColor;
@property (nonatomic ,strong) UIColor *selectColor;
@property (nonatomic ,strong) UIImage *selectIcon;

- (void)cd_SetState:(BOOL)state;

@end
