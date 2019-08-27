//
//  UIView+CDSDImage.m
//  Project
//
//  Created by zhyt on 2018/7/10.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "UIView+CDSDImage.h"
#import "UIView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@implementation UIView (CDSDImage)

@end

@implementation UIButton (CDSDImage)

- (void)cd_setImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state{
    [self cd_setImageWithURL:url forState:state placeholderImage:nil];
}

- (void)cd_setImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state
          placeholderImage:(UIImage *)image{
    [self sd_setImageWithURL:url forState:state placeholderImage:image];
}

@end

@implementation UIImageView (CDSDImage)

- (void)cd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(UIImage *)image{
    [self sd_setImageWithURL:url placeholderImage:image];
}



@end
