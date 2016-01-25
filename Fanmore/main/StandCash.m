//
//  StandCash.m
//  Fanmore
//
//  Created by Cai Jiang on 6/20/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "StandCash.h"
#import "AppDelegate.h"
#import "FMUtils.h"
//#import "TaskListController.h"
//#import "AccountViewController.h"

@interface StandCash ()

@end

@implementation StandCash

-(id)init{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.navigationItem.title = @"积分提现";
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)]];
        self.navigationItem.rightBarButtonItems =@[[[UIBarButtonItem alloc] initWithTitle:@"提现！" style:UIBarButtonItemStyleBordered target:self action:@selector(doDone:)]];
    }
    return self;
}

+(StepDoneCallBack)iamDoneNext:(UIViewController<CashStepController>*)controller{
    void(^block)() = ^() {
//        
//        UIViewController* uc = [controller up:[SafeController class]];
//        if ($safe(uc)) {
//            [controller.navigationController popToViewController:uc animated:YES];
//            return;
//        }
//        
//        uc = [controller up:[TaskListController class]];
//        if ($safe(uc)) {
//            [controller.navigationController popToViewController:uc animated:YES];
//            return;
//        }
//        
//        uc = [controller up:[AccountViewController class]];
//        if ($safe(uc)) {
//            [controller.navigationController popToViewController:uc animated:YES];
//            return;
//        }
//        
//        UIViewController* ac = [controller mainCasher];
//        if ($safe(ac)) {
//            [controller.navigationController popToViewController:ac animated:YES];
//        }else{
//            [controller doBack];
//        }
        
        
        SafeController* sc = [controller findSafeController];
        if ($safe(sc)) {
            [controller doBack];
        }else{
            UIViewController<AbleStartCash>* ac = [controller mainCasher];
            if (!$safe(ac)) {
                [controller doBack];
            }else{
                CashResultTye type = [FMUtils tryCash];
                NSString* msg,*segueName;
                
                switch (type) {
                    case CashResultOK:{
                        [ac actionDone];
                        [controller.navigationController popToViewController:ac animated:NO];
                        return;
                    }
                        
                    case CashResultALP:{
                        if (!$safe(msg)) {
                            msg = @"请先绑定支付宝账号。";
                            segueName = @"ToALP";
                        }
                    }
                        
                    case CashResultPassword:{
                        if (!$safe(msg)) {
                            msg = @"请先设置提现密码。";
                            segueName = @"ToCashPswd";
                        }
                        [FMUtils alertMessage:controller.view msg:msg block:^{
                            [controller performSegueWithIdentifier:segueName sender:nil];
                        }];
                        break;
                    }
                    default:
                        [controller doBack];;
                }
            }
        }
    };
    return block;
}

+(instancetype)pushStandCash:(UIViewController<AbleStartCash>*)controller{
    LoadingState* ls = [AppDelegate getInstance].loadingState;
    
    if ([ls useNewCash]) {
        UIStoryboard* mine = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
        UIViewController* uc = [mine instantiateViewControllerWithIdentifier:@"NewCashController"];
        [controller.navigationController pushViewController:uc animated:YES];
        return nil;
    }
    
#ifdef FanmoreDebugCashRightNow
    [FMUtils shareMyCash:self];
    return NO;
#endif
    CashResultTye type = [FMUtils tryCash];
    
    StandCash* sc;
    NSString* msg,*segueName;
    
    switch (type) {
        case CashResultOK:
            sc = $new(self);
            [controller.navigationController pushViewController:sc animated:YES];
            return sc;
        case CashResultNotEnoughScore:
            [FMUtils alertMessage:controller.view msg:$str(@"最少%@积分才可以提现哦，亲！",ls.changeBoundary)];
            return nil;
        case CashResultALP:
            if (!$safe(msg)) {
                msg = @"请先绑定支付宝账号。";
//                segueName = @"ToALP";
                segueName = @"BindingALB";
            }
        case CashResultMobile:
            if (!$safe(msg)) {
                msg = @"请先绑定手机号码。";
//                segueName = @"ToMobile";
                segueName = @"BindingMobile";
            }
        case CashResultPassword:
            if (!$safe(msg)) {
                msg = @"请先设置提现密码。";
//                segueName = @"ToCashPswd";
                segueName = @"CashPswd";
            }
            [FMUtils alertMessage:controller.view msg:msg block:^{
                [controller beginOtherControllerForCash];
                
                UIStoryboard* sb = controller.storyboard;
                UIViewController* uc;
                @try {
                    uc = [sb instantiateViewControllerWithIdentifier:segueName];
                    if (!uc) {
                        sb = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
                        uc = [sb instantiateViewControllerWithIdentifier:segueName];
                    }
                }
                @catch (NSException *exception) {
                    sb = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
                    uc = [sb instantiateViewControllerWithIdentifier:segueName];
                }
                @finally {
                }
                
                [controller.navigationController pushViewController:uc animated:YES];
            }];
            return NO;
    }
    
    return nil;
    //BindingALB
    //BindingMobile
    //CashPswd
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UITextField* text = [[UITextField alloc] initWithFrame:CGRectMake(20, 141, 280, 30)];
    [text setPlaceholder:@"请输入您的提现密码"];
    [text setBorderStyle:UITextBorderStyleRoundedRect];
    [text addTarget:self action:@selector(textDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [text addTarget:self action:@selector(textEditted:) forControlEvents:UIControlEventEditingChanged];
    text.secureTextEntry = YES;
    [self.view addSubview:text];
    self.textText = text;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 83, 300, 21)];
    [label setText:@"您有1100积分可用于提现，约合人民币110元"];
    [label setFont:[UIFont systemFontOfSize:15.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
    self.labelHint = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 112, 300, 21)];
    [label setText:@"(此数据仅供参考，最终数据以服务器结算为准)"];
    [label setFont:[UIFont systemFontOfSize:11.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor lightGrayColor]];
    [self.view addSubview:label];
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(10, 179, 300, 38)];
    [button setBackgroundImage:[UIImage imageNamed:@"redbackground"] forState:UIControlStateNormal];
    [button setTitle:@"提现" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [button addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:button];
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 229, 300, 21)];
    [label setText:@"请确认已正确绑定支付宝！"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor redColor]];
    [self.view addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 258, 300, 21)];
    [label setText:@"您的提现申请将在1-3个工作日内完成"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor darkGrayColor]];
    [self.view addSubview:label];
    //请确认已正确绑定支付宝！
    //您的提现申请将在1-3个工作日内完成
    
    
    if ([self.delegate respondsToSelector:@selector(initText:andHint:)]) {
        [self.delegate initText:self.textText andHint:self.labelHint];
    }
    
    [self.textText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark delegate


-(void)submitText:(NSString*)str{
    //接受了
}

-(void)initText:(UITextField*)text andHint:(UILabel*)label{
    LoginState* ls = [AppDelegate getInstance].loadingState.userData;
    [label setText:[ls cashScoreHint]];
    CGFloat size = 15.0f;
    while ([label.text sizeWithFont:label.font].width>CGRectGetWidth(label.frame)) {
        size -= 1.0f;
        label.font = [UIFont boldSystemFontOfSize:size];
    }
}

-(void)textUpdated:(UITextField*)text andHint:(UILabel*)label{
    //    label.text = @"";
    LoginState* ls = [AppDelegate getInstance].loadingState.userData;
    [label setText:[ls cashScoreHint]];
}

-(BOOL)textChanged:(UITextField*)text OnHint:(UILabel*)label{
    //check here
    if (!$safe(text.text)|| ![text.text isPassword]) {
        [text shake];
        label.text = @"请输入有效的提现密码。";
        return NO;
    }
//    __weak AccountViewController* wself = self;
    __weak StandCash* wself = self;
    [[[AppDelegate getInstance]getFanOperations]cash:Nil block:^(NSString *msg, NSError *error) {
        if ($safe(error)) {
            void(^wrongPswdBlock)() = ^() {
                [text shake];
            };
            switch (error.code) {
                case 53008:
                    label.text=@"错误的提现密码";
                    [[AppDelegate getInstance]attemptPassword:wself wrong:YES block:wrongPswdBlock];
                    return;
                case 52001:
                    label.text=@"需要支付宝绑定";
                    return;
                case 52002:
                    label.text=@"需要上次积分提现处理完成";
                    return;
                case 52003:
                    label.text=@"需要大于提现基准分";
                    return;
                case 52004:
                    [text shake];
                    label.text=@"需要设置提现密码";
                    return;
                default:
                    //#ifdef FanmoreDebug
                    //                    msg = @"假装成功了！";
                    //                    break;
                    //#endif
                    [[AppDelegate getInstance] attemptPassword:wself wrong:NO block:NULL];
                    [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                    return;
            }
        }
        
        [[AppDelegate getInstance] attemptPassword:wself wrong:NO block:NULL];
        [wself viewWillAppear:YES];
        [wself doBack];
        if (!$safe(msg) || msg.length==0) {
            msg =@"成功申请，请耐心等候";
        }
        [FMUtils alertMessage:wself.view msg:msg block:^{
            [FMUtils shareMyCash:wself];
        }];
    } password:text.text];
    
    return NO;
}

@end
