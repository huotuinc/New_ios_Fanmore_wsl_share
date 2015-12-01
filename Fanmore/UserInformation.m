//
//  UserInformation.m
//  Fanmore
//
//  Created by Cai Jiang on 2/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "UserInformation.h"


@implementation UserInformation

+(NSString*)ownerWorkhard:(NSString*)oriName dict:(NSDictionary*)dict class:(Class)class{
    static NSDictionary* tables;
    if (tables==Nil) {
        //@"industry":@"industryId",@"incoming":@"incomingId",
        tables = @{@"area":@"areaId",@"favoritesStr":@"favoriteId"};
    }
    NSString* target = tables[oriName];
    if ($safe(target)) {
        return target;
    }
    return nil;
}

@synthesize phone;
@synthesize name;
@synthesize sex;
@synthesize birth;
//@synthesize industry;
@synthesize favoritesStr;
@synthesize contacts;
//@synthesize incoming;
@synthesize area;

@synthesize incomeId;
@synthesize industryId;

//@synthesize exp;
//@synthesize pictureURL;
//@synthesize rewarded;

@end
