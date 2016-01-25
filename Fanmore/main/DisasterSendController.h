//
//  DisasterSendController.h
//  Fanmore
//
//  Created by Cai Jiang on 7/17/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebController.h"
#import "Task.h"
#import "FMUtils.h"

@interface DisasterSendController : WebController

+(instancetype)pushController:(UIViewController<SendTask,ShareToolDelegate>*)controller task:(Task*)task;
- (IBAction)clickSend:(UIBarButtonItem *)sender;

@end
