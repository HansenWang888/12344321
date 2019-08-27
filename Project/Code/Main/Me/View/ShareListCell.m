//
//  ShareListCell.m
//  Project
//
//  Created by fy on 2019/1/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ShareListCell.h"

@implementation ShareListCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.conView = [[UIView alloc] init];
    self.conView.backgroundColor = [UIColor whiteColor];
    self.conView.layer.masksToBounds = YES;
    self.conView.layer.cornerRadius = 6.0;
    self.conView.layer.borderColor = HexColor(@"#E6E6E6").CGColor;
    self.conView.layer.borderWidth = 0.5;
    [self.contentView addSubview:self.conView];
    [self.conView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    UIImageView *yanIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chakan"]];
    [self.conView addSubview:yanIcon];
    [yanIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.conView).offset(8);
        make.bottom.equalTo(self.conView).offset(-8);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = Color_6;
    label.font = [UIFont systemFontOfSize2:13];
    [self.conView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yanIcon.mas_right).offset(5);
        make.centerY.equalTo(yanIcon.mas_centerY);
    }];
    self.pageViewLabel = label;
    
    UIImageView *starView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pingfen"]];
    starView.contentMode = UIViewContentModeScaleAspectFit;
    [self.conView addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yanIcon);
        make.bottom.equalTo(label.mas_top).offset(-4);
        make.height.equalTo(@15);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = Color_3;
    titleLabel.font = [UIFont boldSystemFontOfSize2:15];
    [self.conView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yanIcon);
        make.bottom.equalTo(starView.mas_top).offset(-3);
        make.height.equalTo(@20);
    }];
    self.titleLabel = titleLabel;
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_bjsc"]];
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 5.0;
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.backgroundColor = Color_6;
    [self.conView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.conView).offset(7);
        make.right.equalTo(self.conView).offset(-7);
        make.bottom.equalTo(titleLabel.mas_top).offset(-7);
    }];
    self.iconView = iconView;
}

@end
