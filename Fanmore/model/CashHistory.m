//
//  CashHistory.m
//  Fanmore
//
//  Created by Cai Jiang on 2/17/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "CashHistory.h"


@implementation CashHistory

+(NSString*)ownerWorkhard:(NSString*)oriName dict:(NSDictionary*)dict class:(Class)class{
    static NSDictionary* tables;
    if (tables==Nil) {
        tables = @{@"id":@"autoId"};
    }
    NSString* target = tables[oriName];
    if ($safe(target)) {
        return target;
    }
    return nil;
}

@synthesize money;
@synthesize time;
@synthesize score;
@synthesize status;
@synthesize extraMsg;
@synthesize id;
@synthesize statusName;

@end
