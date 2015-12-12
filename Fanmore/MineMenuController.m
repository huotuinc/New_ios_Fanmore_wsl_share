//
//  MineMenuController.m
//  Fanmore
//
//  Created by Cai Jiang on 2/8/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "MineMenuController.h"
#import "BlocksKit+UIKit.h"
#import "AppDelegate.h"
#import "NSNumber+Fanmore.h"
#import "LoginController.h"
#import "WebController.h"
#import "ParticipatesController.h"
#import "FMUtils.h"
#import "UICallbacks.h"
#import "UIViewController+CWPopup.h"
#import "TodayBrowseController.h"
#import "ScoreOneDayController.h"
#import "MasterViewController.h"
#import "SignController.h"
#import "UIView+SSToolkitAdditions.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MasterAndTudiViewController.h"

#define MMImageWidthRate 0.8f
#define MMImageHeightRate 0.8f
#define MMImageLastWidth 0.0f

@interface MineMenuController ()
@property BOOL shaking;
@property UIImageView* mainImage;

//
////luohaibo
///**首页*/
//- (IBAction)homeButtonClick:(id)sender;
///**我的账号点击*/
//- (IBAction)myAccountClick:(id)sender;
///**今日预告*/
//- (IBAction)todayCaveat:(id)sender;
///**师徒联盟*/
//- (IBAction)masterAlliance:(id)sender;
///**规则说明*/
//- (IBAction)ruleSade:(id)sender;
///**更多说明*/
//- (IBAction)moreoption:(id)sender;
///**头像*/
//@property (weak, nonatomic) IBOutlet UIButton *iconViewBtn;
///**头像按钮点击*/
//- (IBAction)iconViewBtnClick:(id)sender;

@end

@implementation MineMenuController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ($eql(segue.identifier,@"ToPutin")) {
        [[segue destinationViewController]viewWeb:[AppDelegate getInstance].loadingState.putInUrl];
    }
//    if ($eql(segue.identifier,@"ToAbout")) {
//        [[segue destinationViewController]viewWeb:[AppDelegate getInstance].loadingState.aboutUsUrl];
//    }
    if (sender==self.rulel) {
        [[segue destinationViewController]viewWeb:[AppDelegate getInstance].loadingState.ruleUrl];
//    }else if ($eql(segue.identifier,@"ToYesTasks")){
//        ParticipatesController* pcc = segue.destinationViewController;
//        pcc.participatesType=1;
    }
}


-(void)refreshStatus{
    if ($safe(self.taskListController)) {
        [self.taskListController clickRefresh:nil];
    }
}

- (void)logout{
    [self refreshStatus];
}

- (void)clickHome{
    
    NSLog(@"click ----首页");
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        CGAffineTransform trans =CGAffineTransformTranslate(CGAffineTransformMakeScale(1, 1), 0, 0);
        [self.mainImage setTransform:trans];
    } completion:^(BOOL finished) {
        [self.taskListController dismissViewControllerAnimated:NO completion:NULL];
        self.taskListController = nil;
    }];
    
}

-(void)clickShareApp{
    if (![[AppDelegate getInstance].loadingState hasLogined]) {
        [FMUtils afterLogin:@selector(clickShareApp) invoker:self];
        return;
    }
    [MasterViewController pushMaster:self];
//    [self performSegueWithIdentifier:@"ToShareApp" sender:self.sharei];
}

-(void)clickRule{
    [self performSegueWithIdentifier:@"ToRule" sender:self.rulel];
}

-(void)clickMore{
    [self performSegueWithIdentifier:@"ToMore" sender:self.morei];
}

-(void)clickAccount{
    [self viewWillAppear:YES];
    if (![[AppDelegate getInstance].loadingState hasLogined]) {
        [FMUtils afterLogin:@selector(clickAccount) invoker:self];
        return;
    }
    [self performSegueWithIdentifier:@"ToAccount" sender:self.homei];
}

-(void)handleGesture:(UIGestureRecognizer*)gestureRecognizer{
    UISwipeGestureRecognizer* ssender = (UISwipeGestureRecognizer*)gestureRecognizer;
    if (ssender.direction==UISwipeGestureRecognizerDirectionLeft){
        [self clickHome];
    }
    if (ssender.direction==UISwipeGestureRecognizerDirectionRight){
//        [self doBack];
    }
}


- (void)homeIconClick{
    
    
    
    NSLog(@"xxxx");
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:fmMainColor];
    
    self.view.userInteractionEnabled = YES;
    
    UIImageView* redt = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 6, 6)];
    
    redt.image = [UIImage imageNamed:@"renyuan"];
    [self.view addSubview:redt];
   
    
    redt = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 6, 6)];
    redt.image = [UIImage imageNamed:@"renyuan"];
    [self.view addSubview:redt];
 
    
    __weak MineMenuController* wself = self;
    void(^shareAppWorker)() = ^(){
        [wself clickShareApp];
    };
    void(^homeWorker)() = ^() {
        [wself clickHome];
    };
    
    void(^previewWorker)() = ^() {
        [wself performSegueWithIdentifier:@"ToPreview" sender:nil];
    };
    void(^toufangWorker)() = ^() {
        [wself performSegueWithIdentifier:@"ToPutin" sender:nil];
    };
    
    void(^accountWorker)() = ^() {
        [wself clickAccount];
    };
    void(^moreWorker)() = ^() {
        [wself clickMore];
    };
    void(^ruleWorker)() = ^() {
        [wself clickRule];
    };
    void(^yesScoreWorker)() = ^() {
        LoadingState* ls = [AppDelegate getInstance].loadingState;
        if ([ls hasLogined]) {
//            NSNumber* totalScore = ls.userData.yesScore;
//            if ($safe(totalScore) && [totalScore intValue]>0) {
                [ScoreOneDayController pushScoreOneDay:nil on:wself];
//            }
        }else{
            [wself clickAccount];
        }
    };
    
    self.myYesterdayRewards.userInteractionEnabled = YES;
    [self.myYesterdayRewards bk_whenTapped:yesScoreWorker];


    self.labelStaticYesScore.userInteractionEnabled = YES;
    [self.labelStaticYesScore bk_whenTapped:yesScoreWorker];
    
//    NSMutableAttributedString* content = [[NSMutableAttributedString alloc] initWithString:@"昨日积分收益"];
//    NSRange contentRange = {0,[content length]};
//    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
//    self.labelStaticYesScore.attributedText = content;
    
    for (int i = 0; i < 2; i++) {
        UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        swipeRecognizer.direction = (i == 0 ? UISwipeGestureRecognizerDirectionRight : UISwipeGestureRecognizerDirectionLeft);
        [self.view addGestureRecognizer:swipeRecognizer];
    }
    
    self.homei.userInteractionEnabled = YES;
    self.homel.userInteractionEnabled = YES;
    
    
    UIGestureRecognizer *gs = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeIconClick)];
    [self.homei addGestureRecognizer:gs];
    
    
    
//    [self.homei bk_whenTapped:^{
//       [wself clickHome];
//    }];
    [self.homei bk_whenTapped:^{
        
        NSLog(@"xxxx");
    }];
//    [self.homel bk_whenTapped:homeWorker];
    
    self.tnoticeI.userInteractionEnabled = YES;
    self.tnoticeL.userInteractionEnabled = YES;
    [self.tnoticeI bk_whenTapped:previewWorker];
    [self.tnoticeL bk_whenTapped:previewWorker];
    
    self.toufangI.userInteractionEnabled = YES;
    self.toufangL.userInteractionEnabled = YES;
    [self.toufangI bk_whenTapped:toufangWorker];
    [self.toufangL bk_whenTapped:toufangWorker];
    
    self.accounti.userInteractionEnabled=YES;
    self.accountl.userInteractionEnabled=YES;
    [self.accounti bk_whenTapped:accountWorker];
    [self.accountl bk_whenTapped:accountWorker];
    
    self.imagePicture.userInteractionEnabled = YES;
    [self.imagePicture bk_whenTapped:accountWorker];
    
    self.rulei.userInteractionEnabled=YES;
    self.rulel.userInteractionEnabled=YES;
    [self.rulei bk_whenTapped:ruleWorker];
    [self.rulel bk_whenTapped:ruleWorker];
    
    self.morei.userInteractionEnabled=YES;
    self.morel.userInteractionEnabled=YES;
    [self.morei bk_whenTapped:moreWorker];
    [self.morel bk_whenTapped:moreWorker];
    
    self.sharei.userInteractionEnabled= YES;
    self.sharel.userInteractionEnabled=YES;
    [self.sharei bk_whenTapped:shareAppWorker];
    [self.sharel bk_whenTapped:shareAppWorker];
        
    self.mainImage = [[UIImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.mainImage];
    self.mainImage.image = [self.mainImageImage copy];
//    self.mainImage.backgroundColor = [UIColor blackColor];
    
    CGFloat widthRate = MMImageWidthRate;
    CGFloat heightRate = MMImageHeightRate;//    CGFloat y = 300.0f;
//    CGSize size = self.mainImage.bounds.size;
//    CGRect rect = CGRectMake(size.width*widthRate*2, 0, size.width*widthRate, size.height*heightRate);
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        CGAffineTransform trans =CGAffineTransformTranslate(CGAffineTransformMakeScale(widthRate, heightRate), 320.0f-MMImageLastWidth, 0);
        //320.0f*(0.5f+MMImageWidthRate/2.0f)-MMImageLastWidth
        [self.mainImage setTransform:trans];
    } completion:NULL];
    
//    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        CGAffineTransform trans =CGAffineTransformMakeScale(widthRate, heightRate);
//        [self.mainImage setTransform:trans];
//    } completion:^(BOOL f){
//        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            CGAffineTransform trans =CGAffineTransformTranslate(self.mainImage.transform, rect.origin.x, rect.origin.y);
//            [self.mainImage setTransform:trans];
//        } completion:NULL];
//    }];
    
    
    self.mainImage.userInteractionEnabled = YES;
    [self.mainImage bk_whenTapped:homeWorker];
//    self.mainImage = nil;
//    self.mainImageImage = nil;
    
    void(^gettingWorker)() = ^() {
        LoadingState* ls = [AppDelegate getInstance].loadingState;
        if ([ls hasLogined]) {
//            NSNumber* totalScore = ls.userData.totalScore;
//            if ($safe(totalScore) && [totalScore intValue]>0) {
                [wself performSegueWithIdentifier:@"getting" sender:wself.labelTotalScore];
//            }
        }
    };
    
    void(^todayBrowseWorker)() = ^() {
        LoadingState* ls = [AppDelegate getInstance].loadingState;
        if ([ls hasLogined]) {
//            NSNumber* totalScore = ls.userData.todayBrowseCount;
//            if ($safe(totalScore) && [totalScore intValue]>0) {
                [TodayBrowseController pushTodayBrowse:wself];
//            }
        }
    };
    
    self.labelTotalScore.userInteractionEnabled = YES;
    [self.labelTotalScore bk_whenTapped:gettingWorker];
    self.staticLabelScoreTotal.userInteractionEnabled = YES;
    [self.staticLabelScoreTotal bk_whenTapped:gettingWorker];
    
    self.labelExp.userInteractionEnabled = YES;
    self.labelName.userInteractionEnabled = YES;
    [self.labelExp bk_whenTapped:gettingWorker];
    [self.labelName bk_whenTapped:gettingWorker];
    
    self.labelBrowses.userInteractionEnabled = YES;
    [self.labelBrowses bk_whenTapped:todayBrowseWorker];
    self.staticLabelBrowseToday.userInteractionEnabled = YES;
    [self.staticLabelBrowseToday bk_whenTapped:todayBrowseWorker];
    
    void(^toMalWorker)() = ^(){
        [wself performSegueWithIdentifier:@"ToMall" sender:nil];
    };
    
    self.labelMall.userInteractionEnabled = YES;
    self.imageMall.userInteractionEnabled = YES;
    [self.labelMall bk_whenTapped:toMalWorker];
    [self.imageMall bk_whenTapped:toMalWorker];

    if ([UIScreen mainScreen].bounds.size.height!=568.0f){
#warning luohaibo 2015/12/2
        [self showGuide:@"guidemm35" on:nil];
    }else
#warning luohaibo 2015/12/2
        [self showGuide:@"guidemm" on:nil];
    
    void(^ToSign)() = ^(){
        SignController* sc = [wself.storyboard instantiateViewControllerWithIdentifier:@"SignController"];
        sc.lastImage = [wself.view imageRepresentation];
        [wself.navigationController pushViewController:sc animated:NO];
    };
    
    [self.buttonSign bk_whenTapped:ToSign];
    self.labelSign.userInteractionEnabled = YES;
    [self.labelSign bk_whenTapped:ToSign];
    
    void (^toItem)() = ^(){
        LoadingState* ls = [AppDelegate getInstance].loadingState;
        if ([ls hasLogined])
            [wself performSegueWithIdentifier:@"ToItem" sender:nil];
    };
    
    self.imageItem.userInteractionEnabled = YES;
    [self.imageItem bk_whenTapped:toItem];
    self.labelItem.userInteractionEnabled = YES;
    [self.labelItem bk_whenTapped:toItem];

//    [self.view addGestureRecognizer:[UISwipeGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
//        UISwipeGestureRecognizer* ssender = (UISwipeGestureRecognizer*)sender;
//        if (ssender.direction==UISwipeGestureRecognizerDirectionRight){
//            [wself performSegueWithIdentifier:@"ToRanking" sender:nil];
//        }
//    }]];
    
    // 找到定位BUTTON的约定
    NSLayoutConstraint* abc = nil;
    for (NSLayoutConstraint* lc in self.view.constraints) {
        if (![lc.firstItem isKindOfClass:[UILabel class] ] && lc.secondItem==self.buttonSign) {
            abc = lc;
            break;
        }
    }
    
    //大小
    if ([self is35Inch]) {
        // 6
        abc.constant = 37.0f;
    }else{
        abc.constant = 75.0f;
    }
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version<7 && [UIScreen mainScreen].bounds.size.height<500 ) {
        abc.constant = 13;
        [self.labelBottomMsg hidenme];
    }

}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    [AppDelegate getInstance].mineNav = self.navigationController;
    
    __weak MineMenuController* wself = self;
    
    NSNumberFormatter* nsf1 = $new(NSNumberFormatter);
    [nsf1 setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nsf1 setCurrencySymbol:@""];
    [nsf1 setMaximumFractionDigits:2];
    [nsf1 setMinimumFractionDigits:0];
    [nsf1 setNegativePrefix:@"-"];
    [nsf1 setNegativeSuffix:@""];
    
    LoadingState* ls = [AppDelegate getInstance].loadingState;
    if ([ls hasLogined]) {
        self.accountl.text = NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.mm.account",nil,[NSBundle mainBundle],@"我的账号",nil);
        if ($safe(ls.userData) && $safe(ls.userData.yesScore)) {
            self.myYesterdayRewards.text = [ls.userData.yesScore currencyStringMax2Digits];
        }else if ($safe(ls.userYesTotalScore)){
            self.myYesterdayRewards.text = [ls.userYesTotalScore currencyStringMax2Digits];
        }else if( $eql(self.myYesterdayRewards.text,@"") ){
            self.myYesterdayRewards.text = @"0";
        }
        
//        NSNumber* totalScore = ls.userData.totalScore;
        NSNumber* totalScore = ls.userData.score;
        if ($safe(totalScore)) {
            [FMUtils dynamicIncreaseLabel:self.labelTotalScore from:@0 to:totalScore duration:1 formatter:nsf1 random:NO];
        }else if( $eql(self.labelTotalScore.text,@"") ){
            self.labelTotalScore.text = @"0";
        }
        
        NSNumber* todayB = ls.userData.todayBrowseCount;
        if ($safe(todayB)) {
            self.labelBrowses.text = [todayB currencyString:@"" fractionDigits:0];
        }else{
            self.labelBrowses.text = @"0";
        }
        
        
        
        [[[AppDelegate getInstance] getFanOperations]getUserTodayBrowseCount:nil block:^(NSNumber *num, NSError *error) {
            if ($safe(num)) {
                wself.labelBrowses.text = [num currencyString:@"" fractionDigits:0];
            }
        }];
    }else{
        
        self.accountl.text = NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.mm.dologin",nil,[NSBundle mainBundle],@"登录/注册",nil);
        self.myYesterdayRewards.text = NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.mm.nologin",nil,[NSBundle mainBundle],@"未登录",nil);
        self.labelTotalScore.text = @"未知";
        self.labelBrowses.text = @"未知";
    }
    
    NSNumber* todayTotal = ls.todayTotalScore;
    
    if ($safe(todayTotal)) {
        [FMUtils dynamicIncreaseLabel:self.totalTaskRewards from:@0 to:todayTotal duration:1 formatter:nsf1 random:NO];
    }else if( $eql(self.totalTaskRewards.text,@"") ){
        self.totalTaskRewards.text = @"0";
    }
    
//    self.redTip.autoresizingMask = 0;
//    CGPoint lastPoint = [FMUtils pointToRightTop:self.myYesterdayRewards];
//    [self.redTip setFrame:CGRectMake(lastPoint.x+0, lastPoint.y, self.redTip.frame.size.width, self.redTip.frame.size.height)];
//    [self.redTip hidenme];
//    
//    if ([ls hasLogined] && [ls.userData hasNewFeedBack]) {
//        self.redTip2.autoresizingMask = 0;
//        self.redTip2.hidden = NO;
//        lastPoint = [FMUtils pointToRightTop:self.morel];
//        [self.redTip2 setFrame:CGRectMake(lastPoint.x+1, lastPoint.y-1, self.redTip.frame.size.width, self.redTip.frame.size.height)];
//    }
//    [self.redTip2 hidenme];
    
    if ([ls hasLogined]) {
//        UserInformation* ui =[AppDelegate getInstance].currentUser;
        
        [ls.userData updateUserPicture:self.imagePicture];
        
//        if ($safe(ui.name) && ui.name.length>0) {
//            [self.labelName setText:ui.name];
//        }else
            [self.labelName setText:ls.userData.userName];
        
        [self.labelExp setText:$str(@"Exp.%@",[ls.userData.exp currencyString:@"" fractionDigits:0])];
        
    }else{
        [self.imagePicture setImage:[UIImage imageNamed:@"queshentu"]];
        [self.labelName setText:@"未登录"];
        [self.labelExp setText:@""];
    }
    
    [self.imageSigngougou setHidden:[ls.userData.dayCheckIn intValue]==0];
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark yaoyao

- (void)shake{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    LoginState* data = [[[AppDelegate getInstance] loadingState] userData];
    if ([data.dayCheckIn intValue]==1) {
        [FMUtils alertMessage:self.view msg:@"您今日已签到"];
        return;
    }
    __weak MineMenuController* wself = self;
    [[[AppDelegate getInstance] getFanOperations] checkIn:nil block:^(NSString *tip, NSError *error) {
        //noop
        if ($safe(error)) {
            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            return;
        }
        [wself viewWillAppear:NO];
    }];
}

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //检测到摇动
    self.shaking = YES;
}

- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //摇动取消
    self.shaking = NO;
}


- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //摇动结束
    if (event.subtype == UIEventSubtypeMotionShake) {
        //something happens
        if (self.shaking) {
            self.shaking = NO;
            //
            LOG(@"shaking!!!");
            [self shake];
        }
    }
}




@end
