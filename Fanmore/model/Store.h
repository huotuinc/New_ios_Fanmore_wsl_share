//
//  Store.h
//  Fanmore
//
//  Created by Cai Jiang on 2/17/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FanmoreModel.h"
#import "CacheResource.h"

@interface Store : FanmoreModel

/**
 *  从Store共享池中获取Store 如果没有该Store则将创建新的
 *  相应接口应该不再使用普通初始化创建Store
 *
 *  @param id <#id description#>
 *
 *  @return <#return value description#>
 */
+(instancetype)storeInPool:(NSNumber*)id;
-(CacheResource*)logoCache;

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * openID;
@property (nonatomic, retain) NSNumber * fav;
@property (nonatomic, retain) NSString * logo;
@property (nonatomic, retain) NSNumber * taskCount;
@property (nonatomic, retain) NSString * contact;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSString * industry;

@end
