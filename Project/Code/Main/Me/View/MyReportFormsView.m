//
//  MyReportFormsView.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/4/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "MyReportFormsView.h"
#import "ReportCell.h"

@interface MyReportFormsView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation MyReportFormsView


-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView {    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    NSInteger width = SCREEN_WIDTH/2;
    layout.itemSize = CGSizeMake(width, width * 0.55);
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    [self addSubview:_collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:NSClassFromString(@"ReportCell") forCellWithReuseIdentifier:@"ReportCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    WEAK_OBJ(weakSelf, self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.dataArray = [[NSMutableArray alloc] init];    
}

-(void)setUserId:(NSString *)userId{
    _userId = userId;
    [self getData];
}

-(void)getData{
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestUserReportInfoWithId:self.userId success:^(id object) {
        SVP_DISMISS;
        [self getDataBack:object[@"data"]];
        [weakSelf reloadData];
    } fail:^(id object) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}


-(void)getDataBack:(NSDictionary *)dict{
    [self.dataArray removeAllObjects];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    [self.dataArray addObject:categoryDic];
    [categoryDic setObject:@"充值奖励" forKey:@"categoryName"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    ReportFormsItem *item = [[ReportFormsItem alloc] init];
    item.icon = @"Firstrecharge";
    item.title = STR_TO_AmountFloatSTR(NUMBER_TO_STR(dict[@"first"]));
    item.desc = @"首充奖励赠送";
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Recharge";
    item.title = STR_TO_AmountFloatSTR(NUMBER_TO_STR(dict[@"two"]));
    item.desc = @"二充奖励赠送";
    [arr addObject:item];
    
    categoryDic = [[NSMutableDictionary alloc] init];
    [self.dataArray addObject:categoryDic];
    [categoryDic setObject:@"邀请会员完成充值" forKey:@"categoryName"];
    arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Firstrecharge";
    item.title = STR_TO_AmountFloatSTR(NUMBER_TO_STR(dict[@"friendFirst"]));
    item.desc = @"首充奖励赠送";
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Recharge";
    item.title = STR_TO_AmountFloatSTR(NUMBER_TO_STR(dict[@"friendTwo"]));
    item.desc = @"二充奖励赠送";
    [arr addObject:item];
    
    categoryDic = [[NSMutableDictionary alloc] init];
    [self.dataArray addObject:categoryDic];
    [categoryDic setObject:@"发包与抢包满额奖励" forKey:@"categoryName"];
    arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Hairbag";
    item.title = STR_TO_AmountFloatSTR(NUMBER_TO_STR(dict[@"send"]));
    item.desc = @"发包奖励";
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"snatch";
    item.title = STR_TO_AmountFloatSTR(NUMBER_TO_STR(dict[@"rob"]));
    item.desc = @"抢包奖励";
    [arr addObject:item];
    
    categoryDic = [[NSMutableDictionary alloc] init];
    [self.dataArray addObject:categoryDic];
    [categoryDic setObject:@"豹子顺子与直推奖励" forKey:@"categoryName"];
    arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"yjfc";
    item.title = STR_TO_AmountFloatSTR(NUMBER_TO_STR(dict[@"bzsz"]));
    item.desc = @"豹子顺子奖励";
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"esjj";
    item.title = STR_TO_AmountFloatSTR(NUMBER_TO_STR(dict[@"commission"]));
    item.desc = @"直推佣金奖励";
    [arr addObject:item];
}


-(void)reloadData{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    if(section == 0)
//        return CGSizeMake(self.frame.size.width, 38 + SCREEN_WIDTH/2 * 0.55);
//    else
        return CGSizeMake(self.frame.size.width, 38);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
        reusableview.backgroundColor = [UIColor whiteColor];
        
        UIImageView *view = [[UIImageView alloc] init];
        view.tag = 96;
        view.backgroundColor = MBTNColor;
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 4;
        [reusableview addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@8);
            make.left.equalTo(reusableview).offset(12);
            make.bottom.equalTo(reusableview).offset(-11);
        }];
        UILabel *label = [reusableview viewWithTag:99];
        if(label == nil){
            label = [[UILabel alloc] init];
            label.textColor = HexColor(@"#48414f");
            label.font = [UIFont systemFontOfSize2:15];
            [reusableview addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(reusableview).offset(25);
                make.bottom.equalTo(reusableview);
                make.height.equalTo(@30);
            }];
            label.tag = 99;
        }
        UIView *lineView = [reusableview viewWithTag:100];
        if(lineView == nil){
            lineView = [[UIView alloc] init];
            lineView.backgroundColor = TBSeparaColor;
            [reusableview addSubview:lineView];
            lineView.tag = 100;
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0.5);
                make.width.equalTo(reusableview);
                make.bottom.equalTo(reusableview);
            }];
        }
        lineView = [reusableview viewWithTag:98];
        if(lineView == nil){
            lineView = [[UIView alloc] init];
            lineView.backgroundColor = BaseColor;
            [reusableview addSubview:lineView];
            lineView.tag = 98;
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@8);
                make.width.equalTo(reusableview);
                make.bottom.equalTo(label.mas_top);
            }];
        }
        NSDictionary *dic = self.dataArray[indexPath.section];
        label.text = dic[@"categoryName"];
    }
    return reusableview;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *dic = self.dataArray[section];
    NSArray *list = dic[@"list"];
    return list.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"ReportCell";
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSArray *list = dic[@"list"];
    ReportFormsItem *item = list[indexPath.row];
    ReportCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UIView *lineView1 = [cell.contentView viewWithTag:211];
    UIView *lineView2 = [cell.contentView viewWithTag:212];
    if(lineView1 == nil){
        lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = TBSeparaColor;
        [cell.contentView addSubview:lineView1];
        lineView1.tag = 211;
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0.5);
            make.height.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView);
        }];
    }
    if(lineView2 == nil){
        lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = TBSeparaColor;
        [cell.contentView addSubview:lineView2];
        lineView2.tag = 212;
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.width.equalTo(cell.contentView);
            make.bottom.equalTo(cell.contentView).offset(-0.5);
        }];
    }
    cell.iconImageView.image = [UIImage imageNamed:item.icon];
    cell.titleLabel.text = item.title;
    cell.descLabel.text = item.desc;
    return cell;
}

@end
