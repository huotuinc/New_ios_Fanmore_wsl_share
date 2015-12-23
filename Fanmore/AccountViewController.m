//
//  AccountViewController.m
//  Fanmore
//
//  Created by Cai Jiang on 2/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "AccountViewController.h"
#import "BlocksKit+UIKit.h"
#import "InformationController.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "NSNumber+Fanmore.h"
#import "ConfirmController.h"
#import "CommonPasswordController.h"
#import "VerificationCodeController.h"
#import <CoreText/CoreText.h>
#import "MJExtension.h"
#import "SafeController.h"
#import "InformationController.h"
#import "UIImageView+WebCache.h"
#import "JiFenToMallController.h"
#import "WeiChatAuthorize.h"
#import "NSString+SSToolkitAdditions.h"
#import "HomeViewController.h"
#import "MallUser.h"

@interface AccountViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(weak) TextChangeController* tccontroller;
@property BOOL doCash;
@property BOOL doCash2;
#ifdef FanmoreDebug
@property BOOL debugCashPswdDoing;
#endif



//luohaibo
/**账号头像*/
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UITableView *itemTableView;

/**账号信息*/
@property (weak, nonatomic) IBOutlet UILabel *accountInfo;

/**我的积分*/
@property (weak, nonatomic) IBOutlet UILabel *myJifen;


@property(nonatomic,strong) NSArray *userList;
@end

@implementation AccountViewController

-(void)beginOtherControllerForCash{
    self.doCash = YES;
    self.doCash2 = NO;
}

-(void)actionDone{
    if (self.doCash) {
        self.doCash2 = YES;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)doBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickMobile{
    self.doCash = NO;
    self.doCash2 = NO;
    [self performSegueWithIdentifier:@"ToMobile" sender:nil];
}

-(void)clickZfb{
    self.doCash = NO;
    self.doCash2 = NO;
    [self performSegueWithIdentifier:@"ToALP" sender:nil];
}



/** luohaibo
 *  初始化
 */
- (void)setUp{
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.itemTableView.dataSource = self;
    self.itemTableView.delegate = self;
    self.itemTableView.tableFooterView = [[UIView alloc] init];
    self.itemTableView.scrollEnabled = NO;
    
    self.myJifen.layer.cornerRadius = 3;
    self.myJifen.layer.masksToBounds = YES;
    
   
#warning LUOHAIBO

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.iconView.layer.cornerRadius = self.iconView.frame.size.height * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderWidth = 2;
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.navigationController setNavigationBarHidden:NO];
    self.doCash = NO;
    
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)]];
//    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version>=7.0) {
        for (UIView* v in self.view.subviews) {
            LOG(@"%@",v);
            v.autoresizingMask =UIViewAutoresizingNone;
            v.frame = CGRectMake(v.frame.origin.x, v.frame.origin.y+50.0f, v.frame.size.width, v.frame.size.height);
            LOG(@"%@",v);
        }
    }
    
    
    
    //luohaibo
    [self setUp];
    
    __weak AccountViewController* wself = self;
    
    [self.btlogout bk_whenTapped:^{
        
//2015/12/18 luohaibo
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"账号注销" message:nil
    delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
//        [ConfirmController confirm:wself message:@"确实要注销么？" block:^{
//            AppDelegate* ad = [AppDelegate  getInstance];
//            [ad logout:wself];
//            [ad storeLastUserInformation:@"" password:@""];
//            [wself.parentViewController dismissViewControllerAnimated:YES completion:NULL];
//        }];
    }];
    
    [self.buttonMobile addTarget:self action:@selector(clickMobile) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonZfb addTarget:self action:@selector(clickZfb) forControlEvents:UIControlEventTouchUpInside];
//    self.zfbLabel.userInteractionEnabled = YES;
//    [self.zfbLabel bk_whenTapped:^{
//        wself.doCash = NO;
//        wself.doCash2 = NO;
//        [wself performSegueWithIdentifier:@"ToALP" sender:wself.zfbLabel];
//    }];
//    self.label.userInteractionEnabled = YES;
//    [self.label bk_whenTapped:^{
//        wself.doCash = NO;
//        wself.doCash2 = NO;
//        [wself performSegueWithIdentifier:@"ToMobile" sender:wself.label];
//    }];
    
    
    self.imagePicture.userInteractionEnabled = YES;
    [self.imagePicture bk_whenTapped:^{
        [wself performSegueWithIdentifier:@"ToInformation" sender:nil];
    }];
    
    if ([[AppDelegate getInstance].loadingState useNewCash]){
        [self.viewMain setContentSize:CGSizeMake(320, 630-65-25)];
    }else
        [self.viewMain setContentSize:CGSizeMake(320, 630)];
    self.viewMain.showsHorizontalScrollIndicator = NO;
    self.viewMain.showsVerticalScrollIndicator = NO;
//    [self.viewMain setScrollEnabled:YES];
//    double version = [[UIDevice currentDevice].systemVersion doubleValue];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //luohaibo
    [self toGetTheGlodToMallAccountList];

}

#warning 用户
/**
 *  获取用户列表
 */
- (void)toGetTheGlodToMallAccountList{
    LoginState * a =  [AppDelegate getInstance].loadingState.userData;
    [[[AppDelegate getInstance]  getFanOperations] TOGetUserList:nil block:^(id result, NSError *error) {
        if (result) {//保存用户列表
            NSArray * UserList = [MallUser objectArrayWithKeyValuesArray:result];
            //创建归档辅助类
            NSMutableData *data = [[NSMutableData alloc] init];
            //创建归档辅助类
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            //编码
            [archiver encodeObject:UserList forKey:MallUesrList];
            //结束编码
            [archiver finishEncoding];
            NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:MallUesrList];
            //写入
            [data writeToFile:filename atomically:YES];
        }
    } WithunionId:a.unionId];
}




/**
 *  账号注销
 *
 *  @param alertView   <#alertView description#>
 *  @param buttonIndex <#buttonIndex description#>
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    NSLog(@"%d",buttonIndex);
    if (buttonIndex == 1) {
        
        AppDelegate* ad = [AppDelegate  getInstance];
        [ad logout:self];
        [ad storeLastUserInformation:@"" password:@""];
        
        
        UIStoryboard * mainS = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WeiChatAuthorize * WeiChart = [mainS instantiateViewControllerWithIdentifier:@"WeiChatAuthorize"];
        WeiChart.loginType = 2;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:WeiChart];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellId = @"CellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"jlsc"];
        cell.textLabel.text = @"进入商城";
        
    }else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"zh"];
        cell.textLabel.text = @"账户安全";
        
    }else if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"jb"];
        cell.textLabel.text = @"基本信息";
        
    }else{
        cell.imageView.image = [UIImage imageNamed:@"xjk"];
        cell.textLabel.text = @"积分兑换至商城";
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {//进入商城
        
#warning luohaibo
        // 1.得到data
        NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:MallUesrList];
        NSData *data = [NSData dataWithContentsOfFile:filename];
        // 2.创建反归档对象
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        // 3.解码并存到数组中
        NSArray *namesArray = [unArchiver decodeObjectForKey:MallUesrList];
        if (namesArray.count) {
            MallUser * user = namesArray[0];
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString * file = [path stringByAppendingPathComponent:ChoneMallAccount];
            [NSKeyedArchiver archiveRootObject:user toFile:file];
        }
        
        
        UIStoryboard * story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeViewController * home = [story instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self.navigationController pushViewController:home animated:YES];
    }else if (indexPath.row == 1){//账户安全
        SafeController * safe = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"SafeController"];
        [self.navigationController pushViewController:safe animated:YES];
    }else if (indexPath.row == 2){//基本信息
        InformationController * safe = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"InformationController"];
        [self.navigationController pushViewController:safe animated:YES];
    }else{//积分兑换小金库
        JiFenToMallController * safe = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"JiFenToMallController"];
        [self.navigationController pushViewController:safe animated:YES];
        
    }
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

//- (NSString *)ToSignUrlWithString:(NSString *)urlStr{
//    NSMutableString * signUrl = [NSMutableString stringWithString:urlStr]; //元素url
//    [signUrl appendFormat:@"?"];
//    NSDate * timestamp = [[NSDate alloc] init];
//    NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[timestamp timeIntervalSince1970] * 1000];  //转化为UNIX时间戳
//    [signUrl appendFormat:@"appid=%@",HuoBanMallBuyAppId];
//    [signUrl appendFormat:@"&timestamp=%@",timeSp];
//    
//    LoadingState * load =  [AppDelegate getInstance].loadingState;
//    
//    [signUrl appendFormat:@"&buserid=%@",load.userData.unionId];
//    
//    [signUrl appendFormat:@"&unionid=%@",load.userData.unionId];
//    NSRange new = [signUrl rangeOfString:@"?"];
//    
//    if (new.location != NSNotFound) {
//        
//        NSString * newUrlStr = [signUrl substringFromIndex:new.location+1];
//        NSArray * separeArray = [newUrlStr componentsSeparatedByString:@"&"]; //？后面的东西
//        NSMutableArray * keys = [NSMutableArray array];
//        for (int i = 0; i<separeArray.count; i++) {//参数的键
//            NSString * sr =  separeArray[i];
//            NSArray *keyArray = [sr componentsSeparatedByString:@"="];
//            [keys addObject:keyArray[0]];
//        }
//        
//        
//        NSMutableArray * sssdasdasd = [NSMutableArray array];
//        for (int i = 0; i<keys.count; i++) {
//            NSString * sss =  separeArray[i];
//            NSString * ccc =  keys[i];
//            NSString * aaaaaaaa = [sss stringByReplacingOccurrencesOfString:keys[i] withString:[ccc lowercaseString]];
//            [sssdasdasd addObject:aaaaaaaa];
//        }
//        NSArray * arr = [sssdasdasd sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
//            return [obj1 compare:obj2] == NSOrderedDescending;
//        }];
//        NSMutableString * signCap = [[NSMutableString alloc] init];
//        for (int i = 0; i<arr.count; i++) {
//            if (i == 0) {
//                [signCap appendString:arr.firstObject];
//            }else{
//                [signCap appendFormat:@"&%@",arr[i]];
//            }
//        }
//        [signCap appendFormat:@"%@",HuoBanMallBuyAppSecrect];
//        NSString * sign = [signCap MD5Sum];
//        [signUrl appendFormat:@"&sign=%@",sign];
//        return signUrl;
//    }
//    return nil;
//}
//


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    /**luohaibo 用户个人信息*/
    LoginState * userData = [[AppDelegate getInstance].loadingState userData];
    
    self.accountInfo.text = userData.userName;
    self.myJifen.text = [NSString stringWithFormat:@" 我的积分:%d ",[userData.score integerValue]];
    
    
    [self.navigationController setNavigationBarHidden:NO];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    NSString * headUrl =  [[[AppDelegate getInstance].loadingState userData] picUrl];
    LOG(@"%@",headUrl);
    NSArray * head = [headUrl componentsSeparatedByString:@"http"];
    
    NSString * aass = nil;
    if (head.count == 2) {
        aass = [NSString stringWithFormat:@"http%@",head[1]];
        LOG(@"%@",aass);
    }else if(head.count == 3){
        aass = [NSString stringWithFormat:@"http%@",head[2]];
    }
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:aass] placeholderImage:[UIImage imageNamed:@"WeiXinIIconViewDefaule"] options:SDWebImageRetryFailed];
    [self.view layoutIfNeeded];
    
    
//    [self viewDidLoadGestureRecognizer];
////    UserInformation* ui = [AppDelegate  getInstance].currentUser;
//    LoginState* ls = [AppDelegate getInstance].loadingState.userData;
//    
//    
//    
//    if ([ls.isBindMobile boolValue] && $safe(ls.mobile)){
//        NSString* strtoattr =ls.mobile;
//        CGFloat fontSize = 19.0f;
//        while(true){
//            CGSize size = [strtoattr sizeWithFont:[UIFont systemFontOfSize:fontSize]];
//            if(size.width<self.buttonMobile.frame.size.width)
//                break;
//            fontSize--;
//        }
//        
//        NSMutableAttributedString* mobile = [[NSMutableAttributedString alloc] initWithString:strtoattr];
//        
////        [mobile addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:fontSize].fontName,fontSize,NULL)) range:NSMakeRange(0, [strtoattr length])];
//        
//        [self.buttonMobile setAttributedTitle:mobile forState:UIControlStateNormal];
////        [self.buttonMobile setTitle:strtoattr forState:UIControlStateNormal];
//        [self.buttonMobile.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
////        [self.buttonMobile.titleLabel setText:strtoattr];
//        [self.labelMobile setText:@"(取消/修改绑定手机)"];
//    }else{
//        NSString* strtoattr =@"绑定手机号码";
//        NSMutableAttributedString* mobile = [[NSMutableAttributedString alloc] initWithString:strtoattr];
//        
////        [mobile addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:17.0f].fontName,17.0f,NULL)) range:NSMakeRange(0, [strtoattr length])];
//        
//        [self.buttonMobile setAttributedTitle:mobile forState:UIControlStateNormal];
////        [self.buttonMobile setTitle:strtoattr forState:UIControlStateNormal];
//        [self.buttonMobile.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
////        [self.buttonMobile.titleLabel setText:strtoattr];
//        [self.labelMobile setText:@"(未绑定)"];
//    }
//    
//    if ($safe(ls.alipayId) && ls.alipayId.length>2){
//        NSString* strtoattr =ls.alipayId;
//        CGFloat fontSize = 19.0f;
//        while(true){
//            CGSize size = [strtoattr sizeWithFont:[UIFont systemFontOfSize:fontSize]];
//            if(size.width<self.buttonMobile.frame.size.width)
//                break;
//            fontSize--;
//        }
//        
//        NSMutableAttributedString* mobile = [[NSMutableAttributedString alloc] initWithString:strtoattr];
//        
////        [mobile addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:fontSize].fontName,fontSize,NULL)) range:NSMakeRange(0, [strtoattr length])];
//        
//        [self.buttonZfb setAttributedTitle:mobile forState:UIControlStateNormal];
////        [self.buttonZfb setTitle:strtoattr forState:UIControlStateNormal];
//        [self.buttonZfb.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
////        [self.buttonZfb.titleLabel setText:strtoattr];
//        [self.labelZfb setText:@"(修改绑定支付宝)"];
//    }else{
//        NSString* strtoattr =@"绑定支付宝";
//        NSMutableAttributedString* mobile = [[NSMutableAttributedString alloc] initWithString:strtoattr];
//        
////        [mobile addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:17.0f].fontName,17.0f,NULL)) range:NSMakeRange(0, [strtoattr length])];
//        
//        [self.buttonZfb setAttributedTitle:mobile forState:UIControlStateNormal];
////        [self.buttonZfb setTitle:strtoattr forState:UIControlStateNormal];
//        [self.buttonZfb.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
////        [self.buttonZfb.titleLabel setText:strtoattr];
//        [self.labelZfb setText:@"(未绑定)"];
//    }
//    
////    self.nameLabel.text = ls.userName;
////    
////    CGFloat fontSize = 19.0f;
////    while ([self.nameLabel.text sizeWithFont:self.nameLabel.font].width>CGRectGetWidth(self.nameLabel.frame)) {
////        fontSize -= 1.0f;
////        self.nameLabel.font = [UIFont systemFontOfSize:fontSize];
////    }
////    
////    if ($safe(ls.alipayId) && ls.alipayId.length>5){
////        self.zfbLabel.text = ls.alipayId;
////    }else{
////        self.zfbLabel.text = @"(我的支付宝未绑定)";
////    }
////    
////    if ([ls.isBindMobile boolValue] && $safe(ls.mobile)){
////        self.label.text = ls.mobile;
////    }else{
////        self.label.text = @"(我的手机号码未绑定)";
////    }
////    
//    
//    self.scoreLabel.text = [ls.score currencyStringMax2Digits];
////    self.tickedScoreLabel.text = [ls.lockScore currencyString:@"" fractionDigits:0];
//    
////    ls.lockScore = @10000;
//    if ([[AppDelegate getInstance].loadingState useNewCash]) {
//        [self.bttixian setBackgroundColor:fmMainColor];
//        [self.bttixian setTitle:@"我的钱包" forState:UIControlStateNormal];
//        [self.bttixian setImage:nil forState:UIControlStateDisabled];
//        [self.bttixian setImage:nil forState:UIControlStateNormal];
//        [self.bttixian setEnabled:YES];
//    }else if ([ls.lockScore intValue]>0) {
//        [self.bttixian setBackgroundColor:fmMainColor];
//        [self.bttixian setTitle:$str(@"%@积分提现中",ls.lockScore) forState:UIControlStateDisabled];
//        [self.bttixian setImage:nil forState:UIControlStateDisabled];
//        [self.bttixian setImage:nil forState:UIControlStateNormal];
//        [self.bttixian setEnabled:NO];
//    }else{
//        [self.bttixian setBackgroundColor:[UIColor clearColor]];
//        [self.bttixian setTitle:nil forState:UIControlStateDisabled];
//        [self.bttixian setImage:[UIImage imageNamed:@"tixiananniu"] forState:UIControlStateNormal];
//        [self.bttixian setEnabled:YES];
//    }
//    
//    self.tickedScoreLabel.text = [ls.totalScore currencyString:@"" fractionDigits:2];
//    self.todaySendLabel.text = $str(@"%@/%@",ls.completeTaskCount,ls.totalTaskCount);
//    
//    
//    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].detailTextLabel.text = [ls.turnAmount stringValue];
//    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]].detailTextLabel.text = [ls.favoriteAmount stringValue];
//    
//    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]].detailTextLabel.text = [ls.crashCount currencyString:@"￥" fractionDigits:1];
//    
//    [self.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
//    
//    if (self.doCash && self.doCash2) {
//        [self bk_performBlock:^(id obj) {
//            if ([obj shouldPerformSegueWithIdentifier:@"ToCash" sender:nil]) {
//                [obj performSegueWithIdentifier:@"ToCash" sender:nil];
//            }
//        } afterDelay:0.5f];
//    }
//    
//    self.doCash = NO;
//    self.doCash2 = NO;
//    
////    __weak AccountViewController* wself = self;
//    
////    UserInformation* ui =[AppDelegate getInstance].currentUser;
//    
//    [ls updateUserPicture:self.imagePicture];
//        
////    if ($safe(ui.name) && ui.name.length>0) {
////        [self.labelName setText:ui.name];
////    }else
//        [self.labelName setText:ls.userName];
//    
//    [self.labelExp setText:$str(@"%@Exp.",ls.exp)];
//    
//    [self showNoshadowNavigationBar];
//    
//    [self.imageInformationHinter setHidden:[ls.completeInfo boolValue]];
//    
//    if ([[AppDelegate getInstance].loadingState useNewCash]) {
//        [self.innerButtonView hidenme];
//        for (NSLayoutConstraint* lc in self.innerButtonView.constraints) {
//            if (lc.firstItem==self.innerButtonView && lc.firstAttribute == NSLayoutAttributeHeight) {
//                lc.constant = 0;
//            }
//        }
////
////        [self.buttonZfb hidenme];
////        [self.labelZfb hidenme];
////        for (NSLayoutConstraint* lc in self.innerButtonView.constraints) {
////            if (lc.firstAttribute==NSLayoutAttributeLeading
////                && (
////                    lc.firstItem==self.buttonMobile || lc.firstItem == self.labelMobile
////                    )) {
////                    lc.constant = 70;
////                }
////        }
//    }
//    
}



#pragma mark storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ($eql(@"ToCash",segue.identifier)) {
        TextChangeController* tcc = segue.destinationViewController;
        tcc.delegate = self;
        self.tccontroller = tcc;
    }
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if ($eql(@"ToCash",identifier)) {
        LoadingState* ls = [AppDelegate getInstance].loadingState;
        
        if ([ls useNewCash]) {
            UIStoryboard* mine = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
            UIViewController* uc = [mine instantiateViewControllerWithIdentifier:@"NewCashController"];
            [self.navigationController pushViewController:uc animated:YES];
            return NO;
        }
#ifdef FanmoreDebugCashRightNow
        [FMUtils shareMyCash:self];
        return NO;
#endif
        CashResultTye type = [FMUtils tryCash];
        __weak AccountViewController* wself = self;
        
        NSString* msg,*segueName;
        
        switch (type) {
            case CashResultOK:
                return YES;
            case CashResultNotEnoughScore:
                [FMUtils alertMessage:self.view msg:$str(@"最少%@积分才可以提现哦，亲！",ls.changeBoundary)];
                return NO;
            case CashResultALP:
                if (!$safe(msg)) {
                    msg = @"请先绑定支付宝账号。";
                    segueName = @"ToALP";
                }
            case CashResultMobile:
                if (!$safe(msg)) {
                    msg = @"请先绑定手机号码。";
                    segueName = @"ToMobile";
                }
            case CashResultPassword:
                if (!$safe(msg)) {
                    msg = @"请先设置提现密码。";
                    segueName = @"ToCashPswd";
                }                
                [FMUtils alertMessage:self.view msg:msg block:^{
                    wself.doCash =YES;
                    wself.doCash2 = NO;
                    [wself performSegueWithIdentifier:segueName sender:wself.view];
                }];
                return NO;
        }
    }
    return YES;
}

#pragma mark 体现

-(void)submitText:(NSString*)str{
    //接受了
}

-(void)initText:(UITextField*)text andHint:(UILabel*)label{
    LoginState* ls = [AppDelegate getInstance].loadingState.userData;
    [label setText:[ls cashScoreHint]];
    CGFloat size = 15.0f;
    while ([label.text sizeWithFont:label.font].width>CGRectGetWidth(label.frame)) {
        size -= 1.0f;
        label.font = [UIFont boldSystemFontOfSize:size];
    }
}

-(void)textUpdated:(UITextField*)text andHint:(UILabel*)label{
//    label.text = @"";
    LoginState* ls = [AppDelegate getInstance].loadingState.userData;
    [label setText:[ls cashScoreHint]];
}

-(BOOL)textChanged:(UITextField*)text OnHint:(UILabel*)label{
    //check here
    if (!$safe(text.text)|| ![text.text isPassword]) {
        [text shake];
        label.text = @"请输入有效的提现密码。";
        return NO;
    }
    __weak AccountViewController* wself = self;
    [[[AppDelegate getInstance]getFanOperations]cash:Nil block:^(NSString *msg, NSError *error) {
        if ($safe(error)) {
            void(^wrongPswdBlock)() = ^() {
                [text shake];
            };
            switch (error.code) {
                case 53008:
                    label.text=@"错误的提现密码";
                    [[AppDelegate getInstance]attemptPassword:wself.tccontroller wrong:YES block:wrongPswdBlock];
                    return;
                case 52001:
                    label.text=@"需要支付宝绑定";
                    return;
                case 52002:
                    label.text=@"需要上次积分提现处理完成";
                    return;
                case 52003:
                    label.text=@"需要大于提现基准分";
                    return;
                case 52004:
                    [text shake];
                    label.text=@"需要设置提现密码";
                    return;
                default:
//#ifdef FanmoreDebug
//                    msg = @"假装成功了！";
//                    break;
//#endif
                    [[AppDelegate getInstance] attemptPassword:wself.tccontroller wrong:NO block:NULL];
                    [FMUtils alertMessage:wself.tccontroller.view msg:[error FMDescription]];
                    return;
            }
        }
        
        [[AppDelegate getInstance] attemptPassword:wself wrong:NO block:NULL];
        [wself viewWillAppear:YES];
        [wself.tccontroller doBack];
        if (!$safe(msg) || msg.length==0) {
            msg =@"成功申请，请耐心等候";
        }
        [FMUtils alertMessage:wself.view msg:msg block:^{
            [FMUtils shareMyCash:wself];
//            [wself shareMyCash];
        }];
    } password:text.text];
    
    return NO;
}



- (IBAction)refresh:(id)sender {
    
    LOG(@"xxxx");
    AppDelegate* ad = [AppDelegate getInstance];
    [[ad getFanOperations] login:Nil block:^(LoginState *ls, NSError *error) {
        if ($safe(error)) {
            [FMUtils alertMessage:self.view msg:[error FMDescription]];
            return;
        }
        [self viewWillAppear:YES];
    } userName:[ad getLastUsername] password:[ad getLastPassword]];
}


//- (IBAction)goToMartkeyClick:(id)sender {
//}
//- (IBAction)bingDingIphoneBtnClick:(id)sender {
//    [self performSegueWithIdentifier:@"ToMobile" sender:nil];
//}
@end
