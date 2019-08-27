//
//  ReportCell.m
//  Project
//
//  Created by fy on 2019/1/9.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ReportCell.h"

@implementation ReportCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = Color_3;
    label.font = [UIFont boldSystemFontOfSize2:17];
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(3);
    }];
    self.titleLabel = label;
    
    UIImageView *yanIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:yanIcon];
    [yanIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.titleLabel.mas_top).offset(-7);
    }];
    self.iconImageView = yanIcon;
    
    label = [[UILabel alloc] init];
    label.textColor = HexColor(@"#808080");
    label.font = [UIFont systemFontOfSize2:14];
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
        make.centerX.equalTo(self.contentView);
    }];
    self.descLabel = label;
}
@end
