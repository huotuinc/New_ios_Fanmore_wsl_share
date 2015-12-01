//
//  ContributionPerFollowerCell.h
//  Fanmore
//
//  Created by Cai Jiang on 7/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FmTableCell.h"

/**
 *  贡献
 */
@interface NSDictionary (ContributionPerFollower)

#ifdef FanmoreMockMaster
+(instancetype)mockContributionPerFollower;
#endif

-(NSNumber*)getID;
-(NSNumber*)getDevote;
-(NSDate*)getDevoteDate;

@end

/**
 *  指定弟子的贡献 用于师徒详情
 */
@interface ContributionPerFollowerCell : FmTableCell

-(void)config:(NSDictionary*)data;

@end
