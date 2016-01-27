//
//  NotifyTaskView.h
//  Fanmore
//
//  Created by Cai Jiang on 11/19/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemCell.h"
#import "Task.h"
#import "AppDelegate.h"

@protocol TableReloadAble <NSObject>

-(void)reloadTable;

@end

@interface NotifyTaskView : UIView

-(void)show:(UIViewController<ItemsKnowlege,BuyItemHandler,TableReloadAble>*)controller task:(Task*)task;

@property (weak, nonatomic) IBOutlet UIButton *buttonHuoyan;
@property (weak, nonatomic) IBOutlet UIButton *buttonNormal;

@property (weak, nonatomic) IBOutlet UILabel *labelCurrent;
@property (weak, nonatomic) IBOutlet UILabel *labelStore;
@property (weak, nonatomic) IBOutlet UIButton *buttonBuy;
@property (weak, nonatomic) IBOutlet UILabel *labelDesc;

@end



@interface AppDelegate (UILocalNotifications)

-(void)cancelLocalNotifacation:(Task*)task;
/**
 *  发布针对该任务的本地通知
 *
 *  @param task <#task description#>
 */
-(BOOL)registerLocalNotifacation:(Task*)task date:(NSDate*)date;

/**
 *  检查通知发布状态
 *
 *  @param task <#task description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)hasRegisterLocalNotifacation:(Task*)task;

@end