//
//  UITableView+YBGeneral.m
//  Aa
//
//  Created by Aalto on 2018/11/20.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "UITableView+YBGeneral.h"

@implementation UITableView (YBGeneral)

- (void)YBGeneral_configuration {
    self.estimatedRowHeight = 44;
    self.estimatedSectionFooterHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    
    self.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
    [self setSeparatorColor:TBSeparaColor];
    /*
Self-Sizing在iOS11下是默认开启的，Headers, footers, and cells都默认开启Self-Sizing，所有estimated高度默认值从iOS11之前的0改变为UITableViewAutomaticDimension
如果目前项目中没有使用estimateRowHeight属性，在iOS11的环境下就要注意了，因为开启Self-Sizing之后，tableView是使用estimateRowHeight属性的，这样就会造成contentSize和contentOffset值的变化，如果是有动画是观察这两个属性的变化进行的，就会造成动画的异常，因为在估算行高机制下，contentSize的值是一点点地变化更新的，所有cell显示完后才是最终的contentSize值。因为不会缓存正确的行高，tableView reloadData的时候，会重新计算contentSize，就有可能会引起contentOffset的变化。iOS11下不想使用Self-Sizing的话，可以通过以下方式关闭:
     
链接：https://www.jianshu.com/p/c816533853ae
     */
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.estimatedRowHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
    }
}

@end
