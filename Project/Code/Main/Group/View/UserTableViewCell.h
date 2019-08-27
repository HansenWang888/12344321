//
//  UserTableViewCell.h
//  Project
//
//  Created by mini on 2018/8/16.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^DeleteBtnBlock)(void);

@interface UserTableViewCell : UITableViewCell

@property (nonatomic,assign) BOOL isDelete;
@property (nonatomic ,copy) DeleteBtnBlock deleteBtnBlock;


@end
