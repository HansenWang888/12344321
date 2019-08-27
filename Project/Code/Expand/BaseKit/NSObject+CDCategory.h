//
//  NSObject+CDCategory.h
//  Project
//
//  Created by zhyt on 2018/7/10.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CDProtocol.h"
#import "SVProgressHUD.h"
#import "StateView.h"



@interface UIColor (CDCategory)
#define CDCOLORA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define CDCOLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//随机色
+ (UIColor *)randColor;

//系统主色
+ (UIColor *)mainColor;

//控制器底色
+ (UIColor *)vcColor;


@end


@interface UIFont (CDCategory)

+ (UIFont *)systemFontOfSize2:(CGFloat)scale;
+ (UIFont *)boldSystemFontOfSize2:(CGFloat)scale;
+ (UIFont *)vvFontOfSize:(CGFloat)scale;
+ (UIFont *)vvBoldFontOfSize:(CGFloat)scale;

@end

@interface NSString (CDCategory)

- (NSString *)MD5ForLower32Bate;
- (NSString *)MD5ForUpper32Bate;

+ (NSString *)cdImageLink:(NSString *)link;
+ (NSString *)deviceModel;
+ (NSString *)systemVersion;
+ (NSString *)appVersion;
+ (NSString *)phoneName;
+ (NSString *)unionid;///<实现keychain方法
- (BOOL) deptNumInputShouldNumber;

@end

@class CDTableModel;
@interface UITableView (CDCategory)
/*
UITableViewCell * CDdequeueCell(UITableView *,CDTableModel *);
*/

- (UITableViewCell *)CDdequeueReusableCellWithIdentifier:(CDTableModel *)model;

+ (UITableView *)groupTable;
+ (UITableView *)normalTable;

@end

@interface UITableViewCell (CDCategory)

@property (nonatomic ,strong) id obj;
@property (nonatomic ,weak) id <CDTableCellDelegate> GJDeleagate;

@end

@interface UINavigationController (CDCategory)

@end

@interface UIViewController (CDCategory)

@property (nonatomic ,strong) id CDParam;

@end

@interface UIButton (CDCategory)

- (void)beginTime:(int)time;

@end

@interface NSMutableDictionary (CDCategory)

- (void)CDSetNOTNULLObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end

@interface UIImage (CDCategory)

@end

@interface UIView (CDCategory)

@property (nonatomic ,strong) StateView *StateView;


@end

