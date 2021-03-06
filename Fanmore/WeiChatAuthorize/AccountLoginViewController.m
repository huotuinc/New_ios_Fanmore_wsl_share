//
//  AccountLoginViewController.m
//  Fanmore
//
//  Created by lhb on 15/12/18.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import "AccountLoginViewController.h"
#import <UIView+BlocksKit.h>
#import "AppDelegate.h"
#import "WeiXinBackViewController.h"
#import "FMUtils.h"
#import <UIView+BlocksKit.h>
#import "WXApi.h"
#import "FMUtils.h"

@interface AccountLoginViewController ()

/**邀请码*/
@property (weak, nonatomic) IBOutlet UILabel *yaoQingMa;

/**手机号*/
@property (weak, nonatomic) IBOutlet UITextField *iphoneNumber;

/**描述*/
@property (weak, nonatomic) IBOutlet UILabel *des;

/**登录点击*/
- (IBAction)LoginButtonClick:(id)sender;

/**邀请码*/
@property (weak, nonatomic) IBOutlet UITextField *yaoqingText;

/**微信授权*/
@property (weak, nonatomic) IBOutlet UIImageView *weixinAuth;
/**游客授权*/
@property (weak, nonatomic) IBOutlet UIImageView *youke;

@end

@implementation AccountLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机注册登录";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // Do any additional setup after loading the view.
    
    self.yaoQingMa.layer.borderWidth = 2;
    self.yaoQingMa.layer.cornerRadius = 2;
    self.yaoQingMa.layer.masksToBounds = YES;
    self.yaoQingMa.layer.borderColor = [UIColor orangeColor].CGColor;
    
    self.yaoQingMa.userInteractionEnabled = YES;
    __weak AccountLoginViewController * wself = self;
    [self.yaoQingMa bk_whenTapped:^{
        [wself yanzhengma];
    }];
   
    
    //设置返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 20, 50, 30);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = left;
    
    
    
    self.weixinAuth.userInteractionEnabled = YES;
    //微信授权
    [self.weixinAuth bk_whenTapped:^{
        [wself WeiSouquan];
    }];
    
    self.youke.userInteractionEnabled = YES;
    //游客
    [self.youke bk_whenTapped:^{
        AppDelegate * ad = [AppDelegate getInstance];
        [[ad getFanOperations] visitorToLogin:nil block:^(id result, NSError *error) {
            if (!error) {
                UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                UIViewController* vc = [main instantiateInitialViewController];
                [wself presentViewController:vc animated:YES completion:^{
                    [wself removeFromParentViewController];
                }];
            }else {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            }
        }];
    }];
    
    
}


- (void)buttonAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)WeiSouquan{
    
    if (![WXApi isWXAppInstalled]) {
        [FMUtils alertMessage:self.view msg:@"请先安装微信"];
    }
}



- (void)yanzhengma{
    
    __weak AccountLoginViewController * wself = self;
    if (self.iphoneNumber.text.length) {
        [[[AppDelegate getInstance] getFanOperations] ToGetYaoqing:nil block:^(NSString *result, NSError *error) {
            if(error){
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            }
        } WithParam:self.iphoneNumber.text];
        [self settime];
    }else{
        UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"手机号不能为空" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [aaa show];
    }
    
}


- (void)settime{
    
    
    __weak AccountLoginViewController * wself = self;
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
                wself.yaoQingMa.text = @"验证码";
                
                //                [captchaBtn setTitle:@"" forState:UIControlStateNormal];
                //                [captchaBtn setBackgroundImage:[UIImage imageNamed:@"resent_icon"] forState:UIControlStateNormal];
                wself.yaoQingMa.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //                NSLog(@"____%@",strTime);
                wself.yaoQingMa.text = [NSString stringWithFormat:@"%@s",strTime];
                wself.yaoQingMa.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)LoginButtonClick:(id)sender {
    if(self.yaoqingText.text.length == 0){
        return;
    }else{
        __weak AccountLoginViewController * wself = self;
        [[[AppDelegate getInstance] getFanOperations] toLoginByPhoneNumber:nil block:^(id result, NSError *error) {
            //luohaibo
            LOG(@"%@",error);
            if (!error) {
                UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                UIViewController* vc = [main instantiateInitialViewController];
                [wself presentViewController:vc animated:YES completion:^{
                    [wself removeFromParentViewController];
                }];
            }else{
                UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                WeiXinBackViewController  *next = [main instantiateViewControllerWithIdentifier:@"WeiXinBackViewController"];
                next.callType =  1;
                next.PhoneNumber= self.iphoneNumber.text;
                next.codeNumber = self.yaoqingText.text;
                [self.navigationController pushViewController:next animated:YES];
            }
            
        } withPhoneNumber:self.iphoneNumber.text andYanzhenMa:self.yaoqingText.text];
        
        
    }
    
    
}

- (void)todoTheLaterThing{
    UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WeiXinBackViewController  *next = [main instantiateViewControllerWithIdentifier:@"WeiXinBackViewController"];
    [self.navigationController pushViewController:next animated:YES];
}
@end
