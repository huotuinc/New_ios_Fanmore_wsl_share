
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

@interface WeiChatAuthorize ()<WXApiDelegate>




@end



@implementation WeiChatAuthorize


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    //微信授权登录code返回
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenWithCode:) name:@"ToGetUserInfo" object:nil];
    
}


/**
 *  微信授权点击
 *
 *  @param sender <#sender description#>
 */
- (IBAction)WeiChatAQuthLogin:(id)sender {
    
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
        
        if (self.loginType == 1) {//注册
            UIStoryboard * sto = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            IphoneLoginViewController * iphone =  [sto instantiateViewControllerWithIdentifier:@"IphoneLoginViewController"];
            [self presentViewController:iphone animated:YES completion:nil];
        }else{//登录
            
        }
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
    __weak WeiChatAuthorize * wself = self;
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeiXinAppKey,WeiXinAppSecret,note.userInfo[@"code"]];
    [UserLoginTool loginRequestGet:url parame:nil success:^(id json) {
       NSLog(@"%@",json);
        AccessCodeModel * access_mode = [AccessCodeModel objectWithKeyValues:json];
        [wself getUserInfo:access_mode];
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
        if (error) {
            NSString * se = error.description;
            NSRange ran = [se rangeOfString:@"90005"];
            if (ran.location != NSNotFound) {//没注册
                [wself login];
            }else{//注册
                [wself todoTheLaterThing];
            }
        }
        
    } withunoind:user.unionid];
}

- (void)login{
    AppDelegate * ds =  [AppDelegate getInstance];
    [[ds getFanOperations] registerUser:nil block:^(LoginState * model, NSError *error) {
        NSLog(@"%@",model);
        if (model) {
            UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController* vc = [main instantiateInitialViewController];
            self.view.window.rootViewController = vc;
        }
        //        [MBProgressHUD hideHUD];
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
@end
