//
//  AppDelegate.h
//  Fanmore
//  1782a62f5430 Share SDK AppKey
//  QQ 101051996 APP KEY：535b920eebcf192cb0da960996ff72d2
//  weixin wx1424e93fb903ef33
//  sinaweibo  key 3653231385 App Secret：4ecff164368e17c8a417ef49a6e755ad
//  Created by Cai Jiang on 1/6/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FanOperations.h"
#import "ASIDownloadCache.h"
#import "HTTPRequestMoniter.h"
#import "CashHistory.h"
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "CitycodeHandler.h"
#import "ShareTool.h"
#import "CacheResource.h"
#import "iVersion.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,iVersionDelegate>

@property(weak) UINavigationController* mineNav;

+(AppDelegate*)getInstance;

+(void)connectAllShareManly;

@property NSDictionary* launchOptions;

/**
 *  最近是否切换过用户
 *
 *  目前定义最近为24小时
 *
 *  @return <#return value description#>
 */
-(BOOL)hasSwitchUser;

/**
 *  重置切换用户状态
 */
-(void)resetSwitchUserState;

/**
 *  接口初始化
 */
-(void)apiLoading;

@property NSTimeInterval launchTime;
@property BOOL forceUpdate;

@property (nonatomic,strong) NSArray* topTaskIds;

@property (nonatomic,strong) LoadingState* loadingState;

@property NSMutableDictionary* preferences;

//fanmoreType:tsharetype!
@property (nonatomic,retain,readonly) NSDictionary* shareTypes;

-(void)newWeixinKey:(NSString*)key;

-(BOOL)taskIsTop:(NSNumber*)taskId;

/**
 *  设置共享/渠道类别
 *
 *  @param types 服务端支持的渠道
 *  @param info  客户端支持的渠道
 */
-(void)setupShareTypes:(NSArray*)types toShare:(NSDictionary*)info;
/**
 *  解析为服务端渠道类别
 *
 *  @param type <#type description#>
 *
 *  @return <#return value description#>
 */
-(NSNumber*)fromShareType:(TShareType)type;
/**
 *  是否已经在所有支持的渠道中转发完毕
 *
 *  @param list <#list description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)allShareTypeSent:(NSString*)list;

//@property NSNumber* todayTotalScore;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,retain) ASIDownloadCache *httpCache;

@property (nonatomic,retain) NSString* resoucesHome;

@property (nonatomic,retain) NSDictionary* industryList;
@property (nonatomic,retain) NSDictionary* favoriteList;
@property (nonatomic,retain) NSDictionary* incomeList;

@property (nonatomic,retain) UserInformation* currentUser;

-(void)startLocate:(id<CitycodeHandler>)citycodeHandler;

-(NSString*)getUpdateURL;
-(void)storeUpdateURL:(NSString*)url;
-(CityCode)getCurrentCityCode;
-(CityCode)getPrefectCityCode;
-(void)storePrefectCityCode:(CityCode)cityCode;
-(void)storeLastImageShowtime:(NSString*)showtime;
-(NSString*)getLastImageShowtime;
-(NSString*)getLastUsername;
-(NSString*)getLastPassword;
-(void)storeLastUserInformation:(NSString*)username password:(NSString*)password;

-(void)storeShareTime;
/**
 *  多少时间以后可以发送
 *
 *
 *  @return 负数或者0表示可以发送
 */
-(NSTimeInterval)ableToShare;

-(void)storeShareTime:(NSString*)fmtype;
/**
 *  多少时间以后可以发送
 *
 *
 *  @param fmtype <#fmtype description#>
 *
 *  @return 负数或者0表示可以发送
 */
-(NSTimeInterval)ableToShare:(NSString*)fmtype;

/**
 *  获取网络操作API
 *
 *  @return 网络操作API
 */
-(id<FanOperations>)getFanOperations;

-(HTTPRequestMoniter*)downloadImage:(NSString*)url handler:(void (^)(UIImage*,NSError*))handler asyn:(BOOL)asyn;
/**
 *  下载图片
 *
 *  @param url        图片地址
 *  @param handler    处理器
 *  @param asyn       是否异步请求
 *  @param storedName 该资源保存在resourcesHome下的缓存名字
 */
-(HTTPRequestMoniter*)downloadImage:(NSString*)url handler:(void (^)(UIImage*,NSError*))handler asyn:(BOOL)asyn resource:(CacheResource*)resource;

-(UINavigationController*)currentController;

-(void)logout:(UIViewController*)controll;
/**
 *  尝试错误的密码
 *  这里会提示用户剩余 尝试的次数 如果次数过多 则注销 并返回到TaskList界面
 *
 */
-(void)attemptPassword:(UIViewController*)controller wrong:(BOOL)wrong block:(void (^)())block;

-(void)savePreferences;

@end

@interface UserInformation (AppData)

-(UIImage*)sexImage;
-(NSString*)sexLabel;
-(NSString*)industryLabel;
-(NSString*)favoritesLabel;
-(NSArray*)favoritesList;
-(void)updateFavorites:(NSArray*)list;
-(NSString*)incomeLabel;

@end

@interface CashHistory (AppData)

-(NSAttributedString*)statusLabel;

@end

@interface NSData (NSData_Conversion)

#pragma mark - String Conversion
- (NSString *)hexadecimalString;

@end
