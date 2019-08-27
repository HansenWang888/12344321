//
//  UserCollectionViewCell.h
//  Project
//
//  Created by mini on 2018/8/16.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupInfoUserModel.h"
typedef void (^tagBlock)(NSInteger tag);
@interface UserCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) GroupInfoUserModel *model;
@property (nonatomic, copy) tagBlock block;

@end
