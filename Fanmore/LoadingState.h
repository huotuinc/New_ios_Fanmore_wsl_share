//
//  LoadingState.h
//  Fanmore
//
//  Created by Cai Jiang on 1/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FanmoreModel.h"
#import "LoadingImg.h"

@class LoginState;

@interface LoadingState : FanmoreModel

@property NSArray* groups;

//@property (nonatomic, retain) NSNumber * updateType;
@property (nonatomic, retain) NSNumber * taskTimeLag;
@property (nonatomic, retain) NSString * updateURL;
@property (nonatomic, retain) NSNumber * changeBoundary;
//@property (nonatomic, retain) NSString * updateTips;
@property (nonatomic, retain) LoadingImg *loadingImg;

@property (nonatomic, retain) NSNumber * taskBrowseScore;
@property (nonatomic, retain) NSNumber * taskLinkScore;
@property (nonatomic, retain) NSNumber * taskTurnScore;
@property (nonatomic, retain) NSNumber * isCompleteUserInfo;
//@property (nonatomic, retain) NSString * smsTag;
//@property (nonatomic, retain) NSString * updateMD5;
@property (nonatomic, retain) NSNumber * userYesTotalScore;
@property (nonatomic, retain) NSNumber * todayTotalScore;
@property (nonatomic, retain) NSNumber * loginStatus;
@property (nonatomic, retain) LoginState *userData;
//@property (atomic, retain) UIImage *image;

@property (nonatomic, retain) NSNumber * customerId;
@property (nonatomic, retain) NSString * aboutUsUrl;
@property (nonatomic, retain) NSString * ruleUrl;
@property (nonatomic, retain) NSString * serviceUrl;
@property (nonatomic, retain) NSString * wxVersionCode;
@property (nonatomic, retain) NSString * website;
/**
 *  微信无法正确给出转发成功事件
 *
 *  @return <#return value description#>
 */
-(BOOL)wxcannotSendSuccess;

/**
 *  人工服务
 */
@property (nonatomic, retain) NSString * manualServiceUrl;
/**
 *  接入指南
 */
@property (nonatomic, retain) NSString * putInUrl;
@property (nonatomic, retain) NSString * toolUrl;

@property(nonatomic,retain) NSNumber* smsEnable;
@property(nonatomic,retain) NSNumber* CashType;

/**
 *  是否使用新的钱包
 *
 *  @return <#return value description#>
 */
-(BOOL)useNewCash;


@property (nonatomic, retain) NSString * grenadeRewardInfo;

-(BOOL)hasBindMobile;
-(BOOL)hasBindALP;
-(BOOL)hasSetCashPSWD;
-(BOOL)hasSMSEnabled;

-(BOOL)hasLogined;
-(void)loginAs:(LoginState*)user;



/**
 *  0,非灾难;1、灾难
 */
@property (nonatomic, retain) NSNumber * disasterFlag;
/**
 *  灾难引导页面
 */
@property (nonatomic, retain) NSString * disasterUrl;

-(BOOL)isDisater;

@property NSArray* checkinExps;

@end
