//
//  YEBInfoVC.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/23.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "YEBInfoVC.h"
#import "YEBHelpVC.h"
#import "YEBTransferDetailView.h"
#import "YEBProfitsDetailView.h"
#import "YEBAccountInfoModel.h"

@interface YEBInfoVC ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) DYSliderHeadView *controlView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<UIView *> *datasource;


@end

@implementation YEBInfoVC {

    NSInteger _defaultSelected;
    
}

+ (instancetype)finalcialInfoVC:(YEBAccountInfoModel *)model {
    
    YEBInfoVC *vc = [YEBInfoVC new];
    vc->_defaultSelected = 0;
    vc.model = model;
    return vc;
}
+ (instancetype)profitInfoVC:(YEBAccountInfoModel *)model {
    
    YEBInfoVC *vc = [YEBInfoVC new];
    vc->_defaultSelected = 1;
    vc.model = model;

    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubView];
//    self.navigationController.navigationBar.translucent = NO;


    // Do any additional setup after loading the view from its nib.
}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:NO];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//
//}
- (void)setupSubView {
    
    YEBTransferDetailView *detailView = [YEBTransferDetailView new];
    detailView.model = self.model;
    if (_defaultSelected) {
        self.controlView = [[DYSliderHeadView alloc] initWithTitles:@[@"收益详情",@"资金明细"]];
        self.datasource = @[[YEBProfitsDetailView new], detailView];
    } else {
        self.controlView = [[DYSliderHeadView alloc] initWithTitles:@[@"资金明细",@"收益详情"]];
        self.datasource = @[detailView, [YEBProfitsDetailView new]];
    }
  
    self.title = @"我的余额宝";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"yeb-?"] style:UIBarButtonItemStylePlain target:self action:@selector(helpBtnClick)];
    self.controlView.type = DYSliderHeaderTypeBanScroll;
    kWeakly(self);
    self.controlView.selectIndexBlock = ^(NSInteger idx) {
        [weakself.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0] atScrollPosition:0 animated:true];
    };
    
    self.controlView.selectColor = kThemeTextColor;
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
  
    [self.view addSubview:self.controlView];
    [self.view addSubview:self.collectionView];
    
    
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(44);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.controlView.mas_bottom).offset(0);
    }];

    
}



- (void)helpBtnClick {
   
    YEBHelpVC *vc = [YEBHelpVC new];
    [self.navigationController pushViewController:vc animated:1];
}


#pragma mark - collectionview delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datasource.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (cell.contentView.subviews.count == 0) {
        UIView *view = self.datasource[indexPath.row];
        [cell.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    

    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}
\
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return collectionView.frame.size;
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
