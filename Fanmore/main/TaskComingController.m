//
//  TaskComingController.m
//  Fanmore
//
//  Created by Cai Jiang on 9/3/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "TaskComingController.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "ToSendTaskController.h"
#import "NotifyCell.h"
#import "RemoteMessageController.h"

@interface TaskComingController ()<UIWebViewDelegate>

//@property Task* saveTask;

@end

@implementation TaskComingController

static Task* TaskComingControllerStaticTask;

+(void)checkNotify:(UINavigationController*)nav data:(NSDictionary*)data{
    if (![data getNotifyType]) {
        return;
    }
    
    if ([[data getNotifyType] intValue]==0 || [[data getNotifyType] intValue]==2) {
        //检测任务状态
        [[[AppDelegate getInstance] getFanOperations] taskReleaseCheck:nil block:^(Task* taskId,int status, NSString *previewURL, NSError *error) {
            UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            if (status==0 || [[data getNotifyType] intValue]==2) {
                ToSendTaskController* rmc = [sb instantiateViewControllerWithIdentifier:@"ToSendTaskController"];
                TaskComingControllerStaticTask = taskId;
                rmc.task = taskId;
                [nav pushViewController:rmc animated:NO];
            }else if(status==1){
                TaskComingController* rmc = [sb instantiateViewControllerWithIdentifier:@"TaskComingController"];
                rmc.taskId = [data getNotifyTaskId];
                rmc.targetURL = previewURL;
                [nav pushViewController:rmc animated:NO];
            }else{
                [FMUtils alertMessage:[[nav.viewControllers lastObject] view] msg:@"这个任务已下架"];
            }
        } taskId:[data getNotifyTaskId]];
    }else if ([[data getNotifyType] intValue]==1){
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        RemoteMessageController* rmc = [sb instantiateViewControllerWithIdentifier:@"RemoteMessageController"];
        rmc.targetURL = [data getNotifyWebUrl];
        [nav pushViewController:rmc animated:NO];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//后退 这个动作 可能是到达其他ViewController 在发生活动时收到通知以来

//-(void)clickGetit{
//    __weak TaskComingController* wself = self;
//    //
//    [[[AppDelegate getInstance] getFanOperations] taskReleaseCheck:self block:^(Task *taskId, BOOL status, NSString *previewURL, NSError *error) {
//        if (status) {
//            ToSendTaskController* rmc = [wself.storyboard instantiateViewControllerWithIdentifier:@"ToSendTaskController"];
////            wself.saveTask = taskId;
//            rmc.task = taskId;
//            [wself.navigationController pushViewController:rmc animated:YES];
//        }else{
//            [FMUtils alertMessage:wself.view msg:@"再等等！"];
//        }
//    } taskId:self.taskId];
//}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    LOG(@"webnavigation %@",request);
    if ([[[request URL] absoluteString] isEqualToString:@"http://www.google.cn/"]) {
        
        Task* task = [[Task alloc] init];
        task.taskId = self.taskId;
        
        __weak TaskComingController* wself = self;
        
        [[[AppDelegate getInstance] getFanOperations] detailTask:nil block:^(NSArray *list, NSError *error) {
            ToSendTaskController* rmc = [wself.storyboard instantiateViewControllerWithIdentifier:@"ToSendTaskController"];
            rmc.task = task;
            [wself.navigationController pushViewController:rmc animated:NO];
        } task:task];
        
        return NO;
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.buttongGetit hidenme];
    self.web.delegate = self;
//    [self.buttongGetit addTarget:self action:@selector(clickGetit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
