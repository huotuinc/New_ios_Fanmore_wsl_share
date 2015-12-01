//
//  Store.m
//  Fanmore
//
//  Created by Cai Jiang on 2/17/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "Store.h"


@implementation Store

static NSMutableDictionary* storePool;
+(instancetype)storeInPool:(NSNumber*)id{
    if (!storePool){
        storePool = $mdictnew;
    }
    Store* st = storePool[id];
    if ($safe(st)){
        return st;
    }
    st = $new(self);
    storePool[id] = st;
    return st;
}

//2014-02-21 17:27:06.795 Fanmore[8107:70b] FanmoreModel.m(120) 没找到数据源taskCount在Store
//2014-02-21 17:27:06.795 Fanmore[8107:70b] FanmoreModel.m(120) 没找到数据源contact在Store
//2014-02-21 17:27:06.796 Fanmore[8107:70b] FanmoreModel.m(120) 没找到数据源intro在Store

+(NSString*)ownerWorkhard:(NSString*)oriName dict:(NSDictionary*)dict class:(Class)class{
    static NSDictionary* tables;
    if (tables==Nil) {
        tables = @{@"id":@"storeId",@"name":@"storeName",@"fav":@"isFav",@"logo":@"storeLargeImgUrl",@"openID":@"Openid"};
    }
    NSString* target = tables[oriName];
    if ($safe(target)) {
        return target;
    }
    return nil;
}

-(CacheResource*)logoCache{
    return [CacheResource cacheByTime:$str(@"store--%@---%@",self.id,self.name) time:2*60*60];
}

@synthesize name;
@synthesize id;
@synthesize openID;
@synthesize fav;
@synthesize logo;
@synthesize taskCount;
@synthesize contact;
@synthesize intro;
@synthesize industry;

@end
