//
//  NSError+Fanmore.m
//  Fanmore
//
//  Created by Cai Jiang on 4/18/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "NSError+Fanmore.h"

@implementation NSError (Fanmore)

- (NSString *)FMDescription{
    NSString* msg= [self localizedDescription];
    //A connection failtrue occurred
    //A connection failure occurred
    if ($eql(@"The request timed out",msg)) {
        return @"网络不佳，万事利正在继续努力加载";
    }
    if ([msg rangeOfString:@"connection failure occurred"].location!=NSNotFound) {
        return @"尚未接入网络，万事利有力难施";
    }
    return msg;
}

@end
