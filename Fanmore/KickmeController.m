//
//  KickmeController.m
//  Fanmore
//
//  Created by Cai Jiang on 10/21/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "KickmeController.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "BlocksKit+UIKit.h"
#import "ItemsAll.h"

@interface KickmeController ()<KickKnowAwre>

@property NSNumber* lastId;
@property NSNumber* residueCount;
@property NSNumber* exp;

@property BOOL checking;

@end

@implementation KickmeController

-(void)loadAnswer{
    self.checking = NO;
    __weak KickmeController* wself = self;
    
    [self.imageLight hidenme];
    
    [[[AppDelegate getInstance] getFanOperations] scratchTicket:nil block:^(NSNumber *id, NSNumber *residueCount, NSNumber *exp, NSError *error) {
        //  发生问题 就重来
        if ($safe(error)) {
            LOG(@"错误 重来");
            [wself performSelector:@selector(loadAnswer) withObject:nil afterDelay:10];
            return;
        }
        
        // id exp residueCount
        wself.lastId = id;
        wself.residueCount = residueCount;
        wself.exp = exp;
        
        if ([exp intValue]>0) {
            [wself.labelAnswer setText:$str(@"%@经验",exp)];
        }else{
            [wself.labelAnswer setText:@"再接再厉"];
        }
        
    }];
}

-(void)answerGetted{
    if (self.checking) {
        return;
    }
    if (!$safe(self.lastId)) {
        return;
    }
    self.checking = YES;
    __weak KickmeController* wself = self;
    
    // 运行一次即可
    [[[AppDelegate getInstance] getFanOperations] useItem:nil block:^(NSNumber* count, NSError *error) {
        if (!$safe(error)) {
            if ([count intValue]>0) {
                [wself.buttonAgain showme];
            }
            
            if ([wself.exp intValue]>0) {
                [UIView animateWithDuration:0.6 animations:^{
                    [wself.imageLight showme];
                }];
            }
            
            NSArray* list = wself.navigationController.viewControllers;
            [list[list.count-2] oneItemUpdate:2 count:count];
            
            wself.lastId = nil;
        }else{
            LOG(@"%@",[error FMDescription]);
        }
        wself.checking = NO;
    } type:2 target:self.lastId];
}

-(void)reinitConver{
    [self.viewControl setContentMode:UIViewContentModeScaleAspectFit];
    //    [self.viewControl setFrame:self.view.bounds];
    [self.viewControl setBackgroundColor:[UIColor clearColor]];
    [self.viewControl setSizeBrush:30.0];
    self.viewControl.answerRect = CGRectMake(self.labelAnswer.frame.origin.x-self.viewAnswer.frame.origin.x, self.labelAnswer.frame.origin.y-self.viewAnswer.frame.origin.y, self.labelAnswer.frame.size.width, self.labelAnswer.frame.size.height);
    
    UIImageView* vv = [[UIImageView alloc] initWithFrame:self.viewAnswer.frame];
    [vv setImage:[UIImage imageNamed:@"huisheguajiangqu"]];
    
    [self.viewControl setHideView:vv];
    [self.viewControl setHideView:vv];
    
    self.viewControl.delegate = self;
}

-(void)recheck{
    // 让ViewControl恢复原状
    [self.buttonAgain hidenme];
    
    KickConverView* vc = [[KickConverView alloc] initWithFrame:self.viewControl.frame];
    [self.view addSubview:vc];
    [self.viewControl removeFromSuperview];
    self.viewControl = vc;
    [self reinitConver];
    
    [self loadAnswer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.buttonAgain hidenme];
    
    [self loadAnswer];
    

    
    // 伪装成功
//        __weak KickmeController* wself = self;
//    self.labelAnswer.userInteractionEnabled = YES;
//    [self.labelAnswer bk_whenTapped:^{
//        [wself answerGetted];
//    }];
    [self reinitConver];
    
    [self.buttonAgain addTarget:self action:@selector(recheck) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
