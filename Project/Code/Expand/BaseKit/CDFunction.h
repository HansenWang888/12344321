//
//  CDFunction.h
//  Project
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

//日期格式
static NSString* const CDDateSeconds = @"yyyy-MM-dd HH:mm:ss";
static NSString* const CDDateminutes = @"yyyy-MM-dd HH:mm";
static NSString* const CDDateDay = @"yyyy-MM-dd";

@interface CDFunction : NSObject

#pragma mark 条件判断
BOOL CD_Success(id ,int);

#pragma mark 适配
// 高度
CGFloat CD_Scal(CGFloat,CGFloat);
// 宽度
CGFloat CD_WidthScal(CGFloat,CGFloat);

#pragma mark 图片
///<画虚线ImageView
UIImage * CD_DRline(UIImageView *);
///<截图view
UIImage * CD_Shot(UIView *);
///<二维码内容及尺寸
UIImage * CD_QrImg(NSString *,CGFloat);
///<重新绘制图片大小
UIImage * CD_TailorImg(UIImage *,CGSize);

#pragma mark 颜色
//16进制颜色
UIColor * ApHexColor(NSString *,CGFloat);
UIColor * HexColor(NSString *);

#pragma mark 时间戳转日期


NSString * dateString_stamp(NSInteger, NSString *);
NSString * dateString_date(NSDate *,NSString *);

NSInteger timeStamp_date(NSDate *);
NSInteger timeStamp_string(NSString *,NSString *);

NSDate * date_string(NSString *,NSString *);
NSDate * date_stamp(NSInteger );

#pragma mark PUSH \ POP
///<push
void CDPush(UINavigationController *,UIViewController*,BOOL);
///<pop
void CDPop(UINavigationController *,BOOL);
///<popToRoot
void CDPopRoot(UINavigationController *,BOOL);

#pragma mark 字符串实例化控制器、绑定参数id
UIViewController * CDVC(NSString *);
UIViewController * CDPVC(NSString *,id);

NSError * tipError(NSString *,NSInteger);
NSError * WXError(NSInteger);


@end
