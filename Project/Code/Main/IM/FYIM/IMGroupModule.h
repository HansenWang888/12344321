//
//  IMGroupModule.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/22.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMGroupEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMGroupModule : NSObject
AS_SINGLETON(IMGroupModule)


- (IMGroupEntity *)getGroupWithGroupId:(NSString *)groupId;





@end

NS_ASSUME_NONNULL_END
