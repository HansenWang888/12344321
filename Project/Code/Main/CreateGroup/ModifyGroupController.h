//
//  ModifyGroupController.h
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/7/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    ModifyGroupTypeMent,//公告
    ModifyGroupTypeName,//名字
} ModifyGroupType;
typedef void (^ModifyGroupBlock)(NSString *text);
@interface ModifyGroupController : UIViewController

@property (nonatomic, copy) NSString *text;
/**
 群ID
 */
@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, assign) ModifyGroupType type;

@property (nonatomic, copy) ModifyGroupBlock block;
@end

NS_ASSUME_NONNULL_END
