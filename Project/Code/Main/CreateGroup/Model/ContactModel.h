//
//  ContactModel.h
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/7/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactModel : NSObject
/** 头像*/
@property (nonatomic, copy) NSString *avatar;
/** 昵称*/
@property (nonatomic, copy) NSString *nick;
/** id*/
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
