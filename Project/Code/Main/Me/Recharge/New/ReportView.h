//
//  ReportView.h
//  Project
//
//  Created by fangyuan on 2019/5/12.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportView : UIView
@property(nonatomic,copy)CallbackBlock selectBlock;
+ (ReportView *)createInstanceWithView:(UIView *)superView;
@end
