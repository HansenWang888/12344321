//
//  SystemAlertTextCell.h
//  Project
//
//  Created by Mike on 2019/3/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SystemAlertTextCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic,strong) id model;

@end

NS_ASSUME_NONNULL_END
