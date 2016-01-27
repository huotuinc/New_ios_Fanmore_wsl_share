//
//  CommonPasswordController.m
//  Fanmore
//
//  Created by Cai Jiang on 2/28/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "CommonPasswordController.h"
#import "BlocksKit+UIKit.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "NSString+SSToolkitAdditions.h"
//#import "AccountViewController.h"
#import "ForgotPswdController.h"
#import "SafeController.h"
#import "AccountViewController.h"
#import "TaskListController.h"

@interface CommonPasswordController ()

@end

@implementation CommonPasswordController


-(SafeController*)findSafeController{
    for (id c in self.navigationController.viewControllers) {
        if ([c isKindOfClass:[SafeController class]]) {
            return c;
        }
    }
    return nil;
}

-(UIViewController<AbleStartCash>*)mainCasher{
    for (id c in self.navigationController.viewControllers) {
        if ([c conformsToProtocol:@protocol(AbleStartCash)]) {
            return c;
        }
        //        if ([c isKindOfClass:[AccountViewController class]]) {
        //            return c;
        //        }
    }
    return nil;
}

-(void)doBack{
    UIViewController* uc = [self up:[SafeController class]];
    if ($safe(uc)) {
        [self.navigationController popToViewController:uc animated:YES];
        return;
    }
    
    uc = [self up:[TaskListController class]];
    if ($safe(uc)) {
        [self.navigationController popToViewController:uc animated:YES];
        return;
    }
    
    uc = [self up:[AccountViewController class]];
    if ($safe(uc)) {
        [self.navigationController popToViewController:uc animated:YES];
        return;
    }
    
    UIViewController* ac = [self mainCasher];
    if ($safe(ac)) {
        [self.navigationController popToViewController:ac animated:YES];
    }else{
        [super doBack];
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

-(void)doSubmit{
    
    __weak CommonPasswordController* wself = self;
    void(^woker)(NSString*,NSError*) = ^(NSString* msg,NSError* error) {
        if ($safe(error)) {
            if (error.code==53002) {
                [FMUtils alertMessage:self.view msg:NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.hint.password.valid",nil,[NSBundle mainBundle],@"请输入有效的密码",@"密码无效时的提醒") block:^{
                    [self.password shake];
                    [self.password2 shake];
                }];
                return;
            }
            [[AppDelegate getInstance]attemptPassword:self wrong:NO block:NULL];
            [FMUtils alertMessage:self.view msg:[error FMDescription]];
            return;
        }
        
        
        [FMUtils alertMessage:self.view msg:self.passwordMode==0?NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.hint.password.changesuccess",nil,[NSBundle mainBundle],@"您的登录密码修改成功！",@"登录密码成功修改"):NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.hint.cashpassword.changesuccess",nil,[NSBundle mainBundle],@"您的提现密码修改成功！",@"提现密码成功修改") block:[StandCash iamDoneNext:self]];
    };
    
#ifdef FanmoreJustDone
    [AppDelegate getInstance].loadingState.userData.withdrawalPassword = [@"mypswdooa1" MD5Sum];
    woker(@"成功!",nil);
    return;
#endif
    
    if (self.editMode==0 && (!$safe(self.oldPassword.text) || ![self.oldPassword.text isPassword] )) {
        [FMUtils alertMessage:self.view msg:self.passwordMode==0?@"请输入原登录密码":@"请输入原提现密码" block:^{
            [wself.oldPassword shake];
        }];
        return;
    }
    
    if (!$safe(self.password.text) || ![self.password.text isPassword]) {
        [FMUtils alertMessage:self.view msg:self.passwordMode==0?@"请输入登录密码":@"请输入提现密码" block:^{
            [wself.password shake];
        }];
        return;
    }
    if (!$safe(self.password2.text) || ![self.password2.text isPassword]) {
        [FMUtils alertMessage:self.view msg:self.passwordMode==0?@"请确认登录密码":@"请确认提现密码" block:^{
            [wself.password2 shake];
        }];
        return;
    }
    
    if (!$eql(self.password.text,self.password2.text)) {
        [FMUtils alertMessage:self.view msg:@"两次密码并不一致" block:^{
            [wself.password shake];
            [wself.password2 shake];
        }];
        return;
    }
    LoginState* ls = [AppDelegate getInstance].loadingState.userData;
    //验证原密码
    if (self.editMode==0 && self.passwordMode==0) {
        NSString* oldpswd = [ls.loginCode componentsSeparatedByString:@"^"][1];
        if (!$eql([self.oldPassword.text MD5Sum],oldpswd)) {
            [FMUtils alertMessage:self.view msg:NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.hint.wrongpassword",nil,[NSBundle mainBundle],@"请输入正确的密码",@"密码错误时的提醒") block:^{
                [wself.oldPassword shake];
            }];
            return;
        }
    }else if(self.editMode==0){
        if (!$eql([self.oldPassword.text MD5Sum],ls.withdrawalPassword)) {
            [[AppDelegate getInstance]attemptPassword:self wrong:YES block:^{
                [wself.oldPassword shake];
            }];
//            [FMUtils alertMessage:self.view msg:@"请输入正确的提现密码" block:^{
//                [self.oldPassword shake];
//            }];
            return;
        }
    }
    
    
    if (self.passwordMode==0) {
        [[[AppDelegate getInstance]getFanOperations]modifyPwd:Nil block:woker newPwd:self.password.text];
    }else{
        [[[AppDelegate getInstance]getFanOperations]setWithdrawalPassword:Nil block:woker withdrawalPassword:self.password.text oldWithdrawalPassword:self.editMode==1?nil:self.oldPassword.text];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.editMode==1) {
        self.oldPassword.hidden = YES;
        self.labelForget.hidden = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadGestureRecognizer];
    [self viewDidLoadFanmore];
    __weak CommonPasswordController* wself = self;
    [self.btcancel addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [self.btok addTarget:self action:@selector(doSubmit) forControlEvents:UIControlEventTouchUpInside];
    
    self.labelForget.userInteractionEnabled = YES;
    [self.labelForget bk_whenTapped:^{
        if (wself.passwordMode==0) {
            [ForgotPswdController openForgotPswd:wself];
            return;
        }
        [wself performSegueWithIdentifier:@"ToReset" sender:wself.labelForget];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doTextnext:(UITextField *)sender {
    // 53002 不合法的用户密码
    if (sender==self.oldPassword) {
        [self.password becomeFirstResponder];
        return;
    }else if(sender==self.password){
        [self.password2 becomeFirstResponder];
        return;
    }else if (sender==self.password2){
        [self doSubmit];
    }
}
- (IBAction)okAction:(id)sender {
    [self doSubmit];
}
@end

@implementation PswdController
@end

@implementation CashPswdController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ($eql(segue.identifier,@"ToReset")) {
        TextChangeController* tc = segue.destinationViewController;
        tc.delegate = self;
    }
}

-(BOOL)textChanged:(UITextField*)text OnHint:(UILabel*)label{
    if (![text.text isPassword]) {
        label.text = NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.hint.wrongpassword",nil,[NSBundle mainBundle],@"请输入正确的密码",@"密码错误时的提醒");
        [text shake];
        return NO;
    }
    NSString* oldpswd = [[AppDelegate getInstance].loadingState.userData.loginCode componentsSeparatedByString:@"^"][1];
    if (!$eql([text.text MD5Sum],oldpswd)) {
        label.text = NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.hint.wrongpassword",nil,[NSBundle mainBundle],@"请输入正确的密码",@"密码错误时的提醒");
        [text shake];
        return NO;
    }
    return YES;
}

-(void)textUpdated:(UITextField*)text andHint:(UILabel*)label{
    label.text = @"";
}

-(void)submitText:(NSString*)str{
    self.editMode = 1;
}

- (void)viewDidLoad{
    self.passwordMode=1;
    LoginState* ls = [AppDelegate getInstance].loadingState.userData;
    //还有一种情况是 密码尝试错误次数过多
    if (!$safe(ls.withdrawalPassword)|| ls.withdrawalPassword.length==0) {
        self.editMode=1;
    }
    [super viewDidLoad];
}
@end
