//
//  UIImage+dy_extension.m
//  Project
//
//  Created by fangyuan on 2019/8/15.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "UIImage+dy_extension.h"

@implementation UIImage (dy_extension)

+ (UIImage*)imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage *)dy_rotateImageWithAngle:(CGFloat)angle resize:(CGSize)size {
    
    if (!self.CGImage) return nil;
    size_t width = size.width;
    size_t height = size.height;
    CGRect newRect = CGRectApplyAffineTransform(CGRectMake(0., 0., width, height),
                                                CGAffineTransformMakeRotation(angle));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 (size_t)newRect.size.width,
                                                 (size_t)newRect.size.height,
                                                 8,
                                                 (size_t)newRect.size.width * 4,
                                                 colorSpace,
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGContextSetShouldAntialias(context, true);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextTranslateCTM(context, +(newRect.size.width * 0.5), +(newRect.size.height * 0.5));
    CGContextRotateCTM(context, angle);
    
    CGContextDrawImage(context, CGRectMake(-(width * 0.5), -(height * 0.5), width, height), self.CGImage);
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
#if SD_UIKIT || SD_WATCH
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
#else
    UIImage *img = [[UIImage alloc] initWithCGImage:imgRef scale:self.scale orientation:kCGImagePropertyOrientationUp];
#endif
    CGImageRelease(imgRef);
    CGContextRelease(context);
    
    return img;
}
@end
