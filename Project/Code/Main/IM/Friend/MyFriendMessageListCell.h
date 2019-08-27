//
//  MyFriendMessageListCell.h
//  Project
//
//  Created by Mike on 2019/6/21.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FYContacts;

NS_ASSUME_NONNULL_BEGIN

@interface MyFriendMessageListCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic,strong) FYContacts *model;

@end

NS_ASSUME_NONNULL_END
