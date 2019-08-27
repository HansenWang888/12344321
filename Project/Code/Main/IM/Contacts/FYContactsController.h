//
//  FYContactsController.h
//  Project
//
//  Created by Mike on 2019/6/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYContactCell.h"


NS_ASSUME_NONNULL_BEGIN

@interface FYContactsController : UIViewController<ContactCellDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@end

NS_ASSUME_NONNULL_END
