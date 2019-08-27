//
//  ActivityView.h
//  Project
//
//  Created by fy on 2019/1/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityView : UIView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataArray;

@property(nonatomic,strong)NSString *beginTime;
@property(nonatomic,strong)NSString *endTime;
@property(nonatomic,strong)UIButton *rightBtn;

@property(nonatomic,strong)NSString *tempBeginTime;
@property(nonatomic,strong)NSString *tempEndTime;

@property(nonatomic,assign)NSInteger selectIndex;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,assign)BOOL hiddenGetRewardBtn;
@end

NS_ASSUME_NONNULL_END
