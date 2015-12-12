//
//  IphoneLoginViewController.m
//  Fanmore
//
//  Created by lhb on 15/12/8.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import "IphoneLoginViewController.h"
#import "LoginViewController.h"
@interface IphoneLoginViewController ()
/**手机号*/
@property (weak, nonatomic) IBOutlet UITextField *PhoneNumber;
/**验证码*/
@property (weak, nonatomic) IBOutlet UITextField *codeNumber;
/**获取验证码*/
@property (weak, nonatomic) IBOutlet UIButton *yanZhen;

@end

@implementation IphoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup{
   
    
}

/**
 *  验证码点击
 *  sms 参数手机号
 *  @param sender <#sender description#>
 */
- (IBAction)CodeYanZhenClick:(id)sender {
    
    NSLog(@"xxxx");
}


/**下一步*/
- (IBAction)NextStep:(id)sender {
    
    LoginViewController * Register = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:Register animated:YES];
    
}



@end
