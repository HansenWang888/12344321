//
//  GroupInfoViewController.h
//  Project
//
//  Created by mini on 2018/8/9.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <RongIMKit/RongIMKit.h>
typedef void (^GroupInfoBlock)(NSString *text);
@interface GroupInfoViewController : UIViewController

+ (GroupInfoViewController *)groupVc:(id)obj;

@property (nonatomic, copy) GroupInfoBlock block;
@end
