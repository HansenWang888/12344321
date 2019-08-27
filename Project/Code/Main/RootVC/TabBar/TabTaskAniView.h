//
//  TabTaskAniView.h
//  Project
//
//  Created by fangyuan on 2019/3/26.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AniView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabTaskAniView : AniView
@property(nonatomic,strong)UIImageView *baseImage;
@property(nonatomic,strong)UIImageView *lineImage1;
@property(nonatomic,strong)UIImageView *lineImage2;
@property(nonatomic,strong)UIImageView *lineImage3;
@property(nonatomic,strong)CallbackBlock finishBlock;

-(void)startAni;
-(void)stopAni;
-(void)resetView;
@end

NS_ASSUME_NONNULL_END
