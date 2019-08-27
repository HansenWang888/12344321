//
//  SendRedPackedCell.m
//  Project
//
//  Created by Mike on 2019/2/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "SelectMineNumCell.h"
#import "SendRPCollectionViewCell.h"
#import "SendRPCollectionView.h"

#define kColumn 5
#define kSpacingWidth 4
#define kTableViewMarginWidth 20
#define kBtnWidth 60

@interface SelectMineNumCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *noButton;
@property (nonatomic, strong) UILabel *moneyLabel;


@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *resultDataArray;
@property (nonatomic,strong) SendRPCollectionView *sendRPCollectionView;


@end

@implementation SelectMineNumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    SelectMineNumCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SelectMineNumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self initNotif];
        //        [self initSubviews];
    }
    return self;
}


- (void)setupUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"send_redpack_back"];
    backImageView.contentMode = UIViewContentModeScaleToFill;
    backImageView.userInteractionEnabled = YES;
    [self addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(CD_Scal(140, 812));
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.height.mas_equalTo(263);
    }];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(kTableViewMarginWidth);
        make.right.mas_equalTo(self.mas_right).offset(-kTableViewMarginWidth);
        make.height.mas_equalTo(CD_Scal(200, 812));
    }];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"雷       号";
    _titleLabel.font = [UIFont systemFontOfSize2:16];
    _titleLabel.textColor = [UIColor colorWithRed:0.388 green:0.388 blue:0.388 alpha:1.000];;
    [backView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(10);
        make.top.equalTo(backView.mas_top).offset(CD_Scal(35, 812));
    }];
    
    
    _noButton = [UIButton new];
    _noButton.layer.cornerRadius = (kBtnWidth-15)/2;
    _noButton.layer.masksToBounds = YES;
    _noButton.layer.borderWidth = 1;
    _noButton.layer.borderColor = [UIColor colorWithRed:1.000 green:0.443 blue:0.247 alpha:1.000].CGColor;
    _noButton.backgroundColor = [UIColor colorWithRed:1.000 green:0.890 blue:0.847 alpha:1.000];
    [_noButton setTitle:@"不" forState:UIControlStateNormal];
    _noButton.titleLabel.font = [UIFont boldSystemFontOfSize2:30];
    [_noButton setTitleColor:[UIColor colorWithRed:1.000 green:0.443 blue:0.247 alpha:1.000] forState:UIControlStateNormal];
    [_noButton addTarget:self action:@selector(onNoButton:) forControlEvents:UIControlEventTouchUpInside];
    _noButton.hidden = YES;
    CGSize size = CGSizeMake(kBtnWidth-15, kBtnWidth-15);
    
    //    [_noButton setBackgroundImage: [self createImageWithColor:[UIColor colorWithRed:0.725 green:0.761 blue:0.843 alpha:1.000] size:size]  forState:UIControlStateNormal];
    //    [_noButton setBackgroundImage: [self createImageWithColor:[UIColor colorWithRed:0.231 green:0.459 blue:0.796 alpha:1.000] size:size] forState:UIControlStateSelected];
    
    [backView addSubview:_noButton];
    
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width -kTableViewMarginWidth*2 - kSendRPTitleCellWidth - kBtnWidth  - (kColumn + 1) * kSpacingWidth) / kColumn;
    CGFloat height = itemWidth * 2 + kSpacingWidth * 3;
    
    
    
    
    
    
    CGFloat frameHeight = (CD_Scal(130, 812) - height) / 2;
    SendRPCollectionView *sendRPCollectionView = [[SendRPCollectionView alloc] initWithFrame:CGRectMake(kSendRPTitleCellWidth, frameHeight, [UIScreen mainScreen].bounds.size.width - kTableViewMarginWidth*2 - kSendRPTitleCellWidth - kBtnWidth, height)];
    //    sendRPCollectionView.backgroundColor = [UIColor redColor];
    sendRPCollectionView.collectionView.allowsMultipleSelection = YES;
    sendRPCollectionView.tag = 99;
    sendRPCollectionView.selectNumCollectionViewBlock = ^{
        if (self.selectNumBlock) {
            self.selectNumBlock(self.sendRPCollectionView.collectionView.indexPathsForSelectedItems);
        }
    };
    sendRPCollectionView.selectMoreMaxCollectionViewBlock = ^{
        if (self.selectMoreMaxBlock) {
            self.selectMoreMaxBlock(YES);
        }
    };
    [backView addSubview:sendRPCollectionView];
    _sendRPCollectionView = sendRPCollectionView;
    
    [_noButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-10);
        make.centerY.equalTo(sendRPCollectionView.mas_centerY);
        make.size.mas_equalTo(size);
    }];
    
    
    UILabel *moneyLabel = [UILabel new];
    moneyLabel.font = [UIFont systemFontOfSize:43];
    moneyLabel.textColor = [UIColor colorWithRed:1.000 green:0.447 blue:0.239 alpha:1.000];
    moneyLabel.text = @"￥0";
    [backView addSubview:moneyLabel];
    _moneyLabel = moneyLabel;
    //    _moneyLabel.backgroundColor = [UIColor blueColor];
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(backView.mas_bottom).offset(-CD_Scal(20, 812));
        make.centerX.equalTo(backView.mas_centerX);
    }];
    
    
    
    UIButton *submitBtn = [UIButton new];
    submitBtn.layer.cornerRadius = 8;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:18];
    submitBtn.layer.masksToBounds = YES;
    //    _submit.backgroundColor = MBTNColor;
    //    [_submit setTitle:@"塞钱进红包" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"send_btn"] forState:UIControlStateNormal];
    //    [_submit setBackgroundImage:[UIImage imageNamed:@"send_btn_dis"] forState:UIControlStateHighlighted];
    
    //    [_submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(action_sendRedpacked) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:submitBtn];
    [submitBtn delayEnable];
    
    
    CGFloat submitWidth = SCREEN_WIDTH/3;
    CGFloat bottomHeight = SCREEN_HEIGHT/2/2;
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(submitWidth);
        make.centerY.mas_equalTo(backImageView.mas_centerY).multipliedBy(1.3);
        make.centerX.mas_equalTo(backImageView.mas_centerX);
    }];
}


- (void)initNotif {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark -  输入字符判断
- (void)textFieldDidChangeValue:(NSNotification *)notiObject {
    
    UITextField *textFieldObj = (UITextField *)notiObject.object;
    NSInteger mObjectInte = [textFieldObj.text integerValue];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%ld",mObjectInte];
    self.money = textFieldObj.text;

}



/**
 设置颜色为背景图片
 
 @param color <#color description#>
 @param size <#size description#>
 @return <#return value description#>
 */
- (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)action_sendRedpacked {
    if (self.mineCellSubmitBtnBlock) {
        self.mineCellSubmitBtnBlock(self.money);
    }
}

- (void)onNoButton:(UIButton *)btn {
    btn.selected = !btn.selected;

    if (btn.selected) {
        self.noButton.backgroundColor = [UIColor colorWithRed:1.000 green:0.443 blue:0.247 alpha:1.000];
        [self.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        self.noButton.backgroundColor = [UIColor colorWithRed:1.000 green:0.890 blue:0.847 alpha:1.000];
        [self.noButton setTitleColor:[UIColor colorWithRed:1.000 green:0.443 blue:0.247 alpha:1.000] forState:UIControlStateNormal];
    }
    
    if (self.selectNoPlayingBlock) {
        self.selectNoPlayingBlock(btn.selected);
    }
}


- (void)setModel:(id)model {
    
    self.resultDataArray = [NSMutableArray arrayWithArray:(NSArray *)model];
    self.sendRPCollectionView.model = self.resultDataArray;

    if (self.money == nil || [self.money isEqual:[NSNull null]]) {
        self.money = @"0";
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@", self.money];
    //    [self.collectionView reloadData];
    //    _titleLabel.text =  [dict objectForKey:@"pokerCount"];
    
}

- (void)setIsBtnDisplay:(BOOL)isBtnDisplay {
    self.noButton.hidden = !isBtnDisplay;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setMaxNum:(int)maxNum{
    _maxNum = maxNum;
    _sendRPCollectionView.maxNum = maxNum;
}
@end


