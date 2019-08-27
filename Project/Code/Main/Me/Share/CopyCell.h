//
//  CopyCell.h
//  Project
//
//  Created by fangyuan on 2019/4/4.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CopyCell : UITableViewCell
@property(nonatomic,strong)UILabel *numLabel;
@property(nonatomic,strong)UILabel *tLabel;
@property(nonatomic,strong)UIButton *copBtn;

-(void)initView;
-(void)setIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
