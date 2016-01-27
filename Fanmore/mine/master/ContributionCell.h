//
//  ContributionCell.h
//  Fanmore
//
//  Created by Cai Jiang on 7/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FmTableCell.h"


/**
 *  贡献
 */
@interface NSDictionary (Contribution)

#ifdef FanmoreMockMaster
+(instancetype)mockContribution;
#endif

/**
 *  徒弟的id 错误 修改成流id
 *
 *  @return <#return value description#>
 */
-(NSNumber*)getFlowId;
/**
 *  用于分页
 *
 *  @return <#return value description#>
 */
//-(NSString*)getPageTag;

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
-(NSNumber*)getLastDevote;
-(NSNumber*)getTotalDevote;
-(NSDate*)getDevoteDate;

@end

/**
 *  贡献列表 用于师徒主页面
 */
@interface ContributionCell : FmTableCell

-(void)config:(NSDictionary*)data;

@property(weak) UILabel* labelToday;
@property(weak) UILabel* labelHistory;
@property(weak) UILabel* labelUsername;
@property(weak) UILabel* labelDate;

@end

