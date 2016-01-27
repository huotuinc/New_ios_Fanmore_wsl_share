//
//  FollowModel.h
//  Fanmore
//
//  Created by lhb on 15/12/11.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowModel : NSObject


/**
 {
 historyTotalBrowseAmount = 0;
 historyTotalTurnAmount = 0;
 recentScore = 0;
 time = "2015-12-10 20-50-10";
 totalScore = 0;
 userId = 1000;
 userName = autoName995;
 yesterdayBrowseAmount = 0;
 yesterdayTurnAmount = 0;
 }
 */


@property(nonatomic,copy) NSString * time;
@property(nonatomic,copy) NSString * userName;
@property(nonatomic,strong) NSNumber *totalScore;
@property(nonatomic,strong) NSNumber *userId;
@property(nonatomic,strong) NSNumber *recentScore;
@property(nonatomic,strong) NSNumber *historyTotalTurnAmount;
@property(nonatomic,strong) NSNumber *historyTotalBrowseAmount;
@property(nonatomic,strong) NSNumber *yesterdayTurnAmount;
@property(nonatomic,strong) NSNumber *yesterdayBrowseAmount;
@end
