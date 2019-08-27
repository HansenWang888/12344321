//
//  TopupBarView.h
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopupBarView : UIView

@property (nonatomic ,readonly) NSString *money;
@property (nonatomic ,strong) UITextField *moneyField;
+ (TopupBarView *)topupBar;

@end
