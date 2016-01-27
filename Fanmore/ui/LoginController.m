//
//  LoginController.m
//  Fanmore
//
//  Created by Cai Jiang on 2/24/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "LoginController.h"
#import "BlocksKit+UIKit.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "UIViewController+CWPopup.h"
#import "RegisterController.h"
#import "ForgotPswdController.h"
#import "WebController.h"

@interface LoginController ()
@property BOOL oldBarHidden;
@end

@implementation LoginController

-(id)initWithNibAndCallback:(UICallbacks*)callback{
    self = [super initWithNibName:@"LoginController" bundle:[NSBundle mainBundle]];
    self.callbacks = callback;
    return self;
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
    [self.infoLabel setBackgroundColor:fmMainColor];
    __weak LoginController* wself = self;
    [self.btlogin bk_whenTapped:^{
        [wself doLogin:wself.btlogin];
    }];
    self.labelRegister.userInteractionEnabled = YES;
    [self.labelRegister bk_whenTapped:^{
        [wself doRegister:wself.labelRegister];
    }];
    [self.btregister bk_whenTapped:^{
        [wself doRegister:wself.btregister];
    }];
    
    self.labelForgot.userInteractionEnabled = YES;
    [self.labelForgot bk_whenTapped:^{
        [ForgotPswdController openForgotPswd:wself];
    }];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.oldBarHidden = self.navigationController.navigationBarHidden;
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden =self.oldBarHidden;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (!$safe(self.view.superview) && $safe(self.callbacks)) {
        [self.callbacks uidismiss];
        self.callbacks = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doLogin:(id)sender {
    __weak LoginController* wself = self;
    if (![self.username.text isMobileNumber] && ![self.username.text isUserName]) {
//        [FMUtils alertMessage:self.view msg:@"请输入正确的登录名或者手机号" block:<#^(void)block#>]
        [self.username shake];
        return;
    }
    
    if (!$safe(self.password.text) || self.password.text.length<6 || self.password.text.length>12) {
        [FMUtils alertMessage:self.view msg:@"无效的密码" block:^{
            [wself.password shake];
        }];
        return;
    }
    
    [wself.view startIndicator];

    
    [[[AppDelegate getInstance]getFanOperations]login:Nil block:^(LoginState *state, NSError *error) {
        
        [wself.view stopIndicator];
        
        if ($safe(error)) {
            if (error.code==53001) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription] block:^{
                    [wself.username shake];
                }];
                return;
            }
            if (error.code==53002) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription] block:^{
                    [wself.password shake];
                }];
                return;
            }
            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            return;
        }
        [wself.callbacks invokeDone:Nil];
    } userName:self.username.text password:self.password.text];
}

- (IBAction)doRegister:(id)sender {
    LOG(@"Register");
    RegisterController* rc = [[RegisterController alloc] initWithNibName:@"RegisterController" bundle:[NSBundle mainBundle]];
    __weak RegisterController* wrc = rc;
    rc.callbacks = [UICallbacks callback:self.callbacks.done cancelled:NULL dismiss:^{
        LOG(@"register dismiss");
        if([[wrc.navigationController.viewControllers lastObject] isKindOfClass:[WebController class]]){
            return NO;
        }
        if ($safe(wrc) && $safe(wrc.navigationController)) {
            [wrc.navigationController popViewControllerAnimated:NO];
        }
        if ($safe(wrc) && $safe(wrc.parentViewController)) {
            [wrc removeFromParentViewController];
        }
        return YES;
    }];
    
    [self.parentViewController addChildViewController:rc];
    rc.relexController = self.parentViewController;
    
    [self.parentViewController dismissPopupViewControllerAnimated:NO completion:^{
        [self removeFromParentViewController];
        [rc.parentViewController.navigationController pushViewController:rc animated:YES];
    }];
    
}

- (IBAction)textfield_did:(UITextField *)sender {
    if (sender==self.username) {
        [self.password becomeFirstResponder];
    }
    if (sender==self.password) {
        [self doLogin:sender];
    }
}
- (IBAction)clickExit:(id)sender {
    [self.parentViewController dismissPopupViewControllerAnimated:YES completion:NULL];
}
@end
