//
//  SendRedPackedCell.h
//  Project
//
//  Created by Mike on 2019/2/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SelectNumBlock)(NSArray *items);
typedef void (^SelectNoPlayingBlock)(BOOL isSelect);
typedef void (^SelectMoreMaxBlock)(BOOL isMoreMax);
typedef void (^MineCellSubmitBtnBlock)(NSString *money);


@interface SelectMineNumCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic,strong) id model;
@property (nonatomic,copy) NSString *money;

@property (nonatomic, copy) SelectNumBlock selectNumBlock;
@property (nonatomic, copy) SelectNoPlayingBlock selectNoPlayingBlock;
@property (nonatomic, copy) SelectMoreMaxBlock selectMoreMaxBlock;
@property (nonatomic, copy) MineCellSubmitBtnBlock mineCellSubmitBtnBlock;


@property (nonatomic,assign) BOOL isBtnDisplay;

@property (nonatomic,assign)NSInteger maxNum;//最多多少个雷号

@end

NS_ASSUME_NONNULL_END
