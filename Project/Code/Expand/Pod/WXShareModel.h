//
//  WXShareModel.h
//  Project
//
//  Created by mini on 2018/8/10.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXShareModel : NSObject

@property (nonatomic ,assign) NSInteger WXShareType;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *content;
@property (nonatomic ,strong) UIImage *imageIcon;
@property (nonatomic ,strong) NSData *imageData;
@property (nonatomic ,copy) NSString *link;

@end
