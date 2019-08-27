//
//  BaseNavigationViewController.h
//  Project
//
//  Created by Mike on 2019/1/23.
//  Copyright © 2019 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationViewController
    : UINavigationController <UIGestureRecognizerDelegate, UINavigationControllerDelegate>
+(UINavigationController *)rootNavigationController;
@end
