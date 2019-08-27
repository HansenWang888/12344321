//
//  NSObject+CDCategory.m
//  Project
//
//  Created by zhyt on 2018/7/10.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "NSObject+CDCategory.h"
#import <objc/runtime.h>
#import <sys/utsname.h>
#import <CommonCrypto/CommonCrypto.h>
#import "CDTableModel.h"
#import "ChatViewController.h"

@implementation UIColor (CDCategory)


+ (UIColor *)randColor{
    return [UIColor colorWithRed:arc4random_uniform(255)/255.0f green:arc4random_uniform(255)/255.0f blue:arc4random_uniform(255)/255.0f alpha: ((CGFloat)arc4random() / 0x100000000)];
}

//系统主色
+ (UIColor *)mainColor{
    return [UIColor whiteColor];
}

//控制器底色
+ (UIColor *)vcColor{
    return [UIColor whiteColor];
}
@end

@implementation UIFont (CDCategory)

+ (UIFont *)systemFontOfSize2:(CGFloat)scale{
    if(SCREEN_HEIGHT == 667)
        return [UIFont systemFontOfSize:scale];
    else if(SCREEN_HEIGHT > 667)
        return [UIFont systemFontOfSize:scale + 1];
    return [UIFont systemFontOfSize:scale];
}

+ (UIFont *)boldSystemFontOfSize2:(CGFloat)scale{
    if(SCREEN_HEIGHT == 667)
        return [UIFont boldSystemFontOfSize:scale];
    else if(SCREEN_HEIGHT > 667)
        return [UIFont boldSystemFontOfSize:scale + 1];
    return [UIFont boldSystemFontOfSize:scale];
}


+ (UIFont *)vvFontOfSize:(CGFloat)scale {
    if(SCREEN_WIDTH == 375)
        return [UIFont systemFontOfSize:scale];
    else if(SCREEN_WIDTH >= 414)
        return [UIFont systemFontOfSize:scale + 1];
    else if(SCREEN_WIDTH <= 320)
        return [UIFont systemFontOfSize:scale - 1];
    return [UIFont systemFontOfSize:scale];
}
+ (UIFont *)vvBoldFontOfSize:(CGFloat)scale {
    if(SCREEN_WIDTH == 375)
        return [UIFont boldSystemFontOfSize:scale];
    else if(SCREEN_WIDTH >= 414)
        return [UIFont boldSystemFontOfSize:scale + 1];
    else if(SCREEN_WIDTH <= 320)
        return [UIFont boldSystemFontOfSize:scale - 1];
    return [UIFont boldSystemFontOfSize:scale];
}

@end

@implementation NSString (CDCategory)


+ (NSString *)cdImageLink:(NSString *)link{
    NSMutableString *str = [[NSMutableString alloc]init];
    if ([link hasPrefix:@"http://"]|[link hasPrefix:@"https://"]) {
        [str appendString:link];
    }
    return str;
}

+ (NSString *)deviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //--------------------iphone-----------------------
    if ([deviceString isEqualToString:@"i386"] || [deviceString isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"] || [deviceString isEqualToString:@"iPhone3,2"] || [deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"] || [deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"] || [deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"] || [deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iphone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iphone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    
    if ([deviceString isEqualToString:@"iPhone9,1"] || [deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"] || [deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"] || [deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"] || [deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"] || [deviceString isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    
    //--------------------ipod-----------------------
    if ([deviceString isEqualToString:@"iPod1,1"])    return @"iPod touch";
    if ([deviceString isEqualToString:@"iPod2,1"])    return @"iPod touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])    return @"iPod touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])    return @"iPod touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])    return @"iPod touch 5G";
    if ([deviceString isEqualToString:@"iPod7,1"])    return @"iPod touch 6G";
    
    
    //--------------------ipad-------------------------
    if ([deviceString isEqualToString:@"iPad1,1"])    return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"] || [deviceString isEqualToString:@"iPad2,2"] || [deviceString isEqualToString:@"iPad2,3"] || [deviceString isEqualToString:@"iPad2,4"])    return @"iPad 2";
    
    if ([deviceString isEqualToString:@"iPad3,1"] || [deviceString isEqualToString:@"iPad3,2"] || [deviceString isEqualToString:@"iPad3,3"])    return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"] || [deviceString isEqualToString:@"iPad3,5"] || [deviceString isEqualToString:@"iPad3,6"])    return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad4,1"] || [deviceString isEqualToString:@"iPad4,2"] || [deviceString isEqualToString:@"iPad4,3"])    return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"] || [deviceString isEqualToString:@"iPad5,4"])    return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,7"] || [deviceString isEqualToString:@"iPad6,8"])    return @"iPad Pro 12.9-inch";
    if ([deviceString isEqualToString:@"iPad6,3"] || [deviceString isEqualToString:@"iPad6,4"])    return @"iPad Pro iPad 9.7-inch";
    if ([deviceString isEqualToString:@"iPad6,11"] || [deviceString isEqualToString:@"iPad6,12"])    return @"iPad 5";
    if ([deviceString isEqualToString:@"iPad7,1"] || [deviceString isEqualToString:@"iPad7,2"])    return @"iPad Pro 12.9-inch 2";
    if ([deviceString isEqualToString:@"iPad7,3"] || [deviceString isEqualToString:@"iPad7,4"])    return @"iPad Pro 10.5-inch";
    
    //----------------iPad mini------------------------
    if ([deviceString isEqualToString:@"iPad2,5"] || [deviceString isEqualToString:@"iPad2,6"] || [deviceString isEqualToString:@"iPad2,7"])    return @"iPad mini";
    if ([deviceString isEqualToString:@"iPad4,4"] || [deviceString isEqualToString:@"iPad4,5"] || [deviceString isEqualToString:@"iPad4,6"])    return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"] || [deviceString isEqualToString:@"iPad4,8"] || [deviceString isEqualToString:@"iPad4,9"])    return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"] || [deviceString isEqualToString:@"iPad5,2"])    return @"iPad mini 4";
    
    if ([deviceString isEqualToString:@"iPad4,1"])    return @"ipad air";
    
    return @"iPhone";
}

+ (NSString *)systemVersion{
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)appVersion{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)phoneName{
    return [[UIDevice currentDevice] name];
}

+ (NSString *)unionid{
    return nil;
}

#pragma mark - 32位 小写
- (NSString *)MD5ForLower32Bate{
    
    //要进行UTF8的转码
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    return digest;
}

#pragma mark - 32位 大写
- (NSString *)MD5ForUpper32Bate{
    
    //要进行UTF8的转码
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    return digest;
}

- (BOOL) deptNumInputShouldNumber
{
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

@end

@implementation UITableView (CDCategory)
/*
 UITableViewCell * CDdequeueCell(UITableView *tableView,CDTableModel *model){
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.className];
 if (cell == nil) {
 cell = [[NSClassFromString(model.className) alloc]initWithStyle:0 reuseIdentifier:model.className];
 cell.selectionStyle = 0;
 }
 cell.obj = model.obj;
 return cell;
 }
 */

- (UITableViewCell *)CDdequeueReusableCellWithIdentifier:(CDTableModel *)model{
    UITableViewCell * cell = [self dequeueReusableCellWithIdentifier:model.className];
    if (cell == nil) {
        cell = [[NSClassFromString(model.className) alloc]initWithStyle:0 reuseIdentifier:model.className];
        cell.selectionStyle = 0;
    }
    cell.obj = model.obj;
    return cell;
}


+ (UITableView *)groupTable{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:1];
    tableView.sectionFooterHeight = 4.0f;
    tableView.sectionHeaderHeight = 4.0f;
    return tableView;
}

+ (UITableView *)normalTable{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:0];
    return tableView;
}

@end

static const void *UITableViewCellModel = "UITableViewCellModel";
static const void *UITableViewCellDelagate = "UITableViewCellDelagate";

@implementation UITableViewCell (CDCategory)

- (void)setObj:(id)obj{
    objc_setAssociatedObject(self, &UITableViewCellModel, obj,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)obj{
    return objc_getAssociatedObject(self, &UITableViewCellModel);
}

- (void)setGJDeleagate:(id<CDTableCellDelegate>)GJDeleagate{
    objc_setAssociatedObject(self, &UITableViewCellDelagate, GJDeleagate, OBJC_ASSOCIATION_ASSIGN );
}

- (id<CDTableCellDelegate>)GJDeleagate{
    return objc_getAssociatedObject(self, &UITableViewCellDelagate);
}

@end

@implementation UINavigationController (CDCategory)

- (void)pushVCName:(NSString *)vcName animated:(BOOL)animated{
    UIViewController *vc = CDVC(vcName);
    if (vc == nil) {
        NSException *excp = [NSException exceptionWithName:@"控制器类名不存在" reason:@"控制器不存在" userInfo:nil];
        [excp raise];
    }
    vc.hidesBottomBarWhenPushed = YES;
    
    [self pushViewController:vc animated:animated];
}


@end

static const void *CDParamKEY = "CDParam";

@implementation UIViewController (CDCategory)

- (void)setCDParam:(id)CDParam{
    objc_setAssociatedObject(self, &CDParamKEY, CDParam,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)CDParam{
    return objc_getAssociatedObject(self, &CDParamKEY);
}



//+ (void)load{
//    Method fromMethod = class_getInstanceMethod([self class], @selector(viewDidLoad));
//    Method toMethod = class_getInstanceMethod([self class], @selector(_SWViewDidLoad));
//    
//    /**
//     *  我们在这里使用class_addMethod()函数对Method Swizzling做了一层验证，如果self没有实现被交换的方法，会导致失败。
//     *  而且self没有交换的方法实现，但是父类有这个方法，这样就会调用父类的方法，结果就不是我们想要的结果了。
//     *  所以我们在这里通过class_addMethod()的验证，如果self实现了这个方法，class_addMethod()函数将会返回NO，我们就可以对其进行交换了。
//     */
//    if (!class_addMethod([self class], @selector(_SWViewDidLoad), method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
//        method_exchangeImplementations(fromMethod, toMethod);
//    }
//}

- (void)_SWViewDidLoad{
    [self _SWViewDidLoad];
    if (![self isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
        self.view.backgroundColor = [UIColor mainColor];
    }
}

@end

@implementation UIButton (CDCategory)

- (void)beginTime:(int)time {
    UIColor *normalColor = self.backgroundColor;
    __block int timeout = time;
    //    UIColor *normalColor = self.backgroundColor;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:@"重新获取" forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
                self.backgroundColor = normalColor;
                //                self.backgroundColor = normalColor;
            });
        }
        else{
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
                self.backgroundColor = [UIColor lightGrayColor];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

@end

@implementation NSMutableDictionary (CDCategory)

- (void)CDSetNOTNULLObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if ([anObject isKindOfClass:[NSString class]]) {
        [self setObject:anObject forKey:(NSString *)aKey];
    }
    if ([anObject isKindOfClass:[NSNumber class]]) {
        [self setValue:anObject forKey:(NSString *)aKey];
    }
    if ([anObject isKindOfClass:[NSDictionary class]]) {
        [self setValue:anObject forKey:(NSString *)aKey];
    }
}

@end

@implementation UIImage (CDCategory)

@end


static const void *CDSTATE = "CDSTATE";


@implementation UIView (CDCategory)

- (void)setStateView:(StateView *)StateView{
//    if(self.StateView != StateView){
        [self.StateView removeFromSuperview];
        [self addSubview:StateView];
        StateView.hidden = YES;
//        self.StateView = StateView;
        objc_setAssociatedObject(self, &CDSTATE,
                                 StateView, OBJC_ASSOCIATION_RETAIN);
//    }
}

- (StateView *)StateView{
    return objc_getAssociatedObject(self, &CDSTATE);
}


@end

