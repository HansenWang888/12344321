//
//  AddressBookViewController.h
//  Project
//
//  Created by Mike on 2019/6/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <malloc/malloc.h>
#import "ABAddressBook.h"

@class ABAddressBook, AddressBookViewController;
@protocol AddressBookViewControllerDelegate <NSObject>
@required


@end


@interface AddressBookViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
    id _delegate;
    
    NSUInteger _selectedCount;
    NSMutableArray *_listContent;  //   本地通讯录数据
    NSMutableArray *_filteredListContent;  // search result 数据
    UISearchBar *ABsearchBar;
    UISearchDisplayController *ABsearchDisplayController;

}

@property (nonatomic, retain) id<AddressBookViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;


@end
