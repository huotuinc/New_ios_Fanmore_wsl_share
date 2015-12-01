//
//  MyTaskDetail.h
//  Fanmore
//
//  Created by Cai Jiang on 6/16/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreFlowSelection.h"
#import "ScoreFlow.h"
#import "ScoreFlowCell.h"

/**
 *  我的任务收益详情
 *  可以是具体某一天 如此的话应该显示2个tab
 *  或者不指定某天 则直接显示历史收益
 */
@interface MyTaskDetail : UIViewController<FlowSelected,UITableViewDataSource>

+(NSDate*)yesterDay;

@property NSDate* date;
@property NSNumber* taskid;

+(instancetype)pushTaskDetail:(NSNumber*)taskid date:(NSDate*)date on:(UIViewController*)controller;

@end
