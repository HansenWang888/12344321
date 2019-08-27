//
//  ABAddressBook.h
//  Project
//
//  Created by Mike on 2019/6/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ABAddressBook : NSObject {
    NSInteger sectionNumber;
    NSInteger recordID;
    BOOL rowSelected;
    NSString *name;
    NSString *email;
    NSString *tel;
    UIImage *thumbnail;
}

@property NSInteger sectionNumber;
@property NSInteger recordID;
@property BOOL rowSelected;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *tel;
@property (nonatomic, retain) UIImage *thumbnail;

@end
