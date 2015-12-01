//
//  FanOperationsTester.h
//  Fanmore
//
//  Created by Cai Jiang on 2/21/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FanOperations.h"
#import "DonetagHolder.h"

@interface FanOperationsTester : NSObject<FanOperations>

@property id<FanOperations> imps;
@property id<DonetagHolder> dholder;

+(instancetype)tester:(id<FanOperations>)imp holder:(id<DonetagHolder>)holder;

@end
