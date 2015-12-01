//
//  NSObject+JSON.m
//  Fanmore
//
//  Created by Cai Jiang on 9/15/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "NSObject+JSON.h"

@implementation NSObject (JSON)

+(BOOL)validJSONStr:(NSString*)str{
    if(!$safe(str))
        return NO;
    unichar firstC = [str characterAtIndex:0];
    unichar lastC = [str characterAtIndex:str.length-1];
    return firstC=='{' && lastC=='}';
}

-(NSString*)myJSONString{
    NSError* error = NULL;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    NSString* rs  = [NSString stringWithUTF8String:[jsonData bytes]];
    if ([NSObject validJSONStr:rs]) {
        return rs;
    }
    return [self myJSONString];
}

@end
