//
//  ChannelView.m
//  Project
//
//  Created by fangyuan on 2019/5/11.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ChannelView.h"

@interface ChannelView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;;
@property(nonatomic,assign)NSInteger selectIndex;
@end

@implementation ChannelView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = COLOR_X(237, 239, 242);
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero  style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.rowHeight = 64;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 10)];
        view.backgroundColor = _tableView.backgroundColor;
        _tableView.tableFooterView = view;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.channelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [cell.contentView addSubview:titleLabel];
        NSInteger a = 12;
        if(SCREEN_WIDTH == 320)
            a = 8;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(a);
            make.right.equalTo(cell.mas_right).offset(-a);
            make.height.equalTo(@30);
            make.centerY.equalTo(cell.mas_centerY);
        }];
        titleLabel.layer.masksToBounds = YES;
        titleLabel.layer.cornerRadius = 15;
        titleLabel.font = [UIFont systemFontOfSize2:15];
        titleLabel.textColor = COLOR_X(60, 60, 60);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.tag = 1;
    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
    if(self.rechargeType == RechargeType_gf){
        cell.backgroundColor = COLOR_X(237, 239, 242);
        if(self.selectIndex == indexPath.row){
            label.backgroundColor = COLOR_X(70, 131, 215);
            label.textColor = [UIColor whiteColor];
        }else{
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = COLOR_X(60, 60, 60);
        }
    }else{
        label.backgroundColor = [UIColor clearColor];
        label.textColor = COLOR_X(60, 60, 60);
        if(self.selectIndex == indexPath.row){
            cell.backgroundColor = [UIColor whiteColor];
        }else{
            cell.backgroundColor = COLOR_X(237, 239, 242);
        }
    }
    label.text = self.channelArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndex = indexPath.row;
    [self.tableView reloadData];
    if(self.selectBlock){
        self.selectBlock([NSNumber numberWithInteger:self.selectIndex]);
    }
}


-(void)setChannelArray:(NSArray *)channelArray{
    _channelArray = channelArray;
    self.selectIndex = 0;
    if(self.tableView)
        [self.tableView reloadData];
}
@end
