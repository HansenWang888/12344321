//
//  BillTableViewCell.m
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "BillTableViewCell.h"
#import "BillItem.h"

@interface BillTableViewCell(){
    UILabel *_state;
    UILabel *_date;
    UILabel *_name;
    UILabel *_money;
    UILabel *_content;
}
@end

@implementation BillTableViewCell

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
    [_state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(12);
        make.width.lessThanOrEqualTo(@(200));
    }];
    [_state setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

    [_date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-9);
    }];
    [_date setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self->_state.mas_bottom).offset(0);
        make.bottom.equalTo(self->_date.mas_top).offset(-8);
        make.right.equalTo(self.contentView);
    }];
    
    [_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self->_state.mas_top);
    }];
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self->_name.mas_bottom).offset(26);
    }];
    
    [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self);
        make.height.equalTo(@38);
        make.width.equalTo(@60);
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    _state = [UILabel new];
    [self.contentView addSubview:_state];
    _state.font = [UIFont systemFontOfSize2:16]; //#369b3c收入 #ff4646支出
    
    _date = [UILabel new];
    [self.contentView addSubview:_date];
    _date.font = [UIFont systemFontOfSize2:14];
    _date.textColor = Color_9;
    
    _name = [UILabel new];
    [self.contentView addSubview:_name];
    _name.font = [UIFont systemFontOfSize:15];
    _name.numberOfLines = 0;
    _name.textColor = HexColor(@"#464646");
    
    _money = [UILabel new]; //#369b3c收入 #ff4646支出
    [self.contentView addSubview:_money];
    _money.font = [UIFont systemFontOfSize2:16];
    _money.textColor = HexColor(@"#369b3c");
    
    _content = [UILabel new]; //#369b3c收入 #ff4646支出
    [self.contentView addSubview:_content];
    _content.font = [UIFont systemFontOfSize2:13];
    _content.textColor = Color_3;
    _content.hidden = YES;
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 71, SCREEN_WIDTH, 2)];
    [self.contentView addSubview:line];
    line.image = CD_DRline(line);
   
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-38);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize2:14];
    [btn setTitle:@"详情>" forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_X(85, 146, 244) forState:UIControlStateNormal];
    [self.contentView addSubview:btn];
    _detailBtn = btn;
}

- (void)setObj:(id)obj{
    BillItem *item = [BillItem mj_objectWithKeyValues:obj];
    BOOL b = [item.money containsString:@"-"];
    _state.textColor = (b)?HexColor(@"#ff4646"):HexColor(@"#369b3c");
    _state.text = (b)?@"支出":@"收入";
    _date.text = item.createTime;
    
    NSMutableString *tStr = [[NSMutableString alloc] initWithString:@""];
    if(item.title.length > 0)
        [tStr appendString:item.title];
    if(item.intro.length > 0){
        if(tStr.length > 0){
            [tStr appendFormat:@"(%@)",item.intro];
        }else
            [tStr appendString:item.intro];
    }
    _name.text = tStr;
    _money.text = STR_TO_AmountFloatSTR(item.money);
    _money.textColor = (b)?HexColor(@"#ff4646"):HexColor(@"#369b3c");
    id objj = obj[@"billtId"];
    NSInteger va = 0;
    if(![objj isKindOfClass:[NSNull class]])
        va = [objj integerValue];
    switch (va) {
        case 3://扫雷抢包
        case 4://扫雷收入
        case 16://豹顺子奖励
        case 17://豹顺子赔付
            
        case 5://扫雷发包
        case 6://扫雷支出
        case 18://逾期退包
        case 34://禁抢群赔付到账
        case 41://禁抢发包
        case 24://niu
        case 25://niu
            _detailBtn.hidden = NO;
            break;
        default:
            _detailBtn.hidden = YES;
            break;
            
    }
   
}
@end
