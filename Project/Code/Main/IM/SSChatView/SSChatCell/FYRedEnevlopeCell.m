//
//  EnvelopeCollectionViewCell.m
//  Project
//
//  Created by mini on 2018/8/8.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "FYRedEnevlopeCell.h"
#import "EnvelopeMessage.h"
@class RCloudImageView;

@implementation FYRedEnevlopeCell



-(void)initChatCellUI {
    [super initChatCellUI];
    [self initSubviews];
}



#pragma mark ----- subView
- (void)initSubviews {
    
    _redIcon = [UIImageView new];
    [self.bubbleBackView addSubview:_redIcon];
    _redIcon.image = [UIImage imageNamed:@"mess_packed_icon_nor"];
    
    _nograbLandminesIcon = [UIImageView new];
    [self.bubbleBackView addSubview:_nograbLandminesIcon];
    _nograbLandminesIcon.image = [UIImage imageNamed:@"landmines"];
    
    [_redIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubbleBackView.mas_left).offset(13);
        make.top.equalTo(self.bubbleBackView.mas_top).offset(22);
//        make.size.mas_equalTo(CGSizeMake(29, 34));87 102
    }];
    
    _contentLabel = [UILabel new];
    [self.bubbleBackView addSubview:_contentLabel];
    _contentLabel.font = [UIFont boldSystemFontOfSize:15];
    _contentLabel.textColor = Color_F;
    _contentLabel.text = kRedpackedGongXiFaCaiMessage;
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bubbleBackView.mas_top).offset(14);
        make.left.equalTo(self->_redIcon.mas_right).offset(8);
        make.right.lessThanOrEqualTo(self.bubbleBackView.mas_right).offset(-14);
    }];
    
    _descLabel = [UILabel new];
    [self.bubbleBackView addSubview:_descLabel];
    _descLabel.font = [UIFont systemFontOfSize:14];
    _descLabel.textColor = Color_F;
    
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(3);
        make.left.equalTo(self.redIcon.mas_right).offset(10);
    }];
    
    _redTypeLabel = [UILabel new];
    [self.bubbleBackView addSubview:_redTypeLabel];
    _redTypeLabel.font = [UIFont systemFontOfSize:12];
    _redTypeLabel.textColor = Color_6;
    
    [_redTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubbleBackView.mas_left).offset(10);
        make.bottom.equalTo(self.bubbleBackView.mas_bottom).offset(-5);
    }];
}

#pragma mark - 更新数据
-(void)setModel:(FYMessagelLayoutModel *)model {
    [super setModel:model];
    
    NSInteger cellStatus = [model.message.redEnvelopeMessage.cellStatus integerValue];
    FYRedEnvelopeType redEnveType = model.message.redEnvelopeMessage.type;
    
    // ****** 赋值 ******
    self.redTypeLabel.text = [self typeString:redEnveType];
    self.descLabel.text = [self cellStatusString:cellStatus];
    
    if (redEnveType == FYRedEnvelopeType_Fu) {
        self.contentLabel.hidden = YES;
        self.redIcon.hidden = YES;
        
    } else if (redEnveType == FYRedEnvelopeType_Mine) {
        self.contentLabel.hidden = NO;
        self.contentLabel.text = [NSString stringWithFormat:@"%@-%zd",model.message.redEnvelopeMessage.money,model.message.redEnvelopeMessage.num];
        self.redIcon.image = (cellStatus == 0)?[UIImage imageNamed:@"mess_packed_icon_nor"]:[UIImage imageNamed:@"mess_packed_icon_open"];
        self.redIcon.hidden = NO;
        
    } else if (redEnveType == FYRedEnvelopeType_Cow) {
        
        self.contentLabel.hidden = NO;
        self.contentLabel.text = [NSString stringWithFormat:@"%@-%zd",model.message.redEnvelopeMessage.money,model.message.redEnvelopeMessage.count];
        self.redIcon.hidden = YES;
        
    } else if (redEnveType == FYRedEnvelopeType_NoRob) {
        
        NSDictionary *nograDict = model.message.redEnvelopeMessage.nograbContent;
        NSArray *bombNumListArray = [(NSString *)nograDict[@"bombList"] mj_JSONObject];
        bombNumListArray = [[FunctionManager sharedInstance] orderBombArray:bombNumListArray];
        //        NSString *mineNumStr = @"[";
        //
        //        for (NSInteger index = 0; index < bombNumListArray.count; index++) {
        //            if (index == bombNumListArray.count -1) {
        //                mineNumStr = [mineNumStr stringByAppendingString: [NSString stringWithFormat:@"%@]", bombNumListArray[index]]];
        //            } else {
        //                mineNumStr = [mineNumStr stringByAppendingString: [NSString stringWithFormat:@"%@", bombNumListArray[index]]];
        //            }
        //        }
        NSString *mineNumStr = [[FunctionManager sharedInstance] formatBombArrayToString:bombNumListArray];
        mineNumStr = [mineNumStr stringByAppendingString: [nograDict[@"type"] integerValue] == 1 ? @"" : @" 不"];
        //        self.contentLabel.text = [NSString stringWithFormat:@"%zd-%@", [contentDict[@"money"] integerValue], mineNumStr];
        self.contentLabel.text = [NSString stringWithFormat:@"%@",  mineNumStr];
        
        self.contentLabel.hidden = NO;
        //        _contentLabel.text = [NSString stringWithFormat:@"%@-%@",contentDict[@"money"],contentDict[@"num"]];
        self.redIcon.image = (cellStatus == 0)?[UIImage imageNamed:@"mess_packed_icon_nor"]:[UIImage imageNamed:@"mess_packed_icon_open"];
        self.redIcon.hidden = NO;
    } else {
        NSLog(@"🔴未知红包类型");
    }
    
    
    // ****** 更新视图位置 ******
    if (redEnveType == FYRedEnvelopeType_Fu) {
        CGFloat topM = 19*FYRedEnvelopeBackHeight/85;
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bubbleBackView.mas_top).offset(topM);
        }];
        
        if (model.message.messageFrom == FYMessageDirection_SEND) {
            CGFloat sLeftM = 54*FYRedEnvelopeBackWidth/200;
            [_descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(8);
                make.left.mas_equalTo(self.bubbleBackView.mas_left).offset(sLeftM);
            }];
            
        } else {
            CGFloat rLeftM = -54*FYRedEnvelopeBackWidth/200;
            [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(8);
                make.right.mas_equalTo(self.bubbleBackView.mas_right).offset(rLeftM);
            }];
        }
        
    } else if (redEnveType == FYRedEnvelopeType_Cow) {
        CGFloat topM = 27*FYRedEnvelopeBackHeight/85;
        CGFloat sLeftM = 13*FYRedEnvelopeBackWidth/200;//sender left no arrow
        CGFloat rLeftM = 17*FYRedEnvelopeBackWidth/200;
//        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.bubbleBackView.mas_top).offset(topM);
//        }];
        
        if (model.message.messageFrom == FYMessageDirection_SEND) {
            [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.bubbleBackView.mas_top).offset(topM);
                make.left.equalTo(self.redIcon.mas_right).offset(sLeftM);
               
            }];
            [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(2);
                make.left.mas_equalTo(self.contentLabel.mas_left);
            }];
        } else {
            
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.bubbleBackView.mas_top).offset(topM);
                make.left.mas_equalTo(self.redIcon.mas_right).offset(rLeftM);
            }];
            [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(2);
                make.left.mas_equalTo(self.redIcon.mas_right).offset(rLeftM);
            }];
        }
    } else {
        CGFloat redIconTopM = 15*FYRedEnvelopeBackHeight/85;
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(self.redIcon.mas_right).offset(10); make.top.mas_equalTo(self.bubbleBackView.mas_top).offset(redIconTopM);
        }];
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(3);
            make.left.mas_equalTo(self.redIcon.mas_right).offset(10);
        }];
    }
    
    self.nograbLandminesIcon.hidden = YES;
    NSDictionary *nograDict = model.message.redEnvelopeMessage.nograbContent;
    BOOL isShowNograbLandminesIcon = [nograDict[@"type"] integerValue]==2?NO:[[nograDict[@"handicap"] stringValue] isEqualToString:@"0"]?NO:YES;
    CGFloat redIconTopM = 18*FYRedEnvelopeBackHeight/85;
    if (model.message.messageFrom == FYMessageDirection_SEND) {
        
        self.descLabel.textAlignment = NSTextAlignmentLeft;
        [self.redTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bubbleBackView.mas_left).offset(10);
            make.bottom.mas_equalTo(self.bubbleBackView.mas_bottom).offset(-5);
        }];
        
        if (redEnveType == FYRedEnvelopeType_Mine || redEnveType == FYRedEnvelopeType_NoRob) {
            [self.redIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.bubbleBackView.mas_left).offset(12);
                make.top.mas_equalTo(self.bubbleBackView.mas_top).offset(redIconTopM);
            }];
            if (redEnveType == FYRedEnvelopeType_NoRob
                &&isShowNograbLandminesIcon) {
                self.nograbLandminesIcon.hidden = NO;
                [self.nograbLandminesIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.bubbleBackView.mas_right).offset(-12);
                    make.top.mas_equalTo(self.bubbleBackView.mas_top).offset(0);
                }];
            }
        }
        
    } else {
        
        if (redEnveType == FYRedEnvelopeType_Mine || redEnveType == FYRedEnvelopeType_NoRob) {
            [self.redIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.bubbleBackView.mas_left).offset(21);
                make.top.mas_equalTo(self.bubbleBackView.mas_top).offset(redIconTopM);
            }];
            if (redEnveType == FYRedEnvelopeType_NoRob
                &&isShowNograbLandminesIcon) {
                self.nograbLandminesIcon.hidden = NO;
                [self.nograbLandminesIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.bubbleBackView.mas_right).offset(0);
                    make.top.mas_equalTo(self.bubbleBackView.mas_top).offset(0);
                }];
            }
        }
        
        self.descLabel.textAlignment = NSTextAlignmentRight;
        [self.redTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bubbleBackView.mas_left).offset(18);
            make.bottom.mas_equalTo(self.bubbleBackView.mas_bottom).offset(-5);
        }];
        
    }
    
    // ****** 设置背景图片 ******
    UIImage *bubbleImage = [self backImage:redEnveType cellStatus:cellStatus dirFrom:model.message.messageFrom];
    self.bubbleBackView.frame = model.bubbleBackViewRect;
    self.bubbleBackView.image = bubbleImage;
    
}

- (void)tapTextMessage:(UIGestureRecognizer *)gestureRecognizer {
    //    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
    //        [self.delegate didTapMessageCell:self.model];
    //    }
}


// 设置背景图片
- (UIImage *)backImage:(FYRedEnvelopeType)redEnveType cellStatus:(NSInteger)cellStatus dirFrom:(FYChatMessageFrom)dirFrom {
    
    UIImage *image = [[UIImage alloc] init];
    
    if (dirFrom == FYMessageDirection_SEND) {
        
        if (redEnveType == FYRedEnvelopeType_Fu) {
            image = (cellStatus == 0)?[UIImage imageNamed:@"redp_back_fu_S"]:[UIImage imageNamed:@"redp_back_fu_disabled_S"];
        } else if (redEnveType == FYRedEnvelopeType_Cow) {
            image = (cellStatus == 0)?[UIImage imageNamed:@"redp_back_cow_S"]:[UIImage imageNamed:@"redp_back_cow_disabled_S"];
        } else {
            image = (cellStatus == 0)?[UIImage imageNamed:@"redp_back_S"]:[UIImage imageNamed:@"redp_back_disabled_S"];
        }
        
    } else {
        
        if (redEnveType == FYRedEnvelopeType_Fu) {
            image = (cellStatus == 0)?[UIImage imageNamed:@"redp_back_fu_R"]:[UIImage imageNamed:@"redp_back_fu_disabled_R"];
        } else if (redEnveType == FYRedEnvelopeType_Cow) {
            image = (cellStatus == 0)?[UIImage imageNamed:@"redp_back_cow_R"]:[UIImage imageNamed:@"redp_back_cow_disabled_R"];
        } else {
            image = (cellStatus == 0)?[UIImage imageNamed:@"redp_back_R"]:[UIImage imageNamed:@"redp_back_disabled_R"];
        }
    }

    return image;
}

- (NSString *)typeString:(NSInteger)type {
    switch (type) {
        case 0:
            return @"福利红包";
            break;
        case 1:
            return @"扫雷红包";
            break;
        case 2:
            return @"牛牛红包";
            break;
        case 3:
            return @"禁抢红包";
            break;
        default:
            break;
    }
    return nil;
}

- (NSString *)cellStatusString:(NSInteger)cellStatus {
    switch (cellStatus) {
        case 0:
            return @"查看红包";
            break;
        case 1:
            return @"红包已领取";
            break;
        case 2:
            return @"红包已被领完";
            break;
        case 3:
            return @"红包已过期";
            break;
        default:
            break;
    }
    return nil;
}

@end
