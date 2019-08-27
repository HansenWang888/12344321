//
//  BillNet.m
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "BillNet.h"
#import "BillItem.h"

@implementation BillNet

- (instancetype)init{
    self = [super init];
    if (self) {
        _dataList = [[NSMutableArray alloc]init];
        _pageSize = 15;
        _page = 0;
        _beginTime = dateString_date([NSDate date], CDDateDay);
        _endTime = dateString_date([NSDate date], CDDateDay);
    }
    return self;
}

- (void)getBillListWithPage:(NSInteger)page
           success:(void (^)(NSDictionary *))success
           failure:(void (^)(NSError *))failue{
    __weak __typeof(self)weakSelf = self;
    [NET_REQUEST_MANAGER requestBillListWithName:self.billName categoryStr:self.categoryStr beginTime:self.beginTime endTime:self.endTime page:page+1 pageSize:self.pageSize success:^(id object) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSDictionary *dic = (NSDictionary *)object;
        if (dic[@"code"] && [dic[@"code"] integerValue] == ResultCodeSuccess) {
            NSDictionary *data = [dic objectForKey:@"data"];
            if (data != NULL) {
                strongSelf.page = [data[@"current"] integerValue];
                if (strongSelf.page == 1) {
                    [strongSelf.dataList removeAllObjects];
                }
                strongSelf.total = [[data objectForKey:@"total"]integerValue];
                NSArray *list = [data objectForKey:@"records"];
                for (id obj in list) {
                    CDTableModel *model = [CDTableModel new];
                    model.obj = obj;
                    model.className = @"BillTableViewCell";
                    [strongSelf.dataList addObject:model];
                }
                
                if (self.dataList.count > 0) {
                    strongSelf.isMost = ((strongSelf.dataList.count % strongSelf.pageSize == 0)&(list.count>0))?NO:YES;
                } else {
                    strongSelf.isMost = NO;
                }
                
            }
            strongSelf.isEmpty = (strongSelf.dataList.count == 0)?YES:NO;
            success(dic);
        }else{
            failue(object);
        }
    } fail:^(id object) {
        failue(object);
    }];
}
@end
