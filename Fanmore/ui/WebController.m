//
//  WebController.m
//  Fanmore
//
//  Created by Cai Jiang on 3/1/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "WebController.h"
#import "BlocksKit+UIKit.h"

@interface WebController ()

@end

@implementation WebController

+(instancetype)openURL:(NSString*)url{
    WebController* wc = [[self alloc] init];
    CGFloat y = 64.0f-wc.view.frame.origin.y;
    CGFloat height = [UIScreen mainScreen].bounds.size.height-y;
    UIWebView* web = [[UIWebView alloc] initWithFrame:CGRectMake(0, y, 320, height)];
    [wc.view addSubview:web];
    wc.web = web;
    
    [wc viewWeb:url];
    return wc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWeb:(NSString*)url{
    self.targetURL = url;
    if ($safe(self.web)) {
        [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.targetURL]]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadFanmore];
    if ($safe(self.targetURL)) {
        [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.targetURL]]];
    }
    [self viewDidLoadGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
