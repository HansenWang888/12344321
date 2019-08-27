//
//  UIAlertViewController+Cus.m
//  Project
//
//  Created by fy on 2018/12/31.
//  Copyright © 2018 CDJay. All rights reserved.
//

#import "UIAlertController+Cus.h"

@implementation UIAlertController (Cus)

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void)modifyColor{
    //修改title
    if(self.title){
        NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:self.title];
        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:Color_0 range:NSMakeRange(0, self.title.length)];
        [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, self.title.length)];
        [self setValue:alertControllerStr forKey:@"attributedTitle"];
    }
    //修改message
    if(self.message){
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:self.message];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:Color_0 range:NSMakeRange(0, self.message.length)];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, self.message.length)];
        [self setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    }
}
@end
