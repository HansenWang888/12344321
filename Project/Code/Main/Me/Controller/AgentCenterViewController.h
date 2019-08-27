//
//  AgentCenterViewController.h
//  ProjectXZHB
//
//  Created by fangyuan on 2019/4/1.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellItemView : UIView
@property(nonatomic,strong)NSString *icon;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,assign)NSDictionary *infoDic;
@end

@interface AgentCenterViewController : SuperViewController

@end

NS_ASSUME_NONNULL_END
