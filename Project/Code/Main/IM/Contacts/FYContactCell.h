//
//  ContactCell.h
//  Project
//
//  Created by Mike on 2019/6/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYContacts.h"

@protocol ContactCellDelegate <NSObject>

@end


@interface FYContactCell : UITableViewCell


@property (weak, nonatomic) id<ContactCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic,strong) FYContacts *model;

@end
