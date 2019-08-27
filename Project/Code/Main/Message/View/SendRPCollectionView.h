//
//  SendRPCollectionView.h
//  Project
//
//  Created by Mike on 2019/3/1.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SelectNumCollectionViewBlock)(void);
typedef void (^SelectMoreMaxCollectionViewBlock)(void);

@interface SendRPCollectionView : UIView

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, copy) SelectNumCollectionViewBlock selectNumCollectionViewBlock;
@property (nonatomic, copy) SelectMoreMaxCollectionViewBlock selectMoreMaxCollectionViewBlock;

@property (nonatomic,strong) id model;
@property (nonatomic,assign)NSInteger maxNum;
@end

NS_ASSUME_NONNULL_END
