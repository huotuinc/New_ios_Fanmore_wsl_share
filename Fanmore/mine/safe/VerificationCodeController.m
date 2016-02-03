//
//  VerificationCodeController.m
//  Fanmore
//
//  Created by Cai Jiang on 2/28/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "VerificationCodeController.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "BlocksKit+UIKit.h"
#import "WebController.h"
#import "AccountViewController.h"
#import "TaskListController.h"
#import "SafeController.h"

@interface VerificationCodeController ()
@property NSString* mobileNumber;
@end

@implementation VerificationCodeController

-(void)rewriteTimeForSendBT:(NSNumber*)last{
    last = $int([last intValue]-1);
    if ([last intValue]<=0) {
        [self.btGetCode setTitle:NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.code.recevie",nil,[NSBundle mainBundle],@"获取验证码",nil) forState:UIControlStateNormal];
        self.btGetCode.enabled = YES;
        return;
    }
    
    [self.btGetCode setTitle:$str(NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.code.recevielater",nil,[NSBundle mainBundle],@"%d秒后重新获取",nil),[last intValue]) forState:UIControlStateDisabled];
    [self performSelector:@selector(rewriteTimeForSendBT:) withObject:last afterDelay:1];
}

-(void)doSendVCCode{
    __weak VerificationCodeController* wself = self;
    if ($safe(self.policySelected) && !self.policySelected.selected) {
        [FMUtils alertMessage:self.view msg:NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.msg.service.agree",nil,[NSBundle mainBundle],@"请阅读并且勾选同意我们的隐私保护政策。",nil)];
        return;
    }
    //先验证手机号码是否正确
    if (![self.textMobile.text isMobileNumber]) {
        [FMUtils alertMessage:wself.view msg:@"请输入有效的手机号" block:^{
            [wself.textMobile shake];
        }];
        return;
    }
    self.mobileNumber = self.textMobile.text;
    [[[AppDelegate getInstance]getFanOperations]verificationCode:Nil block:^(NSString *msg, NSError *error) {
        if ($safe(error)) {
            [FMUtils alertMessage:self.view msg:[error FMDescription]];
            return;
        }
        //发送mobile 以及type字段过去
        LOG(@"获得验证码");
        self.textCode.hidden = NO;
        [self.textCode becomeFirstResponder];
        
        self.btGetCode.enabled = NO;
        [self rewriteTimeForSendBT:@91];
        
    } phone:self.textMobile.text type:$int(self.type)];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ($eql(segue.identifier,@"ToService")) {
        [segue.destinationViewController viewWeb:[AppDelegate getInstance].loadingState.serviceUrl];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadFanmore];
    [self viewDidLoadGestureRecognizer];
    
    __weak VerificationCodeController* wself = self;
    
    if ($safe(self.policySelected)) {
        self.policySelected.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.policySelected bk_whenTapped:^{
            BOOL selected =wself.policySelected.selected;
            wself.policySelected.selected = !selected;
//            LOG(@"selected:%d",self.policySelected.selected);
        }];
    }
    
    if ($safe(self.btGetCode)) {
        [self.btGetCode addTarget:self action:@selector(doSendVCCode) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.labelPocily.userInteractionEnabled = YES;
    [self.labelPocily bk_whenTapped:^{
        if (safeController(wself)) {
            [FMUtils toPolicyController:wself attach:@""];
//            [wself performSegueWithIdentifier:@"ToService" sender:Nil];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textEditDone:(UITextField *)sender {
    if (sender==self.textMobile) {
        [self doSendVCCode];
    }
}
- (IBAction)okAction:(id)sender {
    NSLog(@"a??");
}

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

//-(AccountViewController*)checkAccount{
//    for (id c in self.navigationController.viewControllers) {
//        if ([c isKindOfClass:[AccountViewController class]]) {
//            return c;
//        }
//    }
//    return nil;
//}

@end


@implementation VCBindingALB

- (void)viewDidLoad{
    [super viewDidLoad];
    self.type = 2;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    LoginState* ls = [AppDelegate getInstance].loadingState.userData;
    __weak VerificationCodeController* wself = self;
    if (!([ls.isBindMobile boolValue] && $safe(ls.mobile) && [ls.mobile isMobileNumber])) {
        [FMUtils alertMessage:self.view msg:NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.bingdingmobilefirst",nil,[NSBundle mainBundle],@"请先绑定手机号码。",nil) block:^{
            if (safeController(wself)) {
                [wself performSegueWithIdentifier:@"ToMobile" sender:wself];
            }
        }];
        return;
    }
    
    self.textMobile.text = ls.mobile;
    self.textMobile.enabled = NO;
}

- (IBAction)okAction:(id)sender {
    
    NSLog(@"xxxxxx");
    __weak VerificationCodeController* wself = self;
#ifdef FanmoreJustDone
    LoginState* ls = [AppDelegate getInstance].loadingState.userData;
    ls.alipayId = @"aaa@163.com";
    [StandCash iamDoneNext:self]();
    return;
#endif
    
    if (!self.policySelected.selected) {
        [FMUtils alertMessage:self.view msg:NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.msg.service.agree",nil,[NSBundle mainBundle],@"请阅读并且勾选同意我们的隐私保护政策。",nil)];
        return;
    }
    //校验他们的数据
    if (self.textCode.hidden) {
        [FMUtils alertMessage:self.view msg:@"请先获取验证码"];
        return;
    }
    if (!$safe(self.textCode.text) || self.textCode.text.length<2) {
        [FMUtils alertMessage:wself.view msg:@"请输入验证码" block:^{
            [wself.textCode shake];
        }];
        return;
    }
    
    if (!$safe(self.textalbAccount.text) || self.textalbAccount.text.length<5) {
        [FMUtils alertMessage:wself.view msg:@"请输入有效的支付宝帐号" block:^{
            [wself.textalbAccount shake];
        }];
        return;
    }
    
    if (!$safe(self.textalbName.text) || self.textalbName.text.length<2) {
        [FMUtils alertMessage:wself.view msg:@"请输入有效的真实姓名" block:^{
            [wself.textalbName shake];
        }];
        return;
    }
    
    [[[AppDelegate getInstance]getFanOperations]bindAlipay:Nil block:^(NSString *msg, NSError *error) {
        if ($safe(error)) {
            switch (error.code) {
                case 53003:
                {[FMUtils alertMessage:wself.view msg:[error FMDescription] block:^{
                        [wself.textMobile shake];
                    }];
                    break;}
                case 53004:
                {[FMUtils alertMessage:wself.view msg:[error FMDescription] block:^{
                        [wself.textalbAccount shake];
                    }];
                    break;}
                case 53005:
                {[FMUtils alertMessage:wself.view msg:[error FMDescription] block:^{
                        [wself.textalbName shake];
                    }];
                    break;}
                case 53006:
                case 53007:
                    //                    case 53012:
                {[FMUtils alertMessage:wself.view msg:[error FMDescription] block:^{
                        [wself.textCode shake];
                    }];
                    break;}
                    //52005  52006 需要提供绑定的手机号 我觉得并不输入的必要
                default:
                    [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                    break;
            }
            return;
        }
        //            [self doBack];
        [FMUtils alertMessage:self.view msg:@"绑定成功" block:[StandCash iamDoneNext:self]];
    } phone:self.mobileNumber alipayAccount:self.textalbAccount.text alipayName:self.textalbName.text code:self.textCode.text];
}

- (IBAction)textEditDone:(UITextField *)sender {
    if (self.textalbAccount==sender) {
        [self.textalbName becomeFirstResponder];
        return;
    }
    if (self.textalbName==sender) {
        [self.textCode becomeFirstResponder];
        return;
    }
    if (self.textCode==sender) {
        [self okAction:sender];
        return;
    }
    [super textEditDone:sender];
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

@end

@implementation VCBindingMobile

- (void)viewDidLoad{
    [super viewDidLoad];
    self.type = 1;
#ifdef FanmoreDebug
    self.textMobile.text = @"18606509616";
#endif
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    LoginState* ls = [AppDelegate getInstance].loadingState.userData;
    __weak VerificationCodeController* wself = self;
    if ([ls.isBindMobile boolValue] && $safe(ls.mobile) && [ls.mobile isMobileNumber]) {
        [FMUtils alertMessage:self.view msg:NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.unbingdingmobilefirst",nil,[NSBundle mainBundle],@"请先解除绑定原手机号码。",nil) block:^{
            if (safeController(wself)) {
                [wself performSegueWithIdentifier:@"ToUnbind" sender:wself];
            }
        }];
        return;
    }
}

- (IBAction)okAction:(id)sender {
    __weak VerificationCodeController* wself = self;
#ifdef FanmoreJustDone
    LoginState* ls = [AppDelegate getInstance].loadingState.userData;
    [AppDelegate getInstance].currentUser.phone = @"18606509616";
    ls.isBindMobile = @1;
    ls.mobile = @"18606509616";
    [StandCash iamDoneNext:self]();
    return;
#endif
    
    if (!self.policySelected.selected) {
        [FMUtils alertMessage:self.view msg:NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.msg.service.agree",nil,[NSBundle mainBundle],@"请阅读并且勾选同意我们的隐私保护政策。",nil)];
        return;
    }
    if (self.textCode.hidden) {
        [FMUtils alertMessage:self.view msg:@"请先获取验证码"];
        return;
    }
    if (!$safe(self.textCode.text) || self.textCode.text.length<2) {
        [FMUtils alertMessage:wself.view msg:@"请输入验证码" block:^{
            [wself.textCode shake];
        }];
        return;
    }
    
    
    [[[AppDelegate getInstance]getFanOperations]bindMobile:Nil block:^(NSString *msg, NSError *error) {
        if ($safe(error)) {
            switch (error.code) {
                case 53003:
                {[FMUtils alertMessage:wself.view msg:[error FMDescription] block:^{
                        [wself.textMobile shake];
                    }];
                    break;}
                case 53006:
                case 53007:
                case 53012:
                {[FMUtils alertMessage:wself.view msg:[error FMDescription] block:^{
                        [wself.textCode shake];
                    }];
                    break;}
                default:
                    [FMUtils alertMessage:self.view msg:[error FMDescription]];
                    break;
            }
            return;
        }
        //            [self doBack];
        [FMUtils alertMessage:self.view msg:@"绑定成功" block:[StandCash iamDoneNext:self]];
    } phone:self.mobileNumber code:self.textCode.text];
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


- (IBAction)textEditDone:(UITextField *)sender {
    if (sender==self.textCode) {
        [self okAction:sender];
        return;
    }
    [super textEditDone:sender];
}


@end

@implementation VCUnbindingMobile

//-(void)doBack{
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.type = 1;
#ifdef FanmoreDebug
    self.textMobile.text = @"18606509616";
#endif
}

- (IBAction)okAction:(id)sender {
    __weak VerificationCodeController* wself = self;
    if (!self.policySelected.selected) {
        [FMUtils alertMessage:self.view msg:NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.msg.service.agree",nil,[NSBundle mainBundle],@"请阅读并且勾选同意我们的隐私保护政策。",nil)];
        return;
    }
    if (self.textCode.hidden) {
        [FMUtils alertMessage:self.view msg:@"请先获取验证码"];
        return;
    }
    if (!$safe(self.textCode.text) || self.textCode.text.length<2) {
        [FMUtils alertMessage:wself.view msg:@"请输入验证码" block:^{
            [wself.textCode shake];
        }];
        return;
    }
    [[[AppDelegate getInstance]getFanOperations]releaseBindMobile:Nil block:^(NSString *msg, NSError *error) {
        if ($safe(error)) {
            switch (error.code) {
                case 53003:
                {
                    [FMUtils alertMessage:wself.view msg:[error FMDescription] block:^{
                        [wself.textMobile shake];
                    }];
                    break;
                }
                case 53006:
                case 53007:
                case 53012:
                {
                    [FMUtils alertMessage:wself.view msg:[error FMDescription] block:^{
                        [wself.textCode shake];
                    }];
                    break;
                }
                case 52006:
                {
                    [FMUtils alertMessage:wself.view msg:[error FMDescription] block:^{
                        [wself.textMobile shake];
                    }];
                    break;
                }
                default:
                {
                    [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                    break;
                }
            }
            return;
        }
        // who popped me and I push it back
        [FMUtils alertMessage:self.view msg:@"解绑成功" block:^{
//            UIViewController* ui = self.navigationController.viewControllers[self.navigationController.viewControllers.count-2];
//            [self.navigationController popViewControllerAnimated:YES];
            //不会有人特地来解绑的
            [self performSegueWithIdentifier:@"ToMobile" sender:sender];
//            if ([ui isKindOfClass:[AccountViewController class]]) {
//                AccountViewController* ac = (AccountViewController*)ui;
//                [ac actionDone];
//            }
        }];
        //            [self doBack];
    } phone:self.mobileNumber code:self.textCode.text];
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


- (IBAction)textEditDone:(UITextField *)sender {
    if (sender==self.textCode) {
        [self okAction:sender];
        return;
    }
    [super textEditDone:sender];
}

@end