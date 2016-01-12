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
    
    
    __weak LoginViewController * wself = self;
    AppDelegate * ds =  [AppDelegate getInstance];
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

    
}

@end
