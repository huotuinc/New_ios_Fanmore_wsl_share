//
//  NSString+Fanmore.m
//  Fanmore
//
//  Created by Cai Jiang on 1/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "NSString+Fanmore.h"
#import "RegexKitLite.h"

@implementation NSString (Fanmore)
-(NSDate*)fmToDate{
    static NSDateFormatter *_FanmoreStandDateFormatter = nil;
    static dispatch_once_t oncePredicate;
    static NSDateFormatter *_FanmoreStandDateFormatter2 = nil;
    
    dispatch_once(&oncePredicate, ^{
        NSDateFormatter *rfc822DateFormatter =[NSDateFormatter new];
        rfc822DateFormatter.dateFormat=@"yyyy-MM-dd HH-mm-ss";
        rfc822DateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _FanmoreStandDateFormatter = rfc822DateFormatter;
        rfc822DateFormatter =[NSDateFormatter new];
        rfc822DateFormatter.dateFormat=@"yyyy-MM-dd";
        rfc822DateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _FanmoreStandDateFormatter2 = rfc822DateFormatter;
    });
    
    if ([self isMatchedByRegex:@" "]) {
        return [_FanmoreStandDateFormatter dateFromString:self];
    }
    return [_FanmoreStandDateFormatter2 dateFromString:self];
}

-(NSDate*)fmToDate2{
    static NSDateFormatter *_FanmoreStandDateFormatter2 = nil;
    static dispatch_once_t oncePredicate;
    static NSDateFormatter *_FanmoreStandDateFormatter22 = nil;
    
    dispatch_once(&oncePredicate, ^{
        NSDateFormatter *rfc822DateFormatter =[NSDateFormatter new];
        rfc822DateFormatter.dateFormat=@"yyyy/MM/dd HH:mm:ss";
        rfc822DateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _FanmoreStandDateFormatter2 = rfc822DateFormatter;
        rfc822DateFormatter =[NSDateFormatter new];
        rfc822DateFormatter.dateFormat=@"yyyy/MM/dd";
        rfc822DateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _FanmoreStandDateFormatter22 = rfc822DateFormatter;
    });
    
    if ([self isMatchedByRegex:@" "]) {
        return [_FanmoreStandDateFormatter2 dateFromString:self];
    }
    return [_FanmoreStandDateFormatter22 dateFromString:self];
}

#pragma mark utilities
- (NSString*)encodeURL
{
    CFStringRef data = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)(self), NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSString* newString = CFBridgingRelease(data);
//	NSString *newString = NSMakeCollectable([(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))]);
	if (newString) {
		return newString;
	}
	return @"";
}

-(BOOL)isMobileNumber{
    return [self isMatchedByRegex:@"^[0-9]{11}$"];
}

-(BOOL)isUserName{
    return [self isMatchedByRegex:@"^[A-Za-z]{1}[A-Za-z0-9_@.]{2,19}$"];
}

-(BOOL)isPassword{
    return [self isMatchedByRegex:@"^.{6,12}$"];
}

-(NSString*)parameterFromQuery:(NSString*)name{
    NSArray *urlComponents = [self componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents)
    {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [pairComponents objectAtIndex:0];
        NSString *value = [pairComponents objectAtIndex:1];
        if ($eql(key,name)) {
            return value;
        }
    }
    return nil;
}

@end
