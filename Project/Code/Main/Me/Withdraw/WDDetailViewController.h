//
//  WDDetailViewController.h
//  Project
//
//  Created by fangyuan on 2019/2/27.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDDetailViewController : UIViewController
@property(nonatomic,strong)IBOutlet UILabel *descLabel;
@property(nonatomic,strong)IBOutlet UILabel *moneyLabel;
@property(nonatomic,strong)IBOutlet UILabel *statusLabel;
@property(nonatomic,strong)IBOutlet UILabel *money2Label;
@property(nonatomic,strong)IBOutlet UILabel *serveLabel;
@property(nonatomic,strong)IBOutlet UILabel *time1Label;
@property(nonatomic,strong)IBOutlet UILabel *time2Label;
@property(nonatomic,strong)IBOutlet UILabel *bankLabel;
@property(nonatomic,strong)IBOutlet UILabel *orderLabel;
@property(nonatomic,strong)IBOutlet UILabel *remarkLabel;

@property(nonatomic,strong)NSDictionary *infoDic;

@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;
@end

NS_ASSUME_NONNULL_END
