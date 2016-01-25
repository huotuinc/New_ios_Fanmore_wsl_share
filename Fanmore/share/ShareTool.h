//
//  ShareTool.h
//  Fanmore
//
//  Created by Cai Jiang on 2/22/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define FMShareTool

#ifndef FMShareTool
#import <ShareSDK/ShareSDK.h>
//#import "ShareSDK/Extend/SinaWeiboSDK/WeiboSDK.h"
#endif

typedef enum{
    ShareResultFailed=1,
    ShareResultDone=2,
    ShareResultCancel=3,
}
ShareResult;


/**
 *	@brief	分享类型
 */
typedef enum
{
	TShareTypeSinaWeibo = 1,         /**< 新浪微博 */
	TShareTypeTencentWeibo = 2,      /**< 腾讯微博 */
	TShareTypeSohuWeibo = 3,         /**< 搜狐微博 */
    TShareType163Weibo = 4,          /**< 网易微博 */
	TShareTypeDouBan = 5,            /**< 豆瓣社区 */
	TShareTypeQQSpace = 6,           /**< QQ空间 */
	TShareTypeRenren = 7,            /**< 人人网 */
	TShareTypeKaixin = 8,            /**< 开心网 */
	TShareTypePengyou = 9,           /**< 朋友网 */
	TShareTypeFacebook = 10,         /**< Facebook */
	TShareTypeTwitter = 11,          /**< Twitter */
	TShareTypeEvernote = 12,         /**< 印象笔记 */
	TShareTypeFoursquare = 13,       /**< Foursquare */
	TShareTypeGooglePlus = 14,       /**< Google＋ */
	TShareTypeInstagram = 15,        /**< Instagram */
	TShareTypeLinkedIn = 16,         /**< LinkedIn */
	TShareTypeTumblr = 17,           /**< Tumbir */
    TShareTypeMail = 18,             /**< 邮件分享 */
	TShareTypeSMS = 19,              /**< 短信分享 */
	TShareTypeAirPrint = 20,         /**< 打印 */
	TShareTypeCopy = 21,             /**< 拷贝 */
    TShareTypeWeixiSession = 22,     /**< 微信好友 */
	TShareTypeWeixiTimeline = 23,    /**< 微信朋友圈 */
    TShareTypeQQ = 24,               /**< QQ */
    TShareTypeInstapaper = 25,       /**< Instapaper */
    TShareTypePocket = 26,           /**< Pocket */
    TShareTypeYouDaoNote = 27,       /**< 有道云笔记 */
    TShareTypeSohuKan = 28,          /**< 搜狐随身看 */
    TShareTypePinterest = 30,        /**< Pinterest */
    TShareTypeFlickr = 34,           /**< Flickr */
    TShareTypeDropbox = 35,          /**< Dropbox */
    TShareTypeVKontakte = 36,        /**< VKontakte */
    TShareTypeWeixiFav = 37,         /**< 微信收藏 */
    TShareTypeYiXinSession = 38,     /**< 易信好友 */
    TShareTypeYiXinTimeline = 39,    /**< 易信朋友圈 */
    TShareTypeYiXinFav = 40,         /**< 易信收藏 */
    TShareTypeAny = 99               /**< 任意平台 */
}
TShareType;

typedef void(^ShareResultHandler)(TShareType type,ShareResult result,id data);

@interface ShareMessage : NSObject

@property (nonatomic, retain) NSString * smdescription;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) UIImage* thumbImage;
@property (nonatomic, retain) NSString* thumbImageURL;

@end

@protocol ShareToolDelegate <NSObject>

@optional
-(BOOL)shouldShare:(ShareType)type;

@end

@interface ShareTool : NSObject

+(UIImage*)getClientImage:(TShareType)type enable:(BOOL)enable;

/**
*  根据终端类型创建实例
*
*  @param destType       1 目前只支持微信
*  @param identification 身份识别符
*
*  @return <#return value description#>
*/
+(instancetype)toolWithType:(TShareType)destType identification:(id)identification;

+(BOOL)handleOpenURL:(NSURL*)url;

+(BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

/**
 *  检查是否支持转发
 *
 *  @param autoinstall 是否提示用户安装该终端
 *
 *  @return <#return value description#>
 */
-(BOOL)checkSupport:(BOOL)autoinstall;

-(BOOL)shareMessage:(ShareMessage*)message block:(void (^)(int))block;

+(id<ISSShareActionSheet>)shareMessage:(ShareMessage*)message controller:(UIViewController*)controller sentList:(NSString*)sentList delegate:(id<ShareToolDelegate>)delegate handler:(ShareResultHandler)handler;

@end

