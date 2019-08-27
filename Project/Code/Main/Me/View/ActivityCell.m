//
//  ActivityCell.m
//  Project
//
//  Created by fy on 2019/1/17.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ActivityCell.h"

@implementation ActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void)initView{
    WEAK_OBJ(weakSelf, self);
    UIView *conView = [[UIView alloc] init];
    conView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:conView];
    [conView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(@2);
        make.bottom.equalTo(@-2);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = Color_0;
    titleLabel.font = [UIFont systemFontOfSize2:15];
    [conView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(conView.mas_left).offset(15);
        make.top.equalTo(conView.mas_top).offset(10);
    }];
    self.titleLabel = titleLabel;
    
    UIButton *numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [numBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    numBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [conView addSubview:numBtn];
    [numBtn setBackgroundImage:[[UIImage imageNamed:@"activity4"] stretchableImageWithLeftCapWidth:5 topCapHeight:4] forState:UIControlStateNormal];
    [numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(conView.mas_left).offset(15);
        make.centerY.equalTo(conView).offset(-5);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    self.numBtn = numBtn;
    
    UIImageView *progressBg = [[UIImageView alloc] initWithImage:[[FunctionManager sharedInstance] imageWithColor:COLOR_X(255, 29, 89)]];
    [conView addSubview:progressBg];
    progressBg.layer.masksToBounds = YES;
    progressBg.layer.cornerRadius = 2.5;
    [progressBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numBtn.mas_right).offset(8);
        make.centerY.equalTo(numBtn.mas_centerY);
        make.height.equalTo(@5);
        make.right.equalTo(conView.mas_right).offset(-20);
    }];
    self.progressBg = progressBg;
    
    UIImageView *progressBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity10"]];
    [progressBg addSubview:progressBar];
    progressBar.layer.masksToBounds = YES;
    progressBar.layer.cornerRadius = 3;
    progressBar.tag = 1;
    [progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progressBg.mas_left);
        make.centerY.equalTo(progressBg);
        make.height.equalTo(@6);
        make.width.equalTo(@0);
    }];
    
    UIImageView *progressPot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity8"]];
    progressPot.contentMode = UIViewContentModeScaleAspectFit;
    [conView addSubview:progressPot];
    self.progressPot = progressPot;
    [progressPot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressBg);
        make.width.height.equalTo(@14);
        make.centerX.equalTo(self.progressBg.mas_right).offset(-3);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR_X(245, 245, 245);
    [conView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.right.equalTo(conView);
        make.bottom.equalTo(conView.mas_bottom).offset(-36);
    }];
    
    UIButton *lingQuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lingQuBtn setTitle:@" 领取" forState:UIControlStateNormal];
    [lingQuBtn setTitle:@"已领取" forState:UIControlStateSelected];
    [lingQuBtn setTitleColor:MBTNColor forState:UIControlStateNormal];
    lingQuBtn.titleLabel.font = [UIFont systemFontOfSize2:14];
    [lingQuBtn setTitleColor:Color_6 forState:UIControlStateSelected];
    [lingQuBtn setImage:[UIImage imageNamed:@"activity2"] forState:UIControlStateNormal];
    [lingQuBtn setImage:[UIImage imageNamed:@"activity1"] forState:UIControlStateSelected];
    [conView addSubview:lingQuBtn];
    [lingQuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(conView).offset(-10);
        make.width.equalTo(@70);
        make.top.equalTo(lineView.mas_bottom);
        make.bottom.equalTo(conView.mas_bottom);
    }];
    self.getBtn = lingQuBtn;
    
    UIButton *xiangQingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [xiangQingBtn setTitle:@"活动详情" forState:UIControlStateNormal];
    xiangQingBtn.titleLabel.font = [UIFont systemFontOfSize2:14];
    [xiangQingBtn setTitleColor:HexColor(@"#4976f2") forState:UIControlStateNormal];
    [conView addSubview:xiangQingBtn];
    [xiangQingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.bottom.equalTo(conView.mas_bottom);
        make.width.equalTo(@80);
        make.centerX.equalTo(conView);
    }];
    self.xiangQingBtn = xiangQingBtn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRate:(float)rate{
    if(rate > 1)
        rate = 1;
    
    UIImageView *progressBar = [self.progressBg viewWithTag:1];
    [progressBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressBg.mas_left);
        make.centerY.equalTo(self.progressBg);
        make.height.equalTo(@2);
        make.width.equalTo(self.progressBg).multipliedBy(rate).offset(-4);
    }];
    
    if(self.pointDataArray == nil){
        self.progressPot.hidden = NO;
        [self.progressPot mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.progressBg);
            make.width.height.equalTo(@14);
            make.centerX.equalTo(self.progressBg.mas_right).offset(-3);
        }];
    }else
        self.progressPot.hidden = YES;
}
@end
