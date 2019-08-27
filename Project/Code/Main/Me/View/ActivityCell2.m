//
//  ActivityCell2.m
//  Project
//
//  Created by fangyuan on 2019/2/12.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ActivityCell2.h"

@implementation ActivityCell2
@synthesize pointDataArray;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initView{
    [super initView];
    [self.progressBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.progressBg.superview.mas_right).offset(10);
    }];
//    UIImageView *progressBar = [self.progressBg viewWithTag:1];
//    progressBar.image = [[FunctionManager sharedInstance] imageWithColor:COLOR_X(255, 29, 89)];
}

-(void)setPointArray:(NSArray *)pointDataArray andCurrentMoney:(float)currentMoney{
    NSArray *viewArr = [self.progressBg.superview subviews];
    for (UIView *view in viewArr) {
        if(view.tag == 777)
            [view removeFromSuperview];
    }
    self.pointDataArray = pointDataArray;
    currentMoney += 0.5;//加0.5是为了后面当前节点亮灯显示
    NSInteger pointNum = 4;
    if(SCREEN_WIDTH >= 414)
        pointNum += 1;
    if(pointNum > pointDataArray.count)
        pointNum = pointDataArray.count;
    NSInteger tempIndex = -1;
    for (NSInteger i = 0; i < pointDataArray.count;i ++) {
        NSDictionary *dic = pointDataArray[i];
        float cMoney = [dic[@"threshold"] floatValue];
        if(currentMoney < cMoney){
            tempIndex = i;
            break;
        }
    }
    if(tempIndex == -1)
        tempIndex = pointDataArray.count - 1;
    NSInteger endIndex = tempIndex + pointNum/2;
    if(endIndex < pointNum - 1)
        endIndex = pointNum - 1;
    if(endIndex > pointDataArray.count - 1)
        endIndex = pointDataArray.count - 1;
    
    NSMutableArray *newArray = [NSMutableArray array];
    NSInteger lastIndex = -1;//当前金额的上一个点
    float rate = 0.0;;//当前金额在当前两点间的比例
    NSInteger mm = 0;
    for (NSInteger i = endIndex - pointNum + 1; i <= endIndex; i ++) {
        [newArray addObject:pointDataArray[i]];
        NSDictionary *dic = pointDataArray[i];
        float cMoney = [dic[@"threshold"] floatValue];
        if(currentMoney > cMoney){
            lastIndex = mm;
        }
        mm += 1;
    }
    NSInteger nextIndex = lastIndex + 1;
    if(nextIndex > newArray.count - 1)
        nextIndex = newArray.count - 1;
    float a = currentMoney;
    float b = [newArray[0][@"threshold"] floatValue];
    if(lastIndex > -1){
        a = currentMoney - [newArray[lastIndex][@"threshold"] floatValue];
        b = [newArray[nextIndex][@"threshold"] floatValue] - [newArray[lastIndex][@"threshold"] floatValue];
    }
    if(b == 0)
        rate = 1.0;
    else
        rate = a/b;
    
    self.progressPot.hidden = YES;
    
    pointNum += 1;
    NSInteger x = 83;
    NSInteger width = SCREEN_WIDTH - x;
    NSInteger perWidth = width/pointNum;
    
    UIImageView *progressBar = [self.progressBg viewWithTag:1];
    [progressBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressBg.mas_left);
        make.centerY.equalTo(self.progressBg);
        make.height.equalTo(@2);
        make.width.equalTo(@(perWidth * (lastIndex + 1 + rate)));
    }];
    
    for (NSInteger i = 0; i < newArray.count + 1; i ++) {
        UIImage *img = nil;
        BOOL isLight = NO;
        if(lastIndex + 1 == i && i > 0)
            isLight = YES;
        else
            isLight = NO;
        if(self.getBtn.hidden || self.getBtn.userInteractionEnabled == NO)
            isLight = NO;
        if(isLight)
            img = [UIImage imageNamed:@"activity9"];
        else
            img = [UIImage imageNamed:@"activity8"];
        UIImageView *progressPot = [[UIImageView alloc] initWithImage:img];
        progressPot.tag = 777;
        progressPot.contentMode = UIViewContentModeScaleAspectFit;
        [self.progressBg.superview addSubview:progressPot];
        [progressPot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.progressBg.mas_left).offset(-3 + i * perWidth);
            make.centerY.equalTo(self.progressBg);
            make.width.height.equalTo(@14);
        }];
        
        UIColor *textColor = nil;
        if(!isLight)
            textColor = COLOR_X(255, 53, 98);
        else
            textColor = COLOR_X(254, 199, 2);
        if(i > 0){
            NSDictionary *dd = newArray[i - 1];
            UILabel *label = [[UILabel alloc] init];
            label.tag = 777;
            label.font = [UIFont systemFontOfSize:11];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = textColor;
            label.alpha = 0.7;
            [self.progressBg.superview addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.progressBg).offset(-15);
                make.centerX.equalTo(progressPot.mas_centerX);
                make.width.height.equalTo(@(perWidth));
            }];
            label.text = dd[@"threshold"];
            
            label = [[UILabel alloc] init];
            label.tag = 777;
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = textColor;
            label.alpha = 0.7;
            [self.progressBg.superview addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.progressBg).offset(15);
                make.centerX.equalTo(progressPot.mas_centerX);
                make.width.height.equalTo(@(perWidth));
            }];
            label.text = dd[@"freeGift"];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
