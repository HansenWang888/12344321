//
//  AddGroupContactHeadeerView.h
//  Project
//
//  Created by 汤姆 on 2019/7/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddGroupContactHeadeerView : UIView
/** 数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

NS_ASSUME_NONNULL_END
