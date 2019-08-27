//
//  SendRPTextCell.h
//  ProjectXZHB
//
//  Created by Mike on 2019/3/14.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SendRPTextCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *deTextField;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) id object;
@property (nonatomic, assign) BOOL isUpdateTextField;


+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic,strong) id model;

@end


