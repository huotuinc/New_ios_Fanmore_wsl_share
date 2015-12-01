//
//  ToSendTaskController.m
//  Fanmore
//
//  Created by Cai Jiang on 1/23/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ToSendTaskController.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "LoginController.h"
#import "UIViewController+CWPopup.h"
#import "TaskListController.h"
#import "TaskDetailController.h"
#import "BlocksKit+UIKit.h"
#import "DisasterSendController.h"
#import "TaskComingController.h"

@interface ToSendTaskController ()<ShareToolDelegate,UIScrollViewDelegate,UIWebViewDelegate>
@property Task* task2;

@property BOOL tmoved;
@property BOOL stopShowUps;
@property int stopShowUpsType;
@property BOOL firstWebViewDidFinishLoaded;
@property CGFloat upviewHeight;
@property CGFloat uplabelHeight;
@property int currentState;

@property BOOL animing;
@property int antarget;//0 for hide 1 for show
@end

@implementation ToSendTaskController

-(void)doBack{
    int found = -1;
    for (int i=0; i<self.navigationController.viewControllers.count; i++) {
        if ([self.navigationController.viewControllers[i] isKindOfClass:[TaskComingController class]]) {
            found = i-1;
            break;
        }
    }
    if (found!=-1) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[found] animated:YES];
        return;
    }
//    UIViewController* uc = [self up:[TaskComingController class]];
//    if ($safe(uc)) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
////        [self.navigationController popToViewController:uc animated:YES];
//        return;
//    }
    [super doBack];
}

#pragma mark javascript

-(NSString*)changeHeightOfXibaibai{
//    LOG(@"document.getElementById('xibaibai').style.height = '%dpx' ;%@",(int)(self.uplabelHeight+self.upviewHeight),rs);
//    LOG(@"y of web:%f",self.web.frame.origin.y);
    // document.getElementById('xibaibai').style.height = xx;
    NSString* result = [self.web stringByEvaluatingJavaScriptFromString:$str(@"document.getElementById('xibaibai').style.height = '%dpx'",(int)(self.uplabelHeight+self.upviewHeight))];
    
    if (result && result.length>0) {
        if (self.tmoved) {
            for (NSLayoutConstraint* c in self.view.constraints) {
                if (c.firstItem==self.web && c.secondItem==self.view && c.firstAttribute==NSLayoutAttributeTop && c.secondAttribute==NSLayoutAttributeTop) {
                    c.constant = 0;
                }
            }
            //    [self.web setFrame:CGRectMake(self.web.frame.origin.x, self.web.frame.origin.y+self.uplabelHeight+self.upviewHeight, self.web.frame.size.width, self.web.frame.size.height)];
            self.tmoved = NO;
        }
    }
    
    return result;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //如果是客户提供的URL 那么第一次载入时 如果没有发现xibaibai 则一直显示
    LOG(@"webViewDidFinishLoad");
    NSString* testobj = [self changeHeightOfXibaibai];
    if (!testobj || testobj.length==0) {
        //stopShowUpsType
        self.stopShowUpsType = self.firstWebViewDidFinishLoaded?0:1;
        [self startAnimation:self.stopShowUpsType];
        self.stopShowUps = YES;
    }else
        self.stopShowUps = NO;
    
    if (!self.firstWebViewDidFinishLoaded) {
        self.firstWebViewDidFinishLoaded = YES;
    }
}

#pragma mark scroll

-(void)startAnimation:(int)type{
    
    if ([self.task isUnitedTask]) {
        type = 1;
    }
    
    if (!(![self.task zeroReward] && ![self.task notbeAbletoSend]))
        return;
    
    if (self.currentState!=type) {
        return;
    }
    if (self.animing) {
        return;
    }
    self.upView.translatesAutoresizingMaskIntoConstraints = YES;
    self.labelExtraDes.translatesAutoresizingMaskIntoConstraints = YES;
    self.web.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.animing = YES;
    self.antarget = type;
    __weak ToSendTaskController* wself = self;
    
    wself.currentState = wself.antarget==0?1:0;
    [UIView transitionWithView:wself.upView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:^(BOOL finished) {
                        [UIView transitionWithView:wself.labelExtraDes
                                          duration:0.4
                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                        animations:NULL
                                        completion:^(BOOL finished) {
                                            wself.animing = NO;
                                        }];
                        wself.labelExtraDes.hidden = wself.antarget==0;
                    }];
    wself.upView.hidden = wself.antarget==0;
    
//    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
////        CGAffineTransform trans =CGAffineTransformTranslate(CGAffineTransformMakeScale(1, wself.antarget==0?0:1), 0, 0);
////        [wself.upView setTransform:trans];
////        
////        trans =CGAffineTransformTranslate(CGAffineTransformMakeScale(1, wself.antarget==0?0:1), 0, 0);
////        [wself.labelExtraDes setTransform:trans];
//        
////        trans =CGAffineTransformTranslate(CGAffineTransformMakeScale(1, 1), 0, wself.antarget==0?);
//        
//        LOG(@"动画%d",wself.antarget);
////        CGRect frame = wself.web.frame;
//        wself.currentState = wself.antarget==0?1:0;
////        [wself.web setFrame:CGRectMake(frame.origin.x, frame.origin.y-(wself.antarget==0?1:-1)*(wself.uplabelHeight+wself.upviewHeight), frame.size.width, frame.size.height+(wself.antarget==0?1:-1)*(wself.upviewHeight+wself.uplabelHeight))];
////        CGPoint ct = wself.web.scrollView.contentOffset;
////        [wself.web.scrollView setContentOffset:CGPointMake(ct.x, ct.y+(wself.antarget==0?-1:1)*(wself.upviewHeight+wself.uplabelHeight)) animated:NO];
//        
//        CGRect frame = wself.upView.frame;
//        [wself.upView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, wself.antarget==0?0:wself.upviewHeight)];
//        
//        frame = wself.labelExtraDes.frame;
//        [wself.labelExtraDes setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, wself.antarget==0?0:wself.uplabelHeight)];
//        
//        
////        if (wself.antarget==0) {
////
////        }
//    } completion:^(BOOL finished) {
//        ////        [self.taskListController dismissViewControllerAnimated:NO completion:NULL];
//        ////        self.taskListController = nil;
//        wself.animing = NO;
//        
////        NSLayoutConstraint* con = [wself.upView constraints][0];
////        con.constant = wself.antarget==0?0:wself.upviewHeight;
////        
////        con = [wself.labelExtraDes constraints][0];
////        con.constant = wself.antarget==0?0:wself.uplabelHeight;
//    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!(![self.task zeroReward] && ![self.task notbeAbletoSend]))
        return;
    
    if (self.stopShowUps) {
        [self startAnimation:self.stopShowUpsType];
        return;
    }
    
//    CGSize content = scrollView.contentSize;
    CGPoint offset = scrollView.contentOffset;
//    LOG(@"%f %f",content.height,offset.y);
//    CGFloat yoff = offset.y-self.web.frame.origin.y+64;
    CGFloat yoff = offset.y + [self topY];    
    if (yoff==0) {
        return;
    }
    
    LOG(@"%f",yoff);
    if (yoff<self.upviewHeight+self.uplabelHeight) {
        LOG(@"显示它");
        [self startAnimation:1];
    }else if(yoff>self.upviewHeight+self.uplabelHeight){
        LOG(@"隐藏它");
        [self startAnimation:0];
    }
}

//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
//    //如果隐藏了 就显示呀
//    LOG(@"to top!");
//}

-(UIButton*)getButtonSend{
    return self.btsend;
}
-(UIButton*)getButtonYiqiangwan{
    return self.btsendqiangwan;
}
-(UIButton*)getButtonYizhuanfa{
    return self.btsendyizhuanfa;
}

-(Task*)getTask{
    return self.task;
}
-(Task*)getTask2{
    return self.task2;
}

-(void)updateFavIcon{
    if([self.task.store.fav intValue]==1){
        self.rightButton.image = [UIImage imageNamed:@"shouchangyo2"];
    }else{
        self.rightButton.image = [UIImage imageNamed:@"shouchangyo"];
    }
}

-(void)updateSendButton{
    if (self.task.advancedseconds) {
        //The interval between the receiver and anotherDate. If the receiver is earlier than anotherDate, the return value is negative.
        NSTimeInterval time = [self.task.advancedseconds timeIntervalSinceDate:[NSDate date]];
        if (time<=0) {
            [self.btsend setTitle:@"立即转发" forState:UIControlStateNormal];
            [self.btsend.titleLabel setText:@"立即转发"];
            [self.btsend setAttributedTitle:[[NSAttributedString alloc] initWithString:@"立即转发"] forState:UIControlStateNormal];
        }else{
            [self.btsend.titleLabel setText:$str(@"%@后开抢",[$double(time) timeLag])];
            [self.btsend setTitle:$str(@"%@后开抢",[$double(time) timeLag]) forState:UIControlStateNormal];
            [self.btsend setAttributedTitle:[[NSAttributedString alloc] initWithString:$str(@"%@后开抢",[$double(time) timeLag])] forState:UIControlStateNormal];
            [self performSelector:@selector(updateSendButton) withObject:nil afterDelay:1];
        }
    }else{
        [self.btsend setTitle:@"立即转发" forState:UIControlStateNormal];
        [self.btsend.titleLabel setText:@"立即转发"];
        [self.btsend setAttributedTitle:[[NSAttributedString alloc] initWithString:@"立即转发"] forState:UIControlStateNormal];
    }
}

-(void)doLoad{
    //zeroReward
    //notbeAbletoSend
    __weak ToSendTaskController* wself = self;
    
    if (![wself.task zeroReward] && ![wself.task notbeAbletoSend]) {
        NSLayoutConstraint* con = [wself.upView constraints][0];
        con.constant = 30;
        self.upviewHeight = 30.0f;
    }else{
        NSLayoutConstraint* con = [wself.upView constraints][0];
        con.constant = 0;
        self.upviewHeight = 0.0f;
        [self.upView hidenme];
    }
    
//    [UIView animateWithDuration:10 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        NSLayoutConstraint* con = [wself.upView constraints][0];
//        if ([wself.task zeroReward] || [wself.task notbeAbletoSend]) {
//            con.constant = 0;
//        }
////        CGAffineTransform trans =CGAffineTransformTranslate(CGAffineTransformMakeScale(1, 1), 0, 0);
////        [self.mainImage setTransform:trans];
//    } completion:^(BOOL finished) {
////        [self.taskListController dismissViewControllerAnimated:NO completion:NULL];
////        self.taskListController = nil;
//    }];
    
    
//    [UIView animateWithDuration:10 animations:^{
//        NSLayoutConstraint* con = [wself.upView constraints][0];
//        if ([wself.task zeroReward] || [wself.task notbeAbletoSend]) {
//            con.constant = 0;
//        }
//    }];
    
    self.web.scalesPageToFit = YES;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.task.taskPreview]];
    [self.web loadRequest:request];

//    [FMUtils sendButtonsToggle:self.btsend qiangwan:self.btsendqiangwan yizhuanfa:self.btsendyizhuanfa task:self.task sent:[[AppDelegate getInstance] allShareTypeSent:self.task.sendList]];
    [FMUtils sendButtonsToggle:self task:self.task sent:[[AppDelegate getInstance] allShareTypeSent:self.task.sendList] hideAfterOnline:self.hideButtonOnline];
    
    //score labels
    self.labelAwardSend.text= [self.task.awardSend stringValue];
//    self.viewScore.link.text= [self.task.myAwardLink stringValue];
    self.labelAwardBrowse.text= [self.task.awardBrowse stringValue];
    
    [self updateFavIcon];
    
    if ([self.task isFlashMall]) {
        // 修改右上角图标
//        [self.rightButton setTitle:@"立即转发"];
        [self.rightButton setImage:[UIImage imageNamed:@"nzhuanfa"]];
        [self.btsend hidenme];
        [self.btsendqiangwan hidenme];
        [self.btsendyizhuanfa hidenme];
        
        
        //从12开始
//        CGFloat font = 12.0f;
        NSString* desc = [self.task extraDes];
#ifdef FanmoreDebug
        desc = @"次商品销售提成为30%，商品售出的XX天内没有发生退货,则提成积分转正次商品销售提成为30%，商品售出的XX天内没有发生退货,则提成积分转正";
#endif
        
        CGSize size = [desc sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(310, MAXFLOAT)  lineBreakMode:NSLineBreakByWordWrapping];
        LOG(@"%f",size.height);
//        while (true) {
//            CGSize size = [desc sizeWithFont:[UIFont systemFontOfSize:font]];
//            if (size.width<320.0f) {
//                break;
//            }
//            font -= 1;
//        }
        
//        [self.labelExtraDes setFont:[UIFont systemFontOfSize:font]];
        [self.labelExtraDes setText:desc];
        
        NSLayoutConstraint* con  = [self.labelExtraDes constraints][0];
        con.constant = size.height+20;
        self.uplabelHeight = size.height+20;
    }
    
    if ([self.task isFlashMall]) {
        [self showGuide:@"guidsgdetail21" on:nil];
    }
    
//    self.web.translatesAutoresizingMaskIntoConstraints = YES;
    //在web loaded之前 先下移web
    //完全载入好了以后 再移动回去
    
    for (NSLayoutConstraint* c in self.view.constraints) {
        if (c.firstItem==self.web && c.secondItem==self.view && c.firstAttribute==NSLayoutAttributeTop && c.secondAttribute==NSLayoutAttributeTop) {
            c.constant = self.uplabelHeight+self.upviewHeight;
        }
    }
//    [self.web setFrame:CGRectMake(self.web.frame.origin.x, self.web.frame.origin.y+self.uplabelHeight+self.upviewHeight, self.web.frame.size.width, self.web.frame.size.height)];
    self.tmoved = YES;
    
    [self changeHeightOfXibaibai];
    [self updateSendButton];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)updateSendButton:(UIButton *)button{
    [self.view addSubview:button];
    self.btsend = button;
    [button addTarget:self action:@selector(dosend:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    self.uplabelHeight = 0;
    self.upviewHeight = 0;
    [super viewDidLoad];
    [self viewDidLoadFanmore];
    [self viewDidLoadGestureRecognizer];
    
    self.web.scrollView.delegate = self;
    self.web.delegate = self;
    
    NSLayoutConstraint* con  = [self.labelExtraDes constraints][0];
    con.constant = 0;
    con  = [self.upView constraints][0];
    con.constant = 0;
    
	if ($safe(self.task) && $safe(self.task.taskPreview)) {
        [self doLoad];
    }else if ($safe(self.task)){
        __weak ToSendTaskController* wself = self;
        [[[AppDelegate getInstance] getFanOperations] detailTask:nil block:^(NSArray *array, NSError *error) {
            if (!$safe(error)) {
                [wself doLoad];
            }
        } task:self.task];
    }
    [self.btsend addTarget:self action:@selector(dosend:) forControlEvents:UIControlEventTouchUpInside];
    [self.btsendqiangwan addTarget:self action:@selector(dosend:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dosend2{
    [FMUtils sendTask:self];
}

- (IBAction)dosend:(id)sender {
    [self dosend2];
}

-(BOOL)shouldShare:(ShareType)type{
    
    Task* tosend = [self getTask];
    if (!$safe(tosend) && $safe([self getTask2])) {
        tosend = [self getTask2];
    }
    
#ifdef FanmoreMockDisaster
    tosend.disasterFlag = @1;
    tosend.disasterUrl = FanmoreMockDisaster;
#endif
    
    if ([[[AppDelegate getInstance] loadingState] isDisater] && type==ShareTypeWeixiTimeline){
        [DisasterSendController pushController:self task:tosend];
        return NO;
    }
    return YES;
}

- (IBAction)clickRightButton:(id)sender {
    
    if ([self.task isFlashMall]) {
        [FMUtils sendTask:self];
        return;
    }
    
    if(![[AppDelegate getInstance].loadingState hasLogined]){
        return;
    }
    
    if (!$safe(self.task) || !$safe(self.task.store)) {
        return;
    }
    
    __weak ToSendTaskController* wself = self;
    [[[AppDelegate getInstance]getFanOperations] operFavorite:Nil block:^(NSString *msg, NSError *error) {
        if (!$safe(wself)) {
            return;
        }
        if ($safe(error)) {
            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            return;
        }
        if ($safe(msg)) {
            [wself updateFavIcon];
            
            [FMUtils alertMessage:wself.view msg:msg];
        }
    } store:self.task.store];
    
}
@end
