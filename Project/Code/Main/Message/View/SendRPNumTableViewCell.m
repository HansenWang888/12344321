//
//  SendRPNumTableViewCell.m
//  Project
//
//  Created by Mike on 2019/3/1.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "SendRPNumTableViewCell.h"
#import "SendRPCollectionViewCell.h"
#import "SendRPCollectionView.h"

#define kColumn 5
#define kSpacingWidth 4
#define kTableViewMarginWidth 20
#define kBtnWidth 60

@interface SendRPNumTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *unitLabel;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *resultDataArray;
@property (nonatomic,strong) SendRPCollectionView *sendRPCollectionView;


@end

@implementation SendRPNumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    SendRPNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SendRPNumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        //        [self initSubviews];
    }
    return self;
}


- (void)setupUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(kTableViewMarginWidth);
        make.right.mas_equalTo(self.mas_right).offset(-kTableViewMarginWidth);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"红包个数";
    _titleLabel.font = [UIFont systemFontOfSize2:15];
    _titleLabel.textColor = [UIColor colorWithRed:0.388 green:0.388 blue:0.388 alpha:1.000];;
    [backView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(10);
        make.centerY.equalTo(backView.mas_centerY);
    }];
    
    
    _unitLabel = [UILabel new];
    _unitLabel.text = @"包";
    _unitLabel.font = [UIFont systemFontOfSize2:16];
    _unitLabel.textColor = [UIColor colorWithRed:0.388 green:0.388 blue:0.388 alpha:1.000];
    [backView addSubview:_unitLabel];
    
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-10);
        make.centerY.equalTo(backView.mas_centerY);
    }];
    
    
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width -kTableViewMarginWidth*2 - kSendRPTitleCellWidth - kBtnWidth - (kColumn + 1) * kSpacingWidth) / kColumn;
    
    CGFloat height = itemWidth * 1 + kSpacingWidth * 2;
    CGFloat frameHeight = (CD_Scal(60, 812) - height) / 2;
    SendRPCollectionView *sendRPCollectionView = [[SendRPCollectionView alloc] initWithFrame:CGRectMake(kSendRPTitleCellWidth, frameHeight, [UIScreen mainScreen].bounds.size.width -kTableViewMarginWidth*2 -kSendRPTitleCellWidth - kBtnWidth, height)];
//    sendRPCollectionView.backgroundColor = [UIColor redColor];
    sendRPCollectionView.collectionView.allowsMultipleSelection = NO;
    sendRPCollectionView.selectNumCollectionViewBlock = ^{
        if (self.selectNumBlock) {
            self.selectNumBlock(self.sendRPCollectionView.collectionView.indexPathsForSelectedItems);
        }
    };
    [backView addSubview:sendRPCollectionView];
    _sendRPCollectionView = sendRPCollectionView;
    
    
}


- (void)setModel:(id)model {
    
    self.resultDataArray = [NSMutableArray arrayWithArray:(NSArray *)model];
    self.sendRPCollectionView.model = self.resultDataArray;
    //    [self.collectionView reloadData];
    //    _titleLabel.text =  [dict objectForKey:@"pokerCount"];
}





- (void)layoutSubviews
{
    [super layoutSubviews];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end



