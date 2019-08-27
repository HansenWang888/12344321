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
@end
