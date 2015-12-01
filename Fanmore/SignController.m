//
//  SignController.m
//  Fanmore
//
//  Created by Cai Jiang on 10/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "SignController.h"
#import "BlocksKit+UIKit.h"
#import "AppDelegate.h"
#import "FMUtils.h"

@interface SignController ()

@end

@implementation SignController

-(void)doBack{
    __weak SignController* wself = self;
    [UIView animateWithDuration:0.5 animations:^{
        [wself.viewBottom offset:0 y:400];
    } completion:^(BOOL finished) {
        [wself.navigationController popViewControllerAnimated:NO];
    }];
}

-(void)printDays:(BOOL)todayon{
    // 算出连续on几天
    // 假设 dayCheckIn 为1 最多5 否者最多4
    LoginState* data = [[[AppDelegate getInstance] loadingState] userData];
    int addon = 0;
    if (todayon) {
        addon = 1;
    }else{
        addon =[data.dayCheckIn intValue];
    }
    
    int days = MIN([data.checkInDays intValue], 4+addon);
    // 12 on 34 off
    // 13 c 24 line
    //qdyuan1 qdyuan2 qdyuan3 qdyuan4
    if (days>0) {
        [self.imageC1 setImage:[UIImage imageNamed:@"qdyuan1"]];
    }else{
        [self.imageC1 setImage:[UIImage imageNamed:@"qdyuan3"]];
    }
    
    if (days>1) {
        [self.imageLine1 setImage:[UIImage imageNamed:@"qdyuan2"]];
        [self.imageC2 setImage:[UIImage imageNamed:@"qdyuan1"]];
    }else{
        [self.imageLine1 setImage:[UIImage imageNamed:@"qdyuan4"]];
        [self.imageC2 setImage:[UIImage imageNamed:@"qdyuan3"]];
    }
    
    if (days>2) {
        [self.imageLine2 setImage:[UIImage imageNamed:@"qdyuan2"]];
        [self.imageC3 setImage:[UIImage imageNamed:@"qdyuan1"]];
    }else{
        [self.imageLine2 setImage:[UIImage imageNamed:@"qdyuan4"]];
        [self.imageC3 setImage:[UIImage imageNamed:@"qdyuan3"]];
    }
    
    if (days>3) {
        [self.imageLine3 setImage:[UIImage imageNamed:@"qdyuan2"]];
        [self.imageC4 setImage:[UIImage imageNamed:@"qdyuan1"]];
    }else{
        [self.imageLine3 setImage:[UIImage imageNamed:@"qdyuan4"]];
        [self.imageC4 setImage:[UIImage imageNamed:@"qdyuan3"]];
    }
    
    if (days>4) {
        [self.imageLine4 setImage:[UIImage imageNamed:@"qdyuan2"]];
        [self.imageC5 setImage:[UIImage imageNamed:@"qdyuan1"]];
    }else{
        [self.imageLine4 setImage:[UIImage imageNamed:@"qdyuan4"]];
        [self.imageC5 setImage:[UIImage imageNamed:@"qdyuan3"]];
    }
    
}

-(void)clickSign{
    LoginState* data = [[[AppDelegate getInstance] loadingState] userData];
    
    if ([data.dayCheckIn intValue]==1) {
        [FMUtils alertMessage:self.view msg:@"您今日已签到"];
        return;
    }
    __weak SignController* wself = self;
    
    [[[AppDelegate getInstance] getFanOperations] checkIn:nil block:^(NSString *tip, NSError *error) {
        if ($safe(error)) {
            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            return;
        }        
        [wself printDays:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageLast setImage:self.lastImage];
    
    UIView* vv = [[UIView alloc] initWithFrame:self.viewBottom.frame];
    vv.backgroundColor = self.viewBottom.backgroundColor;
    
    self.labelX = [self.labelX cloneLabel:vv];
    self.labelMsg = [self.labelMsg cloneLabel:vv];
    self.labelMsg2 = [self.labelMsg2 cloneLabel:vv];
    self.labelE1 = [self.labelE1 cloneLabel:vv];
    self.labelE2 = [self.labelE2 cloneLabel:vv];
    self.labelE3 = [self.labelE3 cloneLabel:vv];
    self.labelE4 = [self.labelE4 cloneLabel:vv];
    self.labelE5 = [self.labelE5 cloneLabel:vv];
    
//    self.imageLast = [self.imageLast cloneImage:vv];
    self.imageLine1 = [self.imageLine1 cloneImage:vv];
    self.imageLine2 = [self.imageLine2 cloneImage:vv];
    self.imageLine3 = [self.imageLine3 cloneImage:vv];
    self.imageLine4 = [self.imageLine4 cloneImage:vv];
    
    self.imageC1 = [self.imageC1 cloneImage:vv];
    self.imageC2 = [self.imageC2 cloneImage:vv];
    self.imageC3 = [self.imageC3 cloneImage:vv];
    self.imageC4 = [self.imageC4 cloneImage:vv];
    self.imageC5 = [self.imageC5 cloneImage:vv];
    
    self.imageMao = [self.imageMao cloneImage:vv];
    
    [self.buttonClose removeFromSuperview];
    UIButton* bt = [[UIButton alloc] initWithFrame:CGRectMake(280, 8, 30, 30)];
    [bt setImage:[UIImage imageNamed:@"qiandaocolos"] forState:UIControlStateNormal];
    [vv addSubview:bt];
    self.buttonClose = bt;
    
    [self.buttonSign removeFromSuperview];
    bt = [[UIButton alloc] initWithFrame:CGRectMake(61, 104, 198, 41)];
    [bt setImage:[UIImage imageNamed:@"bigqiandao"] forState:UIControlStateNormal];
    [vv addSubview:bt];
    self.buttonSign = bt;    
    
//    self.buttonClose = [self.buttonClose cloneButton:vv];
//    [self.buttonClose setImage:[UIImage imageNamed:@"qiandaocolos"] forState:UIControlStateNormal];
//    self.buttonSign = [self.buttonSign cloneButton:vv];
//    [self.buttonSign setImage:[UIImage imageNamed:@"bigqiandao"] forState:UIControlStateNormal];
    
    [self.viewBottom removeFromSuperview];
    [self.view addSubview:vv];
    self.viewBottom = vv;
    
    // 349
    CGFloat left = self.view.frame.size.height-349.0f-self.view.frame.origin.y;
    //    [self.viewBottom setFrame:CGRectMake(0, 0, 320.0f, 349.0f)];
    self.viewBottom.frame =CGRectMake(0, left, 320.0f, 349.0f);
    
    
    __weak SignController* wself = self;
    
    [self.buttonClose addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    self.viewMask.userInteractionEnabled = YES;
    [self.viewMask bk_whenTapped:^{
        [wself doBack];
    }];
    
    LoadingState* ls = [AppDelegate getInstance].loadingState;
    if (ls.checkinExps && ls.checkinExps.count>=5) {
        [self.labelE1 setText:$str(@"+%@",ls.checkinExps[0])];
        [self.labelE2 setText:$str(@"+%@",ls.checkinExps[1])];
        [self.labelE3 setText:$str(@"+%@",ls.checkinExps[2])];
        [self.labelE4 setText:$str(@"+%@",ls.checkinExps[3])];
        [self.labelE5 setText:$str(@"+%@",ls.checkinExps[4])];
        
        [self.labelMsg setText:$str(@"连续签到%d天之后，每日最高可获得%@经验",ls.checkinExps.count,ls.checkinExps[4])];
    }

    
    [self printDays:NO];
    [self.buttonSign addTarget:self action:@selector(clickSign) forControlEvents:UIControlEventTouchUpInside];
        
    [self.viewBottom offset:0 y:349];
}

-(void)viewWillAppear:(BOOL)animated{
    __weak SignController* wself = self;
    [UIView animateWithDuration:0.5 animations:^{
        [wself.viewBottom offset:0 y:-349];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
