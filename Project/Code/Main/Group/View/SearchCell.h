//
//  SearchCell.h
//  Project
//
//  Created by Mike on 2019/2/12.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void (^SelectedBtnBlock)(BOOL);


NS_ASSUME_NONNULL_BEGIN

@interface SearchCell : UITableViewCell

@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic ,copy) SelectedBtnBlock selectedBtnBlock;


@end

NS_ASSUME_NONNULL_END
