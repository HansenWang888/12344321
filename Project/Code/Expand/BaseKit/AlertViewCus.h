//
//  AlertViewCus.h
//  Project
//
//  Created by fy on 2019/1/21.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertViewCus : UIView
@property (nonatomic ,strong) UILabel *textLabel;
+ (AlertViewCus *)createInstanceWithView:(UIView *)superView;
-(void)showWithText:(NSString *)text button:(NSString *)buttonTitle callBack:(CallbackBlock)block;//block返回 @0   @1
-(void)showWithText:(NSString *)text button1:(NSString *)buttonTitle1 button2:(NSString *)buttonTitle2 callBack:(CallbackBlock)block;
@end
