//
//  TaskComingController.h
//  Fanmore
//
//  Created by Cai Jiang on 9/3/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "WebController.h"

@interface TaskComingController : WebController

@property NSNumber* taskId;
@property (weak, nonatomic) IBOutlet UIButton *buttongGetit;

/**
 *  这里将为你检查任务状态 并且给予你 任务详情或者是预告信息
 *
 *  @param nav  <#nav description#>
 *  @param data <#data description#>
 */
+(void)checkNotify:(UINavigationController*)nav data:(NSDictionary*)data;

@end
