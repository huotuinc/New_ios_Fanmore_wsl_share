//
//  TaskListCell.h
//  Fanmore
//
//  Created by Cai Jiang on 6/18/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "AbstracyTaskCell.h"
#import "Task.h"

@interface TaskListCell : AbstracyTaskCell

-(void)configureTask:(Task*)task;

@end
