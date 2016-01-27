
//
//  WeiChatAuthorize.m
//  Fanmore
//
//  Created by lhb on 15/11/26.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import "WeiChatAuthorize.h"
#import "WXApi.h"
#import "UserLoginTool.h"
#import "AccessCodeModel.h"
#import "MJExtension.h"
#import "UserInfo.h"
#import "UserLoginTool.h"
#import "SecureHelper.h"
#import "NSObject+JSON.h"
#import "AppDelegate.h"
#import "Paging.h"
#import "WeiXinBackViewController.h"
#import "IphoneLoginViewController.h"
#import "AccountLoginViewController.h"
#import "WXApi.h"
#import "NavController.h"
#import <MBProgressHUD.h>
#import "FMUtils.h"
@interface WeiChatAuthorize ()<WXApiDelegate>


/**手机登录*/
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

/**微信授权登录*/
@property (weak, nonatomic) IBOutlet UIButton *WeiXinLongGIn;

@property (weak, nonatomic) MBProgressHUD * hud;

@end



@implementation WeiChatAuthorize



- (MBProgressHUD *)hud{
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // 隐藏时候从父控件中移除
        _hud.removeFromSuperViewOnHide = YES;
        // YES代表需要蒙版效果
        _hud.dimBackground = YES;
    }
    return _hud;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.loginButton.layer.cornerRadius = 4;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.WeiXinLongGIn.layer.cornerRadius = 4;
    self.WeiXinLongGIn.layer.masksToBounds = YES;
    self.WeiXinLongGIn.layer.borderWidth = 1;
    self.WeiXinLongGIn.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.loginButton.backgroundColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.004 alpha:1.000];
    
    //微信授权登录code返回
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenWithCode:) name:@"ToGetUserInfo" object:nil];
    //微信授权登录code返回
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xxxxaccessTokenWithCode) name:@"weixinauthfailure" object:nil];
    
}

- (void)xxxxaccessTokenWithCode{
    
    LOG(@"xxx");
}


#warning weixin
/**
 *  微信授权点击
 *
 *  @param sender <#sender description#>
 */
- (IBAction)WeiChatAQuthLogin:(id)sender {
    
    UIStoryboard * sto = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AccountLoginViewController * iphone =  [sto instantiateViewControllerWithIdentifier:@"AccountLoginViewController"];
    NavController * nav = [[NavController alloc] initWithRootViewController:iphone];
    
    [self presentViewController:nav animated:YES completion:nil];

}


- (IBAction)secondWeiXinLogin:(id)sender {
    [self WeiXinLog];
}


/**
 *  微信授权登录
 */
- (void)WeiXinLog{
    
    if ([WXApi isWXAppInstalled]) {
        //构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"123" ;
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendAuthReq:req viewController:self delegate:self];
    }else{
        [FMUtils alertMessage:self.view msg:@"请安装微信"];
    }
    
    
}





/**
 *  通过code获取accessToken
 *
 *  @param code code
 */

- (void)accessTokenWithCode:(NSNotification *) note
{
    //进行授权
    
    [self.hud show:YES];

    __weak WeiChatAuthorize * wself = self;
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeiXinAppKey,WeiXinAppSecret,note.userInfo[@"code"]];
    [UserLoginTool loginRequestGet:url parame:nil success:^(id json) {
       LOG(@"%@",json);
        AccessCodeModel * access_mode = [AccessCodeModel objectWithKeyValues:json];
        if (wself.loginType == 2) {
            UserInfo * user = [[UserInfo alloc] init];
            user.unionid = access_mode.unionid;
            [wself WeiXinQAuthSuccess:user];
        }else{
           [wself getUserInfo:access_mode];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}


/**
 *  微信授权登录后返回的用户信息
 */
-(void)getUserInfo:(AccessCodeModel *)aquth
{
    __weak WeiChatAuthorize * wself = self;
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"access_token"] = aquth.access_token;
    parame[@"openid"] = aquth.openid;
    [UserLoginTool loginRequestGet:@"https://api.weixin.qq.com/sns/userinfo" parame:parame success:^(id json) {
        LOG(@"%@",json);
        UserInfo * userInfo = [UserInfo objectWithKeyValues:json];
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName = [path stringByAppendingPathComponent:WXQAuthBringBackUserInfo];
        [NSKeyedArchiver archiveRootObject:userInfo toFile:fileName];
        /**控制器跳转*/
        [wself WeiXinQAuthSuccess:userInfo];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
}


/**
 *  微信授权登录成功
 *
 *  @param user <#user description#>
 */
- (void)WeiXinQAuthSuccess:(UserInfo *)user{
    __weak WeiChatAuthorize * wself = self;
    AppDelegate * ds =  [AppDelegate getInstance];
    [[ds getFanOperations] TOYanZhenRegistParames:nil block:^(id result, NSError *error) {
        LOG(@"%@----%@",result,[error FMDescription]);
        if (error) {
            NSString * se = error.description;
            NSRange ran = [se rangeOfString:@"90005"];
            if (ran.location != NSNotFound) {//不用注册
                [wself login];
            }else{//要注册
                 [wself todoTheLaterThing];
            }
            [self.hud hide:YES];
        }
    } withunoind:user.unionid];
}

- (void)login{
    __weak WeiChatAuthorize * wself = self;
    AppDelegate * ds =  [AppDelegate getInstance];
    [[ds getFanOperations] registerUser:nil block:^(LoginState * model, NSError *error) {
        LOG(@"%@",model);
        
        if (model) {

            UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController* vc = [main instantiateInitialViewController];
            self.view.window.rootViewController = vc;
        }else{
 
            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            [self.hud hide:YES];
        }

    } userName:nil password:nil code:nil invitationCode:SpecialYaoQingMa];
    
}

- (void)todoTheLaterThing{
       UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WeiXinBackViewController  *next = [main instantiateViewControllerWithIdentifier:@"WeiXinBackViewController"];
    [self.navigationController pushViewController:next animated:YES];
}

/**
 *  去掉
 */
- (void)dealloc{
    
    
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.hud hide:YES];
    
}
@end
