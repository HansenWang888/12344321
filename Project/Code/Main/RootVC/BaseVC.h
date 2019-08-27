//
//  BaseVC.h
//  Project
//
//  Created by Aalto on 2019/5/24.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BannerItem;
@interface BaseVC : UIViewController
@property (nonatomic, copy) void(^dismissCompleted)(id obj);

- (void)fromBannerPushToVCWithBannerItem:(BannerItem*)item isFromLaunchBanner:(BOOL)isFromLaunchBanner;
@end

NS_ASSUME_NONNULL_END
