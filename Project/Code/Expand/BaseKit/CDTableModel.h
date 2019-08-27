//
//  CDTableModel.h
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDTableModel : NSObject

@property (nonatomic, copy) NSString *className;
@property (nonatomic, assign) CGFloat heighForCell;
@property (nonatomic, assign) CGFloat heighForHeader;
@property (nonatomic, assign) CGFloat heighForFooter;
@property (nonatomic, strong) id obj;

@end
