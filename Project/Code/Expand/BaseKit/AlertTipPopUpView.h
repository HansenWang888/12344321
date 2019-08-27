//
//  CancelTipPopUpView.h
//  gtp
//
//  Created by Aalto on 2018/12/30.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface AlertTipPopUpView : UIView

- (void)showInApplicationKeyWindow;
- (void)showInView:(UIView *)view;
- (void)richElementsInViewWithModel:(id)model actionBlock:(ActionBlock)block;
@end

NS_ASSUME_NONNULL_END
