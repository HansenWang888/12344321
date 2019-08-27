
//
//  GuideViewController.m
//  Project
//
//  Created by mac on 2018/8/28.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UICollectionView *_collectionView;
    NSArray *_dataList;
}

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
    [self initLayout];
}

#pragma mark ----- Data
- (void)initData{
    _dataList = @[@"guide0",@"guide1",@"guide2"];
}

#pragma mark ----- Layout
- (void)initLayout{
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"class"];
    
    UIButton *btn = [UIButton new];
    [self.view addSubview:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize2:15];
    btn.backgroundColor = COLOR_X(244, 112, 35);
    [btn setTitle:@"立即加入" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 12;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 1.0f;
    [btn addTarget:self action:@selector(action_done) forControlEvents:UIControlEventTouchUpInside];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.height.equalTo(@(42));
        make.width.equalTo(@90);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"class" forIndexPath:indexPath];
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    UIImageView *img = [UIImageView new];
    [cell.contentView addSubview:img];
    img.image = [UIImage imageNamed:_dataList[indexPath.row]];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        [self action_done];
    }
}

#pragma mark action
- (void)action_done{
    [[NSUserDefaults standardUserDefaults]setObject:@(YES) forKey:[NSString appVersion]];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[AppModel shareInstance] reSetRootAnimation:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
