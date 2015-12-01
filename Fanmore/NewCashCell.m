//
//  NewCashCell.m
//  Fanmore
//
//  Created by Cai Jiang on 12/19/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "NewCashCell.h"

@implementation NSDictionary (NewCashHistory)

-(NSNumber*)getNewCashHistoryId{
    return self[@"id"];
}
-(NSNumber*)getNewCashHistoryType{
    return self[@"type"];
}
-(NSNumber*)getNewCashHistoryAmount{
    return self[@"amount"];
}
-(NSDate*)getNewCashHistoryTime{
    return [self[@"time"] fmToDate];
}
-(NSString*)getNewCashHistoryDesc{
    return self[@"actionDes"];
}

@end

@implementation NewCashCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
