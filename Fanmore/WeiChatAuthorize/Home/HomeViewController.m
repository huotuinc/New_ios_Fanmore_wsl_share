//
//  HomeViewController.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/9/5.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "HomeViewController.h"
#import <BlocksKit+UIKit.h>
#import "MJExtension.h"
#import "PushWebViewController.h"
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "NSDictionary+HuoBanMallSign.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MidTabelViewCell.h"
//#import "AccountModel.h"
//#import "UIViewController+MonitorNetWork.h"
//#import "MallMessage.h"
#import "PayModel.h"
//#import "IponeVerifyViewController.h"
//#import <SDWebImageManager.h>
//#import "Order.h"  //支付宝
//#import "DataSigner.h"
//#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "payRequsestHandler.h"
#import "UserLoginTool.h"
//#import <SSZipArchive.h>
//#import <SVProgressHUD.h>
//#import "SISBaseModel.h"
//#import "SISHomeViewController.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "NavController.h"
#import "AccountLoginViewController.h"
#import "WeiChatAuthorize.h"


@interface HomeViewController()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *homeWebView;


@property (weak, nonatomic) IBOutlet UIWebView *homeBottonWebView;

/***/
@property(nonatomic,strong) NSMutableString * debugInfo;
/**
 *  是否显示返回按钮
 *  1、表示显示
 *  2、表示不显示
 */
@property(nonatomic,assign) BOOL showBackArrows;

/**底部网页约束高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeBottonWebViewHeight;
/**图标*/
@property (nonatomic,strong) UIButton * backArrow;
/**返回按钮*/
@property (nonatomic,strong) UIButton * leftOption;

/**刷新按钮标*/
@property (nonatomic,strong) UIButton * refreshBtn;
/**分享按钮*/
@property (nonatomic,strong) UIButton * shareBtn;


/**账号提升选秀*/
//@property (nonatomic,strong) UITableView * midtableView;

/**登陆后的背景遮罩*/
@property (nonatomic,strong) UIView * backView;

/**本地账号*/
@property (nonatomic,strong) NSArray * LocalAccounts;

@property(nonatomic,strong) NSString * orderNo;       //订单号
@property(nonatomic,strong) NSString * priceNumber;  //订单价格
@property(nonatomic,strong) NSString * proDes;       //订单描述
/**支付的url*/
@property(nonatomic,strong) NSString * ServerPayUrl;

@property(nonatomic,strong) PayModel * paymodel;

@end


@implementation HomeViewController


- (UIButton *)backArrow{
    if (_backArrow == nil) {
        _backArrow = [[UIButton alloc] init];
        _backArrow.frame = CGRectMake(0, 0, 25, 25);
        [_backArrow addTarget:self action:@selector(BackToWebView) forControlEvents:UIControlEventTouchUpInside];
        [_backArrow setBackgroundImage:[UIImage imageNamed:@"main_title_left_back"] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backArrow];
    }
    return _backArrow;
}

- (UIButton *)leftOption{
    
    if (_leftOption == nil) {
        _leftOption = [[UIButton alloc] init];
        _leftOption.frame = CGRectMake(0, 0, 35, 25);
        [_leftOption addTarget:self action:@selector(GoToLeft) forControlEvents:UIControlEventTouchUpInside];
        [_leftOption setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftOption];
    }
    return _leftOption;
}

- (void)GoToLeft{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  网页
 */
- (void)BackToWebView{
    if ([self.homeWebView canGoBack]) {
        [self.homeWebView goBack];
    }
}


-(UIButton *)refreshBtn{
    if (_refreshBtn == nil) {
        _refreshBtn = [[UIButton alloc] init];
        _refreshBtn.frame = CGRectMake(0, 0, 25, 25);
        [_refreshBtn addTarget:self action:@selector(refreshToWebViews) forControlEvents:UIControlEventTouchUpInside];
        [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"main_title_left_refresh"] forState:UIControlStateNormal];
        [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"loading"] forState:UIControlStateHighlighted];
    }
    return _refreshBtn;
}

/**
 *  刷新
 */
- (void)refreshToWebViews{
     [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
    self.refreshBtn.userInteractionEnabled = NO;

    [self.homeWebView reload];
}

/**
 *  分享
 */
- (void)shareBtnClicks{
    [self shareSdkSha];
}




/**
 *  分享url处理
 */
- (NSString *) toCutew:(NSString *)urs{
    
//    NSString * gduid = [[NSUserDefaults standardUserDefaults] objectForKey:HuoBanMallUserId];
//    
//    NSRange rang = [urs rangeOfString:@"?"];
//    
//    NSString * back = [urs substringFromIndex:rang.location + 1];
//    
//    NSArray * aa =  [back componentsSeparatedByString:@"&"];
//    
//    __block NSMutableArray * todelete = [NSMutableArray arrayWithArray:aa];
//    
//    NSArray * key = @[@"unionid",@"appid",@"sign"];
//    [aa enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [key enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj containsString:key]) {
//                [todelete removeObject:obj];
//            }
//        }];
//    }];
//    
//    NSMutableString * cc = [[NSMutableString alloc] init];
//    [todelete enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *  stop) {
//        
//        [cc appendFormat:@"%@&",obj];
//    }];
//    [cc appendFormat:@"gduid=%@",gduid];
//    
//    NSString * ee = [urs substringToIndex:rang.location+1];
//    
//    NSString * dd = [NSString stringWithFormat:@"%@%@",ee,cc];
//    
    
    return nil;
}

- (void)shareSdkSha{
    
    
    
    
    
//    if(self.homeWebView.loading){
//        return;
//    }
//    NSString * urs =  self.homeWebView.request.URL.absoluteString;
//    
//    MallMessage * mallmess = [MallMessage getMallMessage];
//    
//    NSString * uraaa = [[NSUserDefaults standardUserDefaults] objectForKey:AppMainUrl];
//    NSMutableString * url = [NSMutableString stringWithString:uraaa];
//    [url appendString:mallmess.mall_logo];
//    
//    
//    //1、创建分享参数
//    NSArray* imageArray = @[url];
//    if (imageArray) {
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:nil
//                                         images:imageArray
//                                            url:[NSURL URLWithString:urs]
//                                          title:@"行装"
//                                           type:SSDKContentTypeAuto];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                       
//                   }];
//
//    }
}

-(void)xxxxx {
        //    //构造分享内容
        //    id<ISSContent> publishContent = [ShareSDK content:mallmess.mall_description
        //                                       defaultContent:mallmess.mall_description
        //                                                image:[ShareSDK imageWithUrl:url]
        //                                                title:mallmess.mall_name
        //                                                  url:[self toCutew:urs]      //mallmess.mall_site
        //                                          description:mallmess.mall_description
        //                                            mediaType:SSPublishContentMediaTypeNews];
        //    [publishContent addSinaWeiboUnitWithContent:mallmess.mall_description image:[ShareSDK imageWithUrl:mallmess.mall_logo] locationCoordinate:nil];
        //    //创建弹出菜单容器
        //    id<ISSContainer> container = [ShareSDK container];
        //
        //    //弹出分享菜单
        //    [ShareSDK showShareActionSheet:container
        //                         shareList:nil
        //                           content:publishContent
        //                     statusBarTips:YES
        //                       authOptions:nil
        //                      shareOptions:nil
        //                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        //
        //                                if (state == SSResponseStateSuccess)
        //                                {
        //                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //                                    [alert show];
        //
        //                                }
        //                                else if (state == SSResponseStateFail)
        //                                {
        //                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
        //                                }
        //                            }];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    //商品
    LoadingState * loInit = [AppDelegate getInstance].loadingState;
    NSString * ddd = [NSString stringWithFormat:@"%@/%@/index.aspx?back=1",loInit.website,loInit.customerId];
    NSURL * urlStr = [NSURL URLWithString:[NSDictionary ToSignUrlWithString:ddd]];
    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:urlStr];
    self.homeWebView.scalesPageToFit = YES;
    self.homeWebView.tag = 100;
    self.homeWebView.delegate = self;
    [self.homeWebView loadRequest:req];
    
    
    
    //tarbar
    NSString * cc = [NSString stringWithFormat:@"%@%@%@",loInit.website,@"/bottom.aspx?customerid=",loInit.customerId];
    NSURLRequest * Bottomreq = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:cc]];
    self.homeBottonWebView.scalesPageToFit = YES;
    self.homeBottonWebView.delegate = self;
    self.homeBottonWebView.tag = 20;
    self.homeBottonWebView.scrollView.bounces = YES;
    self.homeBottonWebView.scrollView.scrollEnabled = NO;
    [self.homeBottonWebView loadRequest:Bottomreq];



    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftOption];
    
    //集成刷新控件
    [self AddMjRefresh];

    
}



- (void)AddMjRefresh{
//    // 添加下拉刷新控件
//    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
//    // 隐藏状态
//    header.stateLabel.hidden = YES;
//    header.arrowView.image= nil;
//    self.homeWebView.scrollView.mj_header = header;
    


}



/*
 *网页下拉刷新
 */
- (void)loadNewData{
    [self.homeWebView reload];
}




- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
}


#pragma mark webView
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if (webView.tag == 100) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if (_showBackArrows) {//返回按钮
            
            [UIView animateWithDuration:0.05 animations:^{
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftOption];
            }];
        }else{
            [UIView animateWithDuration:0.05 animations:^{
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backArrow];
            }];
        }
    }
    
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = request.URL.absoluteString;
    NSLog(@"xxxxxx===========%@",url);
    if (webView.tag == 100) {
        
        if ([url rangeOfString:@"/UserCenter/Login.aspx"].location !=  NSNotFound) {
            if ([WXApi isWXAppInstalled]) {
                UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                WeiChatAuthorize * login =  [main instantiateViewControllerWithIdentifier:@"WeiChatAuthorize"];
                [self presentViewController:login animated:YES completion:nil];
                
            }else{
                UIStoryboard * sto = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AccountLoginViewController * iphone =  [sto instantiateViewControllerWithIdentifier:@"AccountLoginViewController"];
                NavController * nav = [[NavController alloc] initWithRootViewController:iphone];
                
                [self presentViewController:nav animated:YES completion:nil];
                
            }
            
        }else if([url rangeOfString:@"AppAlipay.aspx"].location != NSNotFound){
         
                self.ServerPayUrl = [url copy];
                NSRange trade_no = [url rangeOfString:@"trade_no="];
                NSRange customerID = [url rangeOfString:@"customerID="];
//                NSRange paymentType = [url rangeOfString:@"paymentType="];
                NSRange trade_noRange = {trade_no.location + 9,customerID.location-trade_no.location-10};
                NSString * trade_noss = [url substringWithRange:trade_noRange];//订单号
                self.orderNo = trade_noss;
                //            NSString * payType = [url substringFromIndex:paymentType.location+paymentType.length];
                // 1.得到data
                NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:PayTypeflat];
                NSData *data = [NSData dataWithContentsOfFile:filename];
                // 2.创建反归档对象
                NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
                // 3.解码并存到数组中
                NSArray *namesArray = [unArchiver decodeObjectForKey:PayTypeflat];
                
                LoadingState * loInit = [AppDelegate getInstance].loadingState;
                NSMutableString * url = [NSMutableString stringWithString:loInit.website];
                [url appendFormat:@"%@?orderid=%@",@"/order/GetOrderInfo",trade_noss];
                
                [[[AppDelegate getInstance] getFanOperations] ToGetTheOrderDescripition:nil block:^(id json, NSError *error) {
                if (json) {
                    self.priceNumber = json[@"Final_Amount"];
                    //                    NSLog(@"%@",self.priceNumber);
                    NSString * des =  json[@"ToStr"]; //商品描述
                    //                    NSLog(@"%@",json[@"data"][@"ToStr"]);
                    self.proDes = [des copy];
                    //                    NSLog(@"%@",self.proDes);
                    if(namesArray.count == 1){
                        PayModel * pay =  namesArray.firstObject;  //300微信  400支付宝
                        self.paymodel = pay;
                        if ([pay.payType integerValue] == 300) {//300微信
                            UIActionSheet * aa =  [[UIActionSheet alloc] initWithTitle:@"支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信", nil];
                            aa.tag = 500;//单个微信支付
                            [aa showInView:self.view];
                        }
                        if ([pay.payType integerValue] == 400) {//400支付宝
                            UIActionSheet * aa =  [[UIActionSheet alloc] initWithTitle:@"支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝", nil];
                            aa.tag = 700;//单个支付宝支付
                            [aa showInView:self.view];
                        }
                    }else if(namesArray.count == 2){
                        UIActionSheet * aa =  [[UIActionSheet alloc] initWithTitle:@"支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
                        aa.tag = 900;//两个都有的支付
                        [aa showInView:self.view];
                    }
                    
                }
                
            } withOrder:trade_noss];
                return NO;
         

            
        }else{
            NSRange range = [url rangeOfString:@"__newframe"];
            if (range.location != NSNotFound) {
                UIStoryboard * mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                PushWebViewController * funWeb =  [mainStory instantiateViewControllerWithIdentifier:@"PushWebViewController"];
                funWeb.funUrl = url;
                [self.navigationController pushViewController:funWeb animated:YES];
                return NO;
            }else{
                NSRange range = [url rangeOfString:@"back"];
                if (range.location != NSNotFound) {
                    self.showBackArrows = YES;
                }else{
                    self.showBackArrows = NO;
                }
                return YES;
            }
            
        }
        
        
    }else if(webView.tag == 20){
        LoadingState * loInit = [AppDelegate getInstance].loadingState;
        NSString * cc = [NSString stringWithFormat:@"%@%@%@",loInit.website,@"/bottom.aspx?customerid=",loInit.customerId];
        if ([url isEqualToString:cc]) {
            return YES;
        }else if([url rangeOfString:@"http://wpa.qq.com/msgrd?v=3&uin"].location != NSNotFound){
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]; //拨号
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/cn/app/qq/id451108668?mt=12"]]; //拨号
            }
            return NO;
        }else {
            
            
//            NSString * uraaa = [[NSUserDefaults standardUserDefaults] objectForKey:AppMainUrl];
//            NSRange  range = [url rangeOfString:@"com"];
//            NSString * openUrl = [url substringFromIndex:range.location + range.length];

            NSRange range = [url rangeOfString:@"back"];
            NSString * newUrls = nil;
            if (range.location != NSNotFound) {
                
                newUrls = [url stringByReplacingCharactersInRange:range withString:@"back=1"];
            }else{
                newUrls = [NSString stringWithFormat:@"%@&back=1",url];
            }
           
            NSRange ran = [newUrls rangeOfString:@"aspx"];
            NSString * newUrl = nil;
            if (ran.location != NSNotFound) {
                NSRange cc = NSMakeRange(ran.location+ran.length, 1);
                newUrl = [newUrls stringByReplacingCharactersInRange:cc withString:@"?"];
            }
            NSString * dddd = [NSDictionary ToSignUrlWithString:newUrl];
            NSURL * urlStr = [NSURL URLWithString:dddd];
            NSURLRequest * req = [[NSURLRequest alloc] initWithURL:urlStr];
            [self.homeWebView loadRequest:req];
            return NO;
        }
    }
    return YES;
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 500) {//单个微信支付
        NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:PayTypeflat];
        NSData *data = [NSData dataWithContentsOfFile:filename];
        // 2.创建反归档对象
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        // 3.解码并存到数组中
        NSArray *namesArray = [unArchiver decodeObjectForKey:PayTypeflat];
        [self WeiChatPay:namesArray[0]];
    }else if (actionSheet.tag == 700){// 单个支付宝支付
        //NSLog(@"支付宝%ld",(long)buttonIndex);
        //        [self MallAliPay:self.paymodel];
    }else if(actionSheet.tag == 900){//两个都有的支付
        //0
        //1
        NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:PayTypeflat];
        NSData *data = [NSData dataWithContentsOfFile:filename];
        // 2.创建反归档对象
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        // 3.解码并存到数组中
        NSArray *namesArray = [unArchiver decodeObjectForKey:PayTypeflat];
        if (buttonIndex==0) {//支付宝
            PayModel * paymodel =  namesArray[0];
            PayModel *cc =  [paymodel.payType integerValue] == 400?namesArray[0]:namesArray[1];
            if (cc.webPagePay) {//网页支付
                NSRange parameRange = [self.ServerPayUrl rangeOfString:@"?"];
                NSString * par = [self.ServerPayUrl substringFromIndex:(parameRange.location+parameRange.length)];
                NSArray * arr = [par componentsSeparatedByString:@"&"];
                __block NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [arr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
                    NSArray * aa = [obj componentsSeparatedByString:@"="];
                    NSDictionary * dt = [NSDictionary dictionaryWithObject:aa[1] forKey:aa[0]];
                    [dict addEntriesFromDictionary:dt];
                }];
                NSString * js = [NSString stringWithFormat:@"utils.Go2Payment(%@, %@, 1, false)",dict[@"customerID"],dict[@"trade_no"]];
                [self.homeWebView stringByEvaluatingJavaScriptFromString:js];
            }else{
                [self MallAliPay:cc];
            }
        }
        if (buttonIndex==1) {//微信
            PayModel * paymodel =  namesArray[0];
            if ([paymodel.payType integerValue] == 300) {
                [self WeiChatPay:namesArray[0]];
            }else{
                [self WeiChatPay:namesArray[1]];//微信
            }
            
        }
        
    }
    
}

//支付宝
- (void)MallAliPay:(PayModel*)cc{
    
    
}

/**
 *  微信支付
 */
- (void)WeiChatPay:(PayModel *)model{
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [self PayByWeiXinParame:model];
    if(dict != nil){
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
    }else{
        NSLog(@"提示信息----微信预支付失败");
    }
}


/**
 *  微信支付预zhifu
 */
- (NSMutableDictionary *)PayByWeiXinParame:(PayModel *)paymodel{
    
    payRequsestHandler * payManager = [[payRequsestHandler alloc] init];
    [payManager setKey:paymodel.appKey];
    BOOL isOk = [payManager init:self.paymodel.appId mch_id:self.paymodel.partnerId];
    if (isOk) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
        params[@"appid"] = paymodel.appId;
        params[@"mch_id"] = paymodel.partnerId;     //微信支付分配的商户号
        params[@"nonce_str"] = noncestr; //随机字符串，不长于32位。推荐随机数生成算法
        params[@"trade_type"] = @"APP";   //取值如下：JSAPI，NATIVE，APP，WAP,详细说明见参数规定
        params[@"body"] = @"万事利商城"; //商品或支付单简要描述
        NSMutableString * urls = [NSMutableString stringWithString:[AppDelegate getInstance].loadingState.website];
        [urls appendString:paymodel.notify];
        params[@"notify_url"] = urls;  //接收微信支付异步通知回调地址
        NSString * order = [NSString stringWithFormat:@"%@_%@_%d",self.orderNo,[AppDelegate getInstance].loadingState.customerId ,(arc4random() % 900 + 100)];
        params[@"out_trade_no"] = order; //订单号
        params[@"spbill_create_ip"] = @"192.168.1.1"; //APP和网页支付提交用户端ip，Native支付填调用微信支付API的机器IP。
        params[@"total_fee"] = [NSString stringWithFormat:@"%.f",[self.priceNumber floatValue] * 100];  //订单总金额，只能为整数，详见支付金额
        params[@"device_info"] = ([[UIDevice currentDevice].identifierForVendor UUIDString]);
        params[@"attach"] = [NSString stringWithFormat:@"%@_0",[AppDelegate getInstance].loadingState.customerId];
        //获取prepayId（预支付交易会话标识）
        NSString * prePayid = nil;
        prePayid  = [payManager sendPrepay:params];
//        NSLog(@"xcaccasc%@",[payManager getDebugifo]);
        if ( prePayid != nil) {
            //获取到prepayid后进行第二次签名
            NSString    *package, *time_stamp, *nonce_str;
            //设置支付参数
            time_t now;
            time(&now);
            time_stamp  = [NSString stringWithFormat:@"%ld", now];
            nonce_str	= [WXUtil md5:time_stamp];
            //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
            //package       = [NSString stringWithFormat:@"Sign=%@",package];
            package         = @"Sign=WXPay";
            //第二次签名参数列表
            NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
            [signParams setObject: WeiXinAppKey  forKey:@"appid"];
            [signParams setObject: nonce_str    forKey:@"noncestr"];
            [signParams setObject: package      forKey:@"package"];
            [signParams setObject: @"1251040401"   forKey:@"partnerid"];
            [signParams setObject: time_stamp   forKey:@"timestamp"];
            [signParams setObject: prePayid     forKey:@"prepayid"];
            //生成签名
            NSString *sign  = [payManager createMd5Sign:signParams];
            //添加签名
            [signParams setObject: sign forKey:@"sign"];
            [_debugInfo appendFormat:@"第二步签名成功，sign＝%@\n",sign];
            //返回参数列表
            return signParams;
        }else{
            [_debugInfo appendFormat:@"获取prepayid失败！\n"];
        }
        
    }
    return nil;
}








@end

