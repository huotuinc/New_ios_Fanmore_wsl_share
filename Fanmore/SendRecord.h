//
//  SendRecord.h
//  Fanmore
//
//  Created by Cai Jiang on 1/22/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FanmoreModel.h"

@interface SendRecord : FanmoreModel

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * time;

@end
