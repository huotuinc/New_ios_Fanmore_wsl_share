//
//  AccessCodeModel.h
//  Fanmore
//
//  Created by lhb on 15/12/3.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessCodeModel : NSObject

//"access_token" = "OezXcEiiBSKSxW0eoylIeG-2zFX_ZIuSaqX70S0VVszjCGVOZ65gAjST34AiyD4Fg1rm_9XiU2lLtKcFdS_GPH1cOwSBGWNNh-kOmOz70jZbEBpl4BnFmKWRk5C_lIK6nYyJ6Pk088FrdvjqQYu2wg";
//"expires_in" = 7200;
//openid = ow92RuL4PiGnKAikOV7iDFgvp92A;
//"refresh_token" = "OezXcEiiBSKSxW0eoylIeG-2zFX_ZIuSaqX70S0VVszjCGVOZ65gAjST34AiyD4F6dSvtZmZkBjBDoPjgQnYZQjgVGaUECzKG_5O-LLNK6eLiftmG4kSwwFRW_3ytIjL2mEQQJA-0_wSeQD2Cp6nBw";
//scope = "snsapi_userinfo";
//unionid = "o76SuuMeJjOp0Tnsr2AQnPD_0RKs";


@property(nonatomic,strong) NSString * access_token;
@property(nonatomic,assign) long  expires_in;
@property(nonatomic,strong) NSString * openid;
@property(nonatomic,strong) NSString * scope;
@property(nonatomic,strong) NSString * unionid;
@property(nonatomic,strong) NSString * refresh_token;


//自己加账号有效的时间
@property(nonatomic,strong)NSDate * expiresTime;

@end
