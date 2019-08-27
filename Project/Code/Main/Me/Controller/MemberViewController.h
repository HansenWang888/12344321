//
//  MemberViewController.h
//  Project
//
//  Created by mini on 2018/7/31.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellData : NSObject
@property(nonatomic,strong)NSString *icon;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *subTitle;
@property(nonatomic,assign)BOOL showArrow;
@property(nonatomic,assign)NSInteger tag;
@end

@interface MemberViewController : UIViewController

@end
