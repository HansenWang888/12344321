//
//  ActivityCell.h
//  Project
//
//  Created by fy on 2019/1/17.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *numBtn;
@property(nonatomic,strong)UIButton *xiangQingBtn;
@property(nonatomic,strong)UIButton *getBtn;
@property(nonatomic,assign)float rate;
@property(nonatomic,strong)UIImageView *progressBg;
@property(nonatomic,strong)UIImageView *progressPot;
@property(nonatomic,strong)NSArray *pointDataArray;
-(void)initView;
@end

NS_ASSUME_NONNULL_END
