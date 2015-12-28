//
//  FanOperations.h
//  Fanmore
//
//  Created by Cai Jiang on 1/8/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FanOpertationDelegate.h"
#import "LoadingState.h"
#import "UserInformation.h"
#import "LoginState.h"
#import "Task.h"
#import "Paging.h"

@protocol FanOperations <NSObject>


/**
 *  更新设备token 用于push
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param token    <#token description#>
 */
-(void)UpdatePushToken:(id<FanOpertationDelegate>)delegate block:(void (^)(NSError* error))block token:(NSString*)token;
/**
 *  Loading图逻辑：
 *  强制更新，删除旧图
 *  本地是否存在，不存在，服务器获取，当前展示默认图
 *  存在，check展示时间，过期/无记录，删除
 *  展示时间内，返回loading图
 *
 *  @param delegate 监视器
 *  @block 处理代码
 *  @param userName userName
 *  @param password 密码
 *
 */
-(void)loading:(id<FanOpertationDelegate>)delegate block:(void (^)(UIImage*,NSError*))block userName:(NSString*)userName password:(NSString*)password;

-(void)register:(id<FanOpertationDelegate>)delegate block:(void (^)(LoginState*,NSError*))block userName:(NSString*)userName password:(NSString*)password code:(NSString*)code;

-(void)myRegisterUser:(id<FanOpertationDelegate>)delegate block:(void (^)(id,NSError*))block userName:(NSString*)userName password:(NSString*)password code:(NSString*)code invitationCode:(NSString*)invitationCode;

-(void)registerUser:(id<FanOpertationDelegate>)delegate block:(void (^)(LoginState *,NSError*))block userName:(NSString*)userName password:(NSString*)password code:(NSString*)code invitationCode:(NSString*)invitationCode;
-(void)login:(id<FanOpertationDelegate>)delegate block:(void (^)(LoginState*,NSError*))block userName:(NSString*)userName password:(NSString*)password;

/**
 *  还附加了获取todayTotalScore的逻辑
 *
 *  @param delegate   <#delegate description#>
 *  @param block      <#block description#>
 *  @param screenType <#screenType description#>
 *  @param paging     <#paging description#>
 */
-(void)listTask:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray*,NSError*))block  screenType:(uint)screenType  paging:(Paging*)paging;
-(void)listFlashMallTask:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray* list,NSError* error))block paging:(Paging*)paging;

-(void)listPartTask:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray*,NSError*))block  type:(uint)type  paging:(Paging*)paging;
/**
 *  ScoreFlow
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param task     <#task description#>
 *  @param type     今日1，昨日2，历史3
 *  @param paging   <#paging description#>
 */
-(void)scoreFlow:(id<FanOpertationDelegate>)delegate block:(void (^)(NSNumber* browseCount,NSNumber* linkCount,NSNumber* scoreCount,NSNumber* totalScore,NSArray* flows,NSError* error))block task:(Task*)task  type:(uint)type  paging:(Paging*)paging;

/**
 *  <#Description#>
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param taskid   <#taskid description#>
 *  @param date     <#date description#>
 *  @param type     1昨日，2指定日期，3历史
 *  @param paging   autoId
 */
-(void)NewScoreFlow:(id<FanOpertationDelegate>)delegate block:(void (^)(NSNumber* browseCount,NSNumber* linkCount,NSNumber* dayScore,NSNumber* totalScore,NSArray* list,NSError* error))block taskid:(NSNumber*)taskid date:(NSDate*)date type:(uint)type  paging:(Paging*)paging;

/**
 *  今日浏览
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param paging   autoId
 */
-(void)TodayBrowseList:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray* list,NSError* error))block paging:(Paging*)paging;

-(void)TotalScoreList:(id<FanOpertationDelegate>)delegate block:(void (^)(NSNumber* totalScore,NSNumber* totalCount,NSNumber* maxScore,NSNumber* minScore,NSArray* list,NSError* error))block date:(NSDate*)date;
-(void)newTotalScoreList:(id<FanOpertationDelegate>)delegate block:(void (^)(NSNumber* totalScore,NSNumber* totalCount,NSNumber* maxScore,NSNumber* minScore,NSArray* dateList,NSError* error))block date:(NSDate*)date;
-(void)TotalScoreDay:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray* list,NSError* error))block date:(NSDate*)date;

/**
 *  获得任务详情以及转发记录
 *
 *  @param delegate  监视器
 *  @param block     成功后的回调 1参是转发记录 详情数据将直接写入传入的Task
 *  @param loginCode loginCode
 *  @param task      需要查询详情的Task
 */
-(void)detailTask:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray*,NSError*))block task:(Task*)task;

/**
 *  转发成功提交
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param task     <#task description#>
 */
-(void)turnTask:(id<FanOpertationDelegate>)delegate block:(void (^)(NSString*,NSError*))block task:(Task*)task type:(TShareType)type;

/**
 *  获取用户信息 
 *  必须完成AppDelegate的各项基础属性
 *
 *  @param delegate  <#delegate description#>
 *  @param block     <#block description#>
 *  @param loginCode <#loginCode description#>
 */
-(void)userInfo:(id<FanOpertationDelegate>)delegate block:(void (^)(UserInformation*,NSError*))block;

-(void)updateUserInfo:(id<FanOpertationDelegate>)delegate block:(void (^)(NSString*,NSError*))block user:(UserInformation*)user;

-(void)getUserTodayBrowseCount:(id<FanOpertationDelegate>)delegate block:(void(^)(NSNumber*,NSError*))block;
#pragma mark -- fav store


/**
 *  atuoId
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param paging   <#paging description#>
 */
-(void)myFavoriteStoreList:(id<FanOpertationDelegate>)delegate block:(void(^)(NSArray*,NSError*))block  paging:(Paging*)paging;

/**
 *  oldTaskId
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param storeId  <#storeId description#>
 *  @param paging   <#paging description#>
 */
-(void)myFavoriteTaskDetail:(id<FanOpertationDelegate>)delegate block:(void(^)(NSArray*,NSError*))block store:(Store*)store paging:(Paging*)paging;

-(void)operFavorite:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block store:(Store*)store;

#pragma mark -- Cash
/**
 *  autoId
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param paging   <#paging description#>
 */
-(void)cashHistory:(id<FanOpertationDelegate>)delegate block:(void(^)(NSArray*,NSError*))block paging:(Paging*)paging;

-(void)cash:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block password:(NSString*)password;

#pragma mark 安全

-(void)verificationCode:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block phone:(NSString*)phone type:(NSNumber*)type;
-(void)bindAlipay:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block phone:(NSString*)phone alipayAccount:(NSString*)alipayAccount alipayName:(NSString*)alipayName code:(NSString*)code;
-(void)bindMobile:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block phone:(NSString*)phone code:(NSString*)code;
-(void)releaseBindMobile:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block phone:(NSString*)phone code:(NSString*)code;

-(void)modifyPwd:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block newPwd:(NSString*)newPwd;
-(void)resetPwd:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block phone:(NSString*)phone code:(NSString*)code newPwd:(NSString*)newPwd;
-(void)setWithdrawalPassword:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block withdrawalPassword:(NSString*)withdrawalPassword oldWithdrawalPassword:(NSString*)oldWithdrawalPassword;

-(void)feedback:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block name:(NSString*)name contact:(NSString*)contact content:(NSString*)content;
-(void)feedbackList:(id<FanOpertationDelegate>)delegate block:(void(^)(NSArray*,NSError*))block paging:(Paging*)paging;


#pragma mark master
/**
 *  收徒收益
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param paging   pageTag
 */
-(void)masterIndex:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString* code,NSString* desc,NSString* shareDesc,NSString* shareURL,NSNumber* numbersOfFollowers,NSNumber* totalDevoteYes,NSNumber* totalDevote, NSNumber *todaySafe,NSNumber *lisiSafe,NSNumber *todayShare,NSNumber *lisiShare,NSArray* list,NSError* error))block paging:(Paging*)paging;

/**
 *  徒弟列表
 *
 *  @param delegate  <#delegate description#>
 *  @param block     <#block description#>
 *  @param orderType 排序依据(0、拜师时间1、总贡献值)
 *  @param paging    pageTag
 */
-(void)followerList:(id<FanOpertationDelegate>)delegate block:(void(^)(NSNumber* numbersOfFollowers,NSArray* list,NSError* error))block orderType:(int)orderType paging:(Paging*)paging;

/**
 *  徒弟详情
 *
 *  @param delegate   <#delegate description#>
 *  @param block      <#block description#>
 *  @param followerId 徒弟的id
 *  @param orderType  排序依据(0、拜师时间1、总贡献值)
 *  @param paging     pageTag
 */
-(void)followerDetail:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString* username,NSDate* date,NSNumber* totalDevote,NSArray* list,NSError* error))block followerId:(NSNumber*)followerId orderType:(int)orderType paging:(Paging*)paging;


#pragma mark 闪购
-(void)flashMallDetail:(id<FanOpertationDelegate>)delegate block:(void (^)(NSDictionary* data,NSError* error))block orderNo:(NSString*)orderNo;

-(void)flashMallList:(id<FanOpertationDelegate>)delegate block:(void (^)(NSNumber* count,NSNumber* tempScore,NSNumber* realScore,NSArray* list,NSError* error))block  paging:(Paging*)paging;

#pragma mark 检查该任务是否已开始
/**
 *  状态：0：已开始  1：未开始  2:已下架
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param taskId   <#taskId description#>
 */
-(void)taskReleaseCheck:(id<FanOpertationDelegate>)delegate block:(void(^)(Task* taskId,int status,NSString* previewURL,NSError* error))block taskId:(NSNumber*)taskId;

/**
 *  <#Description#>
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param type     1：每日积分排名  2：总积分排名  3：收徒排名
 */
-(void)ranking:(id<FanOpertationDelegate>)delegate block:(void(^)(NSNumber* myrank,NSString* desc,NSArray* list,NSError* error))block type:(uint)type;

/**
 *  消息类型：1：普通消息  0：预告消息
 *  预告任务状态：1：未开始  0：已开始  2：已下架
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param paging   <#paging description#>
 */
-(void)notifyList:(id<FanOpertationDelegate>)delegate block:(void(^)(NSArray* list,NSError* error))block paging:(Paging*)paging;


#pragma mark 2.3.0

-(void)advanceForward:(id<FanOpertationDelegate>)delegate block:(void(^)(NSDictionary* data,
                                                                         NSError* error))block taskId:(NSNumber*)taskId;

-(void)uploadPicture:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString* tip,
                                                                        NSError* error))block image:(UIImage*)image;

-(void)checkInCalendar:(id<FanOpertationDelegate>)delegate block:(void(^)(
                                                                          NSNumber* lastContinues,
                                                                          NSNumber* todayscore,
                                                                          NSDate* currentdate,
                                                                          NSError* error))block;

-(void)checkIn:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString* tip,
                                                                          NSError* error))block;

-(void)itemList:(id<FanOpertationDelegate>)delegate block:(void(^)(NSArray* items,NSArray* myItems,
                                                                   NSError* error))block;

-(void)rollPrentice:(id<FanOpertationDelegate>)delegate block:(void(^)(NSDictionary* user,
                                                                       NSError* error))block;

-(void)TodayNotice:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray* list,NSError* error))block paging:(Paging*)paging;
/**
 *
 *  @param delegate   <#delegate description#>
 *  @param block      <#block description#>
 *  @param paging     <#paging description#>
 */
-(void)previewTaskList:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray* list,NSError* error))block paging:(Paging*)paging;

-(void)buyItem:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray* items,NSArray* myItems,NSError* error))block type:(int)type;

-(void)useItem:(id<FanOpertationDelegate>)delegate block:(void (^)(NSNumber* count,NSError* error))block type:(int)type target:(NSNumber*)target;

-(void)scratchTicket:(id<FanOpertationDelegate>)delegate block:(void (^)(NSNumber* id,NSNumber* residueCount,NSNumber* exp,NSError* error))block;

-(void)expHistory:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray* history,NSError* error))block paging:(Paging*)paging;

-(void)mywallet:(id<FanOpertationDelegate>)delegate block:(void (^)(NSNumber* scoreLast,NSNumber* walletLast,NSString* des,NSDate* recordTime,NSString* recordDes,NSNumber* recordResult,NSString* recordResultDes,NSError* error))block;

-(void)cashWallet:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString* result,NSError* error))block;
-(void)moneyStoreURL:(id<FanOpertationDelegate>)delegate block:(void (^)(NSString* des,NSError* error))block;
-(void)walletHistory:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray* history,NSError* error))block paging:(Paging*)paging;



/**
 *  提交微信授权返回的用户信息
 *  luohaibo
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 */
- (void)toSouji:(id<FanOpertationDelegate>)delegate block:(void (^)(LoginState*,NSError*))block WithParam:(NSString *)phone withYanzhen:(NSString *)yanzhenma withYaoqingma:(NSString *)yaoqingma;


/**
 *  获取邀请码
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param parame   <#parame description#>
 */

- (void)ToGetYaoqing:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString* result,NSError* error))block WithParam:(NSString *)iphone;

/**
 *  罗海波
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param score    <#score description#>
 */
- (void)TOGetGlodDate:(id<FanOpertationDelegate>)delegate block:(void(^)(id result,NSError* error))block WithParam:(NSString *)score;

/**
 *  获取用户列表
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param unionId  <#unionId description#>
 */
- (void)TOGetUserList:(id<FanOpertationDelegate>)delegate block:(void(^)(id result,NSError* error))block WithunionId:(NSString *)unionId;


/**
 *  积分兑换小金库
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param unionId  <#unionId description#>
 */
- (void)ToChangeJifenToMyBackMall:(id<FanOpertationDelegate>)delegate block:(void(^)(id result,NSError* error))block WithunionId:(NSString *)score withCashpassword:(NSString *)cashpassword withMallUserId:(NSString *)mallUserId WithUserName:(NSString *)username withPassword:(NSString *)passwd;

/**
 *  获取支付接口
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param unionId  <#unionId description#>
 */
- (void)TOGetPayParames:(id<FanOpertationDelegate>)delegate block:(void(^)(id result,NSError* error))block;

/**
 *  获取支付接口
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param unionId  <#unionId description#>
 */
- (void)TOYanZhenRegistParames:(id<FanOpertationDelegate>)delegate block:(void(^)(id result,NSError* error))block withunoind:(NSString *)unind;

/**
 *  获取订单详情
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param unionId  <#unionId description#>
 */
- (void)ToGetTheOrderDescripition:(id<FanOpertationDelegate>)delegate block:(void(^)(id result,NSError* error))block withOrder:(NSString *)orderNo;

/**
 *  手机验证码登录
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param unionId  <#unionId description#>
 */
- (void)toLoginByPhoneNumber:(id<FanOpertationDelegate>)delegate block:(void(^)(id result,NSError* error))block withPhoneNumber:(NSString *)phoneNumber andYanzhenMa:(NSString *)yanzhengma;
@end
