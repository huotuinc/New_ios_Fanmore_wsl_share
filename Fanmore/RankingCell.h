//
//  RankingCell.h
//  Fanmore
//
//  Created by Cai Jiang on 9/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FmTableCell.h"

#ifdef FanmoreDebug

@interface NSMutableDictionary (Ranking)

-(void)setupRankingValue:(NSString*)value names:(NSString*)names;

@end

#endif

@interface NSDictionary (Ranking)

/**
 *  <#Description#>
 *
 *  @return 积分/人数
 */
-(NSString*)getRankingValue;
/**
 *  第一个名字 必须有
 *
 *  @return <#return value description#>
 */
-(NSString*)getFirstRankingName;
/**
 *  其他名字
 *
 *  @return 如果没有其他名字就返回nil
 */
-(NSString*)getOtherRankingNames;

@end

@interface RankingCell : UITableViewCell

-(void)config:(NSUInteger)row myrank:(NSNumber*)myrank data:(NSDictionary*)data type:(uint)type;

@property (weak, nonatomic) IBOutlet UIImageView *imageBackground;
//@property (weak, nonatomic) IBOutlet UIImageView *imageTop;
@property (weak, nonatomic) IBOutlet UILabel *labelValue;
@property (weak, nonatomic) IBOutlet UILabel *labelUnit;
@property (weak, nonatomic) IBOutlet UILabel *labelNormalFirstOne;
@property (weak, nonatomic) IBOutlet UILabel *labelNormalOthers;
@property (weak, nonatomic) IBOutlet UILabel *labelOnlyOne;

@end
