//
//  ConfirmController.m
//  Fanmore
//
//  Created by Cai Jiang on 2/25/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ConfirmController.h"
#import "BlocksKit+UIKit.h"
#import "UIViewController+CWPopup.h"

@interface ConfirmController ()

-(id)initWithMessage:(NSString*)message block:(void (^)())block;
@property(readonly) void (^worker)();
@property NSString* toshow;

@end

@implementation ConfirmController

+(instancetype)confirm:(UIViewController*)parent message:(NSString*)message block:(void (^)())block{
    ConfirmController* cc  = [[ConfirmController alloc] initWithMessage:message block:block];
    [parent addChildViewController:cc];
    [parent fmpresentPopupViewController:cc animated:YES completion:NULL];
    return cc;
}

-(id)initWithMessage:(NSString*)message block:(void (^)())block{
    self = [super initWithNibName:@"ConfirmController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.toshow = message;
        _worker = block;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//
//-(void)removeFromParentViewController{
//    [super removeFromParentViewController];
//    [self.view removeFromSuperview];
//    self.view = nil;
////    self.infoLabel = nil;
////    self.btok = nil;
////    self.btcancel = nil;
////    _worker = nil;
//    self.toshow = nil;
//}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (!$safe(self.view.superview)) {
        LOG(@"what can i do here?");
        [self removeFromParentViewController];
//        _worker = nil;
        self.infoLabel = nil;
        self.btok = nil;
        self.btcancel = nil;
        self.view = nil;
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.infoLabel setBackgroundColor:fmMainColor];
    self.infoLabel.text = self.toshow;
    __weak ConfirmController* wself = self;
    [self.btok bk_whenTapped:^{
        [wself.parentViewController dismissPopupViewControllerAnimated:YES completion:^{
            LOG(@"invoking completion");
            [wself removeFromParentViewController];
            if (wself.worker) {
                wself.worker();
                LOG(@"work invoked!!");
            }
        }];
    }];
    [self.btcancel bk_whenTapped:^{
        [wself.parentViewController dismissPopupViewControllerAnimated:YES completion:^{
            LOG(@"invoking completion");
            [wself removeFromParentViewController];
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
