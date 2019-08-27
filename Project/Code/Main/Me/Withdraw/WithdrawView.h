//
//  WithdrawView.h
//  Project
//
//  Created by fangyuan on 2019/2/27.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawView : UIView<UITextFieldDelegate>
@property(nonatomic,strong)IBOutlet UILabel *bankLabel;
@property(nonatomic,strong)IBOutlet UIImageView *bankIconImageView;
@property(nonatomic,strong)IBOutlet UITextField *textField;
@property(nonatomic,strong)IBOutlet UIButton *submitBtn;
@property(nonatomic,strong)IBOutlet UIButton *selectBankBtn;
@property(nonatomic,strong)IBOutlet UILabel *tipLabel;
-(void)initView;
@end

NS_ASSUME_NONNULL_END
