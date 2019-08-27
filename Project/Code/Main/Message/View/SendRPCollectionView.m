//
//  SendRPCollectionView.m
//  Project
//
//  Created by Mike on 2019/3/1.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "SendRPCollectionView.h"
#import "SendRPCollectionViewCell.h"

#define kColumn 5
#define kSpacingWidth 4
#define kTableViewMarginWidth 20

static NSString * const kCellSendRPCollectionViewId = @"SelectMineNumCell";

@interface SendRPCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property (nonatomic,strong) NSMutableArray *resultDataArray;

@end

@implementation SendRPCollectionView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}


- (void)setModel:(id)model {
    self.resultDataArray = [NSMutableArray arrayWithArray:(NSArray *)model];
    [self.collectionView reloadData];
}


#pragma mark - 首先创建一个collectionView
- (void)initSubviews {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWidth = (self.frame.size.width - (kColumn +1)*kSpacingWidth) / kColumn;
    // 设置每个item的大小
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    // 设置列间距
    layout.minimumInteritemSpacing = kSpacingWidth;
    
    // 设置行间距
    layout.minimumLineSpacing = kSpacingWidth;
    
    //每个分区的四边间距UIEdgeInsetsMake
    layout.sectionInset = UIEdgeInsetsMake(kSpacingWidth, kSpacingWidth, kSpacingWidth, kSpacingWidth);

    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    
    /** mainCollectionView 的布局(必须实现的) */
    _collectionView.collectionViewLayout = layout;
    
    //mainCollectionView 的背景色
    _collectionView.backgroundColor = [UIColor clearColor];
    
    //禁止滚动
    //_collectionView.scrollEnabled = NO;

    _collectionView.delegate = self;
    
    //设置数据源协议
    _collectionView.dataSource = self;

    [_collectionView registerClass:[SendRPCollectionViewCell class] forCellWithReuseIdentifier:kCellSendRPCollectionViewId];
    
    [self addSubview:self.collectionView];
    //    self.collectionView.backgroundColor = [UIColor redColor];
}





#pragma mark -- UICollectionViewDataSource 数据源

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.resultDataArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SendRPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellSendRPCollectionViewId forIndexPath:indexPath];
    NSString *numStr = self.resultDataArray[indexPath.row];
    cell.model = numStr;
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout  视图布局
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = (self.frame.size.width - (kColumn +1)*kSpacingWidth) / kColumn;
    return CGSizeMake(itemWidth, itemWidth);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kSpacingWidth, kSpacingWidth, kSpacingWidth, kSpacingWidth);
}

#pragma mark --UICollectionViewDelegate 代理

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectNumCollectionViewBlock) {
        self.selectNumCollectionViewBlock();
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectNumCollectionViewBlock) {
        self.selectNumCollectionViewBlock();
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tag != 99)
        return YES;
    if(self.collectionView.indexPathsForSelectedItems.count >= self.maxNum) {
        if (self.selectMoreMaxCollectionViewBlock) {
            self.selectMoreMaxCollectionViewBlock();
        }
        return NO;
    }
    
    return YES;
}




@end
