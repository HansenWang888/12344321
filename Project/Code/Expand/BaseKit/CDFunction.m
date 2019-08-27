//
//  CDFunction.m
//  Project
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "CDFunction.h"

@implementation CDFunction


//--------------------条件判断-----------------------
BOOL CD_Success(id obj ,int value){
    if ([obj isKindOfClass:[NSNull class]]) {
        return NO;
    }
    else{
        int v = [obj intValue];
        return v == value;
    }
}

//--------------------适配-----------------------
CGFloat CD_Scal(CGFloat size ,CGFloat scale){
    CGFloat s = SCREEN_HEIGHT/scale;
    return size * s;
}

CGFloat CD_WidthScal(CGFloat size ,CGFloat scale) {
    CGFloat s = SCREEN_WIDTH/scale;
    return size * s;
}

//--------------------虚线图-----------------------
UIImage * CD_DRline(UIImageView *imageView){
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);
    
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    
    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();
    
    // 设置线条终点的形状
    CGContextSetLineCap(line, kCGLineCapRound);
    // 设置虚线的长度 和 间距
    CGFloat lengths[] = {5,5};
    
    CGContextSetStrokeColorWithColor(line, HexColor(@"#E9E9E9").CGColor);
    // 开始绘制虚线
    CGContextSetLineDash(line, 0, lengths, 2);
    
    CGContextMoveToPoint(line, 0.0, 2.0);
    
    CGContextAddLineToPoint(line, imageView.frame.size.width, 2.0);
    
    CGContextStrokePath(line);
    
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}

//--------------------截图-----------------------
UIImage * CD_Shot(UIView *view){
    UIImage *imageRet = nil;
    if (view){
        UIGraphicsBeginImageContext(view.frame.size);
        //获取图像
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        imageRet = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else{
    }
    return imageRet;
}

//--------------------生成二维码-----------------------
UIImage * CD_QrImg(NSString *qrstring, CGFloat size){
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSData *data = [qrstring dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    CGRect extent = CGRectIntegral(outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

//--------------------图片尺寸裁剪-----------------------
UIImage * CD_TailorImg(UIImage *img,CGSize size){
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image1;
}

//-------------------16进制颜色-----------------------
UIColor * HexColor(NSString *color){
    return ApHexColor(color, 1.0);
}

//-------------------16进制颜色-----------------------
UIColor * ApHexColor(NSString *color,CGFloat a){
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
    cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
    cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
    return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:a];
}

//-------------------时间戳转日期-----------------------
NSString * dateString_stamp(NSInteger times,NSString *formatter){ //1532346645
    if (!(times>0)) {
        return @"";
    }
    NSTimeInterval time = (float)times;
    time = (times>999999999999)?time/1000:time; //Java13位PHP10位
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    if (formatter) {
        [dateFormatter setDateFormat:formatter];
    }else{
        [dateFormatter setDateFormat:CDDateSeconds];
    }
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

NSString * dateString_date(NSDate *date,NSString *formatter){
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    if (formatter) {
        [dateFormatter setDateFormat:formatter];
    }else{
        [dateFormatter setDateFormat:CDDateSeconds];
    }
    NSString *currentDateStr = [dateFormatter stringFromDate: date];
    return currentDateStr;
}

NSInteger timeStamp_date(NSDate *date){
    return [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
}

NSInteger timeStamp_string(NSString *string,NSString *formatter){
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (formatter) {
        [dateFormatter setDateFormat:formatter];
    }else{
        [dateFormatter setDateFormat:CDDateSeconds];
    }
    
    NSDate *date = [dateFormatter dateFromString:string];
    return [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
}

NSDate * date_string(NSString *string,NSString *formatter){
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (formatter) {
        [dateFormatter setDateFormat:formatter];
    }else{
        [dateFormatter setDateFormat:CDDateSeconds];
    }
    return [dateFormatter dateFromString:string];
}

NSDate * date_stamp(NSInteger stamp){
    return [NSDate dateWithTimeIntervalSince1970:stamp];
}

//-------------------PUSH\POP----------------------
void CDPush(UINavigationController *nav, UIViewController *v, BOOL animated){
    [nav pushViewController:v animated:animated];
}

void CDPop(UINavigationController *nav,BOOL animated){
    [nav popViewControllerAnimated:animated];
}

void CDPopRoot(UINavigationController *nav,BOOL animated){
    [nav popToRootViewControllerAnimated:animated];
}

//-------------------懒生成\解耦----------------------
UIViewController * CDVC(NSString *vcName){
    return [[NSClassFromString(vcName)alloc]init];
}

//-------------------懒生成\解耦----------------------
UIViewController * CDPVC(NSString *vcName,id param){
    UIViewController *vc = [[NSClassFromString(vcName)alloc]init];
    vc.CDParam = param;
    return vc;
}

//-------------------错误信息----------------------
NSError * tipError(NSString *tip,NSInteger code){
    return [NSError errorWithDomain:tip code:code userInfo:@{@"msg":tip}];
}

//-------------------微信错误信息----------------------
NSError * WXError(NSInteger code){
    NSString *msg = @"系统错误";
    if (code == -1) {
        msg = @"系统错误";
    }
    if (code == -2) {
        msg = @"取消了分享";
    }
    if (code == -3) {
        msg = @"发送失败";
    }
    if (code == -4) {
        msg = @"授权失败";
    }
    if (code == -5) {
        msg = @"微信不支持";
    }
    if (code == -95) {
        msg = @"系统错误";//分享href或文本为空、图片路径不对或加载失败或其他错误
    }
    if (code == -96) {
        msg = @"图片超过限制";
    }
    if (code == -97) {
        msg = @"图片超过限制";
    }
    if (code == -98) {
        msg = @"微信未安装";
    }
    if (code == -99) {
        msg = @"系统错误";//无效的appid
    }
    return [NSError errorWithDomain:msg code:code userInfo:@{@"msg":msg}];
}


@end
