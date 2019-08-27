//
//  VVAlertGroupHeaderView.m
//  ProjectXZHB
//
//  Created by Mike on 2019/3/18.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "VVAlertGroupHeaderView.h"
@interface VVAlertGroupHeaderView ()
@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, strong) UILabel *nameLabel;


@end

@implementation VVAlertGroupHeaderView

///像 自定义cell一样 定义一个headerView
+ (instancetype)VVAlertGroupHeaderViewWithTableView:(UITableView *)tableView {
    static NSString *headerID = @"header";
    VVAlertGroupHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (headerView == nil) {
        headerView = [[self alloc] initWithReuseIdentifier:headerID];
    }
    
    return headerView;
}


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        //布局子控件
        [self setupChlidView];
    }
    
    return self;
}


- (void)setupChlidView{
    //头视图  按钮
    
    
//    UIButton *headerBtn = [[UIButton alloc] init];
////    [headerBtn setTitle:@"确认" forState:UIControlStateNormal];
//    [headerBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    headerBtn.titleLabel.font = [UIFont vvFontOfSize:15];
//    [headerBtn setImage:[UIImage imageNamed:@"dial_mute"] forState:UIControlStateNormal];
//    headerBtn.tag = 1000;
//    headerBtn.titleLabel.numberOfLines = 0;
//    [headerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////    headerBtn.imageView.clipsToBounds = NO;
//    [self addSubview:headerBtn];
//    _headerBtn = headerBtn;
//
//    [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.contentView.mas_centerY);
//        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
//        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
//        make.height.mas_equalTo(35);
//    }];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = COLOR_X(250, 250, 250);
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"-";
    nameLabel.font = [UIFont vvFontOfSize:16];
    nameLabel.textColor = [UIColor colorWithRed:0.212 green:0.212 blue:0.212 alpha:1.000];
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(SCREEN_WIDTH -30*2 -15*2);
        make.left.mas_equalTo(self.mas_left).offset(15);
    }];
    
    UITapGestureRecognizer *tapGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerBtnClick)];
    [self addGestureRecognizer:tapGesturRecognizer];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR_X(240, 240, 240);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (void)headerBtnClick {
//    self.groupModel.expend = !self.groupModel.expend;
    
    if (!self.groupModel.isExpend) {
        //没有展开
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    }else {
        //展开
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    
    if ([self.delegate respondsToSelector:@selector(VVAlertGroupHeaderViewDidClickBtn:)]) {
        
        [self.delegate VVAlertGroupHeaderViewDidClickBtn:self];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
//    self.headerBtn.frame = self.bounds;
//
//    CGFloat countX = self.bounds.size.width - 160;

}


- (void)setGroupModel:(VVAlertModel *)groupModel {
    _groupModel = groupModel;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%zd. %@",self.index, groupModel.name];
//    [self.headerBtn setTitle:[NSString stringWithFormat:@"%zd. %@",self.index, groupModel.name] forState:0];
    
//    if (self.groupModel.isExpend) {
//        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
//    } else {
//        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(0);
//    }
    
}

@end
