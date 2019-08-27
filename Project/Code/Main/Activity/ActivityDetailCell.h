//
//  ActivityDetailCell.h
//  ProjectXZHB
//
//  Created by fangyuan on 2019/3/29.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityDetailCell : UITableViewCell
@property(nonatomic,strong)UIView *containView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *percentLabel;
@property(nonatomic,strong)UIView *progressBar;
@property(nonatomic,strong)UIButton *getButton;
@property(nonatomic,strong)UILabel *rewardLabel;
@property(nonatomic,strong)UILabel *lotteryLabel;

@property(nonatomic,assign)NSMutableArray *aniObjArray;


+(NSInteger)cellHeight;
-(void)initView;
-(void)setTitle:(NSString *)title percentString:(NSString *)percentStr percent:(float)percent reward:(NSString *)reward lottery:(NSString *)lottery;
-(void)setBtnTitle:(NSString *)title status:(NSInteger)status;
@end

NS_ASSUME_NONNULL_END
