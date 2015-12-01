//
//  ScorePerDay.m
//  Fanmore
//
//  Created by Cai Jiang on 6/11/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ScorePerDay.h"

@implementation ScorePerDay

-(NSArray*)listComments{
    if (!$safe(self.comments)) {
        return nil;
    }
    return [self.comments componentsSeparatedByString:@"^"];
}

//-(NSDate*)getTime{
//    return [self[@"date"] fmToDate];
//}
//
//-(NSNumber*)getBrowse{
//    return self[@"browseAmount"];
//}
//
//-(NSNumber*)getScore{
//    return self[@"totalScore"];
//}
//
//-(NSString*)getComments{
//    return self[@"extra"];
//}

-(BOOL)isEqual:(id)other{
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    ScorePerDay* task = other;
    if (!task.time) {
        return NO;
    }
    return [task.time isEqualToDate:self.time];
}

- (NSUInteger)hash {
    if (!self.time) {
        return [super hash];
    }
    return [self.time hash];
//    NSUInteger hash = 0;
//    hash += [[self taskId] hash];
//    hash += [[self taskName] hash];
//    return hash;
}

@end
