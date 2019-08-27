//
//  TabMessageAniView.h
//  Project
//
//  Created by fangyuan on 2019/3/17.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AniView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabMessageAniView : AniView
@property(nonatomic,strong)IBOutlet UIImageView *imageView1;
@property(nonatomic,strong)IBOutlet UIImageView *imageView2;
@property(nonatomic,strong)CallbackBlock finishBlock;
-(void)startAni;
-(void)stopAni;
@end

NS_ASSUME_NONNULL_END
