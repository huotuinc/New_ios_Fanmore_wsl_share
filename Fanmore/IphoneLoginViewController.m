//
//  IphoneLoginViewController.m
//  Fanmore
//
//  Created by lhb on 15/12/8.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import "IphoneLoginViewController.h"
#import "LoginViewController.h"

#import "AppDelegate.h"
@interface IphoneLoginViewController ()<UIAlertViewDelegate>
/**手机号*/
@property (weak, nonatomic) IBOutlet UITextField *PhoneNumber;
/**验证码*/
@property (weak, nonatomic) IBOutlet UITextField *codeNumber;
/**获取验证码*/
@property (weak, nonatomic) IBOutlet UIButton *yanZhen;
/**获取邀请码*/
@property (weak, nonatomic) IBOutlet UITextField *yaoqingma;


@property (weak, nonatomic) IBOutlet UILabel *des;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;

/**注册按钮*/
@property (weak, nonatomic) IBOutlet UIButton *regerstBtn;

@end

@implementation IphoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup{
   
    self.title = @"注册登录";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.regerstBtn.layer.cornerRadius = 5;
    self.regerstBtn.layer.masksToBounds = YES;
    
    self.yanZhen.layer.borderWidth = 1;
    self.yanZhen.layer.borderColor = [UIColor colorWithRed:0.929 green:0.184 blue:0.098 alpha:1.000].CGColor;
    self.view1.layer.cornerRadius = 5;
    self.view1.layer.masksToBounds = YES;
    
    self.view2.layer.cornerRadius = 5;
    self.view2.layer.masksToBounds = YES;
    
    self.view3.layer.cornerRadius = 5;
    self.view3.layer.masksToBounds = YES;
    
    self.des.hidden = YES;
}

/**
 *  验证码点击
 *  sms 参数手机号
 *  @param sender <#sender description#>
 */
- (IBAction)CodeYanZhenClick:(id)sender {
    
    
    self.des.hidden = NO;
    
    self.des.text = [NSString stringWithFormat:@"验证码将已发送，60S后可重新发送"];
    self.des.textColor = [UIColor colorWithWhite:0.325 alpha:1.000];
    
    if (self.PhoneNumber.text.length) {
        
        [[[AppDelegate getInstance] getFanOperations] ToGetYaoqing:nil block:^(NSString *result, NSError *error) {
            NSLog(@"%@----%@",result,error.description);
        } WithParam:self.PhoneNumber.text];
        
        [self settime];
    }else{
        
        UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"手机号不能为空" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [aaa show];
    }

}


/**下一步*/
- (IBAction)NextStep:(id)sender {
    
    
    __weak IphoneLoginViewController * wself = self;
    if (self.yaoqingma.text.length) {
        
        AppDelegate * ad = [AppDelegate getInstance];
        [[ad getFanOperations] toSouji:nil block:^(LoginState * ss, NSError *error) {
            if (!error) {
                UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                UIViewController* vc = [main instantiateInitialViewController];
                [wself presentViewController:vc animated:YES completion:^{
                    [wself removeFromParentViewController];
                }];
            }
        } WithParam:self.PhoneNumber.text withYanzhen:self.codeNumber.text withYaoqingma:self.yaoqingma.text];

        
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (void)settime{
    
    
    __weak IphoneLoginViewController * wself = self;
    /*************倒计时************/
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.yanZhen setTitle:@"验证码" forState:UIControlStateNormal];
                
                //                [captchaBtn setTitle:@"" forState:UIControlStateNormal];
                //                [captchaBtn setBackgroundImage:[UIImage imageNamed:@"resent_icon"] forState:UIControlStateNormal];
                self.yanZhen.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //                NSLog(@"____%@",strTime);
                 [self.yanZhen setTitle:[NSString stringWithFormat:@"%@s",strTime]forState:UIControlStateNormal];
                wself.yanZhen.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
