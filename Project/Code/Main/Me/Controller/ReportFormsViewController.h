//
//  ReportFormsViewController.h
//  Project
//
//  Created by fy on 2019/1/9.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportFormsView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReportFormsViewController : SuperViewController
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)ReportFormsView *reportFormsView;
@property(nonatomic,copy)NSString *userId;

@end

NS_ASSUME_NONNULL_END
