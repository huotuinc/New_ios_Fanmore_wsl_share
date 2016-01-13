//
//  LoginState.m
//  Fanmore
//
//  Created by Cai Jiang on 1/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "LoginState.h"
#import "AppDelegate.h"

@implementation LoginState

-(NSNumber*)ableToCashScore{
    int rmb = [self.score intValue]/10;
    float rmbcost = rmb*10;
    return $float(rmbcost);
}

-(NSString*)cashScoreHint{
    float rmbcost = [[self ableToCashScore] floatValue];
    int rmb = rmbcost/10;
    float last = [self.score floatValue]-rmbcost;
    
    return $str(@"您有%@积分可用于提现，约合人民币%@元；剩余%@积分",[$float(rmbcost) currencyString:@"" fractionDigits:0],[$float(rmb) currencyString:@"" fractionDigits:0],[$float(last) currencyString:@"" fractionDigits:2]);
}

-(void)updateUserPicture:(UIImageView *)view{
    if ($safe(self.picUrl) && self.picUrl.length>0) {
        [[AppDelegate getInstance] downloadImage:self.picUrl handler:^(UIImage *image, NSError *error) {
            [view setImage:image];
        } asyn:YES];
    }else
        [view setImage:[UIImage imageNamed:@"queshentu"]];
}

+(void)hasMoreData:(LoginState*)model dict:(NSDictionary*)dict{
    //[3]	(null)	@"storeId" : (long)18
//    ls.msgs = data[@"msg"];
    if ($safe(dict[@"msg"])) {
        model.msgs = dict[@"msg"];
    }    
}

-(BOOL)hasNewFeedBack{
    if ($safe(self.msgs)) {
        for (NSDictionary* m in self.msgs) {
            if ($eql(m[@"type"],@"s_feedback")) {
                return YES;
            }
        }
    }
    return NO;
}

@synthesize alipayId;
@synthesize completeTaskCount;
@synthesize crashCount;
@synthesize favoriteAmount;
@synthesize isBindMobile;
@synthesize loginCode;
@synthesize mobile;
@synthesize regTime;
@synthesize score;
@synthesize totalTaskCount;
@synthesize turnAmount;
@synthesize welfareCount;
@synthesize userName;
@synthesize yesScore;
@synthesize lockScore;
@synthesize withdrawalPassword;
@synthesize shareContent;
@synthesize shareDes;
@synthesize totalScore;
@synthesize todayBrowseCount;
@synthesize userHead;
@synthesize exp;
@synthesize picUrl;
@synthesize completeInfo;
@synthesize dayCheckIn;
@synthesize checkInDays;

@synthesize unionId;
@synthesize website;
@synthesize mallUserId;
@end
