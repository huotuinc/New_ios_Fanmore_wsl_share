//
//  LoadingState.m
//  Fanmore
//
//  Created by Cai Jiang on 1/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "LoadingState.h"
#import "LoginState.h"
#import "NSString+SSToolkitAdditions.h"


@implementation LoadingState

@synthesize taskTimeLag;
//@synthesize updateType;
@synthesize updateURL;
@synthesize changeBoundary;
//@synthesize updateTips;
@synthesize loadingImg;

@synthesize taskBrowseScore;
@synthesize taskLinkScore;
@synthesize taskTurnScore;
//@synthesize smsTag;
@synthesize isCompleteUserInfo;
//@synthesize updateMD5;
@synthesize userYesTotalScore;
@synthesize loginStatus;
@synthesize userData;

//@synthesize image;

@synthesize aboutUsUrl;
@synthesize ruleUrl;
@synthesize toolUrl;
@synthesize serviceUrl;
@synthesize putInUrl;
@synthesize manualServiceUrl;

@synthesize todayTotalScore;
@synthesize smsEnable;
@synthesize grenadeRewardInfo;


@synthesize disasterFlag;
@synthesize disasterUrl;

@synthesize CashType;
@synthesize wxVersionCode;

-(BOOL)wxcannotSendSuccess{    
    if ($safe(self.wxVersionCode)) {
        return [self.wxVersionCode containsString:@"ios"];
    }
    return NO;
}

-(BOOL)useNewCash{
    if (!$safe(self.CashType)) {
        return NO;
    }
    return [self.CashType intValue]==1;
}

-(BOOL)isDisater{
    return $safe(self.disasterFlag) && [self.disasterFlag intValue]==1;
}

-(BOOL)hasBindMobile{
    return [self.userData.isBindMobile boolValue] && $safe(self.userData.mobile) && [self.userData.mobile isMobileNumber];
}
-(BOOL)hasBindALP{
    return $safe(self.userData.alipayId) && self.userData.alipayId.length>=5;
}
-(BOOL)hasSetCashPSWD{
    return $safe(self.userData.withdrawalPassword) && self.userData.withdrawalPassword.length==32;
}

-(BOOL)hasSMSEnabled{
    return $safe(self.smsEnable) && [self.smsEnable intValue]==0;
}

-(BOOL)hasLogined{
    return $safe(self.userData) && [self.loginStatus boolValue];
}
-(void)loginAs:(LoginState*)user{
    if ($safe(user)) {
        self.loginStatus = @1;
        self.userData = user;
    }else{
        self.userData = nil;
        self.loginStatus = @0;
    }
}



@end
