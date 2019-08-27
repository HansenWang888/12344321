//
//  GroupHeadView.m
//  Project
//
//  Created by mini on 2018/8/16.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "GroupHeadView.h"
#import "UserCollectionViewCell.h"
#import "GroupNet.h"
#import "MessageItem.h"
#import "GroupInfoUserModel.h"
@interface GroupHeadView()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UICollectionView *_collectionView;
    UIButton *_allBtn;
}
@property (nonatomic ,strong) NSMutableArray <GroupInfoUserModel *>*dataList;
@property (nonatomic ,strong) MessageItem *item;
@end

@implementation GroupHeadView


+ (GroupHeadView *)headViewWithModel:(GroupNet *)model item:(MessageItem *)item isGroupLord:(BOOL)isGroupLord {

    GroupHeadView *view = [[GroupHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    view.item = item;
    NSMutableArray <GroupInfoUserModel*>*models = [GroupInfoUserModel mj_objectArrayWithKeyValuesArray:model.dataList];
    [models enumerateObjectsUsingBlock:^(GroupInfoUserModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj.avatar hasPrefix:@"http"]) {
            obj.avatar = @"http://user-default";
        }
        if (isGroupLord) {//群主
            if (idx < 13) {
                [view.dataList addObject:obj];
            }
        }else{//自建群
            if (item.officeFlag){
                [view.dataList addObject:obj];
            }else{
                if (idx < 14) {
                    [view.dataList addObject:obj];
                }
            }
        }
    }];
    if (isGroupLord) {
        GroupInfoUserModel *model = [[GroupInfoUserModel alloc]init];
        model.avatar = @"group_+";
        [view.dataList addObject:model];
        GroupInfoUserModel *model1 = [[GroupInfoUserModel alloc]init];
        model1.avatar = @"group_-";
        [view.dataList addObject:model1];
    }else{
        if (!item.officeFlag){
            GroupInfoUserModel *model1 = [[GroupInfoUserModel alloc]init];
            model1.avatar = @"group_+";
            [view.dataList addObject:model1];
        }
    }

    NSInteger lorow = (view.dataList.count == 0) ? 0 : (view.dataList.count)/5 + ((view.dataList.count) % 5 > 0 ? 1: 0);
    CGFloat height = (lorow > 3 ? 3 : lorow)*CD_Scal(82, 667)+50;
    view.height = height;
    view.isGroupLord = isGroupLord;
    [view updateList:model];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initSubviews];
        [self initLayout];
    }
    return self;
}

#pragma mark - Data
- (void)initData{
    
}

- (void)updateList:(GroupNet *)model {
//     _dataList = model.dataList;
    [_collectionView reloadData];
    
    NSString *count = [NSString stringWithFormat:@"全部群成员(%ld)>",model.total];

    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:count];
    NSRange rang = NSMakeRange(0, count.length);
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize2:14] range:rang];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:MBTNColor range:NSMakeRange(rang.location, rang.length)];

    [_allBtn setAttributedTitle:AttributedStr forState:UIControlStateNormal];
}


#pragma mark ----- Layout
- (void)initLayout{
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-50);
    }];
    
    [_allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self-> _collectionView.mas_bottom).offset(0);
        make.width.equalTo(self.mas_width).offset(-60);
        make.height.equalTo(@(50));
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    self.backgroundColor = Color_F;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/5, CD_Scal(82, 667));
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    [self addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:NSClassFromString(@"UserCollectionViewCell") forCellWithReuseIdentifier:@"UserCollectionViewCell"];
    
    _allBtn = [UIButton new];
    [self addSubview:_allBtn];
    _allBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
    [_allBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
 
    [_allBtn addTarget:self action:@selector(action_allClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCollectionViewCell" forIndexPath:indexPath];
    if (self.dataList.count > indexPath.row) {
        cell.model = self.dataList[indexPath.row];
    }
        __weak __typeof(self)weakSelf = self;
        cell.block = ^(NSInteger tag) {
            if (weakSelf.click) {
                weakSelf.click(tag);
            }
        };

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.click) {
        self.click(indexPath.row);
    }
}

#pragma mark action
- (void)action_allClick{
    if (self.click) {
        self.click(0);
    }
}
- (NSMutableArray<GroupInfoUserModel *> *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataList;
}
@end
