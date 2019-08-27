//
//  VVAlertModel.h
//  ProjectXZHB
//
//  Created by Mike on 2019/3/18.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VVAlertModel : NSObject

// 分组名称
@property (nonatomic, copy) NSString *name;
// 其它
@property (nonatomic, assign) NSInteger other;

// 列表数组
@property (nonatomic, strong) NSArray *friends;

// 是否展开 默认NO
@property (nonatomic, assign, getter=isExpend) BOOL expend;

@end


