//
//  VVAlertGroupHeaderView.m
//  ProjectXZHB
//
//  Created by Mike on 2019/3/18.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVAlertModel.h"

@class VVAlertGroupHeaderView;

// 定义一个 协议
@protocol VVAlertGroupHeaderViewDelegate <NSObject>

- (void)VVAlertGroupHeaderViewDidClickBtn:(VVAlertGroupHeaderView *)headerView;

@end

@interface VVAlertGroupHeaderView : UITableViewHeaderFooterView
//代理属性
@property (nonatomic, assign) id<VVAlertGroupHeaderViewDelegate>delegate;

@property (nonatomic,assign) NSInteger index;
@property (nonatomic, strong) VVAlertModel *groupModel;

@property (nonatomic, assign) BOOL isExpend;

+ (instancetype)VVAlertGroupHeaderViewWithTableView:(UITableView *)tableView;

@end
