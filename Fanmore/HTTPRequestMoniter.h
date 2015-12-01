//
//  HTTPRequestMoniter.h
//  Fanmore
//
//  Created by Cai Jiang on 1/16/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface HTTPRequestMoniter : NSObject


-(id)initWithASIHTTPRequest:(ASIHTTPRequest*)request;

-(void)cancel;

-(BOOL)isCancelled;

@end
