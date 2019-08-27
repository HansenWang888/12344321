//
//  CustomerServiceAlertView.h
//  Project
//
//  Created by Mike on 2019/3/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DisMissViewBlock)(void);
typedef void (^CustomerServiceBlock)(void);


@interface CustomerServiceAlertView : UIView

- (void)updateView:(NSString *)title imageUrl:(NSString *)imageUrl;
- (void)showInView:(UIView *)view;
@property (nonatomic ,copy) DisMissViewBlock disMissViewBlock;
@property (nonatomic ,copy) CustomerServiceBlock customerServiceBlock;

@end

