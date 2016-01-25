//
//  ToSendTaskController.h
//  Fanmore
//
//  Created by Cai Jiang on 1/23/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "SendTask.h"

@interface ToSendTaskController : UIViewController<SendTask>

@property(weak) Task* task;
/**
 *  在任务已上线以后隐藏按钮
 */
@property BOOL hideButtonOnline;

@property (weak, nonatomic) IBOutlet UIWebView *web;
- (IBAction)dosend:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btsend;
@property (weak, nonatomic) IBOutlet UIButton *btsendqiangwan;
@property (weak, nonatomic) IBOutlet UIButton *btsendyizhuanfa;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;
- (IBAction)clickRightButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet UILabel *labelAwardSend;
@property (weak, nonatomic) IBOutlet UILabel *labelAwardBrowse;
@property (weak, nonatomic) IBOutlet UILabel *labelExtraDes;

@end
