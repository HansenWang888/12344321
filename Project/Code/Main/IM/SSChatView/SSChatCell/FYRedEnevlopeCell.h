//
//  EnvelopeCollectionViewCell.h
//  Project
//
//  Created by mini on 2018/8/8.
//  Copyright © 2018年 CDJay. All rights reserved.
//


#import "FYChatBaseCell.h"

@interface FYRedEnevlopeCell : FYChatBaseCell
///*!
// 背景View
// */
//@property(nonatomic, strong) UIImageView *bubbleBackgroundView;
/*!
 文字
 */
@property(nonatomic, strong) UILabel *contentLabel;
/*!
 文字
 */
@property(nonatomic, strong) UILabel *descLabel;
/*!
 图片
 */
@property(nonatomic, strong) UIImageView *redIcon;
/*!
 类型
 */
@property(nonatomic, strong) UILabel *redTypeLabel;
@property(nonatomic, strong) UIImageView *nograbLandminesIcon;
@end
