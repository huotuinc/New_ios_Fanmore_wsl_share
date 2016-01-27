//
//  InputController.m
//  Fanmore
//
//  Created by Cai Jiang on 3/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "InputController.h"
#import "UIViewController+MyPop.h"
#import <objc/runtime.h>
#import "BlocksKit+UIKit.h"

@interface InputController ()
@property UICallbacks* callbacks;
@end

@implementation InputController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(void)popInputView:(UIViewController*)presenter view:(UIView*)view worker:(CB_Done)worker canceller:(CB_Cancelled)canceller{
    //逻辑取消 资源取消
    InputController* ic = [[InputController alloc]initWithNibName:@"InputController" bundle:[NSBundle mainBundle]];
    __weak InputController* wic = ic;
    __weak UIViewController* wpresenter = presenter;
    
    UICallbacks* cb = [UICallbacks callback:worker cancelled:canceller dismiss:^{
        [wpresenter dismissMyPopupViewControllerAnimated:YES completion:^{
            [wic removeFromParentViewController];
            [wic.view removeFromSuperview];
        }];
        return YES;
    }];
    
    __weak UICallbacks* wcb = cb;
    
    [ic dataView:view cbs:cb];
    
    [presenter presentMyPopupViewController:ic animated:YES completion:^{
        UIView *blurView = objc_getAssociatedObject(presenter, &MyBlurViewKey);
        [blurView bk_whenTapped:^{
            [wcb invokeCancel];
        }];
        [wic.view addGestureRecognizer:[UISwipeGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            UISwipeGestureRecognizer* ssender = (UISwipeGestureRecognizer*)sender;
            if (ssender.direction==UISwipeGestureRecognizerDirectionRight){
                [wcb invokeCancel];
            }
        }]];
    }];
    
}

-(void)dataView:(UIView*)view cbs:(UICallbacks*)cbs{
    self.callbacks = cbs;
    [self.view addSubview:view];
    [self.view bringSubviewToFront:self.toolbar];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (!$safe(self.view.superview) && $safe(self.callbacks)) {
        [self.callbacks uidismiss];
        self.callbacks = nil;
    }
}

- (IBAction)doCancelled:(id)sender {
    [self.callbacks invokeCancel];
}

- (IBAction)doDone:(id)sender {
    [self.callbacks invokeDone:self.view];
}
@end
