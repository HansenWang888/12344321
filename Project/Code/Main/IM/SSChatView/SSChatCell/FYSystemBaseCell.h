//
//  FYSystemBaseCell.h
//  Project
//
//  Created by Mike on 2019/4/15.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYMessagelLayoutModel.h"


@protocol FYSystemBaseCellDelegate <NSObject>

@optional;
// 点击VS牛牛Cell消息背景视图
- (void)didTapVSCowcowCell:(FYMessage *)model;

@end




@interface FYSystemBaseCell : UITableViewCell

-(void)initChatCellUI;
@property(nonatomic, strong) FYMessagelLayoutModel  *model;

@property(nonatomic, weak) id <FYSystemBaseCellDelegate> delegate;

@end
