//
//  EnterPwdBoxView.h
//  Project
//
//  Created by Mike on 2019/4/29.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DisMissViewBlock)(void);
typedef void (^JoinGroupBtnBlock)(NSString *);


@interface EnterPwdBoxView : UIView

- (void)showInView:(UIView *)view;
@property (nonatomic ,copy) DisMissViewBlock disMissViewBlock;
@property (nonatomic ,copy) JoinGroupBtnBlock joinGroupBtnBlock;
- (void)disMissView;

@end

NS_ASSUME_NONNULL_END
