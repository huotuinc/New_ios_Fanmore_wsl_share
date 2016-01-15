//
//  AppDelegate.m
//  Fanmore
//
//  Created by Cai Jiang on 1/6/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "AppDelegate.h"

#import "WeiChatAuthorize.h"


#import "NSDictionary+RemotePush.h"
#import "RemoteMessageController.h"
#import "ASIHTTPRequest.h"
#import "TaskComingController.h"
#ifdef FanmoreMock
#import "MockFanOperations.h"
#else
#import "HttpFanOperations.h"
#endif
#import "FMUtils.h"
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLGeocoder.h>
#import "RegexKitLite.h"
#import "MineMenuController.h"
#import "TaskListController.h"
#import "LocatedHelper.h"

#import "ShareSDK/Extend/WeChatSDK/WXApi.h"
#import "ShareSDK/Extend/QQConnectSDK/TencentOpenAPI.framework/Headers/QQApiInterface.h"
#import "ShareSDK/Extend/QQConnectSDK/TencentOpenAPI.framework/Headers/TencentOAuth.h"

#import "iRate.h"
#import "MJExtension.h"
@interface AppDelegate()<UIAlertViewDelegate,WXApiDelegate>

//@property(weak) UINavigationController* lastNavigation;
@property UIWindow* lastKeyWindow;

@property NSDictionary* lastRecivedUserInfo;

@property NSString* deviceToken;

-(void)savePreferences;

@property(strong) id<FanOperations> fanOperations;

@property NSString* preferencesFile;
@property CLLocationManager* locating;
@property id<CitycodeHandler> citycodeHandler;

@end

@implementation AppDelegate

+ (void)initialize
{
    [iRate sharedInstance].messageTitle = @"评个分呗";
    [iRate sharedInstance].message = @"苦逼攻城狮跪求大神给好评 Orz..";
    [iRate sharedInstance].rateButtonLabel = @"好的，赏你了";
    
//    [iRate sharedInstance].previewMode = YES;
    //example configuration
//    [iVersion sharedInstance].appStoreID = 355313284;
#ifdef FanmoreDebugVersion
    [iVersion sharedInstance].previewMode = YES;
#endif
#ifdef FM_JailBreak
    [iVersion sharedInstance].remoteVersionsPlistURL = $str(@"%@/iosappversions.txt",@FMROOT);
//    [iVersion sharedInstance].remoteVersionsPlistURL = @"http://192.168.1.115:8080/iosappversions.txt";
#endif
//    [iVersion sharedInstance].appStoreCountry=@"CN";
}

#ifdef FM_JailBreak
-(BOOL)iVersionShouldOpenAppStore{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[self getUpdateURL]]];
    return NO;
}
#endif

-(void)userDidnotUpdateVersion:(NSString *)version{
    if (self.forceUpdate) {
        [FMUtils alertMessage:self.window msg:@"分红已经切换到赚钱更快的模式，请尽快更新。" block:^{
            [[iVersion sharedInstance] openAppPageInAppStore];
        }];
    }
}

- (void)iVersionUserDidRequestReminderForUpdate:(NSString *)version{
    [self userDidnotUpdateVersion:version];
}
- (void)iVersionUserDidIgnoreUpdate:(NSString *)version{
    [self userDidnotUpdateVersion:version];
}

@synthesize resoucesHome;
@synthesize fanOperations;
@synthesize httpCache;

@synthesize industryList;
@synthesize incomeList;
@synthesize favoriteList;

@synthesize currentUser;

-(id<FanOperations>)getFanOperations{
    return fanOperations;
}

/**
 *	@brief	托管模式下的初始化平台
 */
- (void)initializePlatForTrusteeship
{
    //导入QQ互联和QQ好友分享需要的外部库类型，如果不需要QQ空间SSO和QQ好友分享可以不调用此方法
    [ShareSDK importQQClass:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    //导入人人网需要的外部库类型,如果不需要人人网SSO可以不调用此方法
//    [ShareSDK importRenRenClass:[RennClient class]];
    
    //导入腾讯微博需要的外部库类型，如果不需要腾讯微博SSO可以不调用此方法
//    [ShareSDK importTencentWeiboClass:[WeiboApi class]];
    
    //导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK importWeChatClass:[WXApi class]];
    
    //导入Google+需要的外部库类型，如果不需要Google＋分享可以不调用此方法
//    [ShareSDK importGooglePlusClass:[GPPSignIn class]
//                         shareClass:[GPPShare class]];
    
    //导入Pinterest需要的外部库类型，如果不需要Pinterest分享可以不调用此方法
//    [ShareSDK importPinterestClass:[Pinterest class]];
    
    //导入易信需要的外部库类型，如果不需要易信分享可以不调用此方法
//    [ShareSDK importYiXinClass:[YXApi class]];
}

+(void)connectAllShareManly{
//    [ShareSDK connectSinaWeiboWithAppKey:@"3653231385" appSecret:@"4ecff164368e17c8a417ef49a6e755ad" redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    [ShareSDK connectSinaWeiboWithAppKey:@"1994677353" appSecret:@"0783d8dd1f0eb5a45687cde79aa10108" redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    //        [ShareSDK connectWeChatTimelineWithAppId:@"wx1424e93fb903ef33" wechatCls:[WXApi class]];
    
    //self.preferences[@"newWeixinKey"]
    NSString* wxkey = [AppDelegate getInstance].preferences[@"newWeixinKey"];
    
    //收工设置微信
#ifdef FMWXSELF
    BOOL wxsucess;
    if ($safe(wxkey) && wxkey.length>3) {
        wxsucess = [WXApi registerApp:wxkey];
    }else{
        wxsucess = [WXApi registerApp:WeiXinAppKey];
    }    
//    NSLog(@"wxsucess %d %d",wxsucess, [WXApi isWXAppSupportApi]);
//    [WXApi openWXApp];
    
#else
#endif
    
    if ($safe(wxkey) && wxkey.length>3) {
        [ShareSDK connectWeChatTimelineWithAppId:wxkey wechatCls:[WXApi class]];
    }else{
        [ShareSDK connectWeChatTimelineWithAppId:WeiXinAppKey wechatCls:[WXApi class]];
    }
    
    if ($safe(wxkey) && wxkey.length>3) {
        [ShareSDK connectWeChatSessionWithAppId:wxkey wechatCls:[WXApi class]];
    }else{
        [ShareSDK connectWeChatSessionWithAppId:WeiXinAppKey wechatCls:[WXApi class]];
    }
    
    
//    [ShareSDK connectQZoneWithAppKey:@"101051996" appSecret:@"535b920eebcf192cb0da960996ff72d2" qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    [ShareSDK connectQZoneWithAppKey:@"101066212" appSecret:@"09ef5bfed097b682a83b147d46e46a5a" qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    //连接其他
    [ShareSDK connectSMS];
    [ShareSDK connectMail];
    
    [ShareSDK connectQQWithQZoneAppKey:@"101066212" qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    

    [WXApi registerApp:WeiXinAppKey withDescription:@"wsl"];
    
    
////    [iVersion sharedInstance].delegate = self;
//    self.launchTime = [[NSDate date] timeIntervalSince1970];
//    NSString *sversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:sversion];
//    //91ios weiphone fanmore
//    NSString* qd = nil;
//#ifdef FM_QD
//    qd = $str(@"%@ios",@FM_QD);
//#endif
//    [MobClick startWithAppkey:@"52faffcf56240bc21a023179" reportPolicy:SEND_INTERVAL   channelId:qd];
//#ifdef FanmoreDebug
////    [MobClick setLogEnabled:YES];
//#endif
//    
//#ifndef FMShareTool
////    [ShareSDK importWeChatClass:[WXApi class]];
////    [ShareSDK importQQClass:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
//    
//    BOOL useAppTrusteeship = NO;
//    [ShareSDK registerApp:@"19b4b4d45192" useAppTrusteeship:useAppTrusteeship];
//    if (useAppTrusteeship) {
//        [self initializePlatForTrusteeship];
//        [ShareSDK waitAppSettingComplete:^{
//            NSLog(@"注册完成！");
//        }];
//    }else{
//        [AppDelegate connectAllShareManly];
//    }
//    [ShareSDK registerApp:@"1782a62f5430" useAppTrusteeship:useAppTrusteeship];
//
//#endif

    [self startLocate:[[LocatedHelper alloc] init]];
    // Override point for customization after application launch.
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    UINavigationBar* tnb = [UINavigationBar appearance];
    if (version>=7) {
        [tnb setBarTintColor:fmMainColor];
    }else{
        [tnb setTintColor:fmMainColor];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
#ifdef FMShareTool
    [[ShareTool toolWithType:TShareTypeWeixiTimeline identification:WeiXinAppKey] checkSupport:YES];
#endif

//    UIRemoteNotificationTypeBadge   = 1 << 0,
//    UIRemoteNotificationTypeSound   = 1 << 1,
//    UIRemoteNotificationTypeAlert   = 1 << 2,
//    UIRemoteNotificationTypeNewsstandContentAvailability = 1 << 3,
    if (version>=8) {
#if __IPHONE_8_0
        [application registerForRemoteNotifications];
//        [application currentUserNotificationSettings].types
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:
                                                       (UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeAlert)  categories:nil]];
#endif
    }else
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert];
    
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        //处理本地通知
        NSLog(@"localnotif");
    }
    
#ifdef FanmoreDebugMockRemoteURL
    NSMutableDictionary* myo = [NSMutableDictionary dictionary];
    [myo setRemotePushURL:FanmoreDebugMockRemoteURL];
    
    launchOptions = @{UIApplicationLaunchOptionsRemoteNotificationKey: myo};
#endif
    
#ifdef FanmoreDebugMockRemoteTask
    NSMutableDictionary* myo = [NSMutableDictionary dictionary];
    [myo setRemotePushTaskId:FanmoreDebugMockRemoteTask];
    
    launchOptions = @{UIApplicationLaunchOptionsRemoteNotificationKey: myo};
#endif
    
    self.launchOptions = launchOptions;
    application.applicationIconBadgeNumber = 0;
    
    return YES;
}

-(void) onResp:(BaseResp*)resp
{
    
    /*ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效                         state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            //授权成功的code
            NSDictionary * dict = @{@"code":code};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ToGetUserInfo" object:nil userInfo:dict];
            return;
        }else if(aresp.errCode == -4 || aresp.errCode == -2){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"weixinauthfailure" object:nil];
        }
    }
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle = nil;
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        return;
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败"];
                //                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    LOG(@"will be active");
    __weak AppDelegate* wself = self;
#ifndef FanmoreDebug
    if ([[NSDate date] timeIntervalSince1970]-self.launchTime>300){
#endif
        [self.fanOperations loading:nil block:^(UIImage *state, NSError *error) {
            
//            if ([wself.loadingState.loginStatus integerValue] == 0) {
//                UIStoryboard * mainS = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                WeiChatAuthorize * WeiChart = [mainS instantiateViewControllerWithIdentifier:@"WeiChatAuthorize"];
//                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:WeiChart];
//                wself.window.rootViewController = nav;
////                [self.window makeKeyAndVisible];
//            }else{
//                UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//                UIViewController* vc = [main instantiateInitialViewController];
//                wself.window.rootViewController = vc;
//                
//            }
            
            
            if ($safe(error)) {
                [FMUtils alertMessage:wself.window.viewForBaselineLayout msg:error.FMDescription];
            }
        } userName:[self getLastUsername] password:[self getLastPassword]];
#ifndef FanmoreDebug
    }
#endif
    
    [self userDidnotUpdateVersion:nil];
//    [self.fanOperations load]
//    [self.fanOperations userInfo:nil block:^(UserInformation *user) {
//        if ($safe(user)){
//            self.currentUser = user;
//        }
//    }];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark 用户名，密码，定位信息的管理

-(void)logout:(UIViewController*)controll{
//    self.loadingState.loginStatus = @0;
//    self.loadingState.userData.loginCode=@"";
    [self.loadingState loginAs:nil];
    self.currentUser = nil;
    //寻找Mine
    MineMenuController* mmc;
    if ([controll isKindOfClass:[MineMenuController class]]) {
        mmc = (MineMenuController*)controll;
    }else{
        for (id c in controll.navigationController.viewControllers) {
            if ([c isKindOfClass:[MineMenuController class]]) {
                mmc = c;
            }
        }
    }
    
    if ($safe(mmc)) {
        [mmc logout];
    }else{
        TaskListController* tlc;
        if ([controll isKindOfClass:[TaskListController class]]) {
            tlc = (TaskListController*)controll;
        }else{
            for (id c in controll.navigationController.viewControllers) {
                if ([c isKindOfClass:[TaskListController class]]) {
                    tlc = c;
                }
            }
        }
        
        if ($safe(tlc)) {
            [tlc clickRefresh:nil];
        }else
            NSLog(@"登出时无法定位指定Controller，可能导致临时逻辑错误。");
    }
}

-(void)attemptPassword:(UIViewController*)controller wrong:(BOOL)wrong  block:(void (^)())block{
    if (!wrong) {
        self.preferences[@"wrongPasswordTimes"] = @0;
        [self savePreferences];
    }else{
        NSNumber* times = [self.preferences $for:@"wrongPasswordTimes"];
        if (!$safe(times)) {
            times = @0;
        }
        times = $int([times intValue]+1);
        self.preferences[@"wrongPasswordTimes"] = times;
        [self savePreferences];
        
        if ([times intValue]>=5) {
            //执行注销 并且返回到TaskList界面
            LOG(@"关禁闭！！");
            [self logout:controller];
            id mmcc =controller.navigationController.viewControllers[0];
            [controller.navigationController popToRootViewControllerAnimated:YES];
            [mmcc clickHome];
            
        }else{
            //
            [FMUtils alertMessage:controller.view msg:$str(@"密码错误 剩余%d尝试机会",(5-[times intValue])) block:block];
        }
        
    }
    
}

-(BOOL)taskIsTop:(NSNumber*)taskId{
    if (!$safe(self.topTaskIds)) {
        return NO;
    }
    NSString* tid = [taskId stringValue];
    return [self.topTaskIds containsObject:tid];
}

-(void)storeShareTime{
    self.preferences[@"storeShareTime"] = $double([[NSDate date] timeIntervalSince1970]);
    [self savePreferences];
}
/**
 *  多少时间以后可以发送
 *
 *
 *  @return 负数或者0表示可以发送
 */
-(NSTimeInterval)ableToShare{
    NSNumber* lastTime= self.preferences[@"storeShareTime"];
    if (!$safe(lastTime)) {
        return -1;
    }
    NSTimeInterval x = [[NSDate date] timeIntervalSince1970]-[lastTime doubleValue];
    LOG(@"已过去%d秒，要求%@秒",(int)x,self.loadingState.taskTimeLag);
    return [self.loadingState.taskTimeLag doubleValue]-x;
}


-(void)storeShareTime:(NSString*)fmtype{
//    NSMutableDictionary* lst = self.preferences[@"LastShareTimes"];
//    if (!$safe(lst)) {
//        lst = $mdictnew;
//        self.preferences[@"LastShareTimes"] = lst;
//    }
//    lst[fmtype] = $double([[NSDate date] timeIntervalSince1970]);
//    [self savePreferences];
}
-(NSTimeInterval)ableToShare:(NSString*)fmtype{
    NSMutableDictionary* lst = self.preferences[@"LastShareTimes"];
    if (!$safe(lst)) {
        return -1;
    }
    NSNumber* lastTime= lst[fmtype];
    if (!$safe(lastTime)) {
        return -1;
    }
    NSTimeInterval x = [[NSDate date] timeIntervalSince1970]-[lastTime doubleValue];
    LOG(@"已过去%d秒，要求%@秒",(int)x,self.loadingState.taskTimeLag);
    return [self.loadingState.taskTimeLag doubleValue]-x;
}


-(NSString*)getUpdateURL{
    NSString* url =  [self.preferences $for:@"getUpdateURL"];
    if ($safe(url)) {
        return url;
    }
    return @"http://www.fanmore.cn";
}

-(void)newWeixinKey:(NSString*)key{
    self.preferences[@"newWeixinKey"] = key;
    [ShareSDK connectWeChatTimelineWithAppId:key wechatCls:[WXApi class]];
    [self savePreferences];
}

-(void)storeUpdateURL:(NSString*)url{
    self.preferences[@"getUpdateURL"] = url;
    [self savePreferences];
}

-(void)storeLastImageShowtime:(NSString*)showtime{
    self.preferences[@"getLastImageShowtime"] = showtime;
    [self savePreferences];
}
-(NSString*)getLastImageShowtime{
    return [self.preferences $for:@"getLastImageShowtime"];
}

-(NSString*)getLastUsername{
    return [self.preferences $for:@"lastusername"];
}
-(NSString*)getLastPassword{
    return [self.preferences $for:@"lastpassword"];
}
-(void)storeLastUserInformation:(NSString*)username password:(NSString*)password{
    NSString* last  = [self getLastUsername];
    if ($safe(last) && !$eql(username,last)) {
        self.preferences[@"userChangedTime"] = $double([NSDate timeIntervalSinceReferenceDate]);
    }
    [self attemptPassword:nil wrong:NO block:NULL];
    [self.preferences $obj:username for:@"lastusername"];
    [self.preferences $obj:password for:@"lastpassword"];
    [self savePreferences];
}

-(void)resetSwitchUserState{
    [self.preferences removeObjectForKey:@"userChangedTime"];
    [self savePreferences];
}

-(BOOL)hasSwitchUser{
    NSNumber* userChangedTime = self.preferences[@"userChangedTime"];
    if ($safe(userChangedTime)){
        return [NSDate timeIntervalSinceReferenceDate]<[userChangedTime doubleValue]+24*60*60*1000;
    }
    return NO;
}

-(CityCode)getCurrentCityCode{
    return [(NSNumber*)[self.preferences $for:@"CurrentCityCode"]longValue];
}
-(CityCode)getPrefectCityCode{
    return [(NSNumber*)[self.preferences $for:@"PrefectCityCode"]longValue];
}
-(void)storePrefectCityCode:(CityCode)cityCode;{
    [self.preferences $obj:$long(cityCode) for:@"PrefectCityCode"];
    [self savePreferences];
}

-(void)setupShareTypes:(NSArray*)types toShare:(NSDictionary*)info{
    NSDictionary* defalutInfo = @{@"1": @23,@"2":@1,@"3":@6};
    NSMutableDictionary* tmpts = $mdictnew;
    for (NSString* type in types) {
        id target = info[type];
        if (!$safe(target)) {
            target = defalutInfo[type];
        }
        tmpts[type] = target;
    }
    _shareTypes = [NSDictionary dictionaryWithDictionary:tmpts];
//    _shareTypes = @{@"1": @23,@"2":@1,@"3":@6};
    //,@"4":@2
}
-(NSNumber*)fromShareType:(TShareType)type{
    for (NSString* key in _shareTypes.allKeys) {
        if ([_shareTypes[key] intValue]==(int)type){
            return $int([key intValue]);
        }
    }
    return nil;
}
-(BOOL)allShareTypeSent:(NSString*)list{
    if (!$safe(list)) {
        return NO;
    }
    NSArray* sents = [list componentsSeparatedByString:@","];
    for (NSString* key in _shareTypes.allKeys) {
        if(![sents containsObject:key]){
            return NO;
        }
    }
    return YES;
}

#pragma mark 一般行为




- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark weixin







-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    LOG(@"handleOpenURL %@",url);
    
    if ([url.absoluteString rangeOfString:@"oauth"].location != NSNotFound) {
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        return [ShareTool handleOpenURL:url];
    }
//    return [ShareSDK handleOpenURL:url
//                        wxDelegate:self];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    LOG(@"handleOpenURL %@",url);
    if ([url.absoluteString rangeOfString:@"oauth"].location != NSNotFound) {
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        return [ShareTool openURL:url sourceApplication:sourceApplication annotation:annotation];
        
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    
    if ([url.absoluteString rangeOfString:@"oauth"].location != NSNotFound) {
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        return [ShareTool handleOpenURL:url];
    }
    LOG(@"handleOpenURL %@",url);
//    return [ShareTool handleOpenURL:url];
//    NSString *string =[url absoluteString];
//    NSLog(@"%@",string);
//
//    return [ShareTool openURL:url options:options];
//    return [WXApi handleOpenURL:url delegate:self];
    
}

#pragma mark network Utils
-(HTTPRequestMoniter*)downloadImage:(NSString*)url handler:(void (^)(UIImage*,NSError*))handler asyn:(BOOL)asyn{
    return [self downloadImage:url handler:handler asyn:asyn resource:nil];
}

-(HTTPRequestMoniter*)downloadImage:(NSString*)url handler:(void (^)(UIImage*,NSError*))handler asyn:(BOOL)asyn resource:(CacheResource*)resource{
    
    if (resource!=Nil) {
        NSFileManager* fm = [NSFileManager defaultManager];
        NSString* path = [self.resoucesHome stringByAppendingPathComponent:resource.resourceName];
        if ([resource acceptCache:fm file:path]) {
            handler([UIImage imageWithData:[fm contentsAtPath:path]],nil);
            return nil;
        }
    }
    
    __unsafe_unretained ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    HTTPRequestMoniter* moniter = [[HTTPRequestMoniter alloc]initWithASIHTTPRequest:request];
    __weak HTTPRequestMoniter* wmontier = moniter;
//    __weak ASIHTTPRequest* wrequest = request;
    [request setDownloadCache:self.httpCache];
    [request setCompletionBlock:^{
        if ([wmontier isCancelled]) {
            return;
        }
        UIImage* image = [UIImage imageWithData:[request responseData]];
        if (resource!=nil) {
            [[request responseData]writeToFile:[FMUtils makeSureParentDirectoryExisting:[[self resoucesHome]stringByAppendingPathComponent:resource.resourceName]] atomically:YES];
        }
        handler(image,nil);
    }];
    [request setFailedBlock:^{
        if ([wmontier isCancelled]) {
            return;
        }
        handler(nil,[request error]);
    }];
    if (asyn) {
        [request startAsynchronous];
    } else {
        [request startSynchronous];
    }
    return moniter;
}

#pragma mark locate

-(void)startLocate:(id<CitycodeHandler>)citycodeHandler{
    //在点开某些需要地理信息的时候 还需要手工调用
    self.citycodeHandler = citycodeHandler;
    if (!self.locating) {
        self.locating = $new(CLLocationManager);
        self.locating.desiredAccuracy = kCLLocationAccuracyBest;
        self.locating.distanceFilter = 3000.0f;;
        self.locating.delegate = self;
    }
    if ([CLLocationManager locationServicesEnabled]){
//        4. 在 info.plist里加入：
//        NSLocationWhenInUseDescription，允许在前台获取GPS的描述
//        NSLocationAlwaysUsageDescription，允许在后台获取GPS的描述
#if __IPHONE_8_0
        double version = [[UIDevice currentDevice].systemVersion doubleValue];
        if(version>=8)
            [self.locating requestAlwaysAuthorization];
#endif
        [self.locating startUpdatingLocation];
    } else{
        //应该给出提示
        [self.citycodeHandler handleCitycode:Nil citycode:-1];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //Error Domain=kCLErrorDomain Code=0 "The operation couldn’t be completed. (kCLErrorDomain error 0.)"
    NSLog(@"%@",error);
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    __weak AppDelegate* wself = self;
    if (fabs(howRecent) < 15.0) {
        [self.locating stopUpdatingLocation];
        // If the event is recent, do something with it.
        LOG(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
        
        NSString* urlBuffer = $str(@"http://api.map.baidu.com/geocoder/v2/?output=json&ak=lRfC2kF5DwU8i6QWRiEqPikn&coordtype=wgs84ll&location=%.6f,%.6f&pois=0",location.coordinate.latitude,location.coordinate.longitude);
        
        __unsafe_unretained ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlBuffer]];
//        __weak ASIHTTPRequest* wrequest = request;
//        __weak CLLocation* wlocation = location;
        [request addRequestHeader:@"Referer" value:@"http://www.fanmore.com/"];
        [request setCompletionBlock:^{
//            JSONDecoder *jd=[[JSONDecoder alloc] init];
//            NSDictionary* obj = [jd objectWithData:[request responseData]];
            NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:NULL];
            if ([[obj $for:@"status"] isEqual:@0]){
                NSDictionary* cityrs = [obj $for:@"result"];
                LOG(@"%@",cityrs);
                NSNumber* nscityCode =(NSNumber*)[cityrs $for:@"cityCode"];
                [wself.preferences $obj:nscityCode for:@"CurrentCityCode"];
                [wself.citycodeHandler handleCitycode:location citycode:[nscityCode longValue]];
            }else{
                [wself.citycodeHandler handleCitycode:location citycode:-1];
            }
            
        }];
        [request startAsynchronous];
        
//        CLGeocoder* coder =  $new(CLGeocoder);
//        [coder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//            for (CLPlacemark * placemark in placemarks) {
//                LOG(@"%@",placemark);
//            }
//        }];
    }
}

#pragma mark push 

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    application.applicationIconBadgeNumber = 0;
    //[@"aps"][@"customeItem"]
//    NSLog(@"localnotif %@",notification);
    
    if ($eql(notification.userInfo[@"type"],@"openTask")) {
        self.lastKeyWindow =[UIApplication sharedApplication].keyWindow;
        NSDictionary* info =notification.userInfo[@"aps"][@"customeItem"];
        [self openComingPage:info];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //The notification is delivered when the application is running in the foreground.
    LOG(@"%@",userInfo);
    //aps : badge sound alert
    
    if( [[userInfo objectForKey:@"aps"] objectForKey:@"alert"] != NULL)
    {
        self.lastRecivedUserInfo = userInfo;
        self.lastKeyWindow =[UIApplication sharedApplication].keyWindow;
        //这里也应该是 回到TaskList...问题是。。
        //寻找nav in MainStoryBoard并且处理通知
        //        customItem =         {
        //            taskid = 0;
        //            type = 1;
        //            url = "http://www.baidu.com";
        //        };
        NSString *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"收到新消息"
                              message: msg
                              delegate: self
                              cancelButtonTitle: @"取消"
                              otherButtonTitles: @"打开", nil];
        [alert show];
        //        NSString *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        //        if(msg != nil) {
        //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
        //                                                                message:msg  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
        //            [alertView show];
        //        }
    }
}

//-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
//   
//    
//    completionHandler(UIBackgroundFetchResultNoData);
//}

-(UINavigationController*)currentController{
    if (self.mineNav) {
        return self.mineNav;
    }
    UIViewController* controler = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    UINavigationController* nav;
    if ([controler isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController*)controler;
    }else
        nav = controler.navigationController;
    return nav;
}

-(void)openComingPage:(NSDictionary*)info{
    UIViewController* controler = self.lastKeyWindow.rootViewController.presentedViewController;
    UINavigationController* nav;
    if ([controler isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController*)controler;
    }else
        nav = controler.navigationController;
    //            LOG(@"recevied online %@ %@ %@",userInfo,self.lastNavigation,[UIApplication sharedApplication].keyWindow.rootViewController);
    
    
    if (self.mineNav) {
        [TaskComingController checkNotify:self.mineNav data:info];
    }else{
        [TaskComingController checkNotify:nav data:info];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1: // delete
        {
            NSDictionary* info =self.lastRecivedUserInfo[@"aps"][@"customItem"];
            [self openComingPage:info];
        }
            break;
    }
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Error in registration. Error: %@", error);
}



-(void)checkForUpdateDeviceToken{
    __weak AppDelegate* wself = self;
    if (self.loadingState && self.deviceToken) {
        NSString* uploadedDT = wself.preferences[@"mydeviceToken"];
        if (!uploadedDT || !$eql(uploadedDT,self.deviceToken)) {
            [[self getFanOperations] UpdatePushToken:nil block:^(NSError *error) {
                if ($safe(error)) {
                    [wself performSelector:@selector(checkForUpdateDeviceToken) withObject:nil afterDelay:60];
                }else{
                    wself.preferences[@"mydeviceToken"] = wself.deviceToken;
                    [wself savePreferences];
                }
            } token:self.deviceToken];
        }
    }
}

//You can query the currently enabled notification types using the enabledRemoteNotificationTypes property of UIApplication
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    LOG(@"%@",[deviceToken hexadecimalString]);
    //当发现已经初始化完毕 则直接提交该deviceToken
    //如果没有 则保存该值 系统发现初始化完成 检查该值
    self.deviceToken = [deviceToken hexadecimalString];
    [self checkForUpdateDeviceToken];
}

#pragma mark 初始化

-(void)apiLoading{
    self.launchTime = [[NSDate date] timeIntervalSince1970];
    
    [self checkForUpdateDeviceToken];
}

static AppDelegate* single;

-(void)savePreferences{
    [self.preferences writeToFile:self.preferencesFile atomically:YES];
}

-(id)init{
    if(single!=nil){
        NSCAssert(FALSE, @"AppDelegate单例被多次初始化！");
    }
    self = [super init];
    single = self;
#ifdef FanmoreMock
    self.fanOperations = [MockFanOperations new];
#else
    self.fanOperations = $new(HttpFanOperations);
#endif
    self.httpCache = [[ASIDownloadCache alloc] init];
    [self.httpCache setStoragePath:[[$ documentPath]stringByAppendingPathComponent:@"httpCache"]];
    //ASIOnlyLoadIfNotCachedCachePolicy
    self.resoucesHome =  [[$ documentPath]stringByAppendingPathComponent:@"resources"];
    
    NSFileManager* filem = [NSFileManager defaultManager];
    BOOL dire= YES;
    if (![filem fileExistsAtPath:self.resoucesHome isDirectory:&dire]) {
        [filem createDirectoryAtPath:self.resoucesHome withIntermediateDirectories:YES attributes:nil error:Nil];
    }
    
    self.preferencesFile =[[$ documentPath]stringByAppendingPathComponent:@"preferences"];
    self.preferences = [NSMutableDictionary dictionaryWithContentsOfFile:self.preferencesFile];
    if(self.preferences==Nil){
        self.preferences = $mdictnew;
    }
    
    LOG(@"init delegate");
    
    if ([self.preferences $for:@"CurrentCityCode"]==nil) {
//        [self.preferences $obj:@179 for:@"CurrentCityCode"];
        [self.preferences $obj:@0 for:@"CurrentCityCode"];
    }
    
//    NSLog(@"resourcePath %@",[ConciseKit resourcePath]);
//    NSLog(@"appPath      %@",[ConciseKit appPath]);
//    NSLog(@"homePath     %@",[ConciseKit homePath]);
//    NSLog(@"documentPath %@",[ConciseKit documentPath]);
//    NSLog(@"desktopPath  %@",[ConciseKit desktopPath]);
    return self;
}

+(AppDelegate*)getInstance{
    if (single==Nil) {
        [AppDelegate new];
    }
    return single;
}

@end


#pragma mark -- UserInformation

@implementation UserInformation (AppData)

-(UIImage*)sexImage{
    if ([self.sex intValue]==1) {
        return [UIImage imageNamed:@"nanfuhao"];
    }
    return [UIImage imageNamed:@"nvfuhao"];
}

-(NSString*)sexLabel{
    switch([self.sex intValue]){
        case 1:
            return @"男";
        case 2:
            return @"女";
        default:
            return @"未知";
    }
}
-(NSString*)industryLabel{
    for (id key in single.industryList.allKeys) {
        if ([key intValue]==[self.industryId intValue]) {
            return single.industryList[key];
        }
    }
    return @"";
}

-(void)updateFavorites:(NSArray*)list{
    NSMutableString* buffer = $mstrnew;
    [list $each:^(id obj) {
        [buffer appendFormat:@"%@,",obj];
    }];
    if (buffer.length>1) {
        self.favoritesStr = [buffer substringToIndex:buffer.length-1];
    }else
        self.favoritesStr = buffer;
}

-(NSArray*)favoritesList{
    NSArray* keys = single.favoriteList.allKeys;
    NSArray* fvs = [self.favoritesStr $split:@","];
    NSMutableArray* nmbs = $marrnew;
    NSString* numberPattern = @"([0-9]+)";
    [fvs $each:^(id obj) {
        NSString* match = [obj stringByMatching:numberPattern];
        if ($safe(match) && [match isEqual:@""] == NO) {
            int value = [match intValue];
            for (id k in keys) {
                if ([[k stringByMatching:numberPattern] intValue]==value) {
                    [nmbs $push:k];
                    break;
                }
            }
//            [nmbs $push:$int([match intValue])];
        }
    }];
    return nmbs;
}

-(NSString*)favoritesLabel{
    NSMutableString* buffer = $mstrnew;
    [[self favoritesList] $each:^(id obj) {
        [buffer appendFormat:@"%@,",[single.favoriteList $for:obj]];
    }];
    if (buffer.length>1) {
        return [buffer substringToIndex:buffer.length-1];
    }
    return buffer;
}
-(NSString*)incomeLabel{
    for (id key in single.incomeList.allKeys) {
        if ([key intValue]==[self.incomeId intValue]) {
            return single.incomeList[key];
        }
    }
    return @"";
}

@end

@implementation CashHistory (AppData)

-(NSAttributedString*)statusLabel{
    return [[NSAttributedString alloc] initWithString:self.statusName];
//    switch([self.status intValue]){
//        case 1:
//            return [[NSAttributedString alloc]initWithString:@"处理中"];
//        case 2:
//            return [[NSAttributedString alloc]initWithString:@"申请失效" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
//        case 3:
//            return [[NSAttributedString alloc]initWithString:@"支付中"];
//        case 4:
//            return [[NSAttributedString alloc]initWithString:@"支付完成"];
//        case 5:
//            return [[NSAttributedString alloc]initWithString:@"支付失败" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
//        case 6:
//            return [[NSAttributedString alloc]initWithString:@"申请退回" attributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]}];
//        default:
//            return [[NSAttributedString alloc]initWithString:@"其他" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
//    }
}

@end


@implementation NSData (NSData_Conversion)

#pragma mark - String Conversion
- (NSString *)hexadecimalString {
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

@end
