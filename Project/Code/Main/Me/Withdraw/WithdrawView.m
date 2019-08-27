//
//  WithdrawView.m
//  Project
//
//  Created by fangyuan on 2019/2/27.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "WithdrawView.h"

@implementation WithdrawView

-(void)initView{
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 8;
    self.tipLabel.text = [NSString stringWithFormat:@"当前零钱余额%@元，",[AppModel shareInstance].userInfo.balance];
    self.textField.delegate = self;
    
    self.bankIconImageView.layer.masksToBounds = YES;
    self.bankIconImageView.layer.cornerRadius = self.bankIconImageView.frame.size.width/2.0;
}

-(IBAction)inputAction:(id)sender{
    [self.textField becomeFirstResponder];
}

-(IBAction)allMoneyAction:(id)sender{
    self.textField.text = [NSString stringWithFormat:@"%zd",[[AppModel shareInstance].userInfo.balance integerValue]];
    self.textField.font = [UIFont systemFontOfSize:38];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *s = textField.text;
    NSLog(@"%@  %@",s,string);
    if(s.length == 1 && string.length == 0){
        self.textField.font = [UIFont systemFontOfSize:16];
    }else
        self.textField.font = [UIFont systemFontOfSize:38];
    
    if(s.length > 3 && string.length > 0){
        NSString *pot = [s substringWithRange:NSMakeRange(s.length -3 , 1)];
        if([pot isEqualToString:@"."])
            return NO;
    }
    
    return YES;
}
@end
