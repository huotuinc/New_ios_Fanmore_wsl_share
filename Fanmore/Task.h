//
//  Task.h
//  Fanmore
//   总积分： 剩余积分   转发 好友浏览 好友点击外链 ￥0.4    /次
//  Created by Cai Jiang on 1/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Store.h"
#import "FanmoreModel.h"
#import "ShareTool.h"
#import "CacheResource.h"

@interface Task : FanmoreModel

-(ShareMessage*)toShare:(UIImage*)input;
-(void)checkLargeImg:(void (^)(UIImage*))callback;
-(CacheResource*)largeImageCache;

/**
 *  是否是联盟任务
 *
 *  @return <#return value description#>
 */
-(BOOL)isUnitedTask;

/**
 *  是否已结算
 *
 *  @return <#return value description#>
 */
-(BOOL)isReallyAccounted;

/**
 *  1000300
 *
 *  @return <#return value description#>
 */
-(BOOL)isFlashMall;

/**
 *  该任务是否没有积分奖励
 *  同样也不会显示剩余积分
 *
 *  @return <#return value description#>
 */
-(BOOL)zeroReward;
/**
 *  该任务无法被转发
 *  同样也不会显示转发信息
 *
 *  @return <#return value description#>
 */
-(BOOL)notbeAbletoSend;
/**
 *  仅显示任务详情
 *
 *  @return <#return value description#>
 */
-(BOOL)previewFirst;
/**
 *  无限制条数的转发！
 *
 *  @return <#return value description#>
 */
-(BOOL)nolimitToSend;

//v2.0.0
@property (nonatomic, retain) NSString * extraDes;

//v1.1.0
@property (nonatomic, retain) NSString * sendList;

//@property (nonatomic, retain) UIImage * largeImage;
@property (nonatomic, retain) NSNumber * taskId;
@property (nonatomic, retain) NSNumber * partInAutoId;
@property (nonatomic, retain) NSString * taskName;
@property (nonatomic, retain) NSNumber * awardLink;
@property (nonatomic, retain) NSNumber * awardBrowse;
@property (nonatomic, retain) NSNumber * awardSend;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSDate * publishTime;
@property (nonatomic, retain) NSNumber * status;// 4任务结束  5 任务取消 6 积分用完
@property (nonatomic, retain) NSNumber * sendCount;
/**
 *  1刮刮乐,
 *  2 欢乐大转盘,
 *  3水果达人,
 *  4通用预约
 *  5团购
 *  6调查问卷,
 *  7投票
 *   500优惠券
 *  600 邀请函
 *  90000 注册推荐
 *  999999图文(除图文都算活动)
 *  1000200新手任务
 *  90100求包养
 *  1000100公告
 *  1000300 闪购
 */
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * taskInfo;
@property (nonatomic, retain) NSString * taskPreview;
@property (nonatomic, retain) NSString * taskSmallImgUrl;
//@property (nonatomic, retain) NSString * storeName;
@property (nonatomic, retain) NSString * taskDes;
@property (nonatomic, retain) NSString * awardDes;
#pragma mark - details
@property (nonatomic, retain) NSNumber * lastScore;
@property (nonatomic, retain) NSNumber * totalScore;
@property (nonatomic, retain) NSString * ruleDes;
//@property (nonatomic, retain) NSString * storeLargeImgURL;
//@property (nonatomic, retain) NSString * openID;
//@property (nonatomic, retain) NSString * storeID;
@property (nonatomic, retain) NSString * taskLargeImgUrl;
#pragma mark - my details
@property (nonatomic, retain) NSNumber * myAwardLink;
@property (nonatomic, retain) NSNumber * myAwardBrowse;
@property (nonatomic, retain) NSNumber * myAwardSend;
//@property (nonatomic, retain) NSNumber * isFav;
//@property (nonatomic, retain) NSNumber * isSend;
@property (nonatomic, retain) Store *store;


@property (nonatomic, retain) NSNumber * awardYesLinkResult;
@property (nonatomic, retain) NSNumber * awardYesScanResult;
@property (nonatomic, retain) NSNumber * awardYesSendResult;
@property (nonatomic, retain) NSNumber * isAccount;

/**
 *  总浏览量
 */
@property (nonatomic, retain) NSNumber * totalScanCount;
/**
 *  昨日浏览量（若为昨日请求，则有值返回）
 */
@property (nonatomic, retain) NSNumber * yesScanCount;

/**
 *  当天浏览量
 */
@property (nonatomic, retain) NSNumber * todayBrowseAmount;
/**
 *  历史浏览量
 */
@property (nonatomic, retain) NSNumber * totalAmount;

/**
 *  是否显示转发按钮（0不显示，1显示）
 */
@property (nonatomic, retain) NSNumber * flagShowSend;
/**
 *  是否限制转发次数 (0不限制，1限制）
 */
@property (nonatomic, retain) NSNumber * flagLimitCount;
/**
 *  任务详情界面内优先显示的界面 （0无（只有WEBVIEW），1有）
 */
@property (nonatomic, retain) NSNumber * flagHaveIntro;

@property (nonatomic,retain) NSString* rebate;

@property (nonatomic, retain) NSNumber *online;

/**
 *  返回返利说明。
 *
 *  @return 只有是闪购类型才会返回有效字符串
 */
-(NSString*)getRebateMsg;

@property (nonatomic, retain) NSDate * advancedseconds;

@end
