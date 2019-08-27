//
//  GroupInfoUserModel.h
//  Project
//
//  Created by 汤姆 on 2019/8/1.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupInfoUserModel : NSObject

@property (nonatomic, assign) NSInteger agentFlag;
/** url*/
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *createIp;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *mobile;

@end

NS_ASSUME_NONNULL_END
