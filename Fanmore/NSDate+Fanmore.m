//
//  NSDate+Fanmore.m
//  Fanmore
//
//  Created by Cai Jiang on 1/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "NSDate+Fanmore.h"

@implementation NSDate (Fanmore)

-(BOOL)between:(NSDate*)start end:(NSDate*)end{
    if (start==nil||end==nil){
        return NO;
    }
    return [self laterDate:start]==self && [self earlierDate:end]==self;
}

-(NSString*)fmHumenReadableString{
    NSTimeInterval timediff = [self timeIntervalSinceNow];
    if (timediff>-60) {
        return @"就在刚刚";
    }else if(timediff>-60*2){
        return @"一分钟前";
    }else if(timediff>-60*15){
        return @"几分钟前";
    }else if(timediff>-60*60){
        return @"1小时内";
    }else if(timediff>-2*60*60){
        return @"1小时前";
    }else if(timediff>-3*60*60){
        return @"2小时前";
    }else if(timediff>-4*60*60){
        return @"3小时前";
    }else if(timediff>-5*60*60){
        return @"4小时前";
    }else if(timediff>-6*60*60){
        return @"5小时前";
    }else if(timediff>-7*60*60){
        return @"6小时前";
    }else if(timediff>-8*60*60){
        return @"7小时前";
    }else if(timediff>-9*60*60){
        return @"8小时前";
    } else {
        static NSDateFormatter *_FanmoreHumenReadableDateFormatter = nil;
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            NSDateFormatter *rfc822DateFormatter =[NSDateFormatter new];            rfc822DateFormatter.dateFormat=@"yyyy-MM-dd HH:mm";
            rfc822DateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
            _FanmoreHumenReadableDateFormatter = rfc822DateFormatter;
        });
        return [_FanmoreHumenReadableDateFormatter stringFromDate:self];
    }
}


-(NSString*)fmToString{
    static NSDateFormatter *_FanmoreStandDateFormatter = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSDateFormatter *rfc822DateFormatter =[NSDateFormatter new];
        //        rfc822DateFormatter.dateFormat=@"EEE, dd MMM yyyy hh:mm a z";
        //        rfc822DateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
        rfc822DateFormatter.dateFormat=@"yyyy-MM-dd HH-mm-ss";
        rfc822DateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _FanmoreStandDateFormatter = rfc822DateFormatter;
    });
    return [_FanmoreStandDateFormatter stringFromDate:self];
}

-(NSString*)fmStandStringDateOnly{
    static NSDateFormatter *_FanmoreStandDateFormatter2DateOnly = nil;
    static dispatch_once_t oncePredicate2DateOnly;
    dispatch_once(&oncePredicate2DateOnly, ^{
        NSDateFormatter *rfc822DateFormatter =[NSDateFormatter new];
        //        rfc822DateFormatter.dateFormat=@"EEE, dd MMM yyyy hh:mm a z";
        //        rfc822DateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
        rfc822DateFormatter.dateFormat=@"yyyy-MM-dd";
        rfc822DateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _FanmoreStandDateFormatter2DateOnly = rfc822DateFormatter;
    });
    return [_FanmoreStandDateFormatter2DateOnly stringFromDate:self];
}

-(NSString*)fmStandStringDateOnlyDot{
    static NSDateFormatter *_FanmoreStandDateFormatter2DateOnlyDot = nil;
    static dispatch_once_t oncePredicate2DateOnlyDot;
    dispatch_once(&oncePredicate2DateOnlyDot, ^{
        NSDateFormatter *rfc822DateFormatter =[NSDateFormatter new];
        //        rfc822DateFormatter.dateFormat=@"EEE, dd MMM yyyy hh:mm a z";
        //        rfc822DateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
        rfc822DateFormatter.dateFormat=@"yyyy年MM月dd";
        rfc822DateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _FanmoreStandDateFormatter2DateOnlyDot = rfc822DateFormatter;
    });
    return [_FanmoreStandDateFormatter2DateOnlyDot stringFromDate:self];
}

-(NSString*)fmStandStringDateOnlyChinese{
    static NSDateFormatter *_FanmoreStandDateFormatter2DateOnlyChinese = nil;
    static dispatch_once_t oncePredicate2DateOnlyChinese;
    dispatch_once(&oncePredicate2DateOnlyChinese, ^{
        NSDateFormatter *rfc822DateFormatter =[NSDateFormatter new];
        //        rfc822DateFormatter.dateFormat=@"EEE, dd MMM yyyy hh:mm a z";
        //        rfc822DateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
        rfc822DateFormatter.dateFormat=@"yyyy年MM月dd";
        rfc822DateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _FanmoreStandDateFormatter2DateOnlyChinese = rfc822DateFormatter;
    });
    return [_FanmoreStandDateFormatter2DateOnlyChinese stringFromDate:self];
}

-(NSString*)fmStandString{
    static NSDateFormatter *_FanmoreStandDateFormatter2 = nil;
    static dispatch_once_t oncePredicate2;
    dispatch_once(&oncePredicate2, ^{
        NSDateFormatter *rfc822DateFormatter =[NSDateFormatter new];
        //        rfc822DateFormatter.dateFormat=@"EEE, dd MMM yyyy hh:mm a z";
        //        rfc822DateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
        rfc822DateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
        rfc822DateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _FanmoreStandDateFormatter2 = rfc822DateFormatter;
    });
    return [_FanmoreStandDateFormatter2 stringFromDate:self];
}

@end
