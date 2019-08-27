//
//  AddGroupSearchView.h
//  Project
//
//  Created by 汤姆 on 2019/7/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AddGroupSearchDelegate <NSObject>

- (void)addGroupSearchTitle:(NSString *)title;

@end
@interface AddGroupSearchView : UIView
/**搜索的代理*/
@property (nonatomic, weak) id<AddGroupSearchDelegate> searchDelegate ;

@end

NS_ASSUME_NONNULL_END
