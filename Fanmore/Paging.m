//
//  Paging.m
//  Fanmore
//
//  Created by Cai Jiang on 2/17/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "Paging.h"

@implementation Paging

@synthesize pageIndex;
@synthesize pageSize;
@synthesize parameters;

+(instancetype)defaultPaging{
    return $new(self);
}

+(instancetype)paging:(uint)pageIndex pageSize:(uint)pageSize{
    return [[self alloc]initWithData:pageIndex pageSize:pageSize];
}

+(instancetype)paging:(uint)pageSize parameters:(NSDictionary*)parameters{
    return [[self alloc]initWithData:pageSize parameters:parameters];
}

-(void)toParameters:(NSMutableDictionary*)p{
    p[@"pageIndex"] = $int(pageIndex);
    p[@"pageSize"] = $int(pageSize);
    if ($safe(self.parameters)) {
        [p addEntriesFromDictionary:self.parameters];
    }
}

-(id)initWithData:(uint)pageSize2 parameters:(NSDictionary*)parameters2{
    self = [super init];
    if ($safe(self)){
        self.pageIndex = 0;
        self.pageSize = pageSize2;
        self.parameters = parameters2;
    }
    return self;
}

-(id)initWithData:(uint)pageIndex2 pageSize:(uint)pageSize2{
    self = [super init];
    if ($safe(self)){
        self.pageIndex = pageIndex2;
        self.pageSize = pageSize2;
    }
    return self;
}

-(id)init{
    self = [super init];
    if ($safe(self)){
        self.pageIndex = 0;
        self.pageSize = 30;
    }
    return self;
}

@end
