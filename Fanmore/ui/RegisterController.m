//
//  RegisterController.m
//  Fanmore
//
//  Created by Cai Jiang on 2/25/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "RegisterController.h"
#import "BlocksKit+UIKit.h"
#import "AppDelegate.h"
#import "FMUtils.h"

@interface RegisterController ()
//@property(weak) UITextField* username;
@property NSTimeInterval lastNext;
@end

@implementation RegisterController

-(id)initWithNibAndCallback:(UICallbacks*)callback{
    self = [super initWithNibName:@"RegisterController" bundle:[NSBundle mainBundle]];
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

-(void)doBack{
    [self.navigationController popViewControllerAnimated:YES];
    [self removeFromParentViewController];
    [self.callbacks invokeCancel];
}

-(void)doRegister{
    __weak RegisterController* wself = self;
    LoadingState* ls = [AppDelegate getInstance].loadingState;
    if ([ls hasSMSEnabled]) {
        if (self.textCode.hidden) {
            [FMUtils alertMessage:self.view msg:@"请先获得验证码"];
            return;
        }
        if (!$safe(self.textCode.text) || self.textCode.text.length<4) {
            [FMUtils alertMessage:self.view msg:@"请输入验证码" block:^{
                [wself.textCode shake];
            }];
            return;
        }
    }
    //假定成功
    if (![self.textMobile.text isMobileNumber]) {
        [FMUtils alertMessage:self.view msg:@"请输入有效的手机号" block:^{
            [wself.textMobile shake];
        }];
        return;
    }
    
    if (!$safe(self.password.text) || self.password.text.length<6 || self.password.text.length>12) {
        [FMUtils alertMessage:self.view msg:@"请输入有效的密码" block:^{
            [wself.password shake];
        }];
        return;
    }
    
    if (!$eql(self.password.text,self.cpassword.text)) {
        [FMUtils alertMessage:self.view msg:@"2次输入的密码并不相同" block:^{
            [wself.password shake];
            [wself.cpassword shake];
        }];
        return;
    }
    
    [[[AppDelegate getInstance]getFanOperations] registerUser:nil block:^(LoginState *login, NSError *error) {
        if ($safe(error)) {
            //
            if (53001==error.code) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription] block:^{
                    [wself.textMobile shake];
                }];
                return;
            }
            if (53002==error.code) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription] block:^{
                    [wself.textMobile shake];
                }];
                return;
            }
            if (54001==error.code) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription] block:^{
                    [wself.textMobile shake];
                }];
                return;
            }
            if (53007==error.code) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription] block:^{
                    [wself.textCode shake];
                }];
                return;
            }
            
            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            return;
        }
        [self.callbacks invokeDone:login];
    } userName:self.textMobile.text password:self.password.text code:self.textCode.text invitationCode:self.textInvitationCode.text];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)]];
    self.navigationItem.title = @"用户注册";
    self.type = 3;
    
    [self viewDidLoadGestureRecognizer];
    __weak RegisterController* wself = self;
    [self.btRegister bk_whenTapped:^{
        [wself doRegister];
    }];
    
    self.registerPocilyLabel.userInteractionEnabled = YES;
    [self.registerPocilyLabel bk_whenTapped:^{
//        NSLog(@"adsfasd");
        [FMUtils toPolicyController:wself attach:@""];
    }];
    
    self.imageQ.userInteractionEnabled  = YES;
    [self.imageQ bk_whenTapped:^{
        [FMUtils toRuleController:wself attach:@"#shoutumimi"];
    }];
    
    LoadingState* ls = [AppDelegate getInstance].loadingState;
    
    
    [self.labelNewbieHint setText:ls.grenadeRewardInfo];
    
    if (![ls hasSMSEnabled]) {
        self.btGetCode.hidden = YES;
        self.textMobile.hidden = YES;
        self.textMobile = self.textMobileFull;
        self.textMobile.hidden = NO;
//        self.textMobile.autoresizingMask = UIViewAutoresizingNone;
//        [self.textMobile setFrame:CGRectMake(self.textMobile.frame.origin.x, self.textMobile.frame.origin.y, self.password.frame.size.width, self.textMobile.frame.size.height)];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (!$safe(self.view.superview) && $safe(self.callbacks)) {
        if([self.callbacks uidismiss])
            self.callbacks = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.textMobile becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textdone:(UITextField *)sender {
    if (true) {
        if (self.cpassword==sender) {
            [self doRegister];
            return;
        }
        return;
    }
    NSTimeInterval current = [NSDate timeIntervalSinceReferenceDate];
    
    if (current-self.lastNext<0.5) {
        return;
    }
    
    
    self.lastNext = current;
    
    if (self.textInvitationCode==sender) {
        [self.textMobile becomeFirstResponder];
        return;
    }
    if (self.textMobile==sender) {
        if (self.textCode.hidden) {
            [self.password becomeFirstResponder];
        }else{
            [self.textCode becomeFirstResponder];
        }
        return;
    }
    
    if (self.textCode==sender) {
        [self.password becomeFirstResponder];
        return;
    }
    
    if (self.password==sender) {
        [self.cpassword becomeFirstResponder];
        return;
    }
    
    if (self.cpassword==sender) {
        [self doRegister];
        return;
    }
}
@end
