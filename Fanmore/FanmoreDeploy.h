//
//  FanmoreDeploy.h
//  Fanmore
//
//  Created by Cai Jiang on 4/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#ifndef Fanmore_FanmoreDeploy_h
#define Fanmore_FanmoreDeploy_h

#define Fanmore_RSA_PK_Base64 @"MIIDkzCCAvygAwIBAgIJAJZodoTl9rZIMA0GCSqGSIb3DQEBBQUAMIGOMQswCQYDVQQGEwJjbjERMA8GA1UECBMIWmhlamlhbmcxETAPBgNVBAcTCEhhbmd6aG91MQ4wDAYDVQQKEwVIdW90dTEQMA4GA1UECxMHRmFubW9yZTEQMA4GA1UEAxMHRmFubW9yZTElMCMGCSqGSIb3DQEJARYWaHVvdHVfaGFuZ3pob3VAMTYzLmNvbTAeFw0xNDA0MTUwNjE0MTVaFw0xNDA1MTUwNjE0MTVaMIGOMQswCQYDVQQGEwJjbjERMA8GA1UECBMIWmhlamlhbmcxETAPBgNVBAcTCEhhbmd6aG91MQ4wDAYDVQQKEwVIdW90dTEQMA4GA1UECxMHRmFubW9yZTEQMA4GA1UEAxMHRmFubW9yZTElMCMGCSqGSIb3DQEJARYWaHVvdHVfaGFuZ3pob3VAMTYzLmNvbTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA1K2eMCDWO53Q/YAGioQ3OyVRSObM6laSJ6422Z4kDv+eoBXVqy6OdYw0F9FFAAhLvLbcq/0+PK14ViP4lOJGgufhNVsfywXpvuP/sBNPZqXeOTI/DJZhbMsxv+ZzoIsIWVKpmELuEYpqc6qrl10fxNfZ6oIlRpT+lZ3r/weEjmsCAwEAAaOB9jCB8zAdBgNVHQ4EFgQUcl2LsdJfzRG8r9sVg1gQ+BOZcUYwgcMGA1UdIwSBuzCBuIAUcl2LsdJfzRG8r9sVg1gQ+BOZcUahgZSkgZEwgY4xCzAJBgNVBAYTAmNuMREwDwYDVQQIEwhaaGVqaWFuZzERMA8GA1UEBxMISGFuZ3pob3UxDjAMBgNVBAoTBUh1b3R1MRAwDgYDVQQLEwdGYW5tb3JlMRAwDgYDVQQDEwdGYW5tb3JlMSUwIwYJKoZIhvcNAQkBFhZodW90dV9oYW5nemhvdUAxNjMuY29tggkAlmh2hOX2tkgwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQUFAAOBgQAtAQ8FTZFwcSXANqx702pfVa9ACMiesNFjzQl8vOlUyzLd7FmuQFUp8za5ZkvD3qYF1rUOJdWHCk7C4kfFHmfMOkfvrs4x37ocKP4mmCTWY5cRbSP9QJ1a1aD9yZRKAAUPT0ndrUYabe2ETVWuvnCCgIRyziwWBvXJ2cyE8/lNSA=="

#define FMWXSELF 1

//huotu 91 weiphone gj xuexiao1
//#define FM_JailBreak 1
//#define FM_QD "huotu"

//#define FMROOT "http://192.168.0.208:100"
//#define FMROOT "http://192.168.1.58:99"
#define FMROOT "http://taskapi.silk08.com"

//"http://taskapi.silk08.com"
//"http://taskapi.fancat.cn"
//"http://api.fanmore.cn"

//
#define FanmoreDebug 1

//#define FanmoreMockLocalDate 1
// 模拟 存在今日预告任务
//#define FanmoreMockTodayNotice 1
// 模拟 联盟任务
//#define FanmoreMockUnited 935
//#define FanmoreMockYYNOE 1

//#define FanmoreMockNotify 1
//#define FanmoreMockRanking 1

//模拟获得任务预告通知
//#define FanmoreDebugMockRemoteTask @"-0-"
//模拟获得web消息通知
//#define FanmoreDebugMockRemoteURL @"http://www.baidu.com"
//模拟任务尚未开始通知 如果不设置则认为已开始 并且是获得的第一个Task
//#define FanmoreDebugMockRemoteTaskPreviewURL @"http://www.baidu.com"

//#define FanmoreMockMall 1
/**
 *  模拟师徒系统接口数据
 */
//#define FanmoreMockMaster
//#define FanmoreMockDisaster @"http://www.baidu.com"
/**
 *  测试空数据显示那只猫
 */
//#define FanmoreCatdata 1
/**
 *  如果设置该值 那么修改支付宝绑定 手机绑定 都可以一键完成
 */
//#define FanmoreJustDone 1
//#define FanmoreDebugForceUpdate 1
//#define FanmoreDebugIMEI 1
//#define FanmoreDebugCashRightNow 1
//#define FanmoreDebugMockCashList 1
//#define FanmoreDebugVersion 1


//#define FanmoreMock 1



#endif
