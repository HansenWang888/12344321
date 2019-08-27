//
//  SendRPNumTableViewCell.h
//  Project
//
//  Created by Mike on 2019/3/1.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SelectNumBlock)(NSArray *items);

@interface SendRPNumTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

@property (nonatomic,strong) id model;

@property (nonatomic, copy) SelectNumBlock selectNumBlock;

@end

NS_ASSUME_NONNULL_END
