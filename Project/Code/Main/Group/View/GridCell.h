//
//  GridCell.h
//
//  Created by AaltoChen on 16/3/14.
//  Copyright © 2016年 ShengCheng. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kGridCellHeight   100

@interface GridCell : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSArray *data;
//@property (copy, nonatomic) void(^clickGridRowBlock)(NSDictionary * dataModel);
- (void)actionBlock:(ActionBlock)block;
+(CGFloat)cellHeightWithModel;
//+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(NSArray*)model;
@end
