//
//  CowCowVSMessageModel.h
//  Project
//
//  Created by Mike on 2019/1/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

//#import <RongIMLib/RongIMLib.h>



//@interface CowCowVSMessageModel : RCMessageContent
@interface CowCowVSMessageModel : NSObject

@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *groupOnwerId;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *preMoney;
@property (nonatomic, copy) NSString *userAvatar;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;

@property (nonatomic, assign) BOOL *overFlag;


@property (nonatomic, assign) NSInteger bankScore;
@property (nonatomic, assign) NSInteger bankWin;
@property (nonatomic, assign) NSInteger playerWin;
@property (nonatomic, assign) NSInteger serviceFee;

@property (nonatomic, assign) NSInteger handicap0;
@property (nonatomic, assign) NSInteger handicap1;
@property (nonatomic, assign) NSInteger handicap2;
@property (nonatomic, assign) NSInteger handicap3;
@property (nonatomic, assign) NSInteger handicap4;
@property (nonatomic, assign) NSInteger handicap5;
@property (nonatomic, assign) NSInteger handicap6;
@property (nonatomic, assign) NSInteger handicap7;
@property (nonatomic, assign) NSInteger handicap8;
@property (nonatomic, assign) NSInteger handicap9;


- (instancetype)initWithObj:(id)obj;
@property (nonatomic, copy) NSString *content;

@end

