//
//  FollowerCell.h
//  Fanmore
//
//  Created by Cai Jiang on 7/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FmTableCell.h"


/**
 *  弟子
 */
@interface NSDictionary (Follower)

#ifdef FanmoreMockMaster
+(instancetype)mockFollower;
#endif

/**
 *  徒弟的id
 *
 *  @return <#return value description#>
 */
-(NSNumber*)getFollowerId;

/**
 *  徒弟姓名
 *
 *  @return <#return value description#>
 */
-(NSString*)getUsername;

/**
 *  最近的贡献
 *
 *  @return <#return value description#>
 */
-(NSNumber*)getFollowerLastDevote;
-(NSNumber*)getFollowerTotalDevote;

-(NSDate*)getConnectDate;

@end


/**
 *  弟子的cell 用于 徒弟列表
 */
@interface FollowerCell : FmTableCell

@property(weak) UILabel* labelNo;
@property(weak) UILabel* labelMobile;
@property(weak) UILabel* labelDesc;
@property(weak) UILabel* labelScore;

-(void)config:(NSDictionary*)data index:(NSIndexPath*)index;

@end
