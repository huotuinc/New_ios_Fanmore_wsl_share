//
//  YaoYaoController.m
//  Fanmore
//
//  Created by Cai Jiang on 10/18/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "YaoYaoController.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "ItemsAll.h"
#import <AudioToolbox/AudioToolbox.h>

@interface YaoYaoController ()

@property BOOL shaking;
@property(weak) UIView* maskUp;
@property(weak) UIView* maskDown;
@property int status;

@property NSNumber* lastUserId;

@end

@implementation YaoYaoController


-(void)shake{
    //只有 没摇和获得结果  0 2 才可以展现效果
    if (self.status!=0) {
        return;
    }
    
    __weak YaoYaoController* wself = self;
    
    self.status  = 1;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [wself.viewInfo hidenme];
    
    [[[AppDelegate getInstance] getFanOperations] rollPrentice:nil block:^(NSDictionary *user, NSError *error) {
#ifndef FanmoreMockYYNOE
        if ($safe(error)) {
            // 失败了。。
            [FMUtils alertMessage:wself.view msg:[error FMDescription] block:^{
                [wself.viewInfo hidenme];
            }];
            wself.status = 0;
            return ;
        }
#endif
        
        NSString* url = user[@"pictureUrl"];
        if ($safe(url) && url.length>0) {
            [[AppDelegate getInstance] downloadImage:url handler:^(UIImage *image, NSError *error) {
                [wself.imagePic setImage:image];
            } asyn:YES];
        }else{
            [wself.imagePic setImage:[UIImage imageNamed:@"queshentu"]];
        }
        
        wself.lastUserId = user[@"id"];
        
        NSNumber* sex = user[@"sex"];
        
        if ([sex intValue]==1) {
            [wself.imageSex setImage:[UIImage imageNamed:@"nanfuhao"]];
        }else{
            [wself.imageSex setImage:[UIImage imageNamed:@"nvfuhao"]];
        }
        
        NSDate* registerDate = [user[@"registerDate"]fmToDate];
        
        [wself.labelDate setText:$str(@"注册：%@",[registerDate fmStandStringDateOnly])];
        
        [wself.labelSent setText:$str(@"转发次数：%@",user[@"sentCount"])];
        
        [wself.labelName setText:user[@"name"]];
        
        LOG(@"%f %f",wself.imageUp.frame.origin.y,wself.imageDown.frame.origin.y);
        
        CGFloat oy1 = wself.imageUp.frame.origin.y;
//        CGFloat oy2 = wself.maskUp.frame.origin.y;
        CGFloat oy3 = wself.imageShang.frame.origin.y;
        CGFloat oy4 = wself.imageDown.frame.origin.y;
//        CGFloat oy5 = wself.maskDown.frame.origin.y;
        CGFloat oy6 = wself.imageXia.frame.origin.y;
        
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionOverrideInheritedDuration|UIViewAnimationOptionOverrideInheritedCurve animations:^{
            [wself.imageUp moveTo:0 y:oy1-64];
            [wself.maskUp moveTo:0 y:oy1-64];
            [wself.imageShang moveTo:0 y:oy3-64];
            [wself.imageDown moveTo:0 y:oy4+64];
            [wself.maskDown moveTo:0 y:oy4+64];
            [wself.imageXia moveTo:0 y:oy6+64];
            LOG(@"%f %f",wself.maskUp.frame.origin.y,wself.maskDown.frame.origin.y);
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.4 animations:^{
                    [wself.imageUp moveTo:0 y:oy1];
                    [wself.maskUp moveTo:0 y:oy1];
                    [wself.imageShang moveTo:0 y:oy3];
                    [wself.imageDown moveTo:0 y:oy4];
                    [wself.maskDown moveTo:0 y:oy4];
                    [wself.imageXia moveTo:0 y:oy6];
                    LOG(@"%f %f %d",wself.maskUp.frame.origin.y,wself.maskDown.frame.origin.y,finished);
                } completion:^(BOOL finished) {
                    if (finished) {
                        [wself.viewInfo offset:0 y:-700];
                        [wself.viewInfo showme];
                        LOG(@"%f %f %d",wself.maskUp.frame.origin.y,wself.maskDown.frame.origin.y,finished);
                        [UIView animateWithDuration:0.4 animations:^{
                            [wself.viewInfo offset:0 y:700];
                        } completion:^(BOOL finished) {
                            wself.status = 0;
                        }];
                    }
                    
                }];
            }
            
        }];
    }];
    
    
}

-(void)clickOk{
    __weak YaoYaoController* wself = self;
    [[[AppDelegate getInstance] getFanOperations] useItem:nil block:^(NSNumber* count, NSError *error) {
        if ($safe(error)) {
            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            return;
        }
        
        NSArray* list = wself.navigationController.viewControllers;
        [list[list.count-2] oneItemUpdate:1 count:count];
        
        [FMUtils alertMessage:wself.view msg:@"恭喜你收获了一个乖徒弟！" block:^{
            [wself.viewInfo hidenme];
            if ([count intValue]==0) {
                [wself doBack];
            }
        }];
        
    } type:1 target:self.lastUserId];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewDidLoadFanmore];
    [self viewDidLoadGestureRecognizer];
    
    [self showNoshadowNavigationBar];
    
    UIImageView* niv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yaobg"]];
    [self.view addSubview:niv];
    [niv centerIn:self.view.frame.size as:niv.frame.size];
    
    CGFloat bgy = niv.frame.origin.y;
    bgy -= self.view.frame.origin.y+65.0f;
    
    [niv setFrame:CGRectMake(0, bgy, 320, 128)];
    
    niv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yaoshang"]];
    [niv setFrame:CGRectMake(0, bgy+64.0f, 320, 9)];
    [self.view addSubview:niv];
    self.imageShang = niv;

    
    niv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yaoxia"]];
    [niv setFrame:CGRectMake(0, bgy+64.0f-9.0f, 320, 9)];
    [self.view addSubview:niv];
    self.imageXia = niv;

    niv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yao1yaoA1"]];
    [niv setFrame:CGRectMake(0, bgy+64.0f-160.0f, 320, 160)];
    [self.view addSubview:niv];
    self.imageUp = niv;
    
    niv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yao1yaoA2"]];
    [niv setFrame:CGRectMake(0, bgy+64.0f, 320, 160)];
    [self.view addSubview:niv];
    self.imageDown = niv;
    
    [self.viewInfo setAutoresizingMask:UIViewAutoresizingNone];
    
    UIView* ninfo  = [[UIView alloc] initWithFrame:CGRectMake(10, bgy+64.0f+160.0f, 300, 90)];
    ninfo.backgroundColor = [UIColor whiteColor];
    UIImageView* nniv = [[UIImageView alloc] init];
    self.imagePic = nniv;
    [ninfo addSubview:self.imagePic];
    [self.imagePic setFrame:CGRectMake(18, 11, 68, 68)];
    
    nniv = [[UIImageView alloc] init];
    self.imagePicMask = nniv;
    [self.imagePicMask setImage:[UIImage imageNamed:@"yuan_big"]];
    [ninfo addSubview:self.imagePicMask];
    [self.imagePicMask setFrame:CGRectMake(18, 11, 68, 68)];
    
    nniv = [[UIImageView alloc] init];
    self.imageSex = nniv;
    [ninfo addSubview:self.imageSex];
    [self.imageSex setFrame:CGRectMake(180, 7, 30, 30)];
    
    UILabel* nnlb = [[UILabel alloc] init];
    [nnlb setText:@""];
    nnlb.backgroundColor = [UIColor clearColor];
    [nnlb setFont:[UIFont systemFontOfSize:13]];
    self.labelDate = nnlb;
    [ninfo addSubview:self.labelDate];
    [self.labelDate setFrame:CGRectMake(94, 59, 110, 20)];
    
    nnlb = [[UILabel alloc] init];
    [nnlb setText:@""];
    nnlb.backgroundColor = [UIColor clearColor];
    [nnlb setFont:[UIFont systemFontOfSize:14]];
    self.labelName = nnlb;
    [ninfo addSubview:self.labelName];
    [self.labelName setFrame:CGRectMake(94, 15, 88, 20)];
    
    nnlb = [[UILabel alloc] init];
    [nnlb setText:@""];
    nnlb.backgroundColor = [UIColor clearColor];
    [nnlb setFont:[UIFont systemFontOfSize:14]];
    self.labelSent = nnlb;
    [ninfo addSubview:self.labelSent];
    [self.labelSent setFrame:CGRectMake(94, 35, 110, 20)];
    
    UIButton* bt = [[UIButton alloc] init];
    [bt setBackgroundImage:[UIImage imageNamed:@"duihuan2"] forState:UIControlStateNormal];
    [bt setTitle:@"收徒" forState:UIControlStateNormal];
    self.buttonOk = bt;
    [ninfo addSubview:self.buttonOk];
    [self.buttonOk setFrame:CGRectMake(212, 26, 78, 38)];
    [self.viewInfo removeFromSuperview];
    
    [self.view addSubview:ninfo];
    self.viewInfo = ninfo;
//    [self.viewInfo setFrame:CGRectMake(10, bgy+64.0f+160.0f, 300, 90)];
    self.viewInfo.layer.cornerRadius = 5;
    [self.viewInfo hidenme];
    
    LOG(@"%fd",self.imageBg.frame.origin.y);
//    [self.imageBg centerIn:screen.size as:self.imageBg.frame.size];
//    [self.imageBg offset:0 y:-200.0f];
//    
//    [self.imageShang setFrame:CGRectMake(0, self.imageBg.frame.origin.y-6, 320, 9)];
//    [self.imageXia setFrame:CGRectMake(0, self.imageBg.frame.origin.y+125, 320, 9)];
//    
//    [self.imageUp setFrame:CGRectMake(0, self.imageBg.frame.origin.y-80, 320, 160)];
//    [self.imageDown setFrame:CGRectMake(0, self.imageUp.frame.origin.y+160, 320, 160)];
//    
//    [self.viewInfo setFrame:CGRectMake(self.viewInfo.frame.origin.x, screen.size.height-110, self.viewInfo.frame.size.width, self.viewInfo.frame.size.height)];
    
//    UIImageView* vv = [[UIImageView alloc] initWithFrame:self.imageShang.frame];
//    [vv setImage:[UIImage imageNamed:@"yaoshang"]];
//    [self.imageShang removeFromSuperview];
//    [self.view addSubview:vv];
//    self.imageShang = vv;
//    
//    vv = [[UIImageView alloc] initWithFrame:self.imageXia.frame];
//    [vv setImage:[UIImage imageNamed:@"yaoxia"]];
//    [self.imageXia removeFromSuperview];
//    [self.view addSubview:vv];
//    self.imageXia = vv;
    
// // // //
//    
    UIView* v  = [[UIImageView alloc] initWithFrame:self.imageUp.frame];
    [self.view addSubview:v];
    v.backgroundColor = fmMainColor;
    self.maskUp = v;
    
    v  = [[UIImageView alloc] initWithFrame:self.imageDown.frame];
    [self.view addSubview:v];
    v.backgroundColor = fmMainColor;
    self.maskDown = v;
//
//    [self.imageUp removeFromSuperview];
//    [self.imageDown removeFromSuperview];
//    
//    vv = [[UIImageView alloc] initWithFrame:self.maskUp.frame];
//    [vv setImage:[UIImage imageNamed:@"yao1yaoA1"]];
//    [self.view addSubview:vv];
//    self.imageUp = vv;
//    
//    vv = [[UIImageView alloc] initWithFrame:self.maskDown.frame];
//    [vv setImage:[UIImage imageNamed:@"yao1yaoA2"]];
//    [self.view addSubview:vv];
//    self.imageDown = vv;
    
//    [self.maskUp hidenme];
//    [self.maskDown hidenme];
    
    [self.view bringSubviewToFront:self.maskUp];
    [self.view bringSubviewToFront:self.maskDown];
    
    [self.view bringSubviewToFront:self.imageUp];
    [self.view bringSubviewToFront:self.imageDown];
    
    [self.view bringSubviewToFront:self.viewInfo];
    
    [self.buttonOk addTarget:self action:@selector(clickOk) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
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
