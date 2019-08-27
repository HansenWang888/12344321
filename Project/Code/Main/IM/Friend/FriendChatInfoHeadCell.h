//
//  FriendChatInfoHeadCell.h
//  Project
//
//  Created by Mike on 2019/6/25.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYContacts.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendChatInfoHeadCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic,strong) FYContacts *contacts;

@end

NS_ASSUME_NONNULL_END
