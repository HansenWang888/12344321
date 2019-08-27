//
//  QRCodeViewController.m
//  Project
//
//  Created by fangyuan on 2019/5/8.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "QRCodeViewController.h"
#import "UIImageView+WebCache.h"

@interface QRCodeViewController ()
@property(nonatomic,strong)UIView *contentView;
@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BaseColor;
    self.title = @"二维码名片";
    // Do any additional setup after loading the view.
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.9, SCREEN_WIDTH * 0.9 + 130)];
    view.backgroundColor = [UIColor whiteColor];
    CGPoint center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0 - 50);
    view.center = center;
    [self.view addSubview:view];
    self.contentView = view;
    [self showView];
}

-(void)showView{
    UIImageView *photoView = [[UIImageView alloc] init];
    [self.contentView addSubview:photoView];
    [photoView sd_setImageWithURL:[NSURL URLWithString:[AppModel shareInstance].userInfo.avatar] placeholderImage:[UIImage imageNamed:@"user-default"]];
    photoView.layer.masksToBounds = YES;
    photoView.layer.cornerRadius = 8;
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(20);
        make.width.height.equalTo(@50);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [AppModel shareInstance].userInfo.nick;
    nameLabel.textColor = Color_3;
    nameLabel.font = [UIFont systemFontOfSize2:16];
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(photoView.mas_right).offset(15);
        make.centerY.equalTo(photoView.mas_centerY);
    }];
    
    UIImageView *sexView = [[UIImageView alloc] init];
    sexView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:sexView];
    NSInteger sex = [AppModel shareInstance].userInfo.gender;
    if(sex == 1)
        sexView.image = [UIImage imageNamed:@"female"];
    else
        sexView.image = [UIImage imageNamed:@"male"];
    [sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(2);
        make.centerY.equalTo(photoView.mas_centerY);
        make.width.height.equalTo(@20);
    }];
    
    UIImage *img = CD_QrImg(self.qrCodeUrl, 800);
    UIImageView *qrView = [[UIImageView alloc] init];
    [self.contentView addSubview:qrView];
    [qrView setImage:img];
    NSInteger width = self.contentView.frame.size.height - 160;
    [qrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(width));
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    UILabel *codeLabel = [[UILabel alloc] init];
    codeLabel.backgroundColor = [UIColor clearColor];
    codeLabel.textColor = Color_9;
    codeLabel.textAlignment = NSTextAlignmentCenter;
    codeLabel.font = [UIFont systemFontOfSize2:16];
    [self.contentView addSubview:codeLabel];
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(qrView.mas_bottom).offset(10);
    }];
    
    NSString *ss = [NSString stringWithFormat:@"邀请码：%@",[AppModel shareInstance].userInfo.invitecode];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:ss];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:Color_3 range:NSMakeRange(4, ss.length - 4)];
    codeLabel.attributedText = attributedStr;
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.text = @"扫一扫上面的二维码，快来一起领红包";
    tipLabel.textColor = Color_9;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize2:14];
    [self.contentView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(codeLabel.mas_bottom).offset(10);
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
