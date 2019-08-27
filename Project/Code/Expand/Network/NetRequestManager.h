//
//  NetRequestManager.h
//  XM_12580
//
//  Created by mac on 12-7-9.
//  Copyright (c) 2012年 Neptune. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Public.h"

typedef enum{
    RequestType_post,
    RequestType_get,
    RequestType_put,
    RequestType_delete,
}RequestType;

#define NET_REQUEST_MANAGER [NetRequestManager sharedInstance]

typedef enum{
    ActNil,
    ActRequestMsgBanner,
    ActRequestClickBanner,
    
    ActRequestUserInfo,//用户信息
    ActRequestUserInfoById,//用户信息
    ActModifyUserInfo,//修改个人信息
    ActModifyPassword,//修改密码
    ActResetPassword,//找回密码
    ActUpPayPasswd, //设置支付密码
    ActRequestVerifyCode,
    ActRegister,
    ActCheckRegister,
    ActRequestToken,
    ActCheckLogin,
    ActRequestCaptcha,
    ActRequestTokenBySMS,  // 短信验证码获取token
    ActRequestIMToken,
    ActRemoveToken,//删除token
    ActRequestCommonInfo,//APP基本数据
    ActMyPlayer,//我的下线
    ActCheckMyPlayers,//团队人数查询
    ActRequestAgentReportInfo,//个人代理报表
    ActRequestPromotionCourse,//推广教程
    ActRequestRechargeChannel,//推广教程
    ActUploadImg,
    ActRequestBankList,
    ActDraw,//提现
    ActRequestBillList,//账单列表
    ActRequestBillTypeList,//账单类型
    ActRequestSystemNotice,//通知列表
    ActRequestShareList,//分享列表
    ActAddShareCount,//增加分享页的访问量
    ActRequestRechargeList,//充值列表
    ActRequestReportForms,//报表
    ActRequestActivityList,//查询活动列表
    ActGetReward,//领取奖励
    ActGetFirstRewardInfo,//获取首充、二充数据
    ActToBeAgent,//申请成为代理
    ActGetLotteryList,//可抽奖列表
    ActGetLotterys,//查询转盘奖品
    ActLottery,//抽奖
    ActAddBankCard,//添加银行卡
    ActRequestMyBankList,//我添加的银行卡
    ActRequestWithdrawHistory,//提现历史记录
    ActRequestLastWithdrawInfo,//上次提现的信息
    
    ActRequestRechargeListFirst,//首先支付通道
    ActRequestRechargeListAll,//所有支付通道
    ActOrderRecharge,//提交订单
    ActReOrderRecharge,//重新下单
    ActSubmitRechargeInfo,//提交用户充值信息（去支付）
    ActRequestShareUrl,//获取分享URL
    ActRequestGuideImageList,//获取新手引导图片列表
    
    ActRequestActivityList2,//活动奖励列表
    ActRequestQiaoBaoReward,//获取抢包奖励金额
    ActRequestFaBaoReward,//获取发包奖励金额
    ActRequestQiaoBaoList,//获取抢包活动阶段
    ActRequestJiujiJingList,//获取抢包活动阶段
    ActRequestFaBaoList,//获取发包活动阶段
    ActAll,//通用
}Act;

@interface RequestInfo : NSObject
@property(nonatomic,assign)RequestType requestType;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,assign)Act act;
@property(nonatomic,assign)long long startTime;
-(id)initWithType:(RequestType)type;
@end

@interface NetRequestManager : NSObject{
    NSMutableArray *_httpManagerArray;
}
#pragma mark ---------------------------公共
+ (NetRequestManager *)sharedInstance;

//- (NSString *)getJsonStrFromData:(id)data;

//- (id)getDataFromJson:(NSString *)jsonStr;

#pragma mark ---------------------------接口
-(void)requestClickBannerWithAdvSpaceId:(NSString*)advSpaceId Id:(NSString*)adId success:(CallbackBlock)successBlock
                                   fail:(CallbackBlock)failBlock;
-(void)requestMsgBannerWithId:(NSInteger)adId WithPictureSpe:(NSInteger)pictureSpe success:(CallbackBlock)successBlock
                         fail:(CallbackBlock)failBlock;

#pragma mark 手机注册
-(void)checkRegisterWithDic:(NSMutableDictionary*)dic
                    success:(CallbackBlock)successBlock
                       fail:(CallbackBlock)failBlock;

-(void)registerWithDic:(NSMutableDictionary*)dic
                  success:(CallbackBlock)successBlock
                     fail:(CallbackBlock)failBlock;

#pragma mark 请求验证码
-(void)requestSmsCodeWithPhone:(NSString *)phone
                    type:(GetSmsCodeFromVCType)type
                       success:(CallbackBlock)successBlock
                          fail:(CallbackBlock) failBlock;

-(void)requestImageCaptchaWithPhone:(NSString *)phone type:(GetSmsCodeFromVCType)type
                            success:(CallbackBlock)successBlock
                               fail:(CallbackBlock)failBlock;
#pragma mark 重置密码（找回密码）
-(void)findPasswordWithPhone:(NSString *)phone
                     smsCode:(NSString *)smsCode
                    password:(NSString *)password
                     success:(CallbackBlock)successBlock
                        fail:(CallbackBlock)failBlock;

#pragma mark 重设支付密码
-(void)setPayPasswordWithPhone:(NSString *)phone
                       smsCode:(NSString *)smsCode
                      password:(NSString *)password
                       success:(CallbackBlock)successBlock
                          fail:(CallbackBlock)failBlock;

#pragma mark 密码请求token
-(void)checkLoginWithDic:(NSMutableDictionary*)dic
                 success:(CallbackBlock)successBlock
                    fail:(CallbackBlock)failBlock;
-(void)requestTokenWithDic:(NSMutableDictionary*)dic
                        success:(CallbackBlock)successBlock
                           fail:(CallbackBlock)failBlock;

#pragma mark 短信验证码获取tocken
-(void)requestTockenWithPhone:(NSString *)phone
                      smsCode:(NSString *)smsCode
                      success:(CallbackBlock)successBlock
                         fail:(CallbackBlock)failBlock;

#pragma mark 请求用户信息
-(void)requestUserInfoWithSuccess:(CallbackBlock)successBlock
                            fail:(CallbackBlock)failBlock;


#pragma mark 领取福利（暂不知道此接口用处及参数）
//-(void)drawBoonWithId:(NSString *)bId
//              success:(CallbackBlock)successBlock
//                 fail:(CallbackBlock)failBlock;

#pragma mark 是否签到
//-(void)isSignWithSuccess:(CallbackBlock)successBlock
//                    fail:(CallbackBlock)failBlock;

#pragma mark 签到
//-(void)signWithSuccess:(CallbackBlock)successBlock
//                  fail:(CallbackBlock)failBlock;

#pragma mark 获取银行列表
-(void)requestBankListWithSuccess:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock;

#pragma mark 获取提现记录
//弃用
-(void)requestDrawRecordListWithSuccess:(CallbackBlock)successBlock
                                   fail:(CallbackBlock)failBlock;

-(void)requestDrawRecordListWithPage:(NSInteger)page success:(CallbackBlock)successBlock
                                   fail:(CallbackBlock)failBlock;

#pragma mark 提现
//弃用
-(void)withDrawWithAmount:(NSString *)amount//金额
                  userName:(NSString *)name//名字
                  bankName:(NSString *)backName//银行名
                   bankId:(NSString *)bankId//银行id
                   address:(NSString *)address//地址
                   uppayNO:(NSString *)uppayNO //卡号
                    remark:(NSString *)remark//备注
                   success:(CallbackBlock)successBlock
                      fail:(CallbackBlock)failBlock;

-(void)withDrawWithAmount:(NSString *)amount//金额
                   bankId:(NSString *)bankId//银行id
                  success:(CallbackBlock)successBlock
                     fail:(CallbackBlock)failBlock;

#pragma mark 编辑用户信息
-(void)editUserInfoWithUserAvatar:(NSString *)url
                         userNick:(NSString *)nickName
                           gender:(NSInteger)gender
                          success:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock;

#pragma mark 上传图片
-(void)upLoadImageObj:(UIImage *)image
              success:(CallbackBlock)successBlock
                 fail:(CallbackBlock)failBlock;

#pragma mark (暂不知道用处)
//-(void)requestbizId:(NSString *)bizId
//            success:(CallbackBlock)successBlock
//               fail:(CallbackBlock)failBlock;

#pragma mark 我的下线列表
-(void)requestMyPlayerWithPage:(NSInteger)page
                      pageSize:(NSInteger)pageSize
                    userString:(NSString *)userString
                          type:(NSInteger)type
                       success:(CallbackBlock)successBlock
                          fail:(CallbackBlock)failBlock;

#pragma mark 获取下线基础信息
-(void)requestMyPlayerCommonInfoWithSuccess:(CallbackBlock)successBlock
                                       fail:(CallbackBlock)failBlock;

#pragma mark 账单类型   线上充值 人工充值 抢包 踩雷...
-(void)requestBillTypeWithType:(NSString *)type success:(CallbackBlock)successBlock
                          fail:(CallbackBlock)failBlock;

#pragma mark 获取账单列表
-(void)requestBillListWithName:(NSString *)billName
                   categoryStr:(NSString *)categoryStr
                     beginTime:(NSString *)beginTime
                       endTime:(NSString *)endTime
                          page:(NSInteger)page
                      pageSize:(NSInteger)pageSize
                       success:(CallbackBlock)successBlock
                          fail:(CallbackBlock)failBlock;

#pragma mark 获取app配置
-(void)requestAppConfigWithSuccess:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock;

#pragma mark 获取通知列表
-(void)requestSystemNoticeWithSuccess:(CallbackBlock)successBlock
                                 fail:(CallbackBlock)failBlock;


#pragma mark 请求分享列表
-(void)requestShareListWithSuccess:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock;

#pragma mark 增加分享页的访问量
-(void)addShareCountWithId:(NSInteger)shareId success:(CallbackBlock)successBlock
                      fail:(CallbackBlock)failBlock;

#pragma mark 充值列表
-(void)requestRechargeListWithSuccess:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock;

#pragma mark 报表
-(void)requestReportFormsWithUserId:(NSString *)userId beginTime:(NSString *)beginTime endTime:(NSString *)endTime success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 删除token
-(void)removeTokenWithSuccess:(CallbackBlock)successBlock
                         fail:(CallbackBlock)failBlock;

#pragma mark 获取活动列表
-(void)requestActivityListWithUserId:(NSString *)userId success:(CallbackBlock)successBlock
                                fail:(CallbackBlock)failBlock;

#pragma mark 领取奖励
-(void)getRewardWithActivityType:(NSString *)type userId:(NSString *)userId success:(CallbackBlock)successBlock
                            fail:(CallbackBlock)failBlock;

#pragma mark 领取首充 二充奖励
-(void)getFirstRewardWithUserId:(NSString *)userId rewardType:(NSInteger)rewardType success:(CallbackBlock)successBlock
                           fail:(CallbackBlock)failBlock;

#pragma mark 申请成为代理
-(void)askForToBeAgentWithSuccess:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock;

#pragma mark 查询可抽奖列表
-(void)getLotteryListWithSuccess:(CallbackBlock)successBlock
                            fail:(CallbackBlock)failBlock;

#pragma mark 查询可抽奖具体信息
-(void)getLotteryDetailWithId:(NSInteger)lId success:(CallbackBlock)successBlock
                            fail:(CallbackBlock)failBlock;

#pragma mark 抽奖
-(void)lotteryWithId:(NSInteger)lId success:(CallbackBlock)successBlock
                         fail:(CallbackBlock)failBlock;

#pragma mark 添加银行卡
-(void)addBankCardWithUserName:(NSString *)userName cardNO:(NSString *)cardNO bankId:(NSString *)bankId bankCode:(NSString *)bankCode address:(NSString *)address success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 我的银行卡
-(void)getMyBankCardListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 获取首先支付通道列表
-(void)requestFirstRechargeListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 获取所有支付通道列表
-(void)requestAllRechargeListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 提交支付资料
-(void)submitRechargeInfoWithBankId:(NSString *)bankId
                           bankName:(NSString *)bankName
                             bankNo:(NSString *)bankNo
                                tId:(NSString *)tId//通道id
                              money:(NSString *)money
                               name:(NSString *)name
                            orderId:(NSString *)orderId//无用
                               type:(NSInteger)type
                           typeCode:(NSInteger)typeCode//微信 银行卡
                             userId:(NSString *)userId
                            success:(CallbackBlock)successBlock
                               fail:(CallbackBlock)failBlock;

#pragma mark 提交订单
-(void)submitOrderRechargeInfoWithId:(NSString *)orderId money:(NSString *)money
                                name:(NSString *)name success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 获取分享url
-(void)getShareUrlWithCode:(NSString *)code success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 获取新手引导图片列表
-(void)getGuideImageListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 活动奖励列表
-(void)getActivityListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

-(void)getActivityJiujiJingListWithId:(NSString *)activityId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark 获取抢包活动阶段
-(void)getActivityQiaoBaoListWithId:(NSString *)activityId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 获取发包活动阶段
-(void)getActivityFaBaoListWithId:(NSString *)activityId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 获取活动详情
-(void)getActivityDetailWithId:(NSString *)activityId type:(NSInteger)type success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 获取发包抢包奖励
-(void)getRewardWithId:(NSString *)activityId type:(NSInteger)type success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 个人报表信息
-(void)requestUserReportInfoWithId:(NSString *)userId success:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock;

#pragma mark 查询所有推广教程
-(void)requestCopyListWithSuccess:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock;

#pragma mark 查询所有支付通道
-(void)requestAllRechargeChannelWithSuccess:(CallbackBlock)successBlock
                                       fail:(CallbackBlock)failBlock;
@end
