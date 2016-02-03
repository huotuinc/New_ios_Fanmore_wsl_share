//
//  ForgotPswdController.m
//  Fanmore
//
//  Created by Cai Jiang on 4/16/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ForgotPswdController.h"
#import "FMUtils.h"
#import "AppDelegate.h"
#import "MineMenuController.h"

@interface ForgotPswdController ()

@end

@implementation ForgotPswdController

+(void)openForgotPswd:(UIViewController*)controller{
    ForgotPswdController* fc = [[ForgotPswdController alloc] initWithNibName:@"ForgotPswdController" bundle:[NSBundle mainBundle]];
    [controller.navigationController pushViewController:fc animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.type = 4;
    [self.labelAuto activeSelection];
    
    self.labelAuto.delegate = self;
    self.labelAuto.backgroundCColor = [UIColor colorWithHexString:@"#8B8B8B"];
//    self.labelAuto.backgroundImageName = @"graybackground";
    self.labelMan.delegate = self;
    self.labelMan.backgroundCColor = [UIColor colorWithHexString:@"#8B8B8B"];
//    self.labelMan.backgroundImageName = @"graybackground";
    
    self.navigationItem.title = @"找回密码";
    self.navigationItem.rightBarButtonItem = self.barBtDone;
    
    LoadingState* ls = [AppDelegate getInstance].loadingState;
    if ([ls hasLogined] && [ls hasBindMobile]) {
        self.textMobile.text = ls.userData.mobile;
        self.textMobile.enabled = NO;
    }
    
    [self.helpWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ls.manualServiceUrl]]];
}

-(void)flowSelected:(ScoreFlowSelection*)selection{
    if (selection==self.labelAuto) {
        self.viewMan.hidden = YES;
        self.viewAuto.hidden = NO;
    }else{
        self.viewMan.hidden = NO;
        self.viewAuto.hidden = YES;
        [self.textMobile resignFirstResponder];
        [self.textCode resignFirstResponder];
        [self.textPswd resignFirstResponder];
        [self.textPswd2 resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)textEditDone:(UITextField *)sender {
    [super textEditDone:sender];
    if (sender==self.textCode) {
        [self.textPswd becomeFirstResponder];
        return;
    }
    if (sender==self.textPswd) {
        [self.textPswd2 becomeFirstResponder];
        return;
    }
    if (sender==self.textPswd2) {
        [self doSelector:nil];
        return;
    }
}

- (IBAction)doSelector:(id)sender {
    if (self.labelMan.actived) {
        return;
    }
    __weak ForgotPswdController* wself = self;
    if (![self.textMobile.text isMobileNumber]) {
        [FMUtils alertMessage:self.view msg:@"请先输入手机号码" block:^{
            [wself.textMobile shake];
        }];
        return;
    }
    if (self.textCode.hidden) {
        [FMUtils alertMessage:self.view msg:@"请先获取验证码" block:^{
            [wself.btGetCode shake];
        }];
        return;
    }
    if (!$safe(self.textCode.text) || self.textCode.text.length<4) {
        [FMUtils alertMessage:self.view msg:@"请先输入验证码" block:^{
            [wself.textCode shake];
        }];
        return;
    }
    if (![self.textPswd.text isPassword]) {
        [FMUtils alertMessage:self.view msg:@"请先输入密码" block:^{
            [wself.textPswd shake];
        }];
        return;
    }
    if (![self.textPswd2.text isPassword]) {
        [FMUtils alertMessage:self.view msg:@"请先输入密码" block:^{
            [wself.textPswd2 shake];
        }];
        return;
    }
    
    if (!$eql(self.textPswd2.text,self.textPswd.text)) {
        [FMUtils alertMessage:self.view msg:@"您输入的密码并不一致" block:^{
            [wself.textPswd2 shake];
            [wself.textPswd shake];
        }];
        return;
    }
    
    [[[AppDelegate getInstance] getFanOperations] resetPwd:nil block:^(NSString *msg, NSError *error) {
        if ($safe(error)) {
            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            return;
        }
        NSString* toshow = msg;
        if (!$safe(toshow)) {
            toshow = @"您的密码已成功修改。";
        }
        if ([[AppDelegate getInstance].loadingState hasLogined]) {
            toshow = $str(@"%@ 请重新登录。",toshow);
            [[AppDelegate getInstance] logout:wself];
            __weak MineMenuController* mc;
            for (id c in wself.navigationController.viewControllers) {
                if ([c isKindOfClass:[MineMenuController class]]) {
                    mc = c;
                    break;
                }
            }
            [FMUtils alertMessage:wself.view msg:toshow block:^{
                if ($safe(mc)) {
                    [wself.navigationController popToViewController:mc animated:YES];
                }else{
//                    [wself dismissViewControllerAnimated:NO completion:NULL];
                    [wself doBack];
                }
            }];
        }else{
            [FMUtils alertMessage:wself.view msg:toshow block:^{
//                [wself dismissViewControllerAnimated:NO completion:NULL];
                [wself doBack];
            }];
        }
    } phone:self.textMobile.text code:self.textCode.text newPwd:self.textPswd.text];
}
@end
