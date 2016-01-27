//
//  ScorePerDay.h
//  Fanmore
//
//  Created by Cai Jiang on 6/11/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  browseAmount = 5;
 date = "2014-06-10 00-00-00";
 extra = "";
 totalScore = 15;
 */
@interface ScorePerDay:NSObject

@property (nonatomic, retain) NSDate *  time;//	行为时间
@property (nonatomic, retain) NSNumber * score;//积分量
@property (nonatomic, retain) NSNumber * browse;
/**
 *  额外描述（多条以^隔开）
 */
@property (nonatomic, retain) NSString * comments;

@property (nonatomic, retain) NSArray* details;

/**
 *  获取额外描述
 *
 *  @return <#return value description#>
 */
-(NSArray*)listComments;

@end
