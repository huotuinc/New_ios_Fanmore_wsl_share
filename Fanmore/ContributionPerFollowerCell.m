//
//  ContributionPerFollowerCell.m
//  Fanmore
//
//  Created by Cai Jiang on 7/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ContributionPerFollowerCell.h"

@implementation NSDictionary (ContributionPerFollower)

#ifdef FanmoreMockMaster
+(instancetype)mockContributionPerFollower{
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    data[@"flowId"] = $long(random());
    data[@"score"] = $long(random()%10000);
    data[@"time"] = [[NSDate date] fmToString];
    return [NSDictionary dictionaryWithDictionary:data];
}
#endif

-(NSNumber*)getID{
    return self[@"flowId"];
}
-(NSNumber*)getDevote{
    return self[@"score"];
}
-(NSDate*)getDevoteDate{
    return [self[@"time"] fmToDate];
}

@end

@interface ContributionPerFollowerCell ()

@property(weak) UILabel* labelScore;
@property(weak) UILabel* labelTime;

@end

@implementation ContributionPerFollowerCell

-(void)fminitialization{
    [super fminitialization];
    [self.layer setBorderWidth:0.5];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 9, 176, 21)];
    [self addSubview:label];
    label.textAlignment = NSTextAlignmentLeft;
    self.labelScore = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(204, 9, 96, 21)];
    label.textAlignment = NSTextAlignmentRight;
    [self addSubview:label];
    self.labelTime = label;
}


-(void)config:(NSDictionary*)data{
    [self.labelScore setText:$str(@"贡献：%@积分",[data getDevote])];
    [self.labelTime setText:[[data getDevoteDate] fmStandStringDateOnly]];
}

@end
