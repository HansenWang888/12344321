//
//  ActivityDetailCell.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/3/29.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ActivityDetailCell.h"

@implementation ActivityDetailCell

+(NSInteger)cellHeight{
    return 136;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initView{
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(12, 3, SCREEN_WIDTH - 24, [ActivityDetailCell cellHeight] - 6)];
    containView.backgroundColor = [UIColor whiteColor];
    containView.clipsToBounds = YES;
    containView.layer.masksToBounds = YES;
    containView.layer.cornerRadius = 8.0;
    containView.layer.borderColor = COLOR_X(249, 217, 41).CGColor;
    containView.layer.borderWidth = 4.0;
    [self addSubview:containView];
    self.containView = containView;
    
    UIView *titleBg = [[UIView alloc] init];
    titleBg.backgroundColor = COLOR_X(249, 217, 41);
    [containView addSubview:titleBg];
    [titleBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(containView);
        make.height.equalTo(@38);
    }];
    
    UIView *progressBg = [[UIView alloc] init];
    progressBg.layer.masksToBounds = YES;
    progressBg.layer.cornerRadius = 3;
    progressBg.backgroundColor = [UIColor whiteColor];
    [titleBg addSubview:progressBg];
    [progressBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleBg.mas_right).offset(-15);
        make.height.equalTo(@6);
        make.width.equalTo(@50);
        make.centerY.equalTo(titleBg.mas_centerY);
    }];
    
    self.progressBar = [[UIView alloc] init];
    [progressBg addSubview:self.progressBar];
    [self.progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(progressBg);
        make.width.equalTo(progressBg).multipliedBy(0.5);
    }];
    self.progressBar.backgroundColor = COLOR_X(255, 108, 100);
     
    self.percentLabel = [[UILabel alloc] init];
    self.percentLabel.textColor = COLOR_X(80, 80, 80);
    self.percentLabel.font = [UIFont systemFontOfSize2:14];
    self.percentLabel.textAlignment = NSTextAlignmentRight;
    [titleBg addSubview:self.percentLabel];
    [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(titleBg.mas_height);
        make.top.bottom.equalTo(titleBg);
        make.right.equalTo(progressBg.mas_left).offset(-10);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleBg addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleBg).offset(12);
        make.top.bottom.equalTo(titleBg);
        make.right.equalTo(self.percentLabel.mas_left);
    }];
    titleLabel.font = [UIFont systemFontOfSize2:15];
    titleLabel.textColor = COLOR_X(80, 80, 80);
    self.titleLabel = titleLabel;
    
    UIView *view1 = [self viewForIcon:@"activityIcon1" title:@"18.88奖金"];
    self.rewardLabel = [view1 viewWithTag:3];
    [self.containView addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(15);
        make.top.equalTo(titleBg.mas_bottom);
        make.bottom.equalTo(self.containView.mas_bottom).offset(-8);
        make.width.equalTo(@100);
    }];
    
    UIView *view2 = [self viewForIcon:@"activityIcon2" title:@"1次抽奖"];
    self.lotteryLabel = [view2 viewWithTag:3];
    [self.containView addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1.mas_right);
        make.top.equalTo(titleBg.mas_bottom);
        make.bottom.equalTo(self.containView.mas_bottom).offset(-8);
        make.width.equalTo(@80);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 18.5;
    [self.containView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containView.mas_right).offset(-20);
        make.height.equalTo(@37);
        make.width.equalTo(@92);
        make.centerY.equalTo(self.containView.mas_centerY).offset(19);
    }];
    btn.titleLabel.font = [UIFont systemFontOfSize2:14];
    self.getButton = btn;
}

-(UIView *)viewForIcon:(NSString *)iconName title:(NSString *)title{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(11);
        make.width.equalTo(@50);
        make.centerX.equalTo(view.mas_centerX);
        make.height.equalTo(@50);
    }];
    [self.aniObjArray addObject:imageView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize2:14];
    titleLabel.textColor = COLOR_X(80, 80, 80);
    titleLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:titleLabel];
    titleLabel.tag = 3;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.height.equalTo(@20);
        make.top.equalTo(imageView.mas_bottom);
    }];
    titleLabel.text = title;
    
    return view;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTitle:(NSString *)title percentString:(NSString *)percentStr percent:(float)percent reward:(NSString *)reward lottery:(NSString *)lottery{
    self.titleLabel.text = title;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:percentStr];
    NSRange range = [percentStr rangeOfString:@"/"];
    [string addAttribute:NSForegroundColorAttributeName value:COLOR_X(255, 80, 80) range:NSMakeRange(0, range.location)];
    self.percentLabel.attributedText = string;
    
    [self.progressBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.progressBar.superview);
        make.width.equalTo(self.progressBar.superview).multipliedBy(percent);
    }];
    
    self.rewardLabel.text = [NSString stringWithFormat:@"%@奖金",reward];
    self.lotteryLabel.text = [NSString stringWithFormat:@"%@次抽奖",lottery];
    if([lottery integerValue] == 0)
        self.lotteryLabel.superview.hidden = YES;
    else
        self.lotteryLabel.superview.hidden = NO;
}

-(void)setBtnTitle:(NSString *)title status:(NSInteger)status{
    [self.getButton setTitle:title forState:UIControlStateNormal];
    if(status == 1){
        [self.getButton setBackgroundColor:[UIColor clearColor]];
        [self.getButton setBackgroundImage:[UIImage imageNamed:@"actBtn"] forState:UIControlStateNormal];
        self.getButton.layer.borderWidth = 0;
        [self.getButton setTitleColor:COLOR_X(255, 80, 80) forState:UIControlStateNormal];
        if(![self.aniObjArray containsObject:self.getButton])
            [self.aniObjArray addObject:self.getButton];
    }else if(status == 2){
        [self.getButton setBackgroundColor:[UIColor whiteColor]];
        self.getButton.layer.borderWidth = 1.0;
        self.getButton.layer.borderColor = COLOR_X(255, 185, 51).CGColor;
        [self.getButton setTitleColor:COLOR_X(255, 185, 51) forState:UIControlStateNormal];
        [self.getButton setBackgroundImage:nil forState:UIControlStateNormal];
        if([self.aniObjArray containsObject:self.getButton])
            [self.aniObjArray removeObject:self.getButton];
    }else if(status == 0){
        [self.getButton setBackgroundColor:[UIColor whiteColor]];
        self.getButton.layer.borderWidth = 0;
        [self.getButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.getButton setBackgroundColor:COLOR_X(192, 192, 192)];
        [self.getButton setTitleColor:COLOR_X(80, 80, 80) forState:UIControlStateNormal];
        if([self.aniObjArray containsObject:self.getButton])
            [self.aniObjArray removeObject:self.getButton];
    }
}
@end
