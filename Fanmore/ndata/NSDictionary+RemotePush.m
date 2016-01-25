//
//  NSDictionary+RemotePush.m
//  Fanmore
//
//  Created by Cai Jiang on 9/3/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "NSDictionary+RemotePush.h"

#ifdef FanmoreDebug

@implementation NSMutableDictionary (RemotePush)

-(void)setRemotePushURL:(NSString *)url{
    self[@"getRemotePushURL"] = url;
}

-(void)setRemotePushTaskId:(NSString *)taskid{
    self[@"getRemotePushTaskId"] = taskid;
}


@end

#endif

@implementation NSDictionary (RemotePush)

-(NSString*)getRemotePushTaskId{
    return self[@"getRemotePushTaskId"];
}

-(NSString*)getRemotePushURL{
    return self[@"getRemotePushURL"];
}

-(BOOL)isRemotePushTaskPush{
    NSString* taskid = [self getRemotePushTaskId];
    return $safe(taskid) && taskid.length>0;
}


@end
