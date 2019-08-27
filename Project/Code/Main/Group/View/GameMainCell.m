//
//  SPCell.m
//  LiNiuYang
//
//  Created by Aalto on 2017/7/25.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "GameMainCell.h"
#import "UIButton+WebCache.h"
@interface GameMainCell ()
@property (nonatomic, strong) UIButton* zIV;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) BannerItem* modle;
@end

@implementation GameMainCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self richEles];
    }
    return self;
}


- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
//    self.contentView.backgroundColor = kTableViewBackgroundColor;
    self.backgroundView = [[UIView alloc] init];
    
    UIButton *imageBtn = [[UIButton alloc] init];
    imageBtn.adjustsImageWhenHighlighted = NO;
    imageBtn.userInteractionEnabled = YES;
    [self.contentView addSubview:imageBtn];
    [imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(18);
        make.right.equalTo(self.contentView.mas_right).offset(-18);
        make.top.equalTo(self.contentView.mas_top).offset(14);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-2);
    }];
    [imageBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    _zIV = imageBtn;
    
    
    UIButton *btn = [[UIButton alloc] init];
    btn.adjustsImageWhenHighlighted = NO;
    btn.userInteractionEnabled = YES;
    [btn setImage:[UIImage imageNamed:@"YY2"] forState:UIControlStateNormal];
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageBtn.mas_left).offset(0);
        make.right.equalTo(imageBtn.mas_right).offset(0);
        make.top.equalTo(imageBtn.mas_bottom).offset(-2);
        make.height.equalTo(@4);
    }];
}

- (void)clickItem:(UIButton*)button{
    if (self.block) {
        self.block(_modle);
    }
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _zIV.layer.masksToBounds = YES;
    _zIV.layer.cornerRadius = 8;
    
    _zIV.backgroundColor = COLOR_X(230, 230, 230);
    
}


+(instancetype)cellWith:(UITableView*)tabelView{
    static NSString *CellIdentifier = @"GameMainCell";
    GameMainCell *cell = (GameMainCell *)[tabelView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[GameMainCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel{
    return 127;
}

- (void)richElementsInCellWithModel:(BannerItem*)item{
    if ([item isKindOfClass:[BannerItem class]]) {
        _modle = item;
        [_zIV sd_setBackgroundImageWithURL:[NSURL URLWithString:item.advPicUrl] forState:UIControlStateNormal];
    }
    
    
}
@end
