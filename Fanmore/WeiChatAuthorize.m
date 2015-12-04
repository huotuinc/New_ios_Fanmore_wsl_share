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


@interface WeiChatAuthorize ()<WXApiDelegate>




@end



@implementation WeiChatAuthorize


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
    
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendAuthReq:req viewController:self delegate:self];
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
        NSLog(@"getUserInfo%@",json);
        UserInfo * userInfo = [UserInfo objectWithKeyValues:json];
        [wself toPostWeiXinMessageToServerForLogin:userInfo];
//        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSString *fileName = [path stringByAppendingPathComponent:WeiXinUserInfo];
//        [NSKeyedArchiver archiveRootObject:userInfo toFile:fileName];
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
}


- (void)toPostWeiXinMessageToServerForLogin:(UserInfo *)userInfo{
    
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"sex"] = [NSString stringWithFormat:@"%ld",(long)[userInfo.sex integerValue]];
    parame[@"nickname"] = userInfo.nickname;
    parame[@"openid"] = userInfo.openid;
    parame[@"city"] = userInfo.city;
    parame[@"country"] = userInfo.country;
    parame[@"province"] = userInfo.province;
    parame[@"headimgurl"] = userInfo.headimgurl;
    parame[@"unionid"] = userInfo.unionid;
    id<FanOperations> fos = [[AppDelegate getInstance] getFanOperations];
    [fos toWeiChatLogin:nil block:^(NSString *result, NSError *error) {
        if (result.length) {
            NSLog(@"%@--",result);
        }else{
            
            NSLog(@"%@--",error.description);
        }
        
    } WithParam:parame];
    
    
}


/**
 *  去掉
 */
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}
@end
