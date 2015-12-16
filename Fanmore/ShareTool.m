//
//  ShareTool.m
//  Fanmore
//
//  Created by Cai Jiang on 2/22/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ShareTool.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "UIImage+Fanmore.h"

#import "ShareSDK/Extend/WeChatSDK/WXApi.h"
#import "ShareSDK/Extend/QQConnectSDK/TencentOpenAPI.framework/Headers/QQApiInterface.h"
#import "ShareSDK/Extend/QQConnectSDK/TencentOpenAPI.framework/Headers/TencentOAuth.h"

static NSTimeInterval lastSendWxTime = -1;

@implementation ShareMessage
@end

@interface NSString (ICMErrorInfo)<ICMErrorInfo>

@end

@implementation NSString (ICMErrorInfo)

- (NSInteger)errorCode{
    return 0;
}

- (NSString *)errorDescription{
    return self;
}

- (CMErrorLevel)errorLevel{
    return CMErrorLevelAPI;
}

@end

/**
 *  手工处理者
 */
@interface ManlyWXHandler : NSObject<WXApiDelegate>

-(id)initByHandler:(SSPublishContentEventHandler)handler;

@property(readonly) SSPublishContentEventHandler handler;

@end

@implementation ManlyWXHandler

-(id)initByHandler:(SSPublishContentEventHandler)handler{
    self = [super init];
    if (self) {
        _handler = handler;
    }
    return self;
}

-(void) onResp:(id)resp{
    if ([resp isKindOfClass:[BaseResp class]]) {
        BaseResp *_BaseResp = resp;
        //一旦成功 则删除handler
        if (_BaseResp.errCode==0) {
            self.handler(ShareTypeWeixiTimeline,SSResponseStateSuccess,nil,nil,YES);
            _handler = NULL;
        }else if (_BaseResp.errCode==-2) {
            self.handler(ShareTypeWeixiTimeline,SSResponseStateCancel,nil,_BaseResp.errStr,YES);
            _handler = NULL;
        }else {
            // -2 用户拒绝
            // errStr 有消息的
            // type 0?
            self.handler(ShareTypeWeixiTimeline,SSResponseStateFail,nil,_BaseResp.errStr,YES);
            NSLog(@"微信返回错误码 %d %@",_BaseResp.errCode,_BaseResp.errStr);
        }
    }
}

@end

//,QQApiInterfaceDelegate
@interface WXShareToolHandler : NSObject<WXApiDelegate>
@property(nonatomic, strong, readonly) void (^handler)(int);
-(void)pushHandler:(void (^)(int))handler;
@end

@implementation WXShareToolHandler

-(void)pushHandler:(void (^)(int))handler{
    _handler = handler;
}

-(void) onResp:(id)resp{
    //BaseResp
    if ([resp isKindOfClass:[BaseResp class]]) {
        BaseResp *_BaseResp = resp;
        self.handler(_BaseResp.errCode);
    }else if ([resp isKindOfClass:[QQBaseResp class]]){
        QQBaseResp* _QQBaseResp = resp;
        self.handler(_QQBaseResp.type);
    }
    
}

/**
 处理来至QQ的响应
 */
//- (void)onResp:(QQBaseResp *)resp{
//    
//}

@end


@interface ShareTool ()
@property id identification;
@property WXShareToolHandler* wxhandler;
@property TShareType type;
@end

@implementation ShareTool

+(UIImage*)getClientImage:(TShareType)type enable:(BOOL)enable{
    NSBundle* rs = [NSBundle bundleWithPath:[[NSBundle mainBundle]pathForResource:@"Resource" ofType:@"bundle"]];
    
    UIImage* image =  [UIImage imageWithContentsOfFile:[rs pathForResource:$str(@"Icon_7/sns_icon_%d",type) ofType:@"png"]];
    if (enable) {
        return image;
    }else
        return [UIImage grayscale:image type:1];
}

//static ShareTool* onlyOne;
static NSMutableArray* instances;
static int temperror;
#ifdef FMWXSELF
static ManlyWXHandler* manlyHandler;
#endif

+(instancetype)toolWithType:(TShareType)destType identification:(id)identification;{
    //wx5bdbcbadcdb869df
    for (ShareTool* tool in instances) {
        if (tool.type==destType) {
            return tool;
        }
    }
    ShareTool* tool = $new(self);
    tool.type = destType;
    tool.identification = identification;
    tool.wxhandler = $new(WXShareToolHandler);
//    onlyOne = tool;
    if (!$safe(instances)) {
        instances = $marrnew;
    }
    [instances $push:tool];
    return tool;
}


/**
 *  luohaibo
 *
 *  @param url     <#url description#>
 *  @param options <#options description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    
    LOG(@"回调URL %@",url);
    if ([url.scheme hasPrefix:@"QQ"]) {
        temperror = [[url.query parameterFromQuery:@"error"] intValue];
    }
#ifdef FMShareTool
    NSString* scheme = url.scheme;
    if ([scheme startWith:@"wx"]) {
        for (ShareTool* tool in instances) {
            if (tool.type==TShareTypeWeixiTimeline) {
                return [WXApi handleOpenURL:url delegate:tool.wxhandler];
            }
        }
    } else if ([scheme startWith:@"QQ"]) {
        for (ShareTool* tool in instances) {
            if (tool.type==TShareTypeQQSpace) {
                return [QQApiInterface handleOpenURL:url delegate:tool.wxhandler];
            }
        }
    }
    return NO;
#else
#ifdef FMWXSELF
    if ($safe(manlyHandler) && manlyHandler.handler!=NULL) {
        if(![WXApi handleOpenURL:url delegate:manlyHandler]){
            if([[AppDelegate getInstance].loadingState wxcannotSendSuccess] && [NSDate timeIntervalSinceReferenceDate]-lastSendWxTime<60){
                lastSendWxTime = -1;
                manlyHandler.handler(ShareTypeWeixiTimeline,SSResponseStateSuccess ,nil, nil, YES);
            }
        }
    }
#endif
//    return [ShareSDK handleOpenURL:<#(NSURL *)#> sourceApplication:<#(NSString *)#> annotation:<#(id)#> wxDelegate:<#(id)#>];
    return nil;
#endif

}

+(BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    LOG(@"回调URL %@",url);
    if ([url.scheme hasPrefix:@"QQ"]) {
        temperror = [[url.query parameterFromQuery:@"error"] intValue];
    }
#ifdef FMShareTool
    NSString* scheme = url.scheme;
    if ([scheme startWith:@"wx"]) {
        for (ShareTool* tool in instances) {
            if (tool.type==TShareTypeWeixiTimeline) {
                return [WXApi handleOpenURL:url delegate:tool.wxhandler];
            }
        }
    } else if ([scheme startWith:@"QQ"]) {
        for (ShareTool* tool in instances) {
            if (tool.type==TShareTypeQQSpace) {
                return [QQApiInterface handleOpenURL:url delegate:tool.wxhandler];
            }
        }
    }
    return NO;
#else
#ifdef FMWXSELF
    if ($safe(manlyHandler) && manlyHandler.handler!=NULL) {
        if(![WXApi handleOpenURL:url delegate:manlyHandler]){
            if([[AppDelegate getInstance].loadingState wxcannotSendSuccess] && [NSDate timeIntervalSinceReferenceDate]-lastSendWxTime<60){
                lastSendWxTime = -1;
                manlyHandler.handler(ShareTypeWeixiTimeline,SSResponseStateSuccess ,nil, nil, YES);
            }
        }
    }
#endif
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:[AppDelegate getInstance]];
#endif
}



+(BOOL)handleOpenURL:(NSURL*)url{
    //QQ0605EE5C://response_from_qq?source_scheme=mqqapi&source=qq&error=0&version=1
    //QQ0605EE5C://response_from_qq?source_scheme=mqqapi&source=qq&error=-4&error_description=dGhlIHVzZXIgZ2l2ZSB1cCB0aGUgY3VycmVudCBvcGVyYXRpb24=&version=1
    //提取error参数   0为成功 -4才是真取消
    LOG(@"回调URL %@",url);
    if ([url.scheme hasPrefix:@"QQ"]) {
        temperror = [[url.query parameterFromQuery:@"error"] intValue];
    }
#ifdef FMShareTool
    NSString* scheme = url.scheme;
    if ([scheme startWith:@"wx"]) {
        for (ShareTool* tool in instances) {
            if (tool.type==TShareTypeWeixiTimeline) {
                return [WXApi handleOpenURL:url delegate:tool.wxhandler];
            }
        }
    } else if ([scheme startWith:@"QQ"]) {
        for (ShareTool* tool in instances) {
            if (tool.type==TShareTypeQQSpace) {
                return [QQApiInterface handleOpenURL:url delegate:tool.wxhandler];
            }
        }
    }
    return NO;
#else
    
#ifdef FMWXSELF
    if ($safe(manlyHandler) && manlyHandler.handler!=NULL) {
        if(![WXApi handleOpenURL:url delegate:manlyHandler]){
            if([[AppDelegate getInstance].loadingState wxcannotSendSuccess] && [NSDate timeIntervalSinceReferenceDate]-lastSendWxTime<60){
                lastSendWxTime = -1;
                manlyHandler.handler(ShareTypeWeixiTimeline,SSResponseStateSuccess ,nil, nil, YES);
            }
        }
    }
#endif
    return [ShareSDK handleOpenURL:url wxDelegate:[AppDelegate getInstance]];
#endif
}

-(BOOL)checkSupport:(BOOL)autoinstall{
//    LOG(@"%d  %d",[WXApi isWXAppInstalled],[WXApi isWXAppSupportApi]);
    // || ![WXApi isWXAppSupportApi]
//    if (![WXApi isWXAppInstalled]){
//        if (autoinstall) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
//        }
//        return NO;
//    }
#ifdef FMShareTool
    switch (self.type) {
        case TShareTypeWeixiTimeline:
            return [WXApi registerApp:self.identification];
        case TShareTypeQQSpace:
            return [QQApiInterface isQQSupportApi];
        default:
            break;
    }
    return [WXApi registerApp:self.identification];
#else
    return YES;
#endif
}

-(BOOL)sendQQSpaceMessage:(ShareMessage*)message{
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:message.url]
                                title:message.title
                                description:message.smdescription
                                previewImageURL:[NSURL URLWithString:message.thumbImageURL]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    //QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //将内容分享到qzone
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    if (sent!=EQQAPISENDSUCESS) {
        NSLog(@"QQ空间转发失败 代码%d",sent);
        return NO;
    }else
        return YES;
}

#ifdef FMWXSELF
+(void)sendWxMessageMandly:(ShareMessage*)message handler:(SSPublishContentEventHandler)handler{
    WXWebpageObject* wo = [WXWebpageObject object];
    wo.webpageUrl = message.url;
    
    WXMediaMessage* wd = [WXMediaMessage message];
    wd.description = message.smdescription;
    wd.mediaObject = wo;
    //mediaTagName  选填
    wd.title = message.title;
    
    
    //
    CGSize size = CGSizeMake(80, 80);
    if (message.thumbImage.size.width<size.width) {
        [wd setThumbImage:message.thumbImage];
    }else{
        UIGraphicsBeginImageContext(size);
        // 绘制改变大小的图片
        [message.thumbImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        // 从当前context中创建一个改变大小后的图片
        UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        [wd setThumbImage:scaledImage];
    }
    
    SendMessageToWXReq* testwx = $new(SendMessageToWXReq);
    testwx.scene =WXSceneTimeline;
    testwx.message= wd;
//    testwx.text = @"写一写汉字把";
    testwx.bText = NO;
    
    if([WXApi sendReq:testwx]){
        // 成功转到微信 并开始转发
        lastSendWxTime = [NSDate timeIntervalSinceReferenceDate];
        manlyHandler = [[ManlyWXHandler alloc] initByHandler:handler];
    }else{
        handler(ShareTypeWeixiTimeline,SSResponseStateFail,nil,@"发送到微信失败",YES);
    }
}
#endif

-(BOOL)sendwxMessage:(ShareMessage*)message{
    WXWebpageObject* wo = $new(WXWebpageObject);
    wo.webpageUrl = message.url;
    WXMediaMessage* wd = $new(WXMediaMessage);
    wd.description = message.smdescription;
    wd.mediaObject = wo;
    //mediaTagName  选填
    wd.title = message.title;
    
    
    //
    CGSize size = CGSizeMake(80, 80);
    if (message.thumbImage.size.width<size.width) {
        [wd setThumbImage:message.thumbImage];
    }else{
        UIGraphicsBeginImageContext(size);
        // 绘制改变大小的图片
        [message.thumbImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        // 从当前context中创建一个改变大小后的图片
        UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        [wd setThumbImage:scaledImage];
    }
    
    SendMessageToWXReq* testwx = $new(SendMessageToWXReq);
    testwx.scene =WXSceneTimeline;
    testwx.message= wd;
    //        testwx.text = @"写一写汉字把";
    testwx.bText = NO;
    
    return [WXApi sendReq:testwx];
}

static BOOL _sending = NO;
static id _block;
static __weak id<ISSShareActionSheet> lastShareSheet;
+(id<ISSShareActionSheet>)shareMessage:(ShareMessage*)message controller:(UIViewController*)controller sentList:(NSString*)sentList delegate:(id<ShareToolDelegate>)delegate handler:(ShareResultHandler)handler{
#ifdef FMWXSELF
//    ShareMessage* wmessage = message;
#endif
    
    LOG(@"已连接渠道数%d",[ShareSDK connectedPlatformTypes].count);
    if ([ShareSDK connectedPlatformTypes].count==0) {
        [AppDelegate connectAllShareManly];
    }
    
    
    if ($safe(lastShareSheet)) {
        [lastShareSheet dismiss];
    }
    
    id<ISSCAttachment> imageInfo;
    __weak UIViewController* wcontroller = controller;
    if ([message.thumbImageURL hasSuffix:@"png"] || [message.thumbImageURL hasSuffix:@"PNG"]) {
        imageInfo = [ShareSDK pngImageWithImage:message.thumbImage];
    }else{
        imageInfo = [ShareSDK jpegImageWithImage:message.thumbImage quality:1.0f];
    }
    __weak AppDelegate* ad = [AppDelegate getInstance];
    id<ISSContent> content = [ShareSDK content:message.smdescription
                                defaultContent:@""
                                         image:imageInfo
                                         title:message.title
                                           url:message.url
                                   description:nil
                                     mediaType:SSPublishContentMediaTypeNews];
    SSPublishContentEventHandler _handler =^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state==SSResponseStateBegan) {
            return;
        }
        if (!end) {
            return;
        }
        _sending = NO;
        [ShareTool bk_cancelBlock:_block];
        _block = nil;
        if (type==ShareTypeQQSpace && state==SSResponseStateCancel && temperror==0) {
            state = SSResponseStateSuccess;
        }
        if (state==SSResponseStateSuccess) {
            //cancel end true qqspace
            [ad storeShareTime:[[ad fromShareType:(TShareType)type] stringValue]];
            handler((TShareType)type,ShareResultDone,nil);
        }else{
            LOG(@"ShareSDK回调 %d %d %@ end:%d",type,state,[statusInfo sourceData],end);
            if($safe(error)){
                LOG(@"%d %@",[error errorCode],[error errorDescription]);
            }
            if (state==SSResponseStateCancel) {
                if (safeController(wcontroller)) {
                    [FMUtils alertMessage:wcontroller.view msg:$str(@"请在%@完成转发",[ShareSDK getClientNameWithType:type])];
                }
                handler((TShareType)type,ShareResultCancel,nil);
            }else{
                if ($safe(error) && safeController(wcontroller)) {
                    [FMUtils alertMessage:wcontroller.view msg:[error errorDescription]];
                }
                handler((TShareType)type,ShareResultFailed,error);
            }
        }

    };
    __block id<ISSContent> bcontent = content;
    NSMutableArray* types  = $marrnew;
    
    NSArray* sents = [sentList componentsSeparatedByString:@","];
    __block NSArray* bsents = sents;
    for (NSString* fmtype in ad.shareTypes.allKeys) {
        __block NSString* btype = fmtype;
        BOOL enable = ![bsents containsObject:btype];// &&[ad ableToShare:btype]<=0
        
        ShareType type =(ShareType)[ad.shareTypes[fmtype]intValue];
        [types addObject:[ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:type] icon:[ShareTool getClientImage:(TShareType)type enable:enable] clickHandler:^(){
            
            if ($safe(delegate) && [delegate respondsToSelector:@selector(shouldShare:)]) {
                if (![delegate shouldShare:type]) {
                    return;
                }
            }
            
            if ([bsents containsObject:btype]) {
                [FMUtils alertMessage:wcontroller.view msg:$str(@"您已在%@转发过",[ShareSDK getClientNameWithType:type] )];
                return;
            }
//            NSTimeInterval timeLeft = [ad ableToShare:btype];
//            if (timeLeft>0) {
//                if (safeController(wcontroller)) {
//                    [FMUtils alertMessage:wcontroller.view msg:$str(@"%@后才转发至%@",[$double(timeLeft) timeLag],[ShareSDK getClientNameWithType:type] )];
//                }
//                return;
//            }
            if (_sending) {
                [FMUtils alertMessage:wcontroller.view msg:@"正在转发中……"];
                return;
            }
            //&channel
            [bcontent setUrl:$str(@"%@&channel=%@",[bcontent url],btype)];
            LOG(@"%@",[bcontent url]);
            if (type==ShareTypeSinaWeibo){
                [bcontent setContent:$str(@"%@%@",[bcontent content],[bcontent url])];
            }
            
            _sending = YES;
            _block = [ShareTool bk_performBlock:^{
                _sending = NO;
            } afterDelay:60];
            
#ifdef FMWXSELF
            if (type==ShareTypeWeixiTimeline) {
                //&channel
                [message setUrl:$str(@"%@&channel=%@",[message url],btype)];
                [self sendWxMessageMandly:message handler:_handler];
                return;
            }
#endif

            
//            ShareHelper* helper = $new(ShareHelper);
            id<ISSAuthOptions> _auth = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:nil];
            [_auth setPowerByHidden:YES];
            
            LOG(@"url:%@ desc:%@ content:%@ title:%@ image:%@"
                ,[bcontent url]
                ,[bcontent desc]
                ,[bcontent content]
                ,[bcontent title]
                ,[bcontent image]
                );
            
            [ShareSDK shareContent:bcontent type:type authOptions:_auth statusBarTips:YES result:_handler];
        }]];
    }
    
    if (types.count==0) {
        [FMUtils alertMessage:wcontroller.view msg:@"亲，您已经转发过了"];
        return nil;
    }
    
    lastShareSheet = [ShareSDK showShareActionSheet:[ShareSDK container] shareList:types content:nil statusBarTips:YES authOptions:nil shareOptions:nil result:NULL];
    return lastShareSheet;
}

-(BOOL)shareMessage:(ShareMessage*)message block:(void (^)(int))block{
#ifdef FMShareTool
    [self.wxhandler pushHandler:block];
    switch (self.type) {
        case TShareTypeWeixiTimeline:
            return [self sendwxMessage:message];
        case TShareTypeQQSpace:
            return [self sendQQSpaceMessage:message];
        default:
            break;
    }
    return NO;
#else
    id<ISSContent> content = [ShareSDK content:message.smdescription defaultContent:message.smdescription image:[ShareSDK imageWithUrl:message.thumbImageURL] title:message.title url:message.url
                                   description:message.smdescription mediaType:SSPublishContentMediaTypeNews];
    
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                         allowCallback:YES
//                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                          viewDelegate:nil
//                                               authManagerViewDelegate:nil];
    
    ShareType c = (ShareType)self.type;
//    [ShareSDK showShareViewWithType:c container:nil content:content statusBarTips:YES
//                        authOptions:authOptions shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                            if (state==SSResponseStateBegan) {
//                                return;
//                            }
//                            if (!end) {
//                                return;
//                            }
//                            if (c==ShareTypeQQSpace && state==SSResponseStateCancel && temperror==0) {
//                                state = SSResponseStateSuccess;
//                            }
//                            if (state==SSResponseStateSuccess) {
//                                //cancel end true qqspace
//                                block(0);
//                            }else{
//                                LOG(@"ShareSDK回调 %d %d %@ end:%d",type,state,[statusInfo sourceData],end);
//                                if (state==SSResponseStateCancel) {
//                                    block(1);
//                                }else{
//                                    block(2);
//                                }
//                            }
//
//                        }];
    [ShareSDK shareContent:content type:c authOptions:nil shareOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state==SSResponseStateBegan) {
            return;
        }
        if (!end) {
            return;
        }
        if (c==ShareTypeQQSpace && state==SSResponseStateCancel && temperror==0) {
            state = SSResponseStateSuccess;
        }
        if (state==SSResponseStateSuccess) {
            //cancel end true qqspace
            block(0);
        }else{
            LOG(@"ShareSDK回调 %d %d %@ end:%d",type,state,[statusInfo sourceData],end);
            if (state==SSResponseStateCancel) {
                block(1);
            }else{
                block(2);
            }
        }
    }];
    return YES;
    //
    //    [ShareSDK showShareActionSheet:nil shareList:nil content:content statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
    //        if (state == SSResponseStateSuccess)
    //        {
    //            NSLog(@"分享成功");
    //        }
    //        else if (state == SSResponseStateFail)
    //        {
    //            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
    //        }else if(state == SSResponseStateCancel){
    //            LOG(@"用户取消");
    //        }
    //    }];
#endif
}

@end
