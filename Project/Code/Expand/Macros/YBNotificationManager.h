//
//  YBNotificationManager.h
//  Created by Aalto on 2018/12/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <Foundation/Foundation.h>
FOUNDATION_EXTERN NSString * const kNotify_IsFirstEnterTabBarRefresh;
FOUNDATION_EXTERN NSString * const kNotify_IsFirstEnterPreLoginRefresh;

FOUNDATION_EXTERN NSString * const kNotify_IsBackExchangeRefresh;
FOUNDATION_EXTERN NSString * const kNotify_IsLoginRefresh;
FOUNDATION_EXTERN NSString * const kNotify_IsLoginOutRefresh;

FOUNDATION_EXTERN NSString * const kNotify_IsRegisterSuccessBindingGoogleSuccessRefresh;

FOUNDATION_EXTERN NSString * const kNotify_IsSelectedNoTransactionTabarRefresh;
FOUNDATION_EXTERN NSString * const kNotify_IsPayCellInPostAdsRefresh;

FOUNDATION_EXTERN NSString * const kNotify_jumpAssetVC;
FOUNDATION_EXTERN NSString * const kNotify_IsStopTimeRefresh;
FOUNDATION_EXTERN NSString * const kNotify_IsPayStopTimeRefresh;
FOUNDATION_EXTERN NSString * const kNotify_NetWorkingStatusRefresh;

extern NSString* const kLaunchBannerModel;
extern NSString* const kLoginBannerModel;
extern NSString* const kBombList;
extern NSString* const kBombHitCnt;
extern NSString* const kBombHandicap;
extern NSString* const kUserAssert;
extern NSString* const kIsBuyTip;
extern NSString* const kIsScanTip;

extern NSString* const kIsLogin;

extern NSString* const kUserName;
extern NSString* const kUserPW;
extern NSString* const kUserInfo;

extern NSString* const kFixedAccountsInTransactions;

extern NSString* const kPayMethodesInPostAds;
extern NSString* const kLimitAccountsInPostAds;
extern NSString* const kFixedAccountsInPostAds;

extern NSString* const kFixedAccountsSelectedItemInPostAds;

extern NSString* const kControlNumberInPostAds;
extern NSString* const kControlTimeInPostAds;

extern NSString* const kNumberAndTimeInPostAds;
extern NSString* const kPaymentWaysInPostAds;
extern NSString* const kCheckNoOpenPayMethodesInPostAds;

extern NSString* const kIndexSection;
extern NSString* const kIndexInfo;
extern NSString* const kIndexRow;

extern NSString* const kType ;
extern NSString* const kIsOn ;
extern NSString* const kImg;
extern NSString* const kTit;
extern NSString* const kSubTit;
extern NSString* const kUrl;
extern NSString* const kArr;
extern NSString* const kData;
typedef NS_ENUM(NSUInteger,IndexSectionType){
    IndexSectionZero = 0 ,
    IndexSectionOne ,
    IndexSectionTwo ,
    IndexSectionThree ,
    IndexSectionFour ,
    IndexSectionFive ,
};

typedef NS_ENUM(NSUInteger,EnumActionTag){
    EnumActionTag0 = 0 ,
    EnumActionTag1  ,
    EnumActionTag2  ,
    EnumActionTag3  ,
    EnumActionTag4  ,
    EnumActionTag5  ,
    EnumActionTag6  ,
    EnumActionTag7  ,
    EnumActionTag8  ,
    EnumActionTag9  ,
    EnumActionTag10  ,
    EnumActionTag11  ,
    EnumActionTag12
};

typedef NS_ENUM(NSUInteger,PostAdsType){
    PostAdsTypeCreate = 0 ,
    PostAdsTypeEdit,
};

typedef NS_ENUM(NSUInteger,OccurBannerAdsType){
    OccurBannerAdsTypeAll = 0 ,
    OccurBannerAdsTypeLogin  ,
    OccurBannerAdsTypeLaunch  ,
    OccurBannerAdsTypeMsg ,
    OccurBannerAdsTypeGroup ,
    
};
typedef NS_ENUM(NSUInteger,OccurBannerAdsPictureType){
    OccurBannerAdsPictureTypeAll = 0 ,
    OccurBannerAdsPictureTypeNormal  ,
    OccurBannerAdsPictureTypeLarge
    
};

typedef NS_ENUM(NSUInteger,PostAdsDetailType){
    PostAdsDetailTypeSuccess = 0 ,
    
};

typedef NS_ENUM(NSUInteger,TransferDetailType){
    TransferDetailTypeSuccess = 0 ,
    
};
typedef NS_ENUM(NSUInteger,TransferWayType){
    TransferWayTypeNone = 0 ,
    TransferWayTypeScan  ,
    TransferWayTypeH5 ,
    TransferWayTypeApp
};
typedef NS_ENUM(NSUInteger,TransferRecordType){
    TransferRecordTypeAll = 0 ,
    TransferRecordTypeIn  ,
    TransferRecordTypeOut ,
};

typedef NS_ENUM(NSUInteger,UserAssetsType){
    UserAssetsTypeAll = 0 ,
    UserAssetsTypeTransferIn  ,
    UserAssetsTypeTransferOut ,
    UserAssetsTypeBuyIn  ,
    UserAssetsTypeSellOut ,
    UserAssetsTypeExchange ,
};

typedef NS_ENUM(NSUInteger,TransactionAmountType){
    TransactionAmountTypeNone = 0 ,
    TransactionAmountTypeLimit  ,
    TransactionAmountTypeFixed ,
    
};

typedef NS_ENUM(NSUInteger,MsgType){
    MsgTypeNone = 0 ,
    MsgTypeOrder  ,
    MsgTypeSystem ,
    MsgTypeService
};

typedef NS_ENUM(NSUInteger,SeniorAuthType){
    SeniorAuthTypeFinished = 1 ,
    SeniorAuthTypeUndone  ,
    
};

typedef NS_ENUM(NSUInteger,IdentityAuthType){
    IdentityAuthTypeNone = 0 ,
    IdentityAuthTypeHandling  ,
    IdentityAuthTypeRefuse  ,
    IdentityAuthTypeFinished ,
    
};

typedef NS_ENUM(NSUInteger,OccurOrderType){
    OccurOrderTypeNone = 0 ,
    
    OccurOrderTypeBuy  ,
    OccurOrderTypeSell
};

typedef NS_ENUM(NSUInteger,UserType){
    UserTypeNone = 0 ,
    
    UserTypeBuyer  ,
    UserTypeSeller
};

typedef NS_ENUM(NSUInteger,OrderType){
    BuyerOrderTypeAllPay = 0 ,
    
    BuyerOrderTypeNotYetPay  ,
    
    
    BuyerOrderTypeHadPaidWaitDistribute ,
    BuyerOrderTypeHadPaidNotDistribute,
    
    BuyerOrderTypeFinished,
    
    BuyerOrderTypeCancel,
    BuyerOrderTypeClosed ,
    
    BuyerOrderTypeAppealing ,
    
    
    
    
    SellerOrderTypeNotYetPay ,
    
    SellerOrderTypeWaitDistribute ,
    
    SellerOrderTypeAppealing ,
    
    SellerOrderTypeFinished ,
    
    SellerOrderTypeCancel,
    SellerOrderTypeTimeOut,
};



typedef NS_ENUM(NSUInteger,ExchangeType){
    ExchangeTypeAll = 0,
    
    ExchangeTypeHandling,
    
    ExchangeTypePayed,
    
    ExchangeTypeRefused,
    
    ExchangeTypeBack,
    
    
};

typedef NS_ENUM(NSUInteger,PaywayType){
    PaywayTypeNone = 0,
    
    PaywayTypeWX,
    
    PaywayTypeZFB,
    
    PaywayTypeCard,
};

typedef NS_ENUM(NSUInteger,PaywayOccurType){
    PaywayOccurTypeCreate = 0 ,
    
    PaywayOccurTypeEdit,
};
NS_ASSUME_NONNULL_BEGIN

@interface YBNotificationManager : NSObject
@end

NS_ASSUME_NONNULL_END
