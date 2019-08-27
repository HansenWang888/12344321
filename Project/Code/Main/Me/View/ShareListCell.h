//
//  ShareListCell.h
//  Project
//
//  Created by fy on 2019/1/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareListCell : UICollectionViewCell
@property(nonatomic,strong)UIView *conView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *pageViewLabel;
@property(nonatomic,strong)UIImageView *iconView;
@end

NS_ASSUME_NONNULL_END
