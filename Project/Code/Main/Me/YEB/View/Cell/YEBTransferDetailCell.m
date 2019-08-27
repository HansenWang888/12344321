//
//  YEBTransferDetailCell.m
//  Project
//
//  Created by fangyuan on 2019/7/23.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "YEBTransferDetailCell.h"
#import "YEBFinancialInfoModel.h"

@interface YEBTransferDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;


@end
@implementation YEBTransferDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(YEBFinancialInfoModel *)model {
    [super setModel:model];
    NSDictionary *dict = @{@(1):@"转入",@(2):@"转出",@(3):@"收益"};
    self.typeLabel.text = dict[model.m_type];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",model.m_money];
    self.createTime.text = [model.m_createTime substringWithRange:NSMakeRange(0, model.m_createTime.length - 8)];
    self.hoursLabel.text = [model.m_createTime substringFromIndex:model.m_createTime.length - 8];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
