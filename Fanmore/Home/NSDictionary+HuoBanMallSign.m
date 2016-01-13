//
//  NSDictionary+HuoBanMallSign.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/10/13.
//  Copyright (c) 2015年 HT. All rights reserved.
//  网页链接签名   SISJAVAAPPID

#import "NSDictionary+HuoBanMallSign.h"
#import "MD5Encryption.h"
#import "UserInfo.h"
#import "MallUser.h"
#import "AppDelegate.h"
#import "LoadingState.h"
#import "WXApi.h"
@implementation NSDictionary (HuoBanMallSign)

+ (NSMutableDictionary *)asignWithMutableDictionary:(NSMutableDictionary *)dict{
    
    
//    dict[@"customerid"] = HuoBanMallBuyApp_Merchant_Id;
//    NSDate * timestamp = [[NSDate alloc] init];
//    NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[timestamp timeIntervalSince1970] * 1000];  //转化为UNIX时间戳
//    dict[@"appid"] = HuoBanMallBuyAppId;
//    dict[@"timestamp"] = timeSp;
//    dict[@"operation"]=@"app";
//    //计算asign参数
//    NSArray * arr = [dict allKeys];
//    [arr enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        NSString * cc = [dict objectForKey:obj];
//        if (cc.length==0) {
////            NSLog(@"%@",cc);
//            [dict removeObjectForKey:obj];
//        }
//        
//    }];
//    //计算asign参数
//    arr = [dict allKeys];
//    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
//        return [obj1 compare:obj2] == NSOrderedDescending;
//    }];
//    NSMutableString * signCap = [[NSMutableString alloc] init];
//    //进行asign拼接
//    for (NSString * dicKey in arr) {
//        [signCap appendString:[NSString stringWithFormat:@"%@=%@&",dicKey,[dict valueForKey:dicKey]]];
//    }
//    NSString * aa = [signCap substringToIndex:signCap.length-1];
//    
//    NSString * cc  = [NSString stringWithFormat:@"%@%@",aa,HuoBanMallBuyAppSecrect];
//    dict[@"sign"] = [MD5Encryption md5by32:cc];
    return dict;
}




+ (NSString *)ToSignUrlWithString:(NSString *)urlStr{
    NSMutableString * signUrl = [NSMutableString stringWithString:urlStr]; //元素url
    NSDate * timestamp = [[NSDate alloc] init];
    NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[timestamp timeIntervalSince1970] * 1000];  //转化为UNIX时间戳
    [signUrl appendFormat:@"&appid=%@",HuoBanMallBuyAppId];
    [signUrl appendFormat:@"&timestamp=%@",timeSp];
    
    NSString * bu = nil;
    if ([WXApi isWXAppInstalled]) {
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString * file = [path stringByAppendingPathComponent:ChoneMallAccount];
        MallUser * user =  [NSKeyedUnarchiver unarchiveObjectWithFile:file];
        bu = [NSString stringWithFormat:@"%@",user.userid];
    }else{
        
        bu = [NSString stringWithFormat:@"%@",[AppDelegate getInstance].loadingState.userData.mallUserId];
    }
    
    LOG(@"%@",bu);
    [signUrl appendFormat:@"&buserid=%@",bu];
    [signUrl appendFormat:@"&unionid=%@",[AppDelegate getInstance].loadingState.userData.unionId];
    NSRange new = [signUrl rangeOfString:@"?"];
    
    if (new.location != NSNotFound) {
        
        NSString * newUrlStr = [signUrl substringFromIndex:new.location+1];
        NSArray * separeArray = [newUrlStr componentsSeparatedByString:@"&"]; //？后面的东西
        NSMutableArray * keys = [NSMutableArray array];
        for (int i = 0; i<separeArray.count; i++) {//参数的键
            NSString * sr =  separeArray[i];
            NSArray *keyArray = [sr componentsSeparatedByString:@"="];
            [keys addObject:keyArray[0]];
        }
        
        
        NSMutableArray * sssdasdasd = [NSMutableArray array];
        for (int i = 0; i<keys.count; i++) {
            NSString * sss =  separeArray[i];
            NSString * ccc =  keys[i];
            NSString * aaaaaaaa = [sss stringByReplacingOccurrencesOfString:keys[i] withString:[ccc lowercaseString]];
            [sssdasdasd addObject:aaaaaaaa];
        }
        NSArray * arr = [sssdasdasd sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
            return [obj1 compare:obj2] == NSOrderedDescending;
        }];
        NSMutableString * signCap = [[NSMutableString alloc] init];
        for (int i = 0; i<arr.count; i++) {
            if (i == 0) {
                [signCap appendString:arr.firstObject];
            }else{
                [signCap appendFormat:@"&%@",arr[i]];
            }
        }
        [signCap appendFormat:@"%@",HuoBanMallBuyAppSecrect];
        NSString * sign = [MD5Encryption md5by32:signCap];
        [signUrl appendFormat:@"&sign=%@",sign];
        return signUrl;
    }
    return nil;
}
@end
