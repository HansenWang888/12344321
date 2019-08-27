//
//  IMUserModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/27.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "IMUserModule.h"

@interface IMUserModule ()

@property (nonatomic, strong) NSMutableDictionary *users;



@end
@implementation IMUserModule
DEF_SINGLETON(IMUserModule)

- (instancetype)init {
    self = [super init];
    self.users = @{}.mutableCopy;
    return self;
}


+ (void)initialModule {
    
    
}

- (void)updateUser:(IMUserEntity *)entity {
    
    self.users[entity.userId] = entity;
    
}

@end
