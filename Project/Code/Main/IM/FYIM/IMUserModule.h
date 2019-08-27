//
//  IMUserModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/27.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMUserEntity.h"
NS_ASSUME_NONNULL_BEGIN

@interface IMUserModule : NSObject
AS_SINGLETON(IMUserModule)

+ (void)initialModule;

- (void)updateUser:(IMUserEntity *)entity;


@end

NS_ASSUME_NONNULL_END
