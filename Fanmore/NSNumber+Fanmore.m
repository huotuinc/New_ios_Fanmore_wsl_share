//
//  NSNumber+Fanmore.m
//  Fanmore
//
//  Created by Cai Jiang on 2/24/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "NSNumber+Fanmore.h"

@implementation NSNumber (Fanmore)

-(NSString*)currencyStringMax2Digits{
    if([self floatValue]==[self intValue]){
        //没有小数
        return [self currencyString:@"" fractionDigits:0];
    }
    return [self currencyString:@"" fractionDigits:2];
}

-(NSString*)currencyString{
    NSNumberFormatter* nsf1 = $new(NSNumberFormatter);
    nsf1.numberStyle =NSNumberFormatterCurrencyStyle;
    [nsf1 setNegativePrefix:@"-"];
    [nsf1 setNegativeSuffix:@""];
//    return [NSNumberFormatter localizedStringFromNumber:self numberStyle:NSNumberFormatterCurrencyStyle];
    return [nsf1 stringFromNumber:self];
}

-(NSString*)currencyString:(NSLocale*)locale{
    NSNumberFormatter* nsf1 = $new(NSNumberFormatter);
    [nsf1 setLocale:locale];
    [nsf1 setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nsf1 setNegativePrefix:@"-"];
    [nsf1 setNegativeSuffix:@""];
    return [nsf1 stringFromNumber:self];
}

-(NSString*)currencyString:(NSString*)symbol fractionDigits:(NSUInteger)fractionDigits{
    NSNumberFormatter* nsf1 = $new(NSNumberFormatter);
    [nsf1 setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nsf1 setCurrencySymbol:symbol];
    [nsf1 setMaximumFractionDigits:fractionDigits];
    [nsf1 setMinimumFractionDigits:0];
    [nsf1 setNegativePrefix:@"-"];
    [nsf1 setNegativeSuffix:@""];
    return [nsf1 stringFromNumber:self];
}

-(NSString*)timeLag{
    int x  = [self intValue];
    int x6 = x/60;
    if (x6>0) {
        return $str(@"%d分钟",x6);
    }
    return $str(@"%d秒",x);
}


@end
