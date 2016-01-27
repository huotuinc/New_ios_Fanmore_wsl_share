//
//  NSString+EXTERN.m
//  fanmore---
//
//  Created by lhb on 15/5/29.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "NSString+EXTERN.h"

@implementation NSString (EXTERN)



/**
 *  验证手机号的正则表达式
 */
+ (BOOL) checkTel:(NSString *) phoneNumber{
    NSString *regex = @"^(1)\\d{10}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    
    if (!isMatch) {
        return NO;
    }
    return YES;
}

+(NSString *)xiaoshudianweishudeal:(CGFloat)aac
{
    //设置cell样式
    NSString * ml = [NSString stringWithFormat:@"%.1f",aac];
    NSRange aa = [ml rangeOfString:@"."];
    NSString * bb = [ml substringWithRange:NSMakeRange(aa.location+1, 1)];
    if ([bb isEqualToString:@"0"]) {
        ml = [NSString stringWithFormat:@"%.f",aac];
    }
    return ml;
}


@end
