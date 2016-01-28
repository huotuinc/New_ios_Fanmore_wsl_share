//
//  PreviewTaskCell.m
//  Fanmore
//
//  Created by Cai Jiang on 10/16/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "PreviewTaskCell.h"
#import "BlocksKit+UIKit.h"
#import "FMUtils.h"

@interface PreviewTaskCell ()

@property(weak) UILabel* labelOnlineTime;
@property(weak) UILabel* labelAbleSendTime;
@property(weak) UIButton* buttonHint;

@end

@implementation PreviewTaskCell

-(void)fminitialization{
    [super fminitialization];
    [self.layer setBorderWidth:3];
    CGFloat y = [self addHeaderInfo];
    y =  [self addScoreInfo:y];
    
    UIImageView* iimage = [[UIImageView alloc]initWithFrame:CGRectMake(-10, 110+y, 340, 2)];
    iimage.image = [UIImage imageNamed:@"cibg"];
    [self addSubview:iimage];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 113+y, 290, 20)];
    [label setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:label];
    self.labelOnlineTime = label;
 
    
    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(-10, 131+y, 340, 2)];
    iimage.image = [UIImage imageNamed:@"cibg"];
    [self addSubview:iimage];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 133+y, 290, 20)];
    [label setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:label];
    self.labelAbleSendTime = label;
    [self appendTuzhang:0];
    
    [self addHuodongInformation];
    [self addImageLeftTop];
}


-(void)config:(Task *)task controller:(UIViewController<ItemsKnowlege,BuyItemHandler,TableReloadAble>*)controller{
    [self.buttonHint removeFromSuperview];
    [self hideImageLeftTop];
    [self restoreForUnitTask];
    
    [self updateHuodongInformation:task];
    [self updateImage:task.taskSmallImgUrl];
    [self updateHeaderInfo:task.store.name info:task.taskName];
    [self updateScoreInfo:task.totalScore last:task.lastScore];
    
    // 正式上线时间 %@
    [self.labelOnlineTime setText:$str(@"正式上线时间 %@",[task.publishTime fmStandString])];
    
//    [self.labelAbleSendTime setText:$str(@"你可以在 %@ 提前转发",[task.advancedseconds fmStandString])];
    [self.labelAbleSendTime setText:@"拥有火眼金睛 可以提前转发"];
    self.labelAbleSendTime.hidden = YES;
    BOOL isSend = $safe(task.sendList) && task.sendList.length>0;
    if (isSend) {
        [self updateTuzhang:0 hidden:NO image:[UIImage imageNamed:@"task_send_tag"]];
    }else{
        [self updateTuzhang:0 hidden:YES image:nil];
    }
    
    if ([task isUnitedTask]) {
        [self adjustForUnitTask:task.awardBrowse];
    }
    
    int online = [task.online intValue];
    
    __weak UIViewController<ItemsKnowlege,BuyItemHandler,TableReloadAble>* wself = controller;
    if(online==2){
        [self updateImageLeftTop:[UIImage imageNamed:@"yishangxian"]];
    }else if(!isSend){
        //64 25
        AppDelegate* ad = [AppDelegate getInstance];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(240, 10, 64, 25)];
        //naoling
        if ([ad hasRegisterLocalNotifacation:task]) {
            [button setImage:[UIImage imageNamed:@"naoling-on"] forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage imageNamed:@"naoling"] forState:UIControlStateNormal];
        }
        __weak Task* wtask = task;
        
        [button bk_whenTapped:^{
            if (![ad hasRegisterLocalNotifacation:wtask]) {
//                [ad registerLocalNotifacation:wtask];
                if($safe([wself returnMyItems])){
                    NotifyTaskView* view = [[NSBundle mainBundle] loadNibNamed:@"NotifyTaskView" owner:nil options:nil][0];
                    [view show:wself task:wtask];
                } else{
                    [FMUtils alertMessage:wself.view msg:@"提醒功能初始化中……"];
                }
            }else{
                [ad cancelLocalNotifacation:wtask];
                [FMUtils alertMessage:wself.view msg:@"成功取消。" block:^(){
                    [button setImage:[UIImage imageNamed:@"naoling"] forState:UIControlStateNormal];
                }];
            }
        }];
        [self addSubview:button];
        self.buttonHint = button;
    }
//    else{
//        [self updateImageLeftTop:[UIImage imageNamed:@"yugao"]];
//    }
}

@end
