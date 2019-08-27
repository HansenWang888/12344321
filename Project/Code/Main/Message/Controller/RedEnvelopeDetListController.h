//
//  EnvelopeListViewController.h
//  Project
//
//  Created by mini on 2018/8/13.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedEnvelopeDetListController : UIViewController


@property (nonatomic, assign) BOOL isCowCow;
@property (nonatomic, assign) BOOL isRightBarButton;
//
@property (nonatomic, copy) NSString *redPackedId;
@property (nonatomic, copy) NSString *bankerId;
// 退包时间
@property (nonatomic, assign) CGFloat returnPackageTime;

@end
