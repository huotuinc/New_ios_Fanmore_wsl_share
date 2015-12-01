//
//  NSDictionary+RemotePush.h
//  Fanmore
//
//  Created by Cai Jiang on 9/3/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef FanmoreDebug

@interface NSMutableDictionary (RemotePush)

-(void)setRemotePushTaskId:(NSString*)taskid;
-(void)setRemotePushURL:(NSString*)url;

@end

#endif

@interface NSDictionary (RemotePush)

-(BOOL)isRemotePushTaskPush;
-(NSString*)getRemotePushTaskId;
-(NSString*)getRemotePushURL;

@end

