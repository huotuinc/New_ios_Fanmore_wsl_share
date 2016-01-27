//
//  LoadingImg.m
//  Fanmore
//
//  Created by Cai Jiang on 2/20/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "LoadingImg.h"

@implementation LoadingImg

@synthesize imgUrl;
@synthesize showTime;
@synthesize updateType;

-(CacheResource*)imageCache{
    return [CacheResource cacheByTime:@"loadingimg" time:5];
}

@end
