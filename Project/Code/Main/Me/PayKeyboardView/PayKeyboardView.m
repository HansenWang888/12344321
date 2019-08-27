//
//  PayKeyboardView.m
//  PayKeyboard
//
//  Created by 汤姆 on 2019/7/21.
//  Copyright © 2019 opo. All rights reserved.
//

#import "PayKeyboardView.h"

#import <Masonry.h>
static NSString *const payCellid = @"PayKeyboardViewcell";
@interface PayKeyboardView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (strong, nonatomic) UILabel *titleLab;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSArray *dataSource;

/**删除*/
@property (nonatomic, strong) UIButton *deleteBtn;
/**确定*/
@property (nonatomic, strong) UIButton *determineBtn;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation PayKeyboardView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lineView];
        [self addSubview:self.titleLab];
        [self addSubview:self.collectionView];
        [self addSubview:self.passWordView];
        [self addSubview:self.deleteBtn];
        [self addSubview:self.determineBtn];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.mas_equalTo(-KeyboardViewCellW);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-bottomBarHeight);
            make.height.mas_equalTo(KeyboardViewCellW * 2 + 3);
        }];
        [self.passWordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.equalTo(self.collectionView.mas_top).offset(-passWordViewSpacing);
            make.height.mas_equalTo(passWordViewW);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 20);
        }];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.passWordView.mas_top).offset(-passWordViewSpacing);
            make.centerX.equalTo(self);
        }];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.equalTo(self.collectionView.mas_top);
            make.bottom.mas_equalTo(self.collectionView.mas_centerY);
            make.left.mas_equalTo(self.collectionView.mas_right);
        }];
        [self.determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.equalTo(self.deleteBtn.mas_bottom);
            make.bottom.mas_equalTo(self.collectionView.mas_bottom);
            make.left.mas_equalTo(self.collectionView.mas_right);
        }];
        [self.deleteBtn addTarget:self action:@selector(deleteInside:) forControlEvents:UIControlEventTouchUpInside];
        [self.determineBtn addTarget:self action:@selector(determineInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)deleteInside:(UIButton *)btn{
    
    [self.passWordView deleteBackward];
    [self.passWordView setNeedsDisplay];
}

/**
 确定

 */
- (void)determineInside:(UIButton *)btn{
    if (self.determineBlock != nil){
        self.determineBlock(self.passWordView.textStore);
    }
  
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 11){
        if (self.hideBlock != nil){
            self.hideBlock();
        }
    }else{
        NSString *key = self.dataSource[indexPath.row];

        [self.passWordView insertText:key];
        [self.passWordView setNeedsDisplay];
    }
}
#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PayKeyboardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:payCellid forIndexPath:indexPath];
    if (indexPath.row == 11){
        cell.imageV.image = [UIImage imageNamed:self.dataSource[indexPath.row]];
        cell.lab.hidden = YES;
    }else{
        cell.lab.text = self.dataSource[indexPath.row];
        cell.imageV.hidden = YES;
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(KeyboardViewCellW, KeyboardViewCellW/2);
}

- (UILabel *)titleLab{
    if (!_titleLab){
        _titleLab = [[UILabel alloc]init];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont boldSystemFontOfSize:20];
        _titleLab.textColor = UIColor.blackColor;
        _titleLab.text = @"设置支付密码";
    }
    return _titleLab;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = UIColor.lightGrayColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[PayKeyboardViewCell class] forCellWithReuseIdentifier:payCellid];
        _collectionView.layer.borderWidth = 0.5;
        _collectionView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.minimumLineSpacing = 1;
        _layout.minimumInteritemSpacing = 1;
    }
    return _layout;
}
- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc]init];
        [_deleteBtn setImage:[UIImage imageNamed:@"PayNumberKeyboard.bundle/delete.png"] forState:UIControlStateNormal];
        _deleteBtn.backgroundColor = [UIColor colorWithRed:246.0 / 255.0 green:246.0 / 255.0 blue:246.0 / 255.0 alpha:1.0];
        _deleteBtn.layer.borderWidth = 0.5;
        _deleteBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _deleteBtn;
}
- (UIButton *)determineBtn{
    if (!_determineBtn) {
        _determineBtn = [[UIButton alloc]init];
        [_determineBtn setTitle:@"确定" forState:UIControlStateNormal];
        _determineBtn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        [_determineBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _determineBtn.backgroundColor = [UIColor colorWithRed:50.0 / 255.0 green:147.0 / 255.0 blue:227.0 / 255.0 alpha:1.0];
    }
    return _determineBtn;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = UIColor.lightGrayColor;
    }
    return _lineView;
}
- (PayPassWordView *)passWordView{
    if (!_passWordView){
        _passWordView = [[PayPassWordView alloc]init];
        _passWordView.backgroundColor = UIColor.grayColor;
        _passWordView.squareWidth = ([UIScreen mainScreen].bounds.size.width - 20) / 6;
        _passWordView.rectColor = UIColor.grayColor;
    }
    return _passWordView;
}
- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"·",@"0",@"PayNumberKeyboard.bundle/resign.png",];
    }
    return _dataSource;
}
@end
@interface PayKeyboardViewCell()

@end
@implementation PayKeyboardViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:246.0 / 255.0 green:246.0 / 255.0 blue:246.0 / 255.0 alpha:1.0];
        [self addSubview: self.lab];
        [self addSubview:self.imageV];
        self.lab.frame = self.bounds;
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(10);
            make.bottom.right.mas_equalTo(-10);
        }];
    }
    return self;
}
- (UILabel *)lab{
    if (!_lab) {
        _lab = [[UILabel alloc]init];
        _lab.font = [UIFont boldSystemFontOfSize:24];
        _lab.textColor = UIColor.blackColor;
        _lab.highlightedTextColor =  [UIColor colorWithRed:50.0 / 255.0 green:147.0 / 255.0 blue:227.0 / 255.0 alpha:1.0];

        _lab.textAlignment = NSTextAlignmentCenter;
    }
    return _lab;
}
- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.contentMode = UIViewContentModeCenter;
    }
    return _imageV;
}
@end
