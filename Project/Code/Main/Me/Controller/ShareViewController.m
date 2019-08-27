//
//  ShareViewController.m
//  Project
//
//  Created by fy on 2019/1/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareListCell.h"
#import "ShareDetailViewController.h"

@interface ShareViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSString *shareUrl;
@property(nonatomic,strong)NSDictionary *tempDic;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分享赚钱";
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    NSInteger width = (SCREEN_WIDTH - 24)/2;
    layout.itemSize = CGSizeMake(width, width * 1.6);
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(6, 8, 8, 8);
    [self.collectionView registerClass:NSClassFromString(@"ShareListCell") forCellWithReuseIdentifier:@"ShareListCell"];
    WEAK_OBJ(weakSelf, self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    SVP_SHOW;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.shareUrl = [ud objectForKey:@"shareUrl"];
    [self getData];
}

-(void)getData{
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestShareListWithSuccess:^(id object) {
        SVP_DISMISS;
        weakSelf.dataArray = object[@"data"][@"records"];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView reloadData];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"ShareListCell";
    ShareListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.titleLabel.text = dic[@"title"];
    cell.pageViewLabel.text = [NSString stringWithFormat:@"%ld",[dic[@"clickNum"] integerValue]];
    [cell.iconView cd_setImageWithURL:[NSURL URLWithString:dic[@"firstAvatar"]] placeholderImage:nil];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(96, 100);
//}
//定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_OBJ(weakSelf, self);
    self.tempDic = self.dataArray[indexPath.row];
    SVP_SHOW;
    NSInteger tId = [self.tempDic[@"id"] integerValue];
    [NET_REQUEST_MANAGER getShareUrlWithCode:INT_TO_STR(tId) success:^(id object) {
        weakSelf.shareUrl = object[@"data"];
        if(weakSelf.shareUrl == nil){
            SVP_ERROR_STATUS(@"获取分享地址失败");
            return;
        }
        SVP_DISMISS;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:weakSelf.shareUrl forKey:@"shareUrl"];
        [ud synchronize];
        [weakSelf requestUrlBack];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)requestUrlBack{
    ShareDetailViewController *vc = [[ShareDetailViewController alloc] init];
    vc.title = self.tempDic[@"title"];
    vc.shareInfo = self.tempDic;
    vc.shareUrl = [NSString stringWithFormat:@"%@%@",self.shareUrl,[AppModel shareInstance].userInfo.invitecode];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
