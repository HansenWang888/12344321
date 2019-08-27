//
//  CopyCell.m
//  Project
//
//  Created by fangyuan on 2019/4/4.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "CopyCell.h"
#import "UIView+AZGradient.h"
@implementation CopyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initView{
    UIView *containView = [[UIView alloc] init];
    containView.backgroundColor = [UIColor whiteColor];
    containView.layer.masksToBounds = YES;
    containView.layer.cornerRadius = 8;
    [self addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
    }];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.font = [UIFont systemFontOfSize:11];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.layer.masksToBounds = YES;
    numLabel.layer.cornerRadius = 10;
    [numLabel az_setGradientBackgroundWithColors:@[COLOR_X(253, 172, 105),COLOR_X(246, 83, 76)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    [containView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(containView).offset(8);
        make.width.height.equalTo(@20);
    }];
    self.numLabel = numLabel;
    
    UIButton *copyButton = [UIButton new];
    [containView addSubview:copyButton];
    copyButton.titleLabel.font = [UIFont systemFontOfSize2:13];
    [copyButton setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    copyButton.layer.masksToBounds = YES;
    copyButton.layer.cornerRadius = 14;
    [copyButton az_setGradientBackgroundWithColors:@[COLOR_X(246, 83, 76),COLOR_X(253, 172, 105)] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(containView).offset(-10);
        make.height.equalTo(@28);
        make.width.equalTo(@54);
        make.top.equalTo(containView).offset(10);
    }];
    [copyButton addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    self.copBtn = copyButton;
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize2:16];
    textLabel.textColor = COLOR_X(80, 80, 80);
    textLabel.numberOfLines = 0;
    [containView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numLabel.mas_right).offset(8);
        make.top.equalTo(numLabel.mas_top);
        make.right.equalTo(copyButton.mas_left);
        make.bottom.equalTo(containView.mas_bottom).offset(-10);
    }];
    self.tLabel = textLabel;
}

-(void)setIndex:(NSInteger)index{
    self.numLabel.text = INT_TO_STR(index);
    NSInteger topY = 5;
    if(index == 1)
        topY = 0;
    [self.numLabel.superview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(topY);
        make.bottom.equalTo(self).offset(-5);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)copyAction{
    NSString *s = self.tLabel.text;
    if(s.length == 0)
        s = @"";
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = s;
    SVP_SUCCESS_STATUS(@"复制成功");
}
@end
