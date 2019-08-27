//
//  AddGroupContactHeadeerView.m
//  Project
//
//  Created by 汤姆 on 2019/7/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "AddGroupContactHeadeerView.h"
#import "AddGroupContactHeadeerViewCell.h"
static NSString *const AddGroupContactHeadeerViewCellID = @"AddGroupContactHeadeerViewCellID";
@interface AddGroupContactHeadeerView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@end
@implementation AddGroupContactHeadeerView
- (void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource;
    [self.collectionView reloadData];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionView.backgroundColor = BaseColor;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
//- (void)layoutSubviews{
//    [super layoutSubviews];
////    [self.collectionView layoutIfNeeded];
////    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//
//}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.layout];
        [_collectionView registerClass:[AddGroupContactHeadeerViewCell class] forCellWithReuseIdentifier:AddGroupContactHeadeerViewCellID];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.minimumLineSpacing = 3;
        _layout.minimumInteritemSpacing = 3;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        
    }
    return _layout;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AddGroupContactHeadeerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AddGroupContactHeadeerViewCellID forIndexPath:indexPath];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(50, 50);
}
@end
