//
//  YEBTransferSuccessView.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/23.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "YEBTransferSuccessView.h"

@implementation YEBTransferSuccessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)successView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"YEBTransferSuccessView" owner:nil options:nil].firstObject;
    
}

@end
