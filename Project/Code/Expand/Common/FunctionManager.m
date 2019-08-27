
//  FunctionManager.m
//  I_am_here
//
//  Created by wc on 13-5-2.
//  Copyright (c) 2013年 wc. All rights reserved.
//

#import "FunctionManager.h"
#import "sys/utsname.h"
#import <CoreText/CoreText.h>
#import <objc/runtime.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <arpa/inet.h>
#import <AVFoundation/AVFoundation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#include <mach/mach_host.h>
#include <mach/machine.h>
#include <mach/host_info.h>
#include <mach/mach_time.h>
#import "GTMBase64.h"
#import "NSData+AES.h"
@interface FunctionManager()
@property (nonatomic, copy) ActionBlock block;
@end
@implementation FunctionManager

+(instancetype)sharedInstance{
    static dispatch_once_t onceFun;
    static FunctionManager *instance = nil;
    dispatch_once(&onceFun, ^{
        if(instance == nil){
            instance = [[FunctionManager alloc] init];
        }});
    return instance;
}

-(id)init{
    if(self = [super init]){
    }
    return self;
}
+ (UIImage*)getIcon{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"]lastObject];
    
   return [UIImage imageNamed:icon];
    
}
+ (BOOL)isIphoneX {
    static BOOL isIphoneX = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSSet *platformSet = [NSSet setWithObjects:@"iPhone10,3", @"iPhone10,6", @"iPhone11,8", @"iPhone11,2", @"iPhone11,4", @"iPhone11,6", nil];
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        if ([platform isEqualToString:@"x86_64"] || [platform isEqualToString:@"i386"]) {
            platform = NSProcessInfo.processInfo.environment[@"SIMULATOR_MODEL_IDENTIFIER"];
        }
        isIphoneX = [platformSet containsObject:platform];
    });
    return isIphoneX;
}

+ (CGFloat)iphoneBottomHeight {
    return FunctionManager.isIphoneX ? 34.0 : 0.0;
}

+ (CGFloat)tabBarHeight {
    return [self iphoneBottomHeight] + 49.0;
}

+ (CGFloat)statusBarHeight {
    return FunctionManager.isIphoneX ? 34.0 : 20.0;
}

+ (CGFloat)navigationBarHeight {
    return 44.0;
}

-(id)getCacheDataByKey:(NSString*)key{
    NSString *filePath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:key];
    id data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return data;
}

-(void)setCacheDataWithKey:(NSString*)key data:(id)data{
    if (data) {
        NSString *filePath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:key];
        [NSKeyedArchiver archiveRootObject:data toFile:filePath];
    }
}

+ (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}
+(BOOL)isEmpty:(NSString *)text
{
    if ([[FunctionManager isValueNSStringWith:text] isEqualToString:@""] ||
        [FunctionManager isValueNSStringWith:text] == nil)
    {
        return true;
    }
    return false;
}
#pragma mark -限高计算AttributeString与String的宽度
+(CGFloat)getTextWidth:(NSString *)string withFontSize:(UIFont *)font withHeight:(CGFloat)height
{
    float width = 0;
    CGSize lableSize = CGSizeZero;
    if([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]){
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:font forKey: NSFontAttributeName];
        CGSize sizeTemp = [string boundingRectWithSize: CGSizeMake(MAXFLOAT, height)
                                               options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes: stringAttributes
                                               context: nil].size;
        lableSize = CGSizeMake(ceilf(sizeTemp.width), ceilf(sizeTemp.height));
    }
    width = lableSize.width;
    return width;
}

- (void)loadAnimatedImageWithURL:(NSURL *const)url completion:(void (^)(FLAnimatedImage *animatedImage))completion
{
    NSString *const filename = url.lastPathComponent;
    NSString *const diskPath = [NSHomeDirectory() stringByAppendingPathComponent:filename];
    
    NSData * __block animatedImageData = [[NSFileManager defaultManager] contentsAtPath:diskPath];
    FLAnimatedImage * __block animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedImageData];
    
    if (animatedImage) {
        if (completion) {
            completion(animatedImage);
        }
    } else {
        [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            animatedImageData = data;
            animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedImageData];
            if (animatedImage) {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(animatedImage);
                    });
                }
                [data writeToFile:diskPath atomically:YES];
            }
        }] resume];
    }
}

+ (BOOL)isGifWithImageData: (NSData *)data {
    if ([[self contentTypeWithImageData:data] isEqualToString:@"gif"]) {
        return YES;
    }
    return NO;
}

+ (NSString *)contentTypeWithImageData: (NSData *)data {
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    switch (c) {
            
        case 0xFF:
            
            return @"jpeg";
            
        case 0x89:
            
            return @"png";
            
        case 0x47:
            
            return @"gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"tiff";
            
        case 0x52:
            
            if ([data length] < 12) {
                
                return nil;
                
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                
                return @"webp";
                
            }
            
            return nil;
            
    }
    
    return nil;
}

+(NSMutableArray*)findGamesGrids{
    NSArray* gridSectionNames = @[@{@"红包游戏":@""},
                                  @{@"电子游戏":@""},
                                  @{@"棋牌游戏":@""},
                                  @{@"休闲游戏":@""}
                                  ];
    NSMutableArray* gridParams = [NSMutableArray array];
    NSArray* gridTypes = @[@(EnumActionTag0),@(EnumActionTag5),@(EnumActionTag6),@(EnumActionTag7)];
    for (int i=0; i<gridSectionNames.count; i++) {
        NSDictionary* dic = gridSectionNames[i];
        NSDictionary * param = @{kTit:dic.allKeys[0],
//                                 kImg:[NSString stringWithFormat:@"gameGrid_%i",i],
//                                 kImg:imageTemps[i],
                                 kImg:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"gameGrid_%i",i] withExtension:@"gif"]],
                                 kType:gridTypes[i]
                                 };
        [gridParams addObject:param];
    }
    return gridParams;
}
+(NSDictionary*)encryMethod:(NSDictionary*)dict{
    NSDictionary* encryDic = @{
                               };
    if (![FunctionManager isEmpty:[AppModel shareInstance].encRSAPubKey]) {
        NSData *data = [[dict mj_JSONString] dataUsingEncoding:NSUTF8StringEncoding];
        data = [data AES128EncryptWithKey:[AppModel shareInstance].randomly16Key gIv:[AppModel shareInstance].randomly16Key];
        data = [GTMBase64 encodeData:data];
        NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        encryDic = @{
                     @"encryptKey":[AppModel shareInstance].encRSAPubKey,
                     @"encryptData":s,
                     @"timestamp":[FunctionManager getNowTime]
                     };
        //                encryptKey =  rsa （（publickey+16aes-key）base64 encode）
        //                encryptData  =  res (16aes-key  + data)
    }else{
        encryDic = dict;
    }
    return encryDic;
}

+(id)isValueNSStringWith:(NSString *)str{
    NSString *resultStr = nil;
    //    str =[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([str isEqual:[NSNull null]]
        ||[NSString stringWithFormat:@"%@",str]==nil
        ||[NSString stringWithFormat:@"%@",str].length==0
        ||[[NSString stringWithFormat:@"%@",str] isEqual:@"(null)"]
        ||[[NSString stringWithFormat:@"%@",str] isEqual:@"<null>"]
        ||[[NSString stringWithFormat:@"%@",str] isEqual:@"null"]
        //        ||[str stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0
        ) {
        resultStr = @"";
    }else{
        resultStr = [NSString stringWithFormat:@"%@",str];
    }
    return resultStr;
}
#pragma mark
+(BOOL)getDataSuccessed:(NSDictionary *)dic
{
    if (dic!=nil) {
        int successed = [[dic objectForKey:@"code"]intValue];
        if (successed == 0) {
            return YES;
        } else {
            return NO;
        }
    } else {
        //        (@"后台返回数据有错误：%s",dic.description.UTF8String);
        return NO;
    }
}

+ (CGFloat)getContentHeightWithParagraphStyleLineSpacing:(CGFloat)lineSpacing fontWithString:(NSString*)fontWithString fontOfSize:(CGFloat)fontOfSize boundingRectWithWidth:(CGFloat)width {
    float height = 0;
    CGSize lableSize = CGSizeZero;
    //    if(IS_IOS7)
    if([fontWithString respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = lineSpacing;
        CGSize sizeTemp = [fontWithString boundingRectWithSize: CGSizeMake(width, MAXFLOAT)
                                                       options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                    attributes: @{NSFontAttributeName:
                                                                      [UIFont systemFontOfSize:fontOfSize],
                                                                  NSParagraphStyleAttributeName:
                                                                      paragraphStyle}
                                                       context: nil].size;
        lableSize = CGSizeMake(ceilf(sizeTemp.width), ceilf(sizeTemp.height));
    }
    
    
    height = lableSize.height;
    return height;
}

+(NSString *)getAppSource{
    return @"2";
}

-(NSString *)getDeviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

-(NSString *)getIosVersion{
    return [[UIDevice currentDevice] systemVersion];
}

-(NSString *)getApplicationVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

-(NSString *)getApplicationName{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

-(NSString *)getApplicationID{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"AppId"];
}

-(void)showAlertWithTitle:(NSString *)title andText:(NSString *)text{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:text delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (NSInteger)getWeekFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:destDate];
    NSInteger weekday = [weekdayComponents weekday];
    return weekday;
}

- (NSString *)stringFromDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components: NSEraCalendarUnit |NSYearCalendarUnit | NSMonthCalendarUnit| NSDayCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit fromDate: date];
    
    [comps setMinute:00];
    
    NSDate *newDate =  [calendar dateFromComponents:comps];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:newDate];
    return destDateString;
}

-(NSDate*)dateFromString:(NSString*)uiDate andFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

#pragma mark 验证
-(BOOL)checkIsNum:(NSString *)str{
    NSString * regex        = @"(^[0-9.]{0,15}$)";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:str];
    return isMatch;
}

-(BOOL)checkIsInteger:(NSString *)str{
    NSString * regex        = @"(^[0-9]{0,15}$)";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:str];
    return isMatch;
}

-(BOOL)validateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(BOOL)validatePhone:(NSString *)phone{
    //    NSString *phoneRegex = @"^((1[0-9]))\\d{9}$";
    //    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    //    NSLog(@"phoneTest is %@",phoneTest);
    //    return [phoneTest evaluateWithObject:phone];
    if(phone.length < 6)
        return NO;
    NSString *s = [phone substringToIndex:1];
    if([s isEqualToString:@"1"])
        return YES;
    return NO;
}

//密码
-(BOOL)validatePassword:(NSString *)passWord{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

//昵称
-(BOOL)validateNickname:(NSString *)nickname{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

//身份证号
-(BOOL)validateIdentityCard: (NSString *)identityCard{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark
-(UIImage*)imageWithColor:(UIColor*)color{
    return [self imageWithColor:color andSize:CGSizeMake(5, 2)];
}

-(UIImage*)imageWithColor:(UIColor*)color andSize:(CGSize)size{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(int)heightForLabel:(UILabel *)label{
    return [self heightForStr:label.text andFont:label.font andLineBreakMode:label.lineBreakMode andWidth:label.frame.size.width];
}

-(int)heightForStr:(NSString *)string andFont:(UIFont *)font andLineBreakMode:(NSLineBreakMode)mode andWidth:(int)width{
    CGSize size = CGSizeMake(width,9999);
    CGSize labelsize = [string sizeWithFont:font constrainedToSize:size lineBreakMode:mode];
    return labelsize.height + 2;
}

- (void)exitApp{
    exit(0);
}

-(NSString *)fullPathWithUrl:(NSString *)url{
    return nil;
}

-(UITableViewCell *)cellForChildView:(UIView *)view{
    while (![view.superview isKindOfClass:[UITableViewCell class]]) {
        view = view.superview;
        if(view == nil)
            return nil;
    }
    return (UITableViewCell *)view.superview;
}

- (NSString *)URLEncodedWithString:(NSString *)url{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)url,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

- (NSString *)encodedWithString:(NSString *)string{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)string,
                                                              NULL,
                                                              (CFStringRef)@":/?&=;+!@#$()',*",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

#pragma mark
-(void)fetchVersionInfo{
    
}

-(void)requestVersionInfoBack:(NSDictionary *)dict{
}

-(CGSize)getFitSizeWithLabel:(UILabel *)label{
    return [self getFitSizeWithLabel:label withFixType:FixTypes_width];
}

#pragma mark
-(CGSize)getFitSizeWithLabel:(UILabel *)label withFixType:(FixTypes)fixType{
    NSString *str = label.text;
    CGSize size;
    if(fixType == FixTypes_width)
        size = CGSizeMake(label.frame.size.width, 999);
    else
        size = CGSizeMake(999, label.frame.size.height);
    
    CGSize titleSize;
    titleSize = [str sizeWithFont:label.font constrainedToSize:size lineBreakMode:label.lineBreakMode];
    titleSize.height += 1;
    titleSize.width += 1;
    return titleSize;
}

#pragma mark 文件大小
//单个文件的大小
-(long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
-(float)folderSizeAtPath:(NSString*)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

#pragma mark 保存本地
-(BOOL)archiveWithData:(id)data andFileName:(NSString *)fileName{
    NSString *cachePath = [self documentCachePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@",cachePath,fileName];
    
    BOOL result = [NSKeyedArchiver archiveRootObject:data toFile:path];
    return result;
}

-(id)readArchiveWithFileName:(NSString *)fileName{
    NSString *cachePath = [self documentCachePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@",cachePath,fileName];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return obj;
}

#pragma mark
-(BOOL)skipIcoundBackupAtURL:(NSString*)filePath{
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        return NO;
    NSError* error = nil;
    BOOL success= [[NSURL fileURLWithPath:filePath] setResourceValue:[NSNumber numberWithBool:YES]forKey:NSURLIsExcludedFromBackupKey error:&error];
    return success;
}

#pragma mark 获取当前vc
-(UIViewController *)currentViewController{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    if([result isKindOfClass:[UITabBarController class]]){
        result = ((UITabBarController *)result).selectedViewController;
    }
    if([result isKindOfClass:[UINavigationController class]])
        result = [((UINavigationController *)result).viewControllers lastObject];
    return result;
}

#pragma mark document下创建的保存所有缓存的目录
-(NSString *)documentCachePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [NSString stringWithFormat:@"%@/Cache",[paths objectAtIndex:0]];
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
        [self skipIcoundBackupAtURL:path];
    }
    return path;
}

-(NSString *)localPathByTail:(NSString *)tail{
    NSString *documentPath = [self documentCachePath];
    return [NSString stringWithFormat:@"%@/%@",documentPath,tail];
}

- (NSInteger)getAttributedStringHeightWithString:(NSAttributedString *)string width:(NSInteger)width height:(NSInteger)height{
    NSInteger total_height = 0;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, height);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    total_height = 1000 - line_y + (int) descent +1 + linesArray.count * 8;    //+1为了纠正descent转换成int小数点后舍去的值
    CFRelease(textFrame);
    return total_height;
}

-(UIWindow *)getMainView{
    UIWindow *view = nil;
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows)
        if (window.windowLevel == UIWindowLevelNormal) {
            view = window;
            break;
        }
    return view;
}

-(CGSize)getFitSizeWithStr:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)maxSize{
    CGSize titleSize;
    titleSize = [str sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    titleSize.height += 1;
    titleSize.width += 1;
    return titleSize;
}
+ (NSString *)getNowTime{//13位
    
    //获取当前时间戳
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeSp = [NSString stringWithFormat:@"%.0f", time];
    
    return timeSp;
}
//-(void)handleFailResponse:(id)object actionBlock:(ActionBlock)block{
//    self.block = block;
//    if([object isKindOfClass:[NSError class]]){
//        NSError *error = (NSError *)object;
//        SVP_ERROR(error);
//    }else if([object isKindOfClass:[NSDictionary class]]){
//        NSDictionary *dd = (NSDictionary *)object;
//        if ([FunctionManager isEmpty:dd[@"errorcode"]]) {
//            if ([FunctionManager isEmpty:dd[@"alterMsg"]]) {
//                SVP_ERROR_STATUS(@"登录超时 请退出重新登录");
//            }else{
//                SVP_ERROR_STATUS(dd[@"alterMsg"]);
//            }
//        }else{
//            //errorcode 枚举
//            switch ([dd[@"errorcode"] integerValue]) {
//                case 10000000:
//                {
//                    [[AppModel shareInstance] logout];
//                }
//                    break;
//                case 19:
//                {
//                    if (self.block) {
//                        self.block(@(19));
//                    }
//                }
//                    break;
//
//                default:
//                    break;
//            }
//
//        }
//    }else if([object isKindOfClass:[NSString class]])
//        SVP_ERROR_STATUS(object);
//    else
//        SVP_DISMISS;
//}


-(void)handleFailResponse:(id)object {
    if([object isKindOfClass:[NSError class]]){
        NSError *error = (NSError *)object;
        NSDictionary *errdict = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        if (errdict) {
            NSDictionary *errorData = [NSJSONSerialization JSONObjectWithData: (NSData *)errdict options:kNilOptions error:nil];
            if (errorData) {
                [self errorDataDict:errorData];
            } else {
                SVP_ERROR(error);
            }
        } else {
            SVP_ERROR(error);
        }
    }else if([object isKindOfClass:[NSDictionary class]]){
        NSDictionary *dd = (NSDictionary *)object;
        [self errorDataDict:dd];
    }else if([object isKindOfClass:[NSString class]])
        SVP_ERROR_STATUS(object);
    else
        SVP_DISMISS;
}

- (void)errorDataDict:(NSDictionary *)dict {
    if ([FunctionManager isEmpty:dict[@"errorcode"]]) {
        if ([FunctionManager isEmpty:dict[@"alterMsg"]]) {
            SVP_ERROR_STATUS(@"登录超时 请退出重新登录");
        }else{
            SVP_ERROR_STATUS(dict[@"alterMsg"]);
        }
    }else{
        //errorcode 枚举
        switch ([dict[@"errorcode"] integerValue]) {
            case 10000000:
            case 10000002:
            {
                if([AppModel shareInstance].userInfo.isLogined == YES) {
                    [[AppModel shareInstance] logout];
                }
            }
                break;
                
            default:{
                if ([FunctionManager isEmpty:dict[@"alterMsg"]]) {
                    SVP_ERROR_STATUS(@"登录超时 请退出重新登录");
                }else{
                    SVP_ERROR_STATUS(dict[@"alterMsg"]);
                }
            }
                break;
        }
        
    }
}

-(void)checkVersion:(BOOL)showAlert{
    if([AppModel shareInstance].userInfo.isLogined == NO)
        return;
    WEAK_OBJ(weakObj, self);
    [NET_REQUEST_MANAGER requestAppConfigWithSuccess:^(id object) {
        SVP_DISMISS;
        [weakObj checkVersion2:showAlert];
    } fail:^(id object) {
//        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)checkVersion2:(BOOL)showAlert{
    WEAK_OBJ(weakObj, self);
    NSDictionary *dict = [AppModel shareInstance].commonInfo;
    NSString *appVersion = [self getApplicationVersion];
    NSString *newestVersion = dict[@"ios.version"];
    if([appVersion compare:newestVersion] == NSOrderedAscending){
        NSInteger forceUpate = [dict[@"ios.force.update.flag"] integerValue];
        NSString *desc = dict[@"ios.version.update.content"];
        
        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        view.textLabel.font = [UIFont systemFontOfSize2:16];
        if(forceUpate == 0){
            [view showWithText:desc button1:@"取消" button2:@"更新" callBack:^(id object) {
                NSInteger tag = [object integerValue];
                if(tag == 1){
                    NSURL *url = [NSURL URLWithString:[AppModel shareInstance].commonInfo[@"ios.download.path"]];
                    if([[UIApplication sharedApplication] canOpenURL:url])
                        [[UIApplication sharedApplication] openURL:url];
                    [weakObj performSelector:@selector(exitApp) withObject:nil afterDelay:0.5];
                }
            }];
        }else{
            [view showWithText:desc button:@"更新" callBack:^(id object) {
                NSURL *url = [NSURL URLWithString:[AppModel shareInstance].commonInfo[@"ios.download.path"]];
                if([[UIApplication sharedApplication] canOpenURL:url])
                    [[UIApplication sharedApplication] openURL:url];
                [weakObj performSelector:@selector(exitApp) withObject:nil afterDelay:0.5];
            }];
        }
        //
        //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"版本更新" message:desc preferredStyle:UIAlertControllerStyleAlert];
        //        [alertController modifyColor];
        //        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //            NSURL *url = [NSURL URLWithString:[AppModel shareInstance].commonInfo[@"ios.download.path"]];
        //            if([[UIApplication sharedApplication] canOpenURL:url])
        //                [[UIApplication sharedApplication] openURL:url];
        //            [weakObj performSelector:@selector(exitApp) withObject:nil afterDelay:0.5];
        //        }];
        //        [okAction setValue:Color_0 forKey:@"_titleTextColor"];
        //        [alertController addAction:okAction];
        //        if(forceUpate == 0){
        //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        //            [cancelAction setValue:Color_0 forKey:@"_titleTextColor"];
        //            [alertController addAction:cancelAction];
        //        }
        //        [[[FunctionManager sharedInstance] currentViewController] presentViewController:alertController animated:YES completion:nil];
    }else{
        if(showAlert){
            SVP_SUCCESS_STATUS(@"已是最新版本");
        }
    }
}

-(NSArray *)orderBombArray:(NSArray *)bombArray{
    if(bombArray.count < 2)
        return bombArray;
    NSArray *array = [bombArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSInteger num1 = [obj1 integerValue];
        NSInteger num2 = [obj2 integerValue];
        return num1 > num2;
    }];
    if([bombArray isKindOfClass:[NSMutableArray class]])
        return [NSMutableArray arrayWithArray:array];
    else
        return array;
}

-(NSString *)formatBombArrayToString:(NSArray *)bombArray{
    NSMutableString *s = [[NSMutableString alloc] initWithString:@"["];
    for (NSString *num in bombArray) {
        NSString *ss = num;
        if([num isKindOfClass:[NSNumber class]])
            ss = [((NSNumber *)num) stringValue];
        //        if(s.length > 1)
        //            [s appendString:@","];
        [s appendString:ss];
    }
    [s appendString:@"]"];
    return s;
}

-(NSDictionary *)appConstants{
    NSString *s = [[NSBundle mainBundle] pathForResource:@"AppConstants" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:s];
    return dic;
}

//获取appIconName
-(NSString*)getAppIconName{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    return icon;
}

- (UIImage*)imageWithView:(UIView*) view{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}

-(UIImage *)grayImage:(UIImage *)oldImage{
    int bitmapInfo = kCGImageAlphaNone;
    int width = oldImage.size.width;
    int height = oldImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), oldImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

-(NSMutableDictionary *)removeNull:(NSDictionary *)dict{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:dict];
    NSArray *keyArr = [dic allKeys];
    for (NSString *key in keyArr) {
        id obj = [dic objectForKey:key];
        if([obj isKindOfClass:[NSArray class]]){
            NSMutableArray *arr = (NSMutableArray *)obj;
            for (id obj in arr) {
                if([obj isKindOfClass:[NSDictionary class]])
                    [self removeNull:obj];
            }
        }else if([obj isKindOfClass:[NSNull class]]){
            [dic removeObjectForKey:key];
            NSLog(@"delete Null for Key:%@",key);
        }
    }
    return dic;
}
@end
