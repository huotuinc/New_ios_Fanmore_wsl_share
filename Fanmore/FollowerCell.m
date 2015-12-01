//
//  FollowerCell.m
//  Fanmore
//
//  Created by Cai Jiang on 7/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FollowerCell.h"

@implementation NSDictionary (Follower)

#ifdef FanmoreMockMaster
+(instancetype)mockFollower{
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    data[@"userId"] = $long(random());
    data[@"userName"] = @"18606509616";
    data[@"recentScore"] = $long(random()%10000);
    data[@"totalScore"] = $long(random()%10000);
    data[@"time"] = [[NSDate date] fmToString];
    return [NSDictionary dictionaryWithDictionary:data];
}
#endif

-(NSNumber*)getFollowerId{
    return self[@"userId"];
}

-(NSString*)getUsername{
    return self[@"userName"];
}

-(NSNumber*)getFollowerLastDevote{
    return self[@"recentScore"];
}
-(NSNumber*)getFollowerTotalDevote{
    return self[@"totalScore"];
}
-(NSDate*)getConnectDate{
    return [self[@"time"] fmToDate];
}

@end

@implementation FollowerCell

-(void)fminitialization{
    [super fminitialization];
    [self.layer setBorderWidth:0.5];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(7, 23, 35, 21)];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.labelNo = label;
    
    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(47, 9, 2, 50)];
    image.image = [UIImage imageNamed:@"shuxian"];
    [self addSubview:image];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(57, 9, 133, 14)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:13];
    [self addSubview:label];
    self.labelMobile = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(57, 23, 211, 21)];
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
    self.labelDesc = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(57, 45, 211, 14)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    [self addSubview:label];
    self.labelScore = label;

    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

-(void)config:(NSDictionary*)data index:(NSIndexPath*)index{
//    NSDateFormatter* formatter= $new(NSDateFormatter);
//    formatter.dateFormat = @"MM月dd日";
//    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    
    self.labelNo.text = $str(@"%d",index.row+1);
    self.labelMobile.text = [data getUsername];
    self.labelDesc.text = $str(@"%@成为了你的徒弟",[[data getConnectDate] fmStandStringDateOnly] );
    self.labelScore.text = $str(@"上次贡献：%@  总贡献：%@",[data getFollowerLastDevote],[data getFollowerTotalDevote]);
}

@end
