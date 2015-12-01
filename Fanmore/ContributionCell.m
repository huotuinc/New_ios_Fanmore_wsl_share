//
//  ContributionCell.m
//  Fanmore
//
//  Created by Cai Jiang on 7/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ContributionCell.h"

@implementation NSDictionary (Contribution)

#ifdef FanmoreMockMaster
+(instancetype)mockContribution{
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    data[@"flowId"] = $long(random());
    data[@"pagetag"] = $str(@"%@",$long(random()));
    data[@"userName"] = @"18606509616";
    data[@"score"] = $long(random()%10000);
    data[@"totalScore"] = $long(random()%10000);
    data[@"time"] = [[NSDate date] fmToString];
    return [NSDictionary dictionaryWithDictionary:data];
}
#endif

-(NSNumber*)getFlowId{
    return self[@"flowId"];
}
//-(NSString*)getPageTag{
//    return self[@"pagetag"];
//}

-(NSString*)getUsername{
    return self[@"userName"];
}

-(NSNumber*)getLastDevote{
    return self[@"score"];
}
-(NSNumber*)getTotalDevote{
    return self[@"totalScore"];
}
-(NSDate*)getDevoteDate{
    return [self[@"time"] fmToDate];
}

@end

@implementation ContributionCell

-(void)config:(NSDictionary*)data{
    [self.labelToday setText:$str(@"%@积分",[data getLastDevote])];
    [self.labelUsername setText:[data getUsername]];
    [self.labelHistory setText:$str(@"%@积分",[data getTotalDevote])];
    [self.labelDate setText:[[data getDevoteDate] fmStandStringDateOnly]];
}

-(void)fminitialization{
    [super fminitialization];
    [self.layer setBorderWidth:0.5];
    
    // 10  18 26
    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(9+5, 5+5, 36, 38)];
    image.image = [UIImage imageNamed:@"smalltouxiang"];
    [self addSubview:image];
    
    // height 5+38+13  38+18  56  76
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(53+5, 6+5, 70, 21)];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    [label setText:@"贡献："];
    [self addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(125+5, 6+5, 90, 21)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:label];
    self.labelToday = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(217, 6+5, 91, 21)];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:label];
    self.labelUsername = label;
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(53+5, 27+5, 70, 21)];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    [label setText:@"历史贡献："];
    [self addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(125+5, 27+5, 90, 21)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:label];
    self.labelHistory = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(217, 27+5, 91, 21)];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:label];
    self.labelDate = label;
    
}

@end
