//
//  CashHistory.h
//  Fanmore
//
//  Created by Cai Jiang on 2/17/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FanmoreModel.h"

@interface CashHistory : FanmoreModel

@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * extraMsg;
@property (nonatomic, retain) NSString * statusName;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * showId;

@end
