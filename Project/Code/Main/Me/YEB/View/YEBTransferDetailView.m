//
//  YEBTransferDetailView.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/23.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "YEBTransferDetailView.h"
#import "YEBTransferDetailHeaderView.h"
#import "YEBTransferDetailCell.h"
#import "YEBNetwork.h"
#import "YEBFinancialInfoModel.h"
#import "YEBAccountInfoModel.h"
@interface YEBTransferDetailView ()

@property (nonatomic, copy) NSArray *datasources;
@property (nonatomic, assign) NSInteger type;


@end
@implementation YEBTransferDetailView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self registerNib:[UINib nibWithNibName:@"YEBTransferDetailCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.rowHeight = 54;
    [self loadDataWithType:self.type];
    self.noDataImage = @"state_empty";
    
    return self;
}

- (void)allBtnClick {
    
    kWeakly(self);
    NSArray *data = @[@"全部",@"转入",@"转出",@"收益"];
    DYMenuView *view = [DYMenuLabelView onShowWithTargetView:self.headerView.allBtn titles:data finished:^(NSInteger index) {
        weakself.type = index;
        [weakself loadDataWithType:index];
        [weakself.headerView.allBtn setTitle:[NSString stringWithFormat:@"%@ ▽",data[index]] forState:UIControlStateNormal];
    }];
    view.defaultSelected = self.type;
    
}

- (void)loadDataWithType:(NSInteger)type {
    self.loadDataCallback = ^(NSUInteger pageIndex, DYTableView_Result _Nonnull result) {
        
        [[YEBNetwork getFinancialInfoWithPageIndex:pageIndex pageSize:20 type:type isASC:NO] dy_startRequestWithFinished:^(id  _Nonnull responseObject, DYNetworkError * _Nonnull error) {
            if (!error) {
                NSArray *array = responseObject[@"records"];
                NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:array.count];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [models addObject:[YEBFinancialInfoModel mj_objectWithKeyValues:obj]];
                }];
                result(models.copy);
            } else {
                result(@[]);
            }
        }];
    };
    [self loadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.tableHeaderView) {
        self.tableHeaderView = [YEBTransferDetailHeaderView headerView];
        self.tableHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 140);
        [self.headerView.allBtn addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.headerView.totalMoney.text = [NSString stringWithFormat:@"￥ %.2f",self.model.m_totalMoney];
        self.headerView.profitLabel.text = [NSString stringWithFormat:@"￥ %.2f",self.model.m_totalEarnings];
    }
    
}




- (YEBTransferDetailHeaderView *)headerView {
    
    return (YEBTransferDetailHeaderView *)self.tableHeaderView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
