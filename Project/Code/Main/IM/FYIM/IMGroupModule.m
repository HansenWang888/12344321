//
//  IMGroupModule.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/22.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "IMGroupModule.h"

@interface IMGroupModule ()
@property (nonatomic, strong) NSMutableDictionary *groups;


@end
@implementation IMGroupModule

DEF_SINGLETON(IMGroupModule)


- (id)getGroupWithGroupId:(NSString *)groupId {
    return self.groups[groupId];
}

- (NSMutableDictionary *)groups {
    if (!_groups) {
        _groups = @{}.mutableCopy;
    }
    return _groups;
}
@end
