//
//  GlodMallUserModel.h
//  Fanmore
//
//  Created by lhb on 15/12/16.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlodMallUserModel : NSObject
/**
 IsDelete = 0;
 belongOne = 0;
 coerceloseefficacy = 0;
 customerid = 3721;
 levelID = 295;
 levelName = "\U4f1a\U5458\U7b49\U7ea71";
 password = 00979d5763c1b4334a51533891a9c3e2;
 userType = 0;
 userid = 9947;
 username = C8FJ36GC49V;
 wxHeadImg = "";
 wxNickName = Luohaibo;
 wxOpenId = "app_ow92RuL4PiGnKAikOV7iDFgvp92A";
 wxUnionId = "o76SuuMeJjOp0Tnsr2AQnPD_0RKs";
 */

@property(nonatomic,strong)NSNumber *IsDelete;
@property(nonatomic,strong)NSNumber *belongOne;
@property(nonatomic,strong)NSNumber *coerceloseefficacy;
@property(nonatomic,copy)NSString *levelName;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)NSNumber *userType;
@property(nonatomic,strong)NSNumber *userid;
@property(nonatomic,copy)NSString *wxHeadImg;
@property(nonatomic,copy)NSString *wxNickName;
@property(nonatomic,copy)NSString *wxOpenId;
@property(nonatomic,copy)NSString *wxUnionId;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,strong)NSNumber *customerid;
@end
