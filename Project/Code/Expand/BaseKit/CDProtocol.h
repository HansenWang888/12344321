//
//  CDProtocol.h
//  Project
//
//  Created by zhyt on 2018/7/10.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CDProtocol <NSObject>

@end



@protocol CDTableCellDelegate <NSObject>
@optional

- (void)CDCell:(UITableViewCell *)cell handelPath:(NSIndexPath *)path action:(NSInteger)action;


@end
