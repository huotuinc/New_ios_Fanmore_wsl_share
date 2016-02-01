//
//  FMUtils.m
//  Fanmore
//
//  Created by Cai Jiang on 1/13/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FMUtils.h"
#import "BlocksKit+UIKit.h"
#import "Task.h"

#import "AppDelegate.h"
#import "LoginController.h"
#import "UIViewController+CWPopup.h"
#import "TaskListController.h"
#import "TaskDetailController.h"
#import "PooCodeView.h"
#import "WebController.h"
//#import "TPKeyboardAvoidingScrollView.h"
#import "ItemCell.h"

@implementation FMUtils

+(void)handWebController:(WebController*)web url:(NSString*)url controller:(UIViewController*)controller attach:(NSString*)attach{
    if ($safe(attach)) {
        url = $str(@"%@%@",url,attach);
    }
    [web viewWeb:url];
    [controller.navigationController pushViewController:web animated:YES];
}


+(void)toPolicyController:(UIViewController*)controller attach:(NSString*)attach{
    //PolicyController
    //RuleController
    UIStoryboard* mine = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
    WebController* wc = [mine instantiateViewControllerWithIdentifier:@"PolicyController"];
    NSString* url = [AppDelegate getInstance].loadingState.serviceUrl;
    [self handWebController:wc url:url controller:controller attach:attach];
}

+(void)toToolRuleController:(UIViewController*)controller attach:(NSString*)attach{
    UIStoryboard* mine = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
    WebController* wc = [mine instantiateViewControllerWithIdentifier:@"toolUrlController"];
    NSString* url = [AppDelegate getInstance].loadingState.toolUrl;
    [self handWebController:wc url:url controller:controller attach:attach];
}

+(void)toRuleController:(UIViewController*)controller attach:(NSString*)attach{
    UIStoryboard* mine = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
    WebController* wc = [mine instantiateViewControllerWithIdentifier:@"RuleController"];
    NSString* url = [AppDelegate getInstance].loadingState.ruleUrl;
    [self handWebController:wc url:url controller:controller attach:attach];
}


+(void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = dur;
    
    //animation.delegate = self;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [changeOutView.layer addAnimation:animation forKey:nil];
    
}

+(void)shareMyCash:(UIViewController*)controller{
    LoginState* ls = [AppDelegate getInstance].loadingState.userData;
    
    ShareMessage* sm = $new(ShareMessage);
    sm.title = ls.shareDes;
    sm.smdescription = ls.shareDes;
    sm.url = ls.shareContent;
    sm.thumbImage =  [UIImage imageNamed:@"logo"];
    sm.thumbImageURL = @"logo.png";
    
    __weak UIViewController* wc = controller;
    
    id<ISSShareActionSheet> actionSheetView = [ShareTool shareMessage:sm controller:wc sentList:nil delegate:nil handler:^(TShareType type, ShareResult result, id data) {
        if (result==ShareResultDone) {
            [FMUtils alertMessage:wc.view msg:@"分享成功！" block:^{
                [FMUtils shareMyCash:wc];
            }];
        }
    }];
    if (!$safe(actionSheetView)) {
        return;
    }
    __weak UIView* view = (UIView*)actionSheetView;
    __block CGFloat oy=0;
    __block CGFloat ox=0;
    __block CGFloat cornerRadius,shadowRadius;
    __block UIView* firstView;
    UILabel* titleLabel = [[UILabel alloc]init];
    
    __weak UILabel* wTitleLabel = titleLabel;
    //    void(^removeTitle)() = ^() {
    //        [wTitleLabel removeFromSuperview];
    //    };
    
    void(^checkUIView)(UIView* v) = ^(UIView* v) {
        if (firstView==nil) {
            firstView = v;
        }
        if (v.userInteractionEnabled) {
            //            [v bk]
            //            [v bk_whenTapped:removeTitle];
        }
        
        if (v.frame.origin.y>0 && oy==0) {
            oy = v.frame.origin.y;
        }
        if (v.frame.origin.x>0 && ox==0) {
            //            toView = v;
            ox = v.frame.origin.x;
            LOG(@"%@ %f %f",v,v.layer.cornerRadius,v.layer.shadowRadius);
            cornerRadius =v.layer.cornerRadius;
            shadowRadius =v.layer.shadowRadius;
        }
    };
    for (UIView* sub in view.subviews) {
        checkUIView(sub);
        for (UIView* s in sub.subviews) {
            checkUIView(s);
            for (UIView* s1 in s.subviews) {
                checkUIView(s1);
            }
        }
    }
    UIWebView* webView = [[UIWebView alloc] initWithFrame:firstView.frame];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:sm.url]]];
    
    [view addSubview:webView];
    [titleLabel setFrame:CGRectMake(ox , oy-45.0f , 320.0f-2.0f*ox, 40)];
    //    [titleLabel setFrame:CGRectMake(0 , -45.0f , 320.0f-2.0f*ox, 40)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.layer.cornerRadius = cornerRadius;
    titleLabel.layer.shadowRadius = shadowRadius;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.text = @"告诉小伙伴们你提现了！";
    [view addSubview:wTitleLabel];
    [FMUtils exChangeOut:titleLabel dur:0.5f];
    
    [view bringSubviewToFront:firstView];
    //    [UIView animateWithDuration:0.5f animations:^{
    //        [view addSubview:wTitleLabel];
    //    }];
    
}




+(CashResultTye)tryCash{
    
    LoadingState* ls = [AppDelegate getInstance].loadingState;
#ifndef FanmoreDebug
    if ([ls.userData.score intValue]<[ls.changeBoundary intValue]){
//        [FMUtils alertMessage:self.view msg:$str(@"最少%@积分才可以提现哦，亲！",ls.changeBoundary)];
        return CashResultNotEnoughScore;
    }
#endif
    
    if (![ls hasBindMobile]) {
//        [FMUtils alertMessage:self.view msg:@"请先绑定手机号码。" block:^{
//            wself.doCash =YES;
//            wself.doCash2 = NO;
//            [wself performSegueWithIdentifier:@"ToMobile" sender:wself.view];
//        }];
        return CashResultMobile;
    }
    if (![ls hasBindALP]) {
//        [FMUtils alertMessage:self.view msg:@"请先绑定支付宝账号。" block:^{
//            wself.doCash =YES;
//            wself.doCash2 = NO;
//            [wself performSegueWithIdentifier:@"ToALP" sender:wself.view];
//        }];
        return CashResultALP;
    }
    
    if (![ls hasSetCashPSWD]) {
//        [FMUtils alertMessage:self.view msg:@"请先设置提现密码。" block:^{
//            wself.doCash =YES;
//            wself.doCash2 = NO;
//            [wself performSegueWithIdentifier:@"ToCashPswd" sender:wself.view];
//        }];
        return CashResultPassword;
    }
#ifdef FanmoreDebug
    //debugCashPswdDoing
//    if (!self.debugCashPswdDoing) {
//        self.debugCashPswdDoing = YES;
//        [FMUtils alertMessage:self.view msg:@"请先设置提现密码。" block:^{
//            wself.doCash =YES;
//            wself.doCash2 = NO;
//            [wself performSegueWithIdentifier:@"ToCashPswd" sender:wself.view];
//        }];
//        return NO;
//    }
#endif
    return CashResultOK;
}

+(NSInteger)sectionsByTaskTime:(NSArray*)tasks timeGetter:(NSString* (^)(id input))timeGetter{
    //publishTime
    if (tasks.count==0) {
        return 1;
    }
    NSInteger rs = 1;
    NSString* date = timeGetter([tasks $first]);
    for (id task in tasks) {
        NSString* s = timeGetter(task);
        if (!$eql(s,date)) {
            rs++;
            date = s;
        }
    }
    return rs;
}
+(NSInteger)rowsBy:(NSArray*)tasks section:(NSInteger)section  timeGetter:(NSString* (^)(id input))timeGetter{
    if (tasks.count==0) {
        return 0;
    }
    NSString* date = timeGetter([tasks $first]);
    NSInteger nowSection=0;
    NSInteger nowRows=0;
    for (id task in tasks) {
        NSString* s = timeGetter(task);
        if (!$eql(s,date)) {
            //
            if (nowSection==section) {
                return nowRows;
            }
            nowSection++;
            date = s;
            nowRows=1;
        }else{
            nowRows++;
        }
    }
    if (nowSection==section) {
        return nowRows;
    }
    return NSNotFound;
}

+(id)dataBy:(NSArray*)tasks section:(NSInteger)section andRow:(NSInteger)row timeGetter:(NSString* (^)(id input))timeGetter{
    NSString* date = timeGetter([tasks $first]);
    NSInteger nowSection=0;
    NSInteger nowRows=-1;
    for (id task in tasks) {
        NSString* s = timeGetter(task);
        if (!$eql(s,date)) {
            nowSection++;
            date = s;
            nowRows=0;
        }else{
            nowRows++;
        }
        if (nowSection==section && nowRows==row) {
            return task;
        }
    }
    return Nil;
}


+(NSInteger)sectionsByTaskTime:(NSArray*)tasks{
    //publishTime    
    if (tasks.count==0) {
        return 1;
    }
    NSInteger rs = 1;
    NSString* date = [[[tasks $first] publishTime]fmStandStringDateOnly];
    for (Task* task in tasks) {
        NSString* s = [task.publishTime fmStandStringDateOnly];
        if (!$eql(s,date)) {
            rs++;
            date = s;
        }
    }
    return rs;
}
+(NSInteger)rowsBy:(NSArray*)tasks section:(NSInteger)section{
    if (tasks.count==0) {
        return 0;
    }
    NSString* date = [[[tasks $first] publishTime]fmStandStringDateOnly];
    NSInteger nowSection=0;
    NSInteger nowRows=0;
    for (Task* task in tasks) {
        NSString* s = [task.publishTime fmStandStringDateOnly];
        if (!$eql(s,date)) {
            //
            if (nowSection==section) {
                return nowRows;
            }
            nowSection++;
            date = s;
            nowRows=1;
        }else{
            nowRows++;
        }
    }
    if (nowSection==section) {
        return nowRows;
    }
    return NSNotFound;
}

+(id)dataBy:(NSArray*)tasks section:(NSInteger)section andRow:(NSInteger)row{
    NSString* date = [[[tasks $first] publishTime]fmStandStringDateOnly];
    NSInteger nowSection=0;
    NSInteger nowRows=-1;
    for (Task* task in tasks) {
        NSString* s = [task.publishTime fmStandStringDateOnly];
        if (!$eql(s,date)) {
            nowSection++;
            date = s;
            nowRows=0;
        }else{
            nowRows++;
        }
        if (nowSection==section && nowRows==row) {
            return task;
        }
    }
    return Nil;
}
+(void)sendTask:(UIViewController<SendTask,ShareToolDelegate>*)controller{
    
    AppDelegate* ad = [AppDelegate getInstance];
    if (![ad hasSwitchUser]) {
        [FMUtils _sendTask:controller];
        return;
    }
    
    __weak UIViewController<SendTask,ShareToolDelegate>* wself = controller;
    
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:controller.view];
    [controller.view addSubview:HUD];
    //    HUD.labelText = msg;
    HUD.dimBackground = YES;
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.labelText = @"一个小问题@-@";
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
//    view.backgroundColor = [UIColor redColor];
    
    int int1,int2;
    
    while(true){
        int1 = random()%100;
        int2 = random()%100;
        if (int1 <10 || int2<10) {
            break;
        }
    }
    int answer = int1+int2;
    
    PooCodeView* pcv = [[PooCodeView alloc] initWithFrame:CGRectMake(0, 0, 140, 40)];
    [pcv changeString:$str(@"%d+%d=",int1,int2)];
    
    [view addSubview:pcv];
    
    UITextField* text = [[UITextField alloc] initWithFrame:CGRectMake(145, 0, 55, 40)];
    __weak UITextField* wtext = text;
    __weak MBProgressHUD* wHUD = HUD;
    
    text.backgroundColor = [UIColor lightGrayColor];
    text.returnKeyType =UIReturnKeyDone;
    text.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [text bk_addEventHandler:^(id sender) {
//        NSLog(@"%@ done?",sender);
        if (answer==[wtext.text intValue]) {
            [ad resetSwitchUserState];
            [FMUtils _sendTask:wself];
        }
        [wHUD hide:YES];
    } forControlEvents:UIControlEventEditingDidEndOnExit];
    [view addSubview:text];
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, 180, 30)];
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:@"答好了" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view addSubview:button];
    
    
    [button bk_whenTapped:^{
        [wtext resignFirstResponder];
        if (answer==[wtext.text intValue]) {
            [ad resetSwitchUserState];
            [FMUtils _sendTask:wself];
        }
        [wHUD hide:YES];
    }];
    
    HUD.customView = view;
    
    [HUD show:YES];
    [text becomeFirstResponder];
}

+(void)_sendTask:(UIViewController<SendTask,ShareToolDelegate>*)controller{
    [self _sendTask:controller ignore4:NO ignore3:NO];
}

+(void)_sendTask:(UIViewController<SendTask,ShareToolDelegate>*)controller ignore4:(BOOL)ignore4 ignore3:(BOOL)ignore3{
    
    __weak AppDelegate* ad = [AppDelegate getInstance];
    __weak UIViewController<SendTask,ShareToolDelegate>* wself = controller;
    if (![ad.loadingState hasLogined]) {
        LoginController* ac  = [[LoginController alloc] initWithNibName:@"LoginController" bundle:[NSBundle mainBundle]];
        __weak LoginController* wac = ac;
        //        NSNumber* taskid = wself.task.taskId;
        Task* t =$new(Task);
        [wself setTask2:t];
        t.taskId = [wself getTask].taskId;
        ac.callbacks =  [UICallbacks callback:^(id x) {
            for (id x in wself.navigationController.viewControllers) {
                if ([x isKindOfClass:[TaskListController class]]) {
                    //                    [x addObserver:wself forKeyPath:@"tasks" options:NSKeyValueObservingOptionNew context:(__bridge void *)(taskid)];
                    [x clickRefresh:nil];
                    break;
                }
            }
            
            [[ad getFanOperations] detailTask:nil block:^(NSArray *naa, NSError *error) {
                [wself dosend2];
                for (id x in wself.navigationController.viewControllers) {
                    if ([x isKindOfClass:[TaskDetailController class]]) {
                        TaskDetailController* tdc = x;
                        tdc.task = [wself getTask2];
                    }
                }
            } task:[wself getTask2]];
            //            [wself dosend2];
        } cancelled:^{
        } dismiss:^{
            if ($safe(wac) && $safe(wac.parentViewController)) {
                [wac removeFromParentViewController];
                [wself dismissPopupViewControllerAnimated:YES completion:NULL];
            }
            return YES;
        }];
        [wself addChildViewController:ac];
        [wself fmpresentPopupViewController:ac animated:YES completion:NULL];
        return;
    }
    
    Task* tosend = [wself getTask];
    if (!$safe(tosend) && $safe([wself getTask2])) {
        tosend = [wself getTask2];
    }
    
//    if (![tosend nolimitToSend] && [tosend.lastScore intValue]>0) {
//        if ([ad.loadingState.userData.completeTaskCount intValue] >= [ad.loadingState.userData.totalTaskCount intValue] && (tosend.sendList==nil || tosend.sendList.length==0)) {
//            [FMUtils alertMessage:wself.view msg:@"今日转发已达上限。"];
//            return;
//        }
//    }
    // 移至下面远程判断
    
    if ([ad allShareTypeSent:tosend.sendList]){
        [FMUtils alertMessage:wself.view msg:@"亲，您已经转发过了"];
        return;
    }
    
    if ((!$safe(tosend.sendList) || tosend.sendList.length==0)
        && [tosend.lastScore floatValue]>0
        && ![tosend isFlashMall]
        && ![tosend isUnitedTask]
        ) {
        //有剩余积分 且不是闪购类型
        NSTimeInterval time = [ad ableToShare];
        if (time>0) {
//            NSArray* errorMsg = @[
//                                  @"休息一下,%@后再来分享吧!~",
//                                  @"啊!~卡壳了,没%@恢复不过来。。。",
//                                  @"罢工,罢工,再罢%@",
//                                  @"来,来,课间休息,跟我一起做，伸展运动,1234,2234……; 还有%@",
//                                  @"嘘!小粉出去溜弯了,%@后回来",
//                                  ];
            [FMUtils alertMessage:wself.view msg:$str(@"需要间隔%@才能转发下一个，请再等待%@",[ad.loadingState.taskTimeLag timeLag],[$double(time) timeLag])];
            return;
        }
    }
    
    // 调用新接口 去检查状态！
    [[[AppDelegate getInstance] getFanOperations] advanceForward:nil block:^(NSDictionary *data, NSError *error) {
        if ($safe(error)) {
            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            return;
        }
//        taskType	0不可转发;1提前转发;2正常转发
//        forwardLimit	是否达到转发次数上限：0未;1已达到
//        advanceTool	提前转发道具0无;1有
//        advanceUseTip	提前转发道具使用提示
//        advanceBuyTip	提前转发道具购买提示
//        addOneTool	+1道具0无;1有
//        addOneUseTip	+1道具使用提示
//        addOneBuyTip	＋1道具购买提示
        NSNumber* taskType = data[@"taskType"];
//        taskType = @1;
        switch ([taskType intValue]) {
            case 0:
                // 这里不再是转发 而是购买火眼金睛
//                [FMUtils alertMessage:wself.view msg:@"这个任务现在还无法转发。"];
            {
                // 这里 检测道具 如果有 则提示无法转发 如果没有 就提示是否购买
                [[[AppDelegate getInstance] getFanOperations] itemList:nil block:^(NSArray *items, NSArray *myItems, NSError *error) {
                    if ($safe(error)) {
                        [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                        return;
                    }
                    int amount = 0;
                    for (NSDictionary* it in myItems) {
                        if ([it getAllItemType]==4) {
                            amount = [[it getMyItemAmount] intValue];
                            break;
                        }
                    }
                    if (amount>0) {
                        // 亲，到{时间}才可以使用火眼金睛提前转发该任务
                        if ($safe(tosend.advancedseconds)) {
                            [FMUtils alertMessage:wself.view msg:$str(@"亲，到%@才可以使用火眼金睛提前转发该任务",[tosend.advancedseconds fmStandString])];
                        }else
                            [FMUtils alertMessage:wself.view msg:@"这个任务现在还无法转发。"];
                    }else{
                        [UIAlertView bk_showAlertViewWithTitle:@"购买道具" message:data[@"advanceBuyTip"] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            //如果购买 则要完成 购买指定道具 并且返回结果 成功 失败 失败原因 成功的话 则继续提交转发请求！
                            if (buttonIndex==1) {
                                [[[AppDelegate getInstance] getFanOperations] buyItem:nil block:^(NSArray *items, NSArray *myItems, NSError *error) {
                                    if ($safe(error)) {
                                        [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                                        return;
                                    }
                                    [FMUtils alertMessage:wself.view msg:@"购买成功"];
                                    //                            [FMUtils _sendTask:wself ignore4:ignore4 ignore3:ignore3];
                                } type:4];
                            }
                        }];
                    }
                }];
                return;
                break;
            }
            case 1:
                //提前
            {
                NSNumber* advanceTool = data[@"advanceTool"];
//                advanceTool = @0;
                if ([advanceTool intValue]==0) {
                    //没道具
                    [UIAlertView bk_showAlertViewWithTitle:@"购买道具" message:data[@"advanceBuyTip"] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        //如果购买 则要完成 购买指定道具 并且返回结果 成功 失败 失败原因 成功的话 则继续提交转发请求！
                        if (buttonIndex==1) {
                            [[[AppDelegate getInstance] getFanOperations] buyItem:nil block:^(NSArray *items, NSArray *myItems, NSError *error) {
                                if ($safe(error)) {
                                    [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                                    return;
                                }
                                [FMUtils _sendTask:wself ignore4:ignore4 ignore3:ignore3];
                            } type:4];
                        }
                    }];
                    return;
                }else if(!ignore4){
                    [UIAlertView bk_showAlertViewWithTitle:@"使用道具" message:data[@"advanceUseTip"] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex==1) {
                            [FMUtils _sendTask:wself ignore4:YES ignore3:ignore3];
                        }
                    }];
                    return;
                }
                break;
            }
        }
        
        NSNumber* forwardLimit = data[@"forwardLimit"];
        
        if ([forwardLimit intValue]==1) {
            NSNumber* addOneTool = data[@"addOneTool"];
            if ([addOneTool intValue]==0) {
                //没有道具
                [UIAlertView bk_showAlertViewWithTitle:@"购买道具" message:data[@"addOneBuyTip"] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    //如果购买 则要完成 购买指定道具 并且返回结果 成功 失败 失败原因 成功的话 则继续提交转发请求！
                    if (buttonIndex==1) {
                        [[[AppDelegate getInstance] getFanOperations] buyItem:nil block:^(NSArray *items, NSArray *myItems, NSError *error) {
                            if ($safe(error)) {
                                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                                return;
                            }
                            [FMUtils _sendTask:wself ignore4:ignore4 ignore3:ignore3];
                        } type:3];
                    }
                }];
                return;
            }else if(!ignore3){
                [UIAlertView bk_showAlertViewWithTitle:@"使用道具" message:data[@"addOneUseTip"] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex==1) {
                        [FMUtils _sendTask:wself ignore4:ignore4 ignore3:YES];
                    }
                }];
                return;
            }
        }
        
        [tosend checkLargeImg:^(UIImage *image) {
            ShareMessage* message = [tosend toShare:image];
            [ShareTool shareMessage:message controller:wself sentList:tosend.sendList delegate:wself handler:^(TShareType type, ShareResult result, id data) {
                if (result==ShareResultDone) {
                    [FMUtils submitSendResult:wself task:tosend type:type callback:NULL];
                }
            }];
        }];
        
    } taskId:tosend.taskId];
}

+(void)submitSendResult:(UIViewController<SendTask,ShareToolDelegate>*)controller task:(Task*)task type:(TShareType)type callback:(SuccessCallback)callback{
    AppDelegate* ad = [AppDelegate getInstance];
    __weak UIViewController<SendTask,ShareToolDelegate>* wself = controller;
    [[ad getFanOperations] turnTask:nil block:^(NSString *rs, NSError *error) {
        if ($safe(error)) {
            [FMUtils alertMessage:wself.view msg:[error FMDescription ]];
            [FMUtils submitSendResult:controller task:task type:type callback:callback];
            return;
        }
        //修改状态
        //闪购无需修改状态
        if (![task isFlashMall]) {
//            [FMUtils sendButtonsToggle:[wself getButtonSend] qiangwan:[wself getButtonYiqiangwan] yizhuanfa:[wself getButtonYizhuanfa] task:task sent:[ad allShareTypeSent:task.sendList]];
            [FMUtils sendButtonsToggle:controller task:task sent:[ad allShareTypeSent:task.sendList] hideAfterOnline:NO];
        }
        //设置最后转发标记
        if ([task.sendList rangeOfString:@","].location==NSNotFound && ![task nolimitToSend] && [task.lastScore floatValue]>0) {
            [ad storeShareTime];
        }
        
        if(callback!=NULL){
            callback();
        }else{
            [FMUtils alertMessage:wself.view msg:$safe(rs)&&rs.length>3?rs:@"转发成功！"];
        }
        
    } task:task type:type];

}

+(void)favIconToogle:(UIImageView*)view fav:(BOOL)fav{
    if (fav) {
        view.image = [UIImage imageNamed:@"shangchangicon_down"];
    }else{
        view.image = [UIImage imageNamed:@"shangchangicon"];
    }
}

+(void)sendButtonsToggle:(UIViewController<SendTask>*)controller task:(Task *)task sent:(BOOL)sent hideAfterOnline:(BOOL)hideAfterOnline{
    CGRect buttonRect = [controller getButtonSend].frame;
    
    [[controller getButtonSend] removeFromSuperview];
    
    if ([task notbeAbletoSend]) {
        return;
    }
    
    // 什么都不显示的 情况
    // 1 已上线的隐藏
    if ($safe(task.online) && hideAfterOnline && [task.online intValue]==2) {
        return;
    }

    // 更新 无论如何都显示火眼金睛
//    if ($safe(task.advancedseconds)) {
//        if ([task.advancedseconds earlierDate:[NSDate date]]!=task.advancedseconds) {
//            return;
//        }
//    }
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:buttonRect];
    
    
    // 无偿转发 wuchangzhuanfa
    // 已转发  zhuanfabutton_down
    // 立即转发  zhuanfabutton
    // 火眼金睛 goumaihuoyan
    // 再来一发 红底白字
    
    // 判断应该出现哪个按钮
    
    // 已转发 则显示 已转发
    if (sent) {
        [button setImage:[UIImage imageNamed:@"zhuanfabutton_down"] forState:UIControlStateNormal];
        [button setEnabled:NO];
        [controller updateSendButton:button];
        return;
    }

    // 积分已耗尽 则显示 无偿转发
    if (
        [[task lastScore] floatValue]<=0
        || ([task isUnitedTask] && [task.status intValue]==8 ) ) {
        [button setImage:[UIImage imageNamed:@"wuchangzhuanfa"] forState:UIControlStateNormal];
        [controller updateSendButton:button];
        return;
    }
    
    
    // 接下来又远程判断 是否应该显示 火眼金睛 或者 再来一发 ！ 亦或者立即转发
    // 调用新接口 去检查状态！
    __weak UIViewController<SendTask>* wc = controller;
    [[[AppDelegate getInstance] getFanOperations] advanceForward:nil block:^(NSDictionary *data, NSError *error) {
        if ($safe(error)) {
//            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            [FMUtils sendButtonsToggle:wc task:task sent:sent hideAfterOnline:hideAfterOnline];
            return;
        }
        //        taskType	0不可转发;1提前转发;2正常转发
        //        forwardLimit	是否达到转发次数上限：0未;1已达到
        //        advanceTool	提前转发道具0无;1有
        //        advanceUseTip	提前转发道具使用提示
        //        advanceBuyTip	提前转发道具购买提示
        //        addOneTool	+1道具0无;1有
        //        addOneUseTip	+1道具使用提示
        //        addOneBuyTip	＋1道具购买提示
        NSNumber* taskType = data[@"taskType"];
        //        taskType = @1;
        switch ([taskType intValue]) {
            case 0:
                // 即使时间未到 也显示火眼金睛
////                [FMUtils alertMessage:wself.view msg:@"这个任务现在还无法转发。"];
//                return;
            case 1:
                //提前
            {
//                NSNumber* advanceTool = data[@"advanceTool"];
                // 为 0 表示没有该道具
                [button setImage:[UIImage imageNamed:@"goumaihuoyan"] forState:UIControlStateNormal];
                [wc updateSendButton:button];
                return;
            }
        }
        
        NSNumber* forwardLimit = data[@"forwardLimit"];
        
        if ([forwardLimit intValue]==1) {
//            NSNumber* addOneTool = data[@"addOneTool"];
            // 为 0 表示没有道具
//            [button setBackgroundColor:[UIColor redColor]];
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [button setTitle:@"再来一发" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"zailaiyifaa"] forState:UIControlStateNormal];            
            [wc updateSendButton:button];
            return;
        }
        
        [button setImage:[UIImage imageNamed:@"zhuanfabutton"] forState:UIControlStateNormal];
        [wc updateSendButton:button];
        return;
        
        
    } taskId:task.taskId];
    
}

+(void)sendButtonsToggle:(UIButton*)button qiangwan:(UIButton*)qiangwan yizhuanfa:(UIButton*)yizhuanfa task:(Task*)task sent:(BOOL)sent{
    button.hidden = YES;
    qiangwan.hidden = YES;
    yizhuanfa.hidden = YES;
    if (![task notbeAbletoSend]) {
        if (sent) {
            yizhuanfa.hidden = NO;
        }else if ([task.lastScore floatValue]<=0){
            qiangwan.hidden = NO;
        }else{
            button.hidden = NO;
        }
    }
}



//+(void)sendButtonToggle:(UIButton*)button task:(Task*)task{
//    if (!button.enabled) {
////        [button setTitle:@"已转发" forState:UIControlStateDisabled];
//    }else{
//        if ([task.lastScore intValue]<=0) {
////            [button setTitle:@"已抢完" forState:UIControlStateDisabled];
////            button.enabled = NO;
////            button.titleLabel.text = @"已抢完";
//            button.highlighted = YES;
//        }
//    }
//}
//+(void)sendButtonToggle:(UIButton*)button sent:(BOOL)sent{
//    if(sent){
////        button.imageView.image = [UIImage imageNamed:@"zhuanfabutton_down"];
////        button.imageView.image = nil;
////        [button setBackgroundColor:[UIColor darkGrayColor]];
////        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
////        button.titleLabel.text = @"已转发";
//        LOG(@"set zhuanfa state to down");
//        button.enabled = NO;
//    }else{
////        button.imageView.image = [UIImage imageNamed:@"zhuanfabutton"];
//        LOG(@"set zhuanfa state to up");
////        [button setBackgroundColor:[UIColor clearColor]];
////        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
////        button.titleLabel.text = @"";
//        button.enabled = YES;
//    }
//}


+(void)afterLogin:(SEL)after invoker:(UIViewController<RefreshStatusAble>*)invoker{
    __weak UIViewController<RefreshStatusAble>* wself = invoker;
    //载入登录界面！！！
    
    LoginController* ac  = [[LoginController alloc] initWithNibName:@"LoginController" bundle:[NSBundle mainBundle]];
    __weak LoginController* wac = ac;
    ac.callbacks = [UICallbacks callback:^(id input) {
        LOG(@"login done");
        [wself refreshStatus];
        SuppressPerformSelectorLeakWarning(
                                           [wself performSelector:after]
                                           );
        //            [wself clickAccount];
    } cancelled:NULL dismissbk:^(CB_Done done) {
        LOG(@"login dismiss 1");
        if ([wself respondsToSelector:@selector(beforeDismissLoginFrame)]) {
            [wself beforeDismissLoginFrame];
        }
        
        if ($safe(wac) && $safe(wac.parentViewController)) {
            [wac removeFromParentViewController];
            [wself dismissPopupViewControllerAnimated:YES completion:^{
                LOG(@"login dismiss 2");
                done(nil);
            }];
        }
    }];
    [wself addChildViewController:ac];
    [wself fmpresentPopupViewController:ac animated:YES completion:NULL];
}


+(CGPoint)pointToRightTop:(UILabel*)label{
    CGSize sz = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, 40)];
    CGSize linesSz = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    if(sz.width <= linesSz.width) //判断是否折行
    {
        return CGPointMake(label.frame.origin.x + sz.width, label.frame.origin.y);
    }else{
        return CGPointMake(label.frame.origin.x + (int)sz.width % (int)linesSz.width,linesSz.height - sz.height);
    }
}

+(void)__dynamicIncreaseLabel:(UILabel*)label from:(NSNumber*)from to:(NSNumber*)to faceDuration:(NSTimeInterval)faceDuration count:(uint)count current:(uint)current random:(BOOL)r formatter:(NSNumberFormatter*)formatter{
    
//    LOG(@"%d",current);s
    if (current++>=count){
        if ($safe(formatter)) {
            label.text = [formatter stringFromNumber:to];
        }else{
            label.text = [to stringValue];
        }
        return;
    }
//    NSDate* sdate = [NSDate date];
    [UIView animateWithDuration:0 animations:^{
        NSNumber* startn;
        if (r) {
            int x = [to intValue]+(random()%2==0?1:-1)*(random()%[to intValue]);
            startn = $int(x);
        }else{
            uint xv = ([to longValue]-[from longValue])*current/count;
            startn = $int(xv);
        }
        if ($safe(formatter)) {
            label.text = [formatter stringFromNumber:startn];
        }else{
            label.text = [startn stringValue];
        }
    } completion:^(BOOL finished) {
        //先等一会儿！
        if (finished) {
            //扣除已过去的时间
//            LOG(@"%f",[[NSDate date]timeIntervalSinceDate:sdate]);
            [self bk_performBlock:^{
                [self __dynamicIncreaseLabel:label from:from to:to faceDuration:faceDuration count:count current:current random:r formatter:formatter];
                } afterDelay:faceDuration*0.8];
        }
    }];
}

+(void)dynamicIncreaseLabel:(UILabel*)label from:(NSNumber*)from to:(NSNumber*)to duration:(NSTimeInterval)duration{
    [self dynamicIncreaseLabel:label from:from to:to duration:duration formatter:Nil random:NO];
}

+(void)dynamicIncreaseLabel:(UILabel*)label from:(NSNumber*)from to:(NSNumber*)to duration:(NSTimeInterval)duration  formatter:(NSNumberFormatter*)formatter  random:(BOOL)r{
    LOG(@"to %@",to);
    static NSTimeInterval minDuration = 0.04;
    double timexp = [to longValue]-[from longValue];
    // 计算 duration/timexp 每个数字的变化消耗的时间
    // 从性能上考虑 我们只允许最多执行时间是 minDuration
    // 也就是 duration/timexp 如果 < minDuration  那我们就按照 timexp/minDuration 每单位时间处理这么多数字
    NSTimeInterval faceDuration;
    
    if (duration<timexp*minDuration) {
        faceDuration =minDuration;
    }else{
        faceDuration = duration/timexp;
    }
    
    __block uint count = duration/faceDuration;
    __block uint current=0;
    LOG(@"每间隔%.4f显示一帧 一共%d帧",faceDuration,count);
    NSNumber* startn;
    if (r) {
        //
        int x = [to intValue]+(random()%2==0?1:-1)*(random()%[to intValue]);
        startn = $int(x);
    }else{
        startn = from;
    }
    
    if ($safe(formatter)) {
        label.text = [formatter stringFromNumber:startn];
    }else{
        label.text = [startn stringValue];
    }
    
//    for (; current<count; current++) {
//        [UIView animateWithDuration:((double)current)*faceDuration animations:^{
//            uint xv = ([to longValue]-[from longValue])*current/count;
//            label.text = $str(@"%d",xv);
//        }];
//    }
    
    [self __dynamicIncreaseLabel:label from:from to:to faceDuration:faceDuration count:count current:current random:r formatter:formatter];
}

+(MBProgressHUD*)alertMessage:(UIView*)parent msg:(NSString*)msg{
    return [self alertMessage:parent msg:msg block:Nil];
}

+(MBProgressHUD*)alertMessage:(UIView*)parent msg:(NSString*)msg block:(void (^)())block{
    if (!parent) {
        return nil;
    }
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:parent];
    [parent addSubview:HUD];
//    HUD.labelText = msg;
    HUD.dimBackground = YES;
    HUD.mode = MBProgressHUDModeText;
    HUD.mode = MBProgressHUDModeCustomView;
    CGSize size = [msg sizeWithFont:HUD.labelFont constrainedToSize:CGSizeMake(256, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//    NSLog(@"%f %f",size.width,size.height);
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.adjustsFontSizeToFitWidth = NO;
	label.textAlignment = NSTextAlignmentCenter;
	label.opaque = NO;
	label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines=5;
	label.textColor = [UIColor whiteColor];
	label.font = HUD.labelFont;
//	label.text = HUD.labelText;
    label.text = msg;
    HUD.customView = label;
    
    __weak UIScrollView* scrollable = nil;
    BOOL scrollEnable = YES;
    if ([parent isKindOfClass:[UIScrollView class]]) {
        scrollable = (UIScrollView*)parent;
        scrollEnable = [scrollable isScrollEnabled];
        [scrollable setScrollEnabled:NO];
    }
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        if ($safe(scrollable)) {
            [scrollable setScrollEnabled:scrollEnable];
        }
        [HUD removeFromSuperview];
        if (block) {
            block();
        }
    }];
    return HUD;
}

+(NSString*)makeSureParentDirectoryExisting:(NSString*)file{
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString* path = [self parentPath:file];
    BOOL isDir = YES;
    if (![fm fileExistsAtPath:path isDirectory:&isDir]) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:Nil error:Nil];
    }
    return file;
}

+(NSString*)parentPath:(NSString*)path{
    NSArray* paths = [path $split:@"/"];
    NSRange range = NSMakeRange(0, [paths count]-1);
    NSArray* newpaths = [paths subarrayWithRange:range];
    return [newpaths $join:@"/"];
}

+(void)broder:(UIView*)view borderType:(BorderType)borderType cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth dashPattern:(NSInteger)dashPattern spacePattern:(NSInteger)spacePattern borderColor:(UIColor*)borderColor{
    
    //因为没法remove走 所以或多或少会存在一些 问题 特别是在实例重用的时候
//    if (_shapeLayer) [_shapeLayer removeFromSuperlayer];
    
    CAShapeLayer* _shapeLayer = [CAShapeLayer layer];
    
    //border definitions
//	CGFloat cornerRadius = _cornerRadius;
//	CGFloat borderWidth = _borderWidth;
//	NSInteger dashPattern1 = _dashPattern;
//	NSInteger dashPattern2 = _spacePattern;
	UIColor *lineColor = borderColor ? borderColor : [UIColor blackColor];
    
    //drawing
	CGRect frame = view.bounds;
    
//	_shapeLayer = [CAShapeLayer layer];
    
    //creating a path
	CGMutablePathRef path = CGPathCreateMutable();
    
    //drawing a border around a view
	CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
	CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
	CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
	CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
	CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
	CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
	CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
	CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
	CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the _shapeLayer object's path
	_shapeLayer.path = path;
	CGPathRelease(path);
    
	_shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
	_shapeLayer.frame = frame;
	_shapeLayer.masksToBounds = NO;
	[_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
	_shapeLayer.fillColor = [[UIColor clearColor] CGColor];
	_shapeLayer.strokeColor = [lineColor CGColor];
	_shapeLayer.lineWidth = borderWidth;
	_shapeLayer.lineDashPattern = borderType == BorderTypeDashed ? [NSArray arrayWithObjects:[NSNumber numberWithInt:dashPattern], [NSNumber numberWithInt:spacePattern], nil] : nil;
	_shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view
	[view.layer addSublayer:_shapeLayer];
	view.layer.cornerRadius = cornerRadius;
}


+(CGRect)lockAtScreen:(UISwipeGestureRecognizerDirection)direction  rect:(CGRect)rect offset:(CGFloat)offset{
    UIScreen* screen = [UIScreen mainScreen];
    // d = T - o;
    CGFloat t;
    CGFloat o;
    switch (direction) {
        case UISwipeGestureRecognizerDirectionDown:
        case UISwipeGestureRecognizerDirectionUp:
            o = rect.origin.y;
            break;
        case UISwipeGestureRecognizerDirectionLeft:
        case UISwipeGestureRecognizerDirectionRight:
            o = rect.origin.y;
            break;
        default:
            @throw [NSException exceptionWithName:@"无效的方向" reason:@"无效的方向" userInfo:Nil];
    }
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionDown:
        case UISwipeGestureRecognizerDirectionUp:
            t = screen.bounds.size.height-rect.size.height;
            break;
        case UISwipeGestureRecognizerDirectionLeft:
        case UISwipeGestureRecognizerDirectionRight:
            t = screen.bounds.size.width-rect.size.width;
            break;
        default:
            @throw [NSException exceptionWithName:@"无效的方向" reason:@"无效的方向" userInfo:Nil];
    }
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionDown:
            case UISwipeGestureRecognizerDirectionRight:
            t = t-offset;
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            case UISwipeGestureRecognizerDirectionUp:
            t = t+offset;
            break;
        default:
            @throw [NSException exceptionWithName:@"无效的方向" reason:@"无效的方向" userInfo:Nil];
    }
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionDown:
        case UISwipeGestureRecognizerDirectionUp:
            return CGRectOffset(rect, 0, t-o);
        case UISwipeGestureRecognizerDirectionLeft:
        case UISwipeGestureRecognizerDirectionRight:
            return CGRectOffset(rect, t-o, 0);
        default:
            @throw [NSException exceptionWithName:@"无效的方向" reason:@"无效的方向" userInfo:Nil];
    }
}

@end
