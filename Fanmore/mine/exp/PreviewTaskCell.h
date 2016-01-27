//
//  PreviewTaskCell.h
//  Fanmore
//
//  Created by Cai Jiang on 10/16/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "AbstracyTaskCell.h"
#import "Task.h"
#import "ItemCell.h"
#import "NotifyTaskView.h"

@interface PreviewTaskCell : AbstracyTaskCell

-(void)config:(Task*)task controller:(UIViewController<ItemsKnowlege,BuyItemHandler,TableReloadAble>*)controller;

@end
