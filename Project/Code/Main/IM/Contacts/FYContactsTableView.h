//
//  ContactsTableView.h
//  Project
//
//  Created by Mike on 2019/6/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactsTableViewDelegate;



@interface FYContactsTableView : UIView

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) id<ContactsTableViewDelegate> delegate;
- (void)reloadData;


@end

@protocol ContactsTableViewDelegate <UITableViewDataSource,UITableViewDelegate>

- (NSArray *)sectionIndexTitlesForABELTableView:(FYContactsTableView *)tableView;


@end
