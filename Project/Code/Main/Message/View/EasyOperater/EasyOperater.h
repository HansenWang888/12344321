//
//  EasyOperater.h
//  ProjectXZHB
//
//  Created by fangyuan on 2019/3/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EasyOperater : UIView
+(instancetype)sharedInstance;
+(BOOL)isExist;
+(void)remove;
-(void)show;
-(void)dismiss;
@end

NS_ASSUME_NONNULL_END
