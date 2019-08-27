//
//  SendRedPackedTextCell.h
//  Project
//
//  Created by Mike on 2019/2/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SendRedPackedTextCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *deTextField;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UIViewController *object;

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic,strong) id model;

@end

NS_ASSUME_NONNULL_END
