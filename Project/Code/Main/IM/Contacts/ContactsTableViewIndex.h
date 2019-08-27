//
//  ContactsTableViewIndex.h
//  Project
//
//  Created by Mike on 2019/6/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactsTableViewIndexDelegate;


@interface ContactsTableViewIndex : UIView

@property (nonatomic, strong) NSArray *indexes;
@property (nonatomic, weak) id <ContactsTableViewIndexDelegate> tableViewIndexDelegate;

@end

@protocol ContactsTableViewIndexDelegate <NSObject>

- (void)tableViewIndex:(ContactsTableViewIndex *)tableViewIndex didSelectSectionAtIndex:(NSInteger)index withTitle:(NSString *)title;

- (void)tableViewIndexTouchesBegan:(ContactsTableViewIndex *)tableViewIndex;

- (void)tableViewIndexTouchesEnd:(ContactsTableViewIndex *)tableViewIndex;

- (NSArray *)tableViewIndexTitle:(ContactsTableViewIndex *)tableViewIndex;

@end
