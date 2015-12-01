//
//  LoginState.h
//  Fanmore
//
//  Created by Cai Jiang on 1/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FanmoreModel.h"

@interface LoginState : FanmoreModel

@property (nonatomic, retain) NSString * loginCode;
@property (nonatomic, retain) NSNumber * yesScore;
@property (nonatomic, retain) NSNumber * totalTaskCount;
@property (nonatomic, retain) NSNumber * completeTaskCount;
@property (nonatomic, retain) NSString * alipayId;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSNumber * isBindMobile;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSDate * regTime;
@property (nonatomic, retain) NSNumber *score;
@property (nonatomic, retain) NSNumber *lockScore;
@property (nonatomic, retain) NSNumber *favoriteAmount;
@property (nonatomic, retain) NSNumber * turnAmount;
@property (nonatomic, retain) NSNumber * crashCount;
@property (nonatomic, retain) NSNumber * welfareCount;
@property (nonatomic, retain) NSString * withdrawalPassword;
@property (nonatomic, retain) NSString *shareContent;
@property (nonatomic, retain) NSString *shareDes;
@property (nonatomic, retain) NSNumber * totalScore;
@property (nonatomic, retain) NSNumber * todayBrowseCount;
@property (nonatomic, retain) NSArray * msgs;

-(BOOL)hasNewFeedBack;

@property (nonatomic, retain) NSNumber *exp;
@property (nonatomic, retain) NSString *picUrl;

@property (nonatomic, retain) NSNumber *completeInfo;
-(void)updateUserPicture:(UIImageView*)view;

@property (nonatomic, retain) NSNumber *dayCheckIn;
@property (nonatomic, retain) NSNumber *checkInDays;

/**
 *  可以用于提现的积分
 *
 *  @return <#return value description#>
 */
-(NSNumber*)ableToCashScore;
-(NSString*)cashScoreHint;

@end
