//
//  ScoreFlow.h
//  Fanmore
//
//  Created by Cai Jiang on 3/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FanmoreModel.h"

@interface ScoreFlow : FanmoreModel

@property (nonatomic, retain) NSDate *  time;//	行为时间
@property (nonatomic, retain) NSNumber*  id;
@property (nonatomic, retain) NSNumber*  channelType;
@property (nonatomic, retain) NSString* operation;//行为描述
@property (nonatomic, retain) NSNumber * score;//	    积分量

@end
