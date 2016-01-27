//
//  FanmoreModel.h
//  Fanmore
//
//  Created by Cai Jiang on 2/20/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FanmoreModel : NSObject

+(instancetype)modelFromDict:(NSDictionary*)dict;
+(instancetype)modelFromDict:(NSDictionary*)dict model:(FanmoreModel*)model;

+(NSString*)ownerWorkhard:(NSString*)oriName dict:(NSDictionary*)dict class:(Class)class;
+(void)hasMoreData:(FanmoreModel*)model dict:(NSDictionary*)dict;

@end
