//
//  MsgHeaderView.m
//  Project
//
//  Created by Aalto on 2019/4/29.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "MsgHeaderView.h"
@interface MsgHeaderView ()
@property (nonatomic, strong) SDCycleScrollView *sdCycleScrollView;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong)id requestParams;
@end
@implementation MsgHeaderView

- (instancetype)initWithFrame:(CGRect)frame WithModel:(id)requestParams{
    self = [super initWithFrame:frame];
    if (self) {
        _requestParams = requestParams;
        [self publicTopPartView];
        
    }
    return self;
}

- (void)publicTopPartView{
    UIView * topline = [[UIView alloc]init];
    topline.backgroundColor = HexColor(@"#f6f5fa");
    [self addSubview:topline];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(3);
        make.left.right.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
    }];
    
    [self layoutIfNeeded];
    
    _sdCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake( 10, 3, SCREEN_WIDTH-20, kGETVALUE_HEIGHT(1080, 372, SCREEN_WIDTH))  placeholderImage:[UIImage imageNamed:@"common_placeholder"]];
    [self addSubview:_sdCycleScrollView];
    _sdCycleScrollView.autoScrollTimeInterval = 5.0;
    _sdCycleScrollView.autoScroll = YES;
    _sdCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _sdCycleScrollView.currentPageDotColor = HexColor(@"#ffffff"); // 自定义分页控件小圆标颜色
    _sdCycleScrollView.layer.masksToBounds = YES;
    _sdCycleScrollView.layer.cornerRadius = 6;
    
    UIView * topline1 = [[UIView alloc]init];
    topline1.backgroundColor = HexColor(@"#f6f5fa");
    [self addSubview:topline1];
    [topline1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(CGRectGetMaxY(self.sdCycleScrollView.frame));
        make.left.right.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
    }];
    
    BannerData* data = _requestParams;
    _sdCycleScrollView.autoScrollTimeInterval = [data.carouselTime intValue];
    
    NSArray* imagesModels = data.skAdvDetailList;
    
    NSMutableArray* imageURLStrings = [NSMutableArray array];
    //    NSMutableArray* imageTitles = [NSMutableArray array];
    
    if (imagesModels.count>0) {
        for (int i=0; i<imagesModels.count; i++) {
            BannerItem *item = imagesModels[i];
            [imageURLStrings addObject:item.advPicUrl];
            
            
            //            NSDictionary *model = imagesModels[i];
            //            [imageURLStrings addObject:model[kImg]];
            //                        [imageTitles addObject:model[@"kTit"]];
        }
    }
    
    _sdCycleScrollView.imageURLStringsGroup = imageURLStrings;
    if (imagesModels.count==1) {
        _sdCycleScrollView.autoScroll = NO;
    }else{
        _sdCycleScrollView.autoScroll = YES;
    }
    
    WEAK_OBJ(weakSelf, self);
    _sdCycleScrollView.clickItemOperationBlock = ^(NSInteger index) {
        BannerItem *item = imagesModels[index];
        
        //        NSDictionary *model = imagesModels[index];
        if (item!=nil) {
            if (![FunctionManager isEmpty:item.advLinkUrl]) {
                [NET_REQUEST_MANAGER requestClickBannerWithAdvSpaceId:data.ID Id:item.ID success:^(id object) {
                    
                } fail:^(id object) {
                    
                }];
            }
            
            
            if (weakSelf.block) {
                weakSelf.block(item);
            }
            
        }
        
    };
    
}

- (void)actionBlock:(DataBlock)block{
    self.block = block;
}


- (instancetype)initWithFrame:(CGRect)frame WithLaunchAndLoginModel:(id)requestParams WithOccurBannerAdsType:(OccurBannerAdsType)occurBannerAdsType{
    self = [super initWithFrame:frame];
    if (self) {
        _requestParams = requestParams;
        [self publicScrollPartView:frame WithOccurBannerAdsType:occurBannerAdsType];
        
    }
    return self;
}

- (void)publicScrollPartView:(CGRect)frame WithOccurBannerAdsType:(OccurBannerAdsType)occurBannerAdsType{
    UIView * topline = [[UIView alloc]init];
    topline.backgroundColor = HexColor(@"#f6f5fa");
    [self addSubview:topline];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(3);
        make.left.right.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
    }];
    
    [self layoutIfNeeded];
    
    _sdCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake( 0,0, frame.size.width, frame.size.height)  placeholderImage:[UIImage imageNamed:@"common_placeholder"]];
    [self addSubview:_sdCycleScrollView];
    _sdCycleScrollView.autoScrollTimeInterval = 5.0;
    _sdCycleScrollView.autoScroll = YES;
    
    _sdCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _sdCycleScrollView.currentPageDotColor = HexColor(@"#ffffff"); // 自定义分页控件小圆标颜色
    //    _sdCycleScrollView.layer.masksToBounds = YES;
    //
        _sdCycleScrollView.showPageControl = occurBannerAdsType == OccurBannerAdsTypeLaunch?NO:YES;
    //    if (occurBannerAdsType == OccurBannerAdsTypeLogin) {
    //
    //        _sdCycleScrollView.layer.cornerRadius = 9;
    //        _sdCycleScrollView.layer.borderColor = [UIColor whiteColor].CGColor;
    //        _sdCycleScrollView.layer.borderWidth = 11;
    //    }else{
    //        _sdCycleScrollView.layer.cornerRadius = 0;
    //        _sdCycleScrollView.layer.borderColor = [UIColor clearColor].CGColor;
    //        _sdCycleScrollView.layer.borderWidth = 0;
    //    }
    
    //    _sdCycleScrollView.layer.cornerRadius = 4;
    
    //    UIView * topline1 = [[UIView alloc]init];
    //    topline1.backgroundColor = HexColor(@"#f6f5fa");
    //    [self addSubview:topline1];
    //    [topline1 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(CGRectGetMaxY(self.sdCycleScrollView.frame));
    //        make.left.right.top.mas_equalTo(0);
    //        make.centerX.mas_equalTo(self);
    //    }];
    
    [self richElemenstsInView:_requestParams];
    
}

-(void)richElemenstsInView:(id)requestParams{
    BannerData* data = requestParams;
    _sdCycleScrollView.autoScrollTimeInterval = [data.carouselTime intValue];
    
    NSArray* imagesModels = data.skAdvDetailList;
    
    NSMutableArray* imageURLStrings = [NSMutableArray array];
    //    NSMutableArray* imageTitles = [NSMutableArray array];
    
    if (imagesModels.count>0) {
        for (int i=0; i<imagesModels.count; i++) {
            BannerItem *bData = imagesModels[i];
            [imageURLStrings addObject:[NSString stringWithFormat:@"%@",bData.advPicUrl]];
            
            
            //            NSDictionary *model = imagesModels[i];
            //            [imageURLStrings addObject:model[kImg]];
            //                        [imageTitles addObject:model[@"kTit"]];
        }
    }
    
    _sdCycleScrollView.imageURLStringsGroup = imageURLStrings;
    if (imagesModels.count==1) {
        _sdCycleScrollView.autoScroll = NO;
    }else{
        _sdCycleScrollView.autoScroll = YES;
    }
    
    WEAK_OBJ(weakSelf, self);
    _sdCycleScrollView.clickItemOperationBlock = ^(NSInteger index) {
        BannerItem *item = imagesModels[index];
        
        //        NSDictionary *model = imagesModels[index];
        if (item!=nil) {
            //            if (![FunctionManager isEmpty:item.advLinkUrl]) {
            //                [NET_REQUEST_MANAGER requestClickBannerWithAdvSpaceId:data.ID Id:item.ID success:^(id object) {
            //
            //                } fail:^(id object) {
            //
            //                }];
            //            }
            
            
            if (weakSelf.block) {
                weakSelf.block(item);
            }
            
        }
        
    };
}
@end
