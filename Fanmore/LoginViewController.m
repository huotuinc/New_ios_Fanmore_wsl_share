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
 *  注册
 *
 *  @param sender <#sender description#>
 */
- (IBAction)login:(id)sender {
    
    
    if (self.InviteCode.text.length > 0) {
        NSMutableDictionary * parame = [NSMutableDictionary dictionary];
        parame[@"sex"] = [NSString stringWithFormat:@"%ld",(long)[self.user.sex integerValue]];
        parame[@"nickname"] = self.user.nickname;
        parame[@"openid"] = self.user.openid;
        parame[@"city"] = self.user.city;
        parame[@"country"] = self.user.country;
        parame[@"province"] = self.user.province;
        parame[@"headimgurl"] = self.user.headimgurl;
        parame[@"unionId"] = self.user.unionid;
        parame[@"invitationCode"] = @"WSL0LOVE";
        [[[AppDelegate getInstance] getFanOperations] toWeiChatLogin:nil block:^(NSString *result, NSError *error) {
            if (result) {//注册成功
                NSLog(@"%@",result);
            }else{//失败
                NSLog(@"%@",error.description);
            }
        } WithParam:parame];
    }else{
        
        
    }
    
    
}

@end
