//
//  CharUserInfoCell.h
//  Project
//
//  Created by Mike on 2019/1/7.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class <#name#>

@interface CharUserInfoCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// <#strong注释#>
@property (nonatomic,strong) id model;

@end

