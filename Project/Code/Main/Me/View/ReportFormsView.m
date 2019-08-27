//
//  ReportFormsView.m
//  Project
//
//  Created by fy on 2019/1/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ReportFormsView.h"
#import "ReportCell.h"
#import "ReportHeaderView.h"
#import "SelectTimeView.h"
#import "CDAlertViewController.h"

@implementation ReportFormsItem
@end

@interface ReportFormsView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)ReportHeaderView *headerView;

@end

@implementation ReportFormsView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView {
    // Do any additional setup after loading the view.
    self.beginTime = dateString_date([NSDate date], CDDateDay);
    self.endTime = dateString_date([NSDate date], CDDateDay);
    self.tempBeginTime = dateString_date([NSDate date], CDDateDay);
    self.tempEndTime = dateString_date([NSDate date], CDDateDay);
    
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
    SVP_SHOW;
    if([AppModel shareInstance].userInfo.agentFlag == NO)
        return;
}

-(void)setUserId:(NSString *)userId{
    _userId = userId;
    [self getData];
}
-(void)getData{
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestReportFormsWithUserId:self.userId beginTime:self.tempBeginTime endTime:self.tempEndTime success:^(id object) {
        SVP_DISMISS;
        weakSelf.beginTime = weakSelf.tempBeginTime;
        weakSelf.endTime = weakSelf.tempEndTime;
        [self requestDataBack:object[@"data"]];
        [weakSelf reloadData];
    } fail:^(id object) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)requestDataBack:(NSDictionary *)dict{
    [self.dataArray removeAllObjects];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    [self.dataArray addObject:categoryDic];
    
    [categoryDic setObject:@"APP活跃度" forKey:@"categoryName"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    ReportFormsItem *item = [[ReportFormsItem alloc] init];
    item.icon = @"Newregistration";
    item.title = NUMBER_TO_STR(dict[@"registerUserCount"]);
    item.desc = @"新注册人数";
    [arr addObject:item];
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Totalregistration";
    item.title = NUMBER_TO_STR(dict[@"registerUserTotal"]);
    item.desc = @"总注册人数";
    [arr addObject:item];
    [self.collectionView reloadData];
    
    NSString *s1 = NUMBER_TO_STR(dict[@"firstRechargeMoneySum"]);
    NSString *s2 =  NUMBER_TO_STR(dict[@"firstRechargeCount"]);
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Firstrecharge";
    item.title = [NSString stringWithFormat:@"%@/%@",s1,s2];
    item.desc = @"首充金额/笔数";
    [arr addObject:item];
    
    s1 = NUMBER_TO_STR(dict[@"secondRechargeMoneySum"]);
    s2 =  NUMBER_TO_STR(dict[@"secondRechargeCount"]);
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Recharge";
    item.title = [NSString stringWithFormat:@"%@/%@",s1,s2];
    item.desc = @"二充金额/笔数";
    [arr addObject:item];
    
    if([self isSelf]){
        categoryDic = [[NSMutableDictionary alloc] init];
        [self.dataArray addObject:categoryDic];
        
        [categoryDic setObject:@"充值与提现" forKey:@"categoryName"];
        arr = [[NSMutableArray alloc] init];
        [categoryDic setObject:arr forKey:@"list"];
        
        item = [[ReportFormsItem alloc] init];
        item.icon = @"fdefdsv";
        item.title = NUMBER_TO_STR(dict[@"rechargeMoneySum"]);
        item.desc = @"充值总额";
        [arr addObject:item];
        
        item = [[ReportFormsItem alloc] init];
        item.icon = @"Totalrecharge";
        item.title = NUMBER_TO_STR(dict[@"cashDrawsMoneySum"]);
        item.desc = @"提现总额";
        [arr addObject:item];
        [self.collectionView reloadData];
        
        item = [[ReportFormsItem alloc] init];
        item.icon = @"Startingamount";
        item.title = NUMBER_TO_STR(dict[@"beginMoney"]);
        item.desc = @"起始余额";
        [arr addObject:item];
        
        item = [[ReportFormsItem alloc] init];
        item.icon = @"Asofbalance";
        item.title = NUMBER_TO_STR(dict[@"endMoney"]);
        item.desc = @"截至余额";
        [arr addObject:item];
        
//        item = [[ReportFormsItem alloc] init];
//        item.icon = @"Profitandloss";
//        item.title = NUMBER_TO_STR(dict[@"profit"]);
//        item.desc = @"盈亏";
//        [arr addObject:item];
//
//        item = [[ReportFormsItem alloc] init];
//        item.icon = @"fc";
//        item.title = NUMBER_TO_STR(dict[@"profitCommission"]);
//        item.desc = @"我的分成";
//        [arr addObject:item];
    }
    
    categoryDic = [[NSMutableDictionary alloc] init];
    [self.dataArray addObject:categoryDic];
    
    [categoryDic setObject:@"发包与抢包" forKey:@"categoryName"];
    arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    s1 = NUMBER_TO_STR(dict[@"redbonusMoneySum"]);
    s2 =  NUMBER_TO_STR(dict[@"redbonusCount"]);
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Amountofthepackage";
    item.title = [NSString stringWithFormat:@"%@/%@",s1,s2];
    item.desc = @"发包金额/个数";
    [arr addObject:item];
    
    s1 = NUMBER_TO_STR(dict[@"grabMoneySum"]);
    s2 =  NUMBER_TO_STR(dict[@"grabCount"]);
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"qb";
    item.title = [NSString stringWithFormat:@"%@/%@",s1,s2];
    item.desc = @"抢包金额/个数";
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Hairbag";
    item.title = NUMBER_TO_STR(dict[@"redbonusUserCount"]);
    item.desc = @"发包人数";
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"snatch";
    item.title = NUMBER_TO_STR(dict[@"grabUserCount"]);
    item.desc = @"抢包人数";
    [arr addObject:item];
    
    categoryDic = [[NSMutableDictionary alloc] init];
    [self.dataArray addObject:categoryDic];
    
    [categoryDic setObject:@"奖金与佣金" forKey:@"categoryName"];
    arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"yjfc";
    item.title = NUMBER_TO_STR(dict[@"sendCommission"]);
    item.desc = @"流水佣金分成";
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"";//@"yqhyyj";
    item.title = @"敬请期待";
    item.desc = @"";
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"scjj";
    item.title = NUMBER_TO_STR(dict[@"firstRechargePrize"]);
    item.desc = @"首充用户奖金";
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"esjj";
    item.title = NUMBER_TO_STR(dict[@"secondRechargePrize"]);
    item.desc = @"二充用户奖金";
    [arr addObject:item];
}

-(void)reloadData{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return CGSizeMake(self.frame.size.width, 38 + SCREEN_WIDTH/2 * 0.55);
    else
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
        ReportHeaderView *pView = [reusableview viewWithTag:97];
        if(indexPath.section == 0){
            if(pView == nil){
                pView = [ReportHeaderView headView];
                self.headerView = pView;
                WEAK_OBJ(weakSelf, self);
                pView.beginChange = ^(id object) {
                    [weakSelf datePickerByType:0];
                };
                pView.endChange = ^(id object) {
                    [weakSelf datePickerByType:1];
                };
                pView.tag = 97;
                [reusableview addSubview:pView];
                NSInteger width = SCREEN_WIDTH/2;
                [pView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.equalTo(reusableview);
                    make.height.equalTo(@(width * 0.55));
                }];
                [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(reusableview).offset(25);
                    make.bottom.equalTo(reusableview);
                    make.height.equalTo(@30);
                }];
            }
            pView.beginTime = self.beginTime;
            pView.endTime = self.endTime;
        }else
            [pView removeFromSuperview];
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


-(void)showTimeSelectView{
    SelectTimeView *timeView = [SelectTimeView sharedInstance];
    WEAK_OBJ(weakSelf, self);
    timeView.selectBlock = ^(id object) {
        TimeRange range = (TimeRange)[object integerValue];
        [weakSelf selectTime:range];
    };
    [self addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

-(void)selectTime:(TimeRange)range{
    if(range == TimeRange_today){
        self.tempBeginTime = dateString_date([NSDate date], CDDateDay);
        self.tempEndTime = dateString_date([NSDate date], CDDateDay);
        [self.rightBtn setTitle:@"今天" forState:UIControlStateNormal];
    }else if(range == TimeRange_yesterday){
        self.tempBeginTime = dateString_date([[NSDate alloc] initWithTimeIntervalSinceNow:-24 * 3600], CDDateDay);
        self.tempEndTime = dateString_date([[NSDate alloc] initWithTimeIntervalSinceNow:-24 * 3600], CDDateDay);
        [self.rightBtn setTitle:@"昨天" forState:UIControlStateNormal];
    }else if(range == TimeRange_thisWeek){
        NSDate *nowDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:nowDate];
        // 获取今天是周几
        NSInteger weekDay = [comp weekday];
        weekDay -= 1;
        if(weekDay < 1)
            weekDay = 7;
        self.tempBeginTime = dateString_date([[NSDate alloc] initWithTimeIntervalSinceNow:- ((weekDay - 1) * 24 * 3600)], CDDateDay);
        self.tempEndTime = dateString_date([NSDate date], CDDateDay);
        [self.rightBtn setTitle:@"本周" forState:UIControlStateNormal];
    }else if(range == TimeRange_lastWeek){
        NSDate *nowDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:nowDate];
        // 获取今天是周几
        NSInteger weekDay = [comp weekday];
        weekDay -= 1;
        if(weekDay < 1)
            weekDay = 7;
        self.tempBeginTime = dateString_date([[NSDate alloc] initWithTimeIntervalSinceNow:- ((weekDay - 1 + 7) * 24 * 3600)], CDDateDay);
        self.tempEndTime = dateString_date([[NSDate alloc] initWithTimeIntervalSinceNow: ((7 - weekDay - 7) * 24 * 3600)], CDDateDay);
        [self.rightBtn setTitle:@"上周" forState:UIControlStateNormal];
    }else if(range == TimeRange_thisMonth){
        NSDate *nowDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth  fromDate:nowDate];
        NSInteger year = [comp year];
        NSInteger month = [comp month];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [formatter setTimeZone:timeZone];
        [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
        
        NSString *timeStrb = [NSString stringWithFormat:@"%ld-%02ld-01 00:00:00",(long)year,(long)month];
        self.tempBeginTime = dateString_date([formatter dateFromString:timeStrb], CDDateDay);
        
        //        month += 1;
        //        if(month > 12){
        //            month = 1;
        //            year += 1;
        //        }
        //        NSString *timeStre = [NSString stringWithFormat:@"%ld-%02ld-01 00:00:00",(long)year,(long)month];
        //        NSDate *dd = [[formatter dateFromString:timeStre] dateByAddingTimeInterval:-24 * 3600];
        self.tempEndTime = dateString_date([NSDate date], CDDateDay);
        [self.rightBtn setTitle:@"本月" forState:UIControlStateNormal];
    }else if(range == TimeRange_lastMonth){
        NSDate *nowDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth  fromDate:nowDate];
        NSInteger year = [comp year];
        NSInteger month = [comp month];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [formatter setTimeZone:timeZone];
        [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
        
        NSString *timeStrb = [NSString stringWithFormat:@"%ld-%02ld-01 00:00:00",(long)year,(long)month];
        NSDate *dd = [[formatter dateFromString:timeStrb] dateByAddingTimeInterval:-24 * 3600];
        self.tempEndTime = dateString_date(dd, CDDateDay);
        
        month -= 1;
        if(month < 1){
            month = 12;
            year -= 1;
        }
        NSString *timeStre = [NSString stringWithFormat:@"%ld-%2ld-01 00:00:00",(long)year,(long)month];
        self.tempBeginTime = dateString_date([formatter dateFromString:timeStre], CDDateDay);
        [self.rightBtn setTitle:@"上月" forState:UIControlStateNormal];
    }
    SVP_SHOW;
    [self getData];
}

- (void)datePickerByType:(NSInteger)type{
    __weak typeof(self) weakSelf = self;
    [CDAlertViewController showDatePikerDate:^(NSString *date) {
        [weakSelf updateType:type date:date];
    }];
}

- (void)updateType:(NSInteger)type date:(NSString *)date{
    if (type == 0) {
        if([self.beginTime isEqualToString:date])
            return;
        self.beginTime = date;
        self.tempBeginTime = self.beginTime;
        self.headerView.beginTime = self.beginTime;
        [self.rightBtn setTitle:@"--" forState:UIControlStateNormal];
    }else{
        if([self.endTime isEqualToString:date])
            return;
        self.endTime = date;
        self.tempEndTime = self.endTime;
        self.headerView.endTime = self.endTime;
        [self.rightBtn setTitle:@"--" forState:UIControlStateNormal];
    }
    if([self.beginTime compare:self.endTime] != NSOrderedDescending){
        SVP_SHOW;
        [self getData];
    }
}

-(BOOL)isSelf{
    if(self.userId == nil)
        return NO;
    if([self.userId integerValue] == [[AppModel shareInstance].userInfo.userId integerValue])
        return YES;
    return NO;
}
@end
