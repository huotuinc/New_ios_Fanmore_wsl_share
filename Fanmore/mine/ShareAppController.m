//
//  ShareAppController.m
//  Fanmore
//
//  Created by Cai Jiang on 4/4/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ShareAppController.h"
#import "AppDelegate.h"
#import "FMUtils.h"

@interface ShareAppController ()

@end

@implementation ShareAppController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)clickSend{
    LoginState* ls = [AppDelegate getInstance].loadingState.userData;
    
    ShareMessage* sm = $new(ShareMessage);
    sm.title = ls.shareDes;
    sm.smdescription = ls.shareDes;
    sm.url = ls.shareContent;
    sm.thumbImage =  [UIImage imageNamed:@"logo"];
    sm.thumbImageURL = @"logo.png";
    
    __weak ShareAppController* wself = self;
    [ShareTool shareMessage:sm controller:self sentList:nil delegate:nil handler:^(TShareType type, ShareResult result, id data) {
        if (result==ShareResultDone) {
            [FMUtils alertMessage:wself.view msg:@"分享成功！"];
        }
    }];
}

- (void)viewDidLoad
{
    LoginState* ls = [AppDelegate getInstance].loadingState.userData;
    self.targetURL = ls.shareContent;
    [super viewDidLoad];
    [self.btSend addTarget:self action:@selector(clickSend) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];
}

@end
