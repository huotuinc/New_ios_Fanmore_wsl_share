//
//  BrowseTaskCell.m
//  Fanmore
//
//  Created by Cai Jiang on 6/17/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "BrowseTaskCell.h"

@interface BrowseTaskCell ()

@property(weak) UILabel* labelBrowseToday;
//@property(weak) UILabel* labelBrowseHistory;

@end

@implementation BrowseTaskCell

-(void)fminitialization{
    [super fminitialization];
    CGFloat y = [self addHeaderInfo];
    
    UILabel* label = nil;
    y = [self addSimpleInfoOneLine:y msg:@"今日浏览量：" p:&label];
    if ($safe(label)) {
        self.labelBrowseToday = label;
    }
//    
//    label = nil;
//    y = [self addSimpleInfoOneLine:y msg:@"历史浏览量：" p:&label];
//    if ($safe(label)) {
//        self.labelBrowseHistory = label;
//    }
    
    [self endWithSendInfoAndTime:y addRewards:NO sendInfo:YES];
    [self appendTuzhang:0];
}

-(void)configTask:(Task*)task{
    self.image.image = [self.class DefaultImage];
    
    [self.labelBrowseToday setText:[task.todayBrowseAmount stringValue]];
//    [self.labelBrowseHistory setText:[task.totalAmount stringValue]];
    
    [self updateHeaderInfo:task.taskInfo info:task.taskName];
    [self updateTime:task.publishTime andSendCount:task.sendCount];
    [self updateSendList:task.sendList];
    [self updateImage:task.taskSmallImgUrl];
    
    int status = [task.status intValue];
    if (status==4 | status==5 || status==6) {
        [self updateTuzhang:0 hidden:NO image:[UIImage imageNamed:@"task_over"]];
    }else{
        [self updateTuzhang:0 hidden:YES image:nil];
    }
    
}

@end
