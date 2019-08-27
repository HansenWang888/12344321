//
//  CancelTipPopUpView.m
//  gtp
//
//  Created by Aalto on 2018/12/30.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "AlertTipPopUpView.h"
#define XHHTuanNumViewHight 228//96
#define XHHTuanNumViewWidth 306
@interface AlertTipPopUpView()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIView *contentView;
@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) NSMutableArray* leftLabs;
@property (nonatomic, strong)UIButton *saftBtn;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, assign) CGFloat contentViewHeigth;

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *funcBtns;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) UIButton *singleSureButton;
@end

@implementation AlertTipPopUpView

- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        [self setupContent];
    }
    
    return self;
}

- (void)setupContent {
    _leftLabs = [NSMutableArray array];
    
    _funcBtns = [NSMutableArray array];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.backgroundColor = ApHexColor(@"#000000",0.8);
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    _contentViewHeigth = XHHTuanNumViewHight;
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - XHHTuanNumViewWidth)/2, (SCREEN_HEIGHT - _contentViewHeigth)/2, XHHTuanNumViewWidth, _contentViewHeigth)];
        _contentView.layer.cornerRadius = 6;
        _contentView.layer.masksToBounds = YES;
        _contentView.userInteractionEnabled = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        // 右上角关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(_contentView.width -  90, 0, 90, 47);
        closeBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
        [closeBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [closeBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
//        [_contentView addSubview:closeBtn];
        
        // 左上角关闭按钮
        UIButton *saftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saftBtn.frame = CGRectMake(0, 0, _contentView.width, 47);
        saftBtn.titleLabel.font = [UIFont systemFontOfSize2:17];
        [saftBtn setTitleColor:HEXCOLOR(0x232630) forState:UIControlStateNormal];
        [saftBtn setTitle:@"删除支付宝" forState:UIControlStateNormal];
        saftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _saftBtn = saftBtn;
        [_contentView addSubview:saftBtn];
        
        _line1 = [[UIImageView alloc]init];
        [self.contentView addSubview:_line1];
        _line1.backgroundColor = HEXCOLOR(0xe8e9ed);

        [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.top.offset(48);
            make.height.equalTo(@3);
        }];
        
        [self layoutAccountPublic];
        
    }
}

-(void)layoutAccountPublic{
    _btns = [NSMutableArray array];
    
    for (int i = 0; i < 1; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.tag =  i;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleLabel.numberOfLines = 0;
        //            [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
        [_btns addObject:button];
    }
    
//    [_btns mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:48 tailSpacing:60];
    
    [_btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@20);
        make.trailing.equalTo(@-20);
        make.top.mas_offset(@24);
        make.bottom.mas_offset(@-72);
//        make.height.mas_equalTo(@30);
    }];

    NSArray* subtitleArray =@[@"好的"];
    for (int i = 0; i < subtitleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        button.layer.masksToBounds = YES;
//        button.layer.cornerRadius = 6;
//        button.layer.borderWidth = 1;
        
        [button setTitle:subtitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [button addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funAdsButtonClickItem:)]];
        [self.contentView addSubview:button];
        [_funcBtns addObject:button];
        //        [_fucBtns[i] layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    UIButton* btn0 =_funcBtns.firstObject;
//    btn0.backgroundColor =HEXCOLOR(0xffffff);
    [btn0 az_setGradientBackgroundWithColors:@[HEXCOLOR(0xfe3366),HEXCOLOR(0xff733d)] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [btn0 setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
//    btn0.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
    [btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.right.left.bottom.equalTo(self.contentView);
    }];


//    UIButton* btn1 =_funcBtns.lastObject;
////    [btn1 setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x9b9b9b)] forState:UIControlStateNormal];
////    [btn1 setTitleColor:HEXCOLOR(0xf7f9fa) forState:UIControlStateNormal];
//    btn1.backgroundColor =HEXCOLOR(0x4c7fff);
//    [btn1 setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
//    btn1.layer.borderColor = [UIColor clearColor].CGColor;
//
//    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:24 tailSpacing:24];
//
//    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-18);
//        make.height.equalTo(@40);
//    }];
}

- (void)funAdsButtonClickItem:(UITapGestureRecognizer*)btn{
    EnumActionTag tag = btn.view.tag;
    switch (tag) {
        case EnumActionTag0:
        {
            [self disMissView];
        }
            break;
        case EnumActionTag1:
        {
            [self disMissView];
            if (self.block) {
                self.block(@(btn.view.tag));
            }
        }
            break;
        default:
            break;
    }
}

- (void)richElementsInViewWithModel:(id)model actionBlock:(ActionBlock)block{
    self.block = block;
    [_saftBtn setTitle:@"" forState:UIControlStateNormal];
    _saftBtn.hidden = YES;
    _line1.hidden = YES;
    UIButton* bt0 =_btns[0];
//    UIButton* bt1 =_btns[1];
    
    [bt0 setTitleColor:Color_0 forState:UIControlStateNormal];
    bt0.titleLabel.font = [UIFont systemFontOfSize:17];
    [bt0 setTitle:[NSString stringWithFormat:@"%@",model] forState:UIControlStateNormal];
    
//    [bt1 setTitleColor:HEXCOLOR(0x4a4a4a) forState:UIControlStateNormal];
//    bt1.titleLabel.font = [UIFont systemFontOfSize2:12];
//    [bt1 setTitle:@"" forState:UIControlStateNormal];
    
    CGFloat textHeight = [FunctionManager getContentHeightWithParagraphStyleLineSpacing:0 fontWithString:[NSString stringWithFormat:@"%@",model] fontOfSize:17 boundingRectWithWidth:XHHTuanNumViewWidth-40];
    if (textHeight > _contentViewHeigth - 48 -60) {
        _contentViewHeigth = textHeight +48 +60;
    }
    [_contentView setFrame:CGRectMake((SCREEN_WIDTH - XHHTuanNumViewWidth)/2, SCREEN_HEIGHT, XHHTuanNumViewWidth, _contentViewHeigth)];
    WEAK_OBJ(weakSelf, self);
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.alpha = 1.0;
        
        [weakSelf.contentView setFrame:CGRectMake((SCREEN_WIDTH - XHHTuanNumViewWidth)/2, (SCREEN_HEIGHT - weakSelf.contentViewHeigth)/2,XHHTuanNumViewWidth,weakSelf.contentViewHeigth)];
        
    } completion:nil];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

- (void)showInApplicationKeyWindow{
    [self showInView:[UIApplication sharedApplication].keyWindow];
    
    //    [popupView showInView:self.view];
    //
    //    [popupView showInView:[UIApplication sharedApplication].keyWindow];
    //
    //    [[UIApplication sharedApplication].keyWindow addSubview:popupView];
}

- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    WEAK_OBJ(weakSelf, self);
    [_contentView setFrame:CGRectMake((SCREEN_WIDTH - XHHTuanNumViewWidth)/2, (SCREEN_HEIGHT - _contentViewHeigth)/2, XHHTuanNumViewWidth, _contentViewHeigth)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         weakSelf.alpha = 0.0;
                         
                         [weakSelf.contentView setFrame:CGRectMake((SCREEN_WIDTH - XHHTuanNumViewWidth)/2, SCREEN_HEIGHT, XHHTuanNumViewWidth, weakSelf.contentViewHeigth)];
                     }
                     completion:^(BOOL finished){
                         
                         [weakSelf removeFromSuperview];
                         [weakSelf.contentView removeFromSuperview];
                         
                     }];
    
}
@end

