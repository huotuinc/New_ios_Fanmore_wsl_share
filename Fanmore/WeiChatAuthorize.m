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



@interface WeiChatAuthorize ()<WXApiDelegate>




@end



@implementation WeiChatAuthorize


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

- (void)accessTokenWithCode:(NSString * )code
{
    
    //进行授权
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"123",@"xxxx",code];
    [UserLoginTool loginRequestGet:url parame:nil success:^(id json) {
       
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}

@end
