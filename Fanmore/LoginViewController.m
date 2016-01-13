//
//  LoginViewController.m
//  Fanmore
//
//  Created by lhb on 15/12/4.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//  邀请码注册控制器

#import "LoginViewController.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "FMUtils.h"
#import "WXApi.h"
@interface LoginViewController ()


@property (nonatomic,strong) UserInfo * user;
/**邀请码*/
@property (weak, nonatomic) IBOutlet UITextField *InviteCode;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView * left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    left.image = [UIImage imageNamed:@"TextField"];
    self.InviteCode.leftViewMode = UITextFieldViewModeAlways;
    self.InviteCode.leftView = left;
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)setup{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:WXQAuthBringBackUserInfo];
    UserInfo * user = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    self.user = user;
}

/**
 *  注册 luohaibo
 *
 *  @param sender <#sender description#>
 */
- (IBAction)login:(id)sender {
    if (!self.InviteCode.text.length){
        [FMUtils alertMessage:self.view msg:@"邀请码不能为空"];
        return;
    }
    __weak LoginViewController * wself = self;
    AppDelegate * ds =  [AppDelegate getInstance];
    
    if ([WXApi isWXAppInstalled]) {
        //    [MBProgressHUD showMessage:nil];
        [[ds getFanOperations] registerUser:nil block:^(LoginState * model, NSError *error) {
            if (!error) {
                UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                UIViewController* vc = [main instantiateInitialViewController];
                self.view.window.rootViewController = vc;
            }else{
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            }
            //        [MBProgressHUD hideHUD];
        } userName:nil password:nil code:nil invitationCode:self.InviteCode.text];
    }else{
        AppDelegate * ad = [AppDelegate getInstance];
        [[ad getFanOperations] toSouji:nil block:^(LoginState * ss, NSError *error) {
            if (!error) {
                UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                UIViewController* vc = [main instantiateInitialViewController];
                [wself presentViewController:vc animated:YES completion:^{
                    [wself removeFromParentViewController];
                }];
            }else{
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            }
        } WithParam:_PhoneNumber withYanzhen:_codeNumber withYaoqingma:self.InviteCode.text];
        
    }


    
}


@end
