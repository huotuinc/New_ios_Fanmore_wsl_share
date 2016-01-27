//
//  CacheResource.m
//  Fanmore
//
//  Created by Cai Jiang on 3/4/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "CacheResource.h"

@interface CacheResource ()
@property NSTimeInterval cacheTime;
@end

@implementation CacheResource

+(instancetype)cacheByTime:(NSString*)name time:(NSTimeInterval)time{
    CacheResource* cr = $new(self);
    cr.resourceName = name;
    cr.cacheTime = time;
    return cr;
}

-(BOOL)acceptCache:(NSFileManager*)fm file:(NSString*)file{
    BOOL isDir ;
    if ([fm fileExistsAtPath:file isDirectory:&isDir]){
        if (isDir) {
            return NO;
        }
        
        NSDictionary *attrs = [fm attributesOfItemAtPath: file error: NULL];
        if ([[NSDate date] timeIntervalSinceDate:[attrs fileModificationDate]]<self.cacheTime) {
            return YES;
        }
        //If the receiver is earlier than anotherDate, the return value is negative.
        return NO;
    }else
        return NO;
}

@end
