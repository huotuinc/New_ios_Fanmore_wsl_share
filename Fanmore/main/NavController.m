//
//  NavController.m
//  Fanmore
//
//  Created by Cai Jiang on 1/7/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "NavController.h"
#import "AppDelegate.h"
#import "NSDictionary+RemotePush.h"
#import "RemoteMessageController.h"
#import "TaskComingController.h"
#import "ToSendTaskController.h"

@interface NavController ()

@property Task* saveTask;

@end

@implementation NavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(void)handleRemoteNotification:(NSDictionary*)payload{
//    //didReceiveRemoteNotification in AppDelegate
//    //需要处理该通知 比如 直接打开某taskid 神马神马的
//    __weak NavController* wself = self;
//    if ([payload isRemotePushTaskPush]) {
//        
//        //检测任务状态
//        [[[AppDelegate getInstance] getFanOperations] taskReleaseCheck:nil block:^(Task* taskId,BOOL status, NSString *previewURL, NSError *error) {
//            if (status) {
//                ToSendTaskController* rmc = [wself.storyboard instantiateViewControllerWithIdentifier:@"ToSendTaskController"];
//                wself.saveTask = taskId;
//                rmc.task = taskId;
//                [wself pushViewController:rmc animated:NO];
//            }else{
//                TaskComingController* rmc = [wself.storyboard instantiateViewControllerWithIdentifier:@"TaskComingController"];
//                rmc.taskId = [payload getRemotePushTaskId];
//                rmc.targetURL = previewURL;
//                [wself pushViewController:rmc animated:NO];
//            }
//        } taskId:[payload getRemotePushTaskId]];
//    }else if ($safe([payload getRemotePushURL])){
//        RemoteMessageController* rmc = [self.storyboard instantiateViewControllerWithIdentifier:@"RemoteMessageController"];
//        rmc.targetURL = [payload getRemotePushURL];
//        [self pushViewController:rmc animated:NO];
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    LOG(@"NavController loaded!");
    
    NSDictionary* launchOptions = [AppDelegate getInstance].launchOptions;
    if (launchOptions && launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        NSDictionary* remoteNotifycationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        LOG(@"%@",remoteNotifycationPayload);
//        aps =     {
//	        alert = wwwwww;
//	        badge = 1;
//	        customItem =         {
//	            taskid = 0;
//	            type = 1;
//	            url = "http://www.baidu.com";
//	        };
//	        sound = default;
//	    };
        [TaskComingController checkNotify:self data:remoteNotifycationPayload[@"aps"][@"customItem"]];
//        [self handleRemoteNotification:remoteNotifycationPayload];
    }
    
    if (launchOptions && launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        UILocalNotification* notify =launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        LOG(@"%@",notify);
        if ($eql(notify.userInfo[@"type"],@"openTask")) {
            NSDictionary* info =notify.userInfo[@"aps"][@"customeItem"];
            [TaskComingController checkNotify:self data:info];
        }
    }
    
    //UIViewController* myid = [[self storyboard]instantiateViewControllerWithIdentifier:@"MyID"];
    
    //[self popToViewController:myid animated:YES];
    //[self pushViewController:myid animated:YES];
//    myid.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
//    
//    [self addChildViewController:myid];
//    [self.view addSubview:myid.view];
//    [myid didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
