//
//  BillHeadView.h
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TimeBlock)(id);
typedef void (^TypeBlock)(NSInteger type);

@interface BillHeadView : UIView<ActionSheetDelegate>

+ (BillHeadView *)headView:(BOOL)isAll;

@property (nonatomic ,copy) TimeBlock beginChange;
@property (nonatomic ,copy) TimeBlock endChange;
@property (nonatomic ,copy) TypeBlock TypeChange;
@property (nonatomic ,copy) NSString *beginTime;
@property (nonatomic ,copy) NSString *endTime;
@property(nonatomic,strong)NSMutableArray *billTypeList;
@property (nonatomic,strong)UILabel *balanceLabel;
@property(nonatomic,assign)BOOL isAll;
- (instancetype)initWithFrame:(CGRect)frame isAll:(BOOL)isAll;
@end
