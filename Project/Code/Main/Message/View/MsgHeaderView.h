//
//  MsgHeaderView.h
//  Project
//
//  Created by Aalto on 2019/4/29.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MsgHeaderView : UIView
- (void)actionBlock:(DataBlock)block;

- (instancetype)initWithFrame:(CGRect)frame WithModel:(id)requestParams;
- (instancetype)initWithFrame:(CGRect)frame WithLaunchAndLoginModel:(id)requestParams WithOccurBannerAdsType:(OccurBannerAdsType)occurBannerAdsType;
-(void)richElemenstsInView:(id)requestParams;
@end

NS_ASSUME_NONNULL_END
