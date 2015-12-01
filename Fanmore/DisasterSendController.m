//
//  DisasterSendController.m
//  Fanmore
//
//  Created by Cai Jiang on 7/17/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "DisasterSendController.h"
#import "AppDelegate.h"

@interface DisasterSendController ()<SendTask,ShareToolDelegate>
@property(weak) Task* tasktosend;
@property(weak) UIViewController<SendTask,ShareToolDelegate>* caller;
@end

@implementation DisasterSendController

+(instancetype)pushController:(UIViewController<SendTask,ShareToolDelegate> *)controller task:(Task *)task{
    UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DisasterSendController* dc = [main instantiateViewControllerWithIdentifier:@"DisasterSendController"];
    [dc setTargetURL:[[[AppDelegate getInstance] loadingState] disasterUrl]];
    dc.tasktosend = task;
    dc.caller = controller;
    [controller.navigationController pushViewController:dc animated:YES];
    return dc;
}

- (IBAction)clickSend:(UIBarButtonItem *)sender {
    __weak DisasterSendController* wself = self;
    SuccessCallback block =^{
        UIPasteboard* paster = [UIPasteboard generalPasteboard];
        [paster setString:wself.tasktosend.taskInfo];
        [FMUtils alertMessage:wself.view msg:@"复制完成！"];
    };
    
    NSArray* sents = [self.tasktosend.sendList componentsSeparatedByString:@","];
    NSNumber* fmtype = [[AppDelegate getInstance] fromShareType:TShareTypeWeixiTimeline];
    if ([sents containsObject:$str(@"%@",fmtype)]) {
        //已转发 仅仅复制
        block();
    }else{
        [FMUtils submitSendResult:self task:self.tasktosend type:TShareTypeWeixiTimeline callback:block];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark 代理caller

-(void)updateSendButton:(UIButton *)button{
    [self.caller updateSendButton:button];
}

-(void)setTask:(Task*)task{
    [self.caller setTask:task];
}
-(Task*)getTask{
    return [self.caller getTask];
}
-(void)setTask2:(Task*)task2{
    [self.caller setTask2:task2];
}
-(Task*)getTask2{
    return [self.caller getTask2];
}
-(UIButton*)getButtonSend{
    return [self.caller getButtonSend];
}
-(UIButton*)getButtonYiqiangwan{
    return [self.caller getButtonYiqiangwan];
}
-(UIButton*)getButtonYizhuanfa{
    return [self.caller getButtonYizhuanfa];
}

-(void)dosend2{
    [self.caller dosend2];
}
-(BOOL)shouldShare:(ShareType)type{
    if ([self.caller respondsToSelector:@selector(shouldShare:)]) {
        return [self.caller shouldShare:type];
    }
    return YES;
}

@end
