//
//  ReportFormsView.h
//  Project
//
//  Created by fy on 2019/1/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReportFormsItem : NSObject
@property(nonatomic,strong)NSString *icon;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)NSString *desc;
@end


@interface ReportFormsView : UIView

@property(nonatomic,strong)NSString *beginTime;
@property(nonatomic,strong)NSString *endTime;

@property(nonatomic,strong)NSString *tempBeginTime;
@property(nonatomic,strong)NSString *tempEndTime;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)NSString *userId;
-(void)getData;
-(void)showTimeSelectView;
@end

NS_ASSUME_NONNULL_END
