//
//  NSNumber+Fanmore.h
//  Fanmore
//
//  Created by Cai Jiang on 2/24/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Fanmore)

/**
 *  以货币形式显示
 *  如果存在小数则显示 否者隐藏小数
 *
 *  @return <#return value description#>
 */
-(NSString*)currencyStringMax2Digits;

-(NSString*)currencyString;

-(NSString*)currencyString:(NSLocale*)locale;

-(NSString*)currencyString:(NSString*)symbol fractionDigits:(NSUInteger)fractionDigits;

-(NSString*)timeLag;

@end
