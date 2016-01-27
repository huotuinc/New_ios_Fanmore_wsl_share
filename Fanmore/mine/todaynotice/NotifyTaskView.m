//
//  NotifyTaskView.m
//  Fanmore
//
//  Created by Cai Jiang on 11/19/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "NotifyTaskView.h"
#import "BlocksKit+UIKit.h"
#import "FMUtils.h"

@implementation AppDelegate (UILocalNotifications)

//-(NSMutableArray*)localNotificationTasks{
//    NSMutableArray* list = self.preferences[@"localNotificationTasks"];
//    if (!$safe(list)) {
//        list = [NSMutableArray array];
//        self.preferences[@"localNotificationTasks"] = list;
//    }
//    return list;
//}

-(void)cancelLocalNotifacation:(Task *)task{
    for (UILocalNotification* nf in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSDictionary* info = nf.userInfo;
        if ($eql(info[@"type"],@"openTask") && $eql(info[@"aps"][@"customeItem"][@"taskId"],task.taskId)) {
            [[UIApplication sharedApplication] cancelLocalNotification:nf];
            return;
        }
    }
}

-(BOOL)registerLocalNotifacation:(Task*)task date:(NSDate*)date{
    
#ifdef FanmoreMockLocalDate
    NSLog(@"测试更改提醒时间至 10秒后");
    date = [NSDate dateWithTimeIntervalSinceNow:15];
#endif
    
    UILocalNotification* notification = [[UILocalNotification alloc] init];
    notification.fireDate = date;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = task.taskName;
    notification.alertAction = @"打开";
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;
    notification.userInfo = @{
                              @"type":@"openTask",
                              @"aps":@{
                                      @"alert":task.taskName,
                                      @"customeItem":@{
                                              @"type":@2,
                                              @"taskId":task.taskId
                                              }
                                      }
                              };    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    [[self localNotificationTasks] addObject:task.taskId];
//    [self savePreferences];
    
    return YES;
}

-(BOOL)hasRegisterLocalNotifacation:(Task *)task{
    for (UILocalNotification* nf in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSDictionary* info = nf.userInfo;
        if ($eql(info[@"type"],@"openTask") && $eql(info[@"aps"][@"customeItem"][@"taskId"],task.taskId)) {
            return YES;
        }
    }
    return NO;
}

@end

@interface NotifyTaskView ()

@property(weak) UIView* maskView;

@end

@implementation NotifyTaskView


-(void)dismiss{
    [self.maskView removeFromSuperview];
    [self removeFromSuperview];
}

-(NSDate*)targetDate:(UIViewController<ItemsKnowlege,BuyItemHandler,TableReloadAble> *)controller task:(Task *)task{
    
    int current =  0;
    
    for (NSDictionary* item in [controller returnMyItems]) {
        if ([item getAllItemType]==4) {
            [self.labelCurrent setText:$str(@"当前:%@",[item getMyItemAmount])];
            current = [[item getMyItemAmount] intValue];
        }
    }
    
    if (current>0 && [task.advancedseconds earlierDate:[NSDate date]]!=task.advancedseconds) {
        return task.advancedseconds;
    }else
        return task.publishTime;
}

-(void)show:(UIViewController<ItemsKnowlege,BuyItemHandler,TableReloadAble> *)controller task:(Task *)task{
    __weak NotifyTaskView* wself = self;
//    self.item = item;
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor colorWithHexString:@"000" alpha:0.7];
    [view bk_whenTapped:^{
        [wself dismiss];
    }];
    [controller.view addSubview:view];
    self.maskView = view;
    
    [controller.view addSubview:self];
    [self centerIn:CGSizeMake(320, 450) as:CGSizeMake(248, 240)];
    self.layer.cornerRadius = 10;
    
    int current =  0;
    
    for (NSDictionary* item in [controller returnMyItems]) {
        if ([item getAllItemType]==4) {
            [self.labelCurrent setText:$str(@"当前:%@",[item getMyItemAmount])];
            current = [[item getMyItemAmount] intValue];
        }
    }
    
    NSDictionary* selectedItem = nil;
    
    for (NSDictionary* item in [controller returnItems]) {
        if ([item getAllItemType]==4) {
            [self.labelStore setText:$str(@"可购:%@/%@",[item getAllItemStore],[item getAllItemStoreTotal])];
            selectedItem = item;
        }
    }
    
    if (current<1 || [task.advancedseconds timeIntervalSinceNow]>0) {
        [self.buttonHuoyan setEnabled:NO];
    }
    
    
    __weak UIViewController<ItemsKnowlege,BuyItemHandler,TableReloadAble> * wc = controller;
    [self.buttonBuy bk_whenTapped:^{
        [wc buyItem:selectedItem];
        [wself dismiss];
    }];
    
    [self.buttonHuoyan bk_whenTapped:^{
        AppDelegate* ad = [AppDelegate getInstance];
        if([ad registerLocalNotifacation:task date:task.advancedseconds]){
            [FMUtils alertMessage:wc.view msg:@"设置提醒成功。" block:^(){
                [wc reloadTable];
                [wself dismiss];
            }];
        }
    }];
    
    //设置提醒后在任务开始时向您的手机发出通知。（请在系统设置中允许小粉发起通知）
    
    NSDate* targetDate = [self targetDate:controller task:task];
    
    [self.labelDesc setText:$str(@"提醒将在%@时向您的手机发出通知。（请在系统设置中允许小粉发起通知）",[targetDate fmStandString])];
    
    [self.buttonNormal bk_whenTapped:^{
        AppDelegate* ad = [AppDelegate getInstance];
        
        if([ad registerLocalNotifacation:task date:[wself targetDate:wc task:task]]){
            [FMUtils alertMessage:wc.view msg:@"设置提醒成功。" block:^(){
                [wc reloadTable];
                [wself dismiss];
            }];
        }
    }];
    
}


@end
