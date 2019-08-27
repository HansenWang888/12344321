//
//  CowCowVSMessageCell.h
//  Project
//
//  Created by Mike on 2019/1/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

//#import <RongIMKit/RongIMKit.h>
#import "FYSystemBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

#define bgWidth (UIScreen.mainScreen.bounds.size.width - (CD_WidthScal(60, 320) * 2))//
#define bgRate 0.45

#define CowBackImageHeight bgWidth * bgRate

@interface CowCowVSMessageCell : FYSystemBaseCell

@property (nonatomic ,strong) UILabel *tipLabel;

@end

NS_ASSUME_NONNULL_END
