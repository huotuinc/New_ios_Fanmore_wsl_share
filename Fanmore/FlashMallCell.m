//
//  FlashMallCell.m
//  Fanmore
//
//  Created by Cai Jiang on 8/8/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FlashMallCell.h"

@implementation NSDictionary (SLCell)

-(NSString*)getSLOrderTime{
    return self[@"updateTime"];
}

-(NSNumber*)getSLOrderId{
    return self[@"orderID"];
}

-(NSString*)getSLId{
    return self[@"orderNo"];
}
-(NSString*)getSLName{
    return self[@"goodsName"];
}
-(NSString*)getSLUser{
    return self[@"name"];
}
-(NSDate*)getSLDate{
    NSString* time  = self[@"time"];
    return [time fmToDate2];
}
-(NSNumber*)getSLScoreTemp{
    return self[@"tempScore"];
}
-(NSNumber*)getSLScoreActurl{
    return self[@"realScore"];
}

-(NSString*)getSLTimeCount{
//    if ($safe(self[@"timeCount"]) && [self[@"timeCount"] length]>0)
        return self[@"timeCount"];
//    if ([[self getSLStatus] intValue]==1) {
//        return @"已到账";
//    }else
//        return @"积分扣除";
//    
//    return [self getSLStatusMsg];
}
-(NSNumber*)getSLStatus{
    return self[@"status2"];
}
-(NSString*)getSLStatusMsg{
    if (self[@"status2Des"]) {
        return self[@"status2Des"];
    }
    NSNumber* status = [self getSLStatus];
    switch ([status intValue]) {
        case 0:
            return @"临时积分";
        case 1:
            return @"积分到账";
        case -1:
            return @"积分扣除";
        case -2:
            return @"积分扣除";
    }
    return @"未知";
}

@end

@implementation FlashMallCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)config:(NSDictionary *)data{
    [self.labelID setText:[data getSLId]];
    
    [self.labelName setText:[data getSLName]];
    //初始font 12
    [self.labelName wellFontFrom:12.0f];
        
    [self.labelUser setText:[data getSLUser]];
    [self.labelScoreActurl setText:$str(@"%@",[data getSLScoreActurl])];
    [self.labelScoreTemp setText:$str(@"%@",[data getSLScoreTemp])];
    NSDateFormatter *rfc822DateFormatter =[NSDateFormatter new];
    //        rfc822DateFormatter.dateFormat=@"EEE, dd MMM yyyy hh:mm a z";
    //        rfc822DateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
    rfc822DateFormatter.dateFormat=@"yyyy/MM/dd";
    rfc822DateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    [self.labelTime setText:[rfc822DateFormatter stringFromDate:[data getSLDate]]];
    
    [self.labelTimeCount setText:[data getSLTimeCount]];
}


@end
