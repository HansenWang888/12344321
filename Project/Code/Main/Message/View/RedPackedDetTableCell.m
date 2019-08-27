//
//  EnvelopTableViewCell.m
//  Project
//
//  Created by Mike on 2019/1/3.
//  Copyright © 2018年 Mike. All rights reserved.
//

#import "RedPackedDetTableCell.h"
#import "EnvelopeNet.h"

@interface RedPackedDetTableCell()

@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UIImageView *sex;
@property (nonatomic,strong) UILabel *date;
@property (nonatomic,strong) UILabel *moneyLable;
@property (nonatomic,strong) UIImageView *maxImg;
@property (nonatomic,strong) UIImageView *mineImageView;
//
@property (nonatomic,strong) UIImageView *bankerImageView;
@property (nonatomic,strong) UIImageView *pointsNumImageView;



@end

@implementation RedPackedDetTableCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initData];
        [self initSubviews];
        [self initLayout];
    }
    return self;
}

#pragma mark ----- Data
- (void)initData{
    
}


#pragma mark ----- Layout
- (void)initLayout{
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView);
        make.height.width.equalTo(@(40));
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self ->_icon.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset(16);
    }];
    
    [_date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self ->_icon.mas_right).offset(11);
        make.top.equalTo(self ->_name.mas_bottom).offset(6);
    }];
    
    [_mineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-100);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [_maxImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self ->_date.mas_centerY);
    }];
}

#pragma mark ----- subView
- (void)initSubviews {
    _icon = [UIImageView new];
    [self.contentView addSubview:_icon];
    _icon.layer.cornerRadius = 5;
    _icon.layer.masksToBounds = YES;
    
    _name = [UILabel new];
    [self.contentView addSubview:_name];
    _name.textColor = Color_3;
    _name.font = [UIFont systemFontOfSize2:15];
    
    _bankerImageView = [[UIImageView alloc] init];
    _bankerImageView.image = [UIImage imageNamed:@"cow_banker"];
    _bankerImageView.hidden = YES;
    [self.contentView addSubview:_bankerImageView];
    
    [_bankerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_right).offset(5);
        make.centerY.equalTo(self.name.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(36, 18));
    }];
    
    _date = [UILabel new];
    [self.contentView addSubview:_date];
    _date.textColor = Color_9;
    _date.font = [UIFont systemFontOfSize2:12];
    
    _pointsNumImageView = [[UIImageView alloc] init];
    _pointsNumImageView.hidden = YES;
    [self.contentView addSubview:_pointsNumImageView];
    
    [_pointsNumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(15, 14.5));
    }];
    
    _moneyLable = [UILabel new];
    [self.contentView addSubview:_moneyLable];
    _moneyLable.textColor = Color_3;
    _moneyLable.font = [UIFont boldSystemFontOfSize:16];
    
    [_moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    _mineImageView = [UIImageView new];
    [self.contentView addSubview:_mineImageView];
    _mineImageView.image = [UIImage imageNamed:@"mess_bomb"];
    
    _maxImg = [UIImageView new];
    [self.contentView addSubview:_maxImg];
    _maxImg.image = [UIImage imageNamed:@"icon_luck_max"];

}

- (void)setObj:(id)obj{
    NSString *avatar = [NSString cdImageLink:[obj objectForKey:@"avatar"]];
    [_icon cd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"user-default"]];
    
    NSString *money = [NSString stringWithFormat:@"%@",[obj objectForKey:@"money"]];
    NSString *nickname = [NSString stringWithFormat:@"%@",[obj objectForKey:@"nick"]];
    
    //    NSInteger sex = [[obj objectForKey:@"gender"] integerValue];
    
    if ([[obj objectForKey:@"createTime"] isKindOfClass:[NSString class]]) {
        _date.text = [obj objectForKey:@"createTime"];
    } else {
        _date.text = dateString_stamp([[obj objectForKey:@"createTime"] integerValue],nil);
    }
    
    _name.text = (![nickname isKindOfClass:[NSNull class]])?nickname:@"";
    _moneyLable.text = (![money isKindOfClass:[NSNull class]]) ? money : @"";
    
    if ([[obj objectForKey:@"redpType"] integerValue] == 2) { // 牛牛红包
        self.pointsNumImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"cow_%@", [obj objectForKey:@"score"]]];
        
        [_moneyLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.pointsNumImageView.mas_left).offset(-5);
            make.centerY.equalTo(self.pointsNumImageView.mas_centerY);
        }];
        _bankerImageView.hidden = [[obj objectForKey:@"isBanker"] boolValue] ? NO : YES;
        
        self.pointsNumImageView.hidden = NO;
        _mineImageView.hidden = YES;
        _maxImg.hidden = YES;
    } else {
        [_moneyLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.top.equalTo(self.contentView).offset(15);
        }];
        
        self.pointsNumImageView.hidden = YES;
        _maxImg.hidden = [[obj objectForKey:@"isLuck"] boolValue] ? NO : YES;
        _mineImageView.hidden = [[obj objectForKey:@"isMine"] boolValue] ? NO : YES;
        if ([[obj objectForKey:@"redpType"] integerValue] == 3) {
            if (GetUserDefaultWithKey(kBombList)) {
                NSArray *bombNumArray = GetUserDefaultWithKey(kBombList);
                NSInteger lastNum = [[money substringWithRange:NSMakeRange(money.length-1, 1)]integerValue];
                if (bombNumArray.count>0) {
                    for (NSNumber* i in bombNumArray) {
                        if ([i integerValue] == lastNum) {
                            if ([GetUserDefaultWithKey(kBombHitCnt)integerValue]>0) {
                                _mineImageView.hidden = NO;
                            }
//                            if ([GetUserDefaultWithKey(kBombHandicap)integerValue]>0) {
                                [self redXingWithLabel:_moneyLable atIndex:_moneyLable.text.length-1];
//                            }
                            
                        }
                    }
                }
            }
            
            
        }
    }
    
    
}
- (void)redXingWithLabel:(UILabel *)tempLabel atIndex:(NSInteger)tempIndex {
    NSMutableAttributedString * tempString = [[NSMutableAttributedString alloc] initWithString: tempLabel.text];
    [tempString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(tempIndex, 1)];
    tempLabel.attributedText = tempString;
}
@end
