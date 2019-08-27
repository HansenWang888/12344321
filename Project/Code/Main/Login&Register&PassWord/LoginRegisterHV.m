//  gtp
//
//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "LoginRegisterHV.h"
@interface LoginRegisterHV ()
@property (nonatomic, assign) GetSmsCodeFromVCType type;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong)id requestParams;
@property (nonatomic, strong)UIButton * titleBtn;
@end

@implementation LoginRegisterHV

- (instancetype)initWithFrame:(CGRect)frame WithModel:(id)requestParams{
    self = [super initWithFrame:frame];
    if (self) {
        _requestParams = requestParams;
        [self publicTopPartView];
        
        _type = [_requestParams intValue];
        switch (_type) {
            case GetSmsCodeFromVCLoginBySMS:
                [self.titleBtn setTitle:@"用户登录" forState:UIControlStateNormal];
                break;
            case GetSmsCodeFromVCRegister:
                [self.titleBtn setTitle:@"用户注册" forState:UIControlStateNormal];
                break;
            case GetSmsCodeFromVCResetPW:
                [self.titleBtn setTitle:@"重设密码" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        
    }
    return self;
}

- (void)publicTopPartView{
    UIButton* uploadImgBtn = [[UIButton alloc] init];
    [self addSubview:uploadImgBtn];
    [uploadImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(77);
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(26);
        make.right.mas_equalTo(-26);
//        make.centerX.mas_equalTo(self);
    }];
    
    [uploadImgBtn.layer setCornerRadius:5];
    uploadImgBtn.layer.masksToBounds = YES;
    [uploadImgBtn.layer setBorderColor:[UIColor colorWithRed:216.0/256 green:216.0/256 blue:216.0/256 alpha:1].CGColor];
    [uploadImgBtn.layer setBorderWidth:1.0];
    uploadImgBtn.backgroundColor = [UIColor colorWithRed:247.0/256 green:248.0/256 blue:249.0/256 alpha:1];
    [uploadImgBtn addTarget:self action:@selector(uploadImgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [uploadImgBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [uploadImgBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    uploadImgBtn.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    uploadImgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    
    //title
    self.titleBtn = [[UIButton alloc] init];
//    [self.titleBtn setTitle:@"用户登录" forState:UIControlStateNormal];
    [self.titleBtn setTitleColor:HexColor(@"#5d5d5d") forState:UIControlStateNormal];
    self.titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    self.titleBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleBtn];
    self.titleBtn.contentVerticalAlignment =UIControlContentVerticalAlignmentBottom;
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(uploadImgBtn.mas_bottom).offset(19);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
//        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(36);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self layoutIfNeeded];
//    self.titleBtn.layer.masksToBounds = YES;
//    self.titleBtn.layer.cornerRadius = 0;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.titleBtn.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.titleBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    self.titleBtn.layer.mask = maskLayer;
}
-(void)uploadImgBtnClick:(UIButton*)sender{
    if (self.block) {
        self.block(sender);
    }
}
- (void)actionBlock:(DataBlock)block{
    self.block = block;
}

//- (instancetype)initWithFrame:(CGRect)frame WithNotYetVertifyModel:(id)requestParams{
//    self = [super initWithFrame:frame];
//    if (self) {
//        _requestParams = requestParams;
//        [self notYetVertifyPartView];
//        
//        
//    }
//    return self;
//}
//
//- (void)notYetVertifyPartView{
//    
//    UILabel * titleLb = [[UILabel alloc] init];
//    titleLb.text = @"请上传手持身份证照片";
//    titleLb.font = [UIFont systemFontOfSize:17];
//    [self addSubview:titleLb];
//    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(24);
//        make.top.mas_equalTo(18);
//        make.left.mas_equalTo(20);
//        make.right.mas_equalTo(-20);
//        make.centerX.mas_equalTo(self);
//    }];
//    //上传图片大按钮
//    UIButton* uploadImgBtn = [[UIButton alloc] init];
//    [self addSubview:uploadImgBtn];
//    [uploadImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(144);
//        make.top.equalTo(titleLb.mas_bottom).offset(15);
//        make.left.mas_equalTo(50);
//        make.right.mas_equalTo(-50);
//        make.centerX.mas_equalTo(self);
//    }];
//    
//    [uploadImgBtn.layer setCornerRadius:5];
//    uploadImgBtn.layer.masksToBounds = YES;
//    [uploadImgBtn.layer setBorderColor:[UIColor colorWithRed:216.0/256 green:216.0/256 blue:216.0/256 alpha:1].CGColor];
//    [uploadImgBtn.layer setBorderWidth:1.0];
//    uploadImgBtn.backgroundColor = [UIColor colorWithRed:247.0/256 green:248.0/256 blue:249.0/256 alpha:1];
//    [uploadImgBtn addTarget:self action:@selector(uploadImgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [uploadImgBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
//    [uploadImgBtn setImage:[UIImage imageNamed:@"handIdentity"] forState:UIControlStateNormal];
//    uploadImgBtn.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
//    uploadImgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//}
@end
