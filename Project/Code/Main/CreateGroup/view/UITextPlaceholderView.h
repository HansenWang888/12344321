//
//  UITextPlaceholderView.h
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/7/27.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 带占位符的 UITextView
 */
@interface UITextPlaceholderView : UITextView
/** 占位文字 */
@property (nonatomic,copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic,strong) UIColor *placeholderColor;
@end


