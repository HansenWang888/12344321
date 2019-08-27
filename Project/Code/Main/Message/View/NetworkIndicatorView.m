//
//  NetworkIndicatorView.m
//  VVCollectProject
//
//  Created by Mike on 2019/3/24.
//  Copyright © 2019 Mike. All rights reserved.
//

#import "NetworkIndicatorView.h"

@interface NetworkIndicatorView ()

@end

@implementation NetworkIndicatorView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //        [self initData];
        [self initSubviews];
        //        [self initLayout];
    }
    return self;
}

- (void)initSubviews {
    
    self.backgroundColor = [UIColor colorWithRed:1.000 green:0.875 blue:0.875 alpha:1.000];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"network_fail"];
    [self addSubview:iconImageView];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(19);
        make.centerY.equalTo(self.mas_centerY);
        make.size.equalTo(@(26));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"当前网络不可用，请检查你的网络设置";
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(20);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}




@end
