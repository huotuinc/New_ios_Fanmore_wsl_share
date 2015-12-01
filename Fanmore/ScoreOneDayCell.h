//
//  ScoreOneDayCell.h
//  Fanmore
//
//  Created by Cai Jiang on 6/16/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "AbstracyTaskCell.h"

@interface NSDictionary (ScoreOneDay)

-(NSDate*)getScoreOneDayDate;

@end

@interface ScoreOneDayCell : AbstracyTaskCell

@property(weak) UILabel* labelStaticBrowse;

-(void)configureData:(NSDictionary*)data;

@end
