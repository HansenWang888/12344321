//
//  JSPatchManager.h
//  Project
//
//  Created by Mike on 2019/1/13.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPEngine.h"
#import "JPLoader.h"

typedef NS_ENUM(NSInteger, VVComparisonResult)
{
    VVOrderedAscending = -1L,//升序
    VVOrderedSame,
    VVOrderedDescending//降序
};

@interface JSPatchManager : NSObject


/**
 同步加载还是异步加载补丁更新

 @param async YES 异步  NO 同步
 */
+(void)asyncUpdate:(BOOL)async;



@end
