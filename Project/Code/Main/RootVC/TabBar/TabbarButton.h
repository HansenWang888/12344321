//
//  TabbarButton.h
//  Project
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabbarButton : UIButton

@property(nonatomic,strong)UIImageView *iconImg;
@property (nonatomic ,strong) UIImage *normalImg;
@property (nonatomic ,strong) UIImage *selectImg;

@property (nonatomic ,strong) UIColor *normalColor;
@property (nonatomic ,strong) UIColor *selectColor;

@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) NSString *badeValue;
@property (nonatomic ,strong) UIColor *badeColor;
@property (nonatomic ,assign) BOOL tabbarSelected;
@property (nonatomic ,assign)float scaleX;
@property (nonatomic ,assign)float scaleY;

@property (nonatomic ,assign) NSInteger animationType;
+ (TabbarButton *)tabbar;

//- (void)setSelected:(BOOL)selected;

@end
