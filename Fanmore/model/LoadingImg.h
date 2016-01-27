//
//  LoadingImg.h
//  Fanmore
//
//  Created by Cai Jiang on 2/20/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FanmoreModel.h"
#import "CacheResource.h"

@interface LoadingImg : FanmoreModel

-(CacheResource*)imageCache;
@property (nonatomic, retain) NSString * imgUrl;
@property (nonatomic, retain) NSString * showTime;
@property (nonatomic, retain) NSNumber * updateType;

@end
