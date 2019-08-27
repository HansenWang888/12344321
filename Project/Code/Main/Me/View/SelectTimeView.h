//
//  SelectTimeView.h
//  Project
//
//  Created by fy on 2019/1/10.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    TimeRange_today = 1,
    TimeRange_yesterday,
    TimeRange_thisWeek,
    TimeRange_lastWeek,
    TimeRange_thisMonth,//这个月
    TimeRange_lastMonth,//上个月
}TimeRange;

@interface SelectTimeView : UIView<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,copy)CallbackBlock selectBlock;
+ (SelectTimeView *)sharedInstance;
-(void)removeSelf;
@end

NS_ASSUME_NONNULL_END
