//
//  CacheResource.h
//  Fanmore
//
//  Created by Cai Jiang on 3/4/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheResource : NSObject

+(instancetype)cacheByTime:(NSString*)name time:(NSTimeInterval)time;

@property NSString* resourceName;

-(BOOL)acceptCache:(NSFileManager*)fm file:(NSString*)file;

@end
