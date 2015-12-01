//
//  SendTask.h
//  Fanmore
//
//  Created by Cai Jiang on 4/4/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@protocol SendTask <NSObject>


/**
 *  更新按钮
 *
 *  @param button <#button description#>
 */
-(void)updateSendButton:(UIButton*)button;

-(void)setTask:(Task*)task;
-(Task*)getTask;
-(void)setTask2:(Task*)task2;
-(Task*)getTask2;
-(UIButton*)getButtonSend;
-(UIButton*)getButtonYiqiangwan;
-(UIButton*)getButtonYizhuanfa;

-(void)dosend2;

@end
