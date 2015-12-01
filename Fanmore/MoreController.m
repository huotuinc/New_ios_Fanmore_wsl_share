//
//  MoreController.m
//  Fanmore
//
//  Created by Cai Jiang on 3/1/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "MoreController.h"
#import "WebController.h"
#import "AppDelegate.h"
#import "BlocksKit+UIKit.h"
#import "FMUtils.h"

@interface MoreController ()
@property BOOL hasFeeds;
@property(weak) UIImageView* tip;
@end

@implementation MoreController

-(void)refreshStatus{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)gotoFeedback{
    [self performSegueWithIdentifier:@"Feedback" sender:nil];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ($eql(identifier,@"Feedback") && ![[AppDelegate getInstance].loadingState hasLogined]) {
        [FMUtils afterLogin:@selector(gotoFeedback) invoker:self];
        return NO;
    }
    if ($eql(identifier,@"Feedback") && self.hasFeeds) {
        [self performSegueWithIdentifier:@"FeedbackList" sender:sender];
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ($eql(segue.identifier,@"ToPutin")) {
        [[segue destinationViewController]viewWeb:[AppDelegate getInstance].loadingState.putInUrl];
    }
    if ($eql(segue.identifier,@"ToAbout")) {
        [[segue destinationViewController]viewWeb:[AppDelegate getInstance].loadingState.aboutUsUrl];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadFanmore];
    [self viewDidLoadGestureRecognizer];
    self.tableView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.cellCache.userInteractionEnabled = YES;
    __weak MoreController* wself = self;
    [self.cellCache bk_whenTapped:^{
        [wself loopDir:[[$ documentPath]stringByAppendingPathComponent:@"httpCache"] block:^(NSFileManager * fm, NSString *path) {
            [fm removeItemAtPath:path error:NULL];
        }];
        
        [wself loopDir:[[$ documentPath]stringByAppendingPathComponent:@"resources"] block:^(NSFileManager * fm, NSString *path) {
            [fm removeItemAtPath:path error:NULL];
        }];
        [wself countCacheSize];
    }];
    
    [self.cellCancelSinaWeiboAuth bk_whenTapped:^{
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        [FMUtils alertMessage:wself.view msg:@"取消授权成功。"];
    }];
    
    [self.cellVersionCheck bk_whenTapped:^{
        [[iVersion sharedInstance] openAppPageInAppStore];
    }];
    [self.cellVersionCheck.detailTextLabel setText:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    [[[AppDelegate getInstance] getFanOperations] feedbackList:nil block:^(NSArray *feeds, NSError *error) {
        wself.hasFeeds = feeds.count>0;
    } paging:[Paging paging:10 parameters:@{@"autoId":@0}]];
    
//    self.cellFeedBack.detailTextLabel.text = @"";
    UIImageView* redt = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 6, 6)];
    redt.image = [UIImage imageNamed:@"renyuan"];
    [self.view addSubview:redt];
    redt.hidden = YES;
    self.tip = redt;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self countCacheSize];
    [self.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];

    LoadingState* ls = [AppDelegate getInstance].loadingState;
    if ([ls hasLogined] && [ls.userData hasNewFeedBack]) {
        self.tip.autoresizingMask = 0;
        self.tip.hidden = NO;
        CGPoint lastPoint = [FMUtils pointToRightTop:self.cellFeedBack.textLabel];
//        [self.tip setFrame:CGRectMake(133.0f, 56.0f, self.tip.frame.size.width, self.tip.frame.size.height)];
    [self.tip setFrame:CGRectMake(lastPoint.x+self.cellFeedBack.frame.origin.x+1.0f, lastPoint.y+self.cellFeedBack.frame.origin.y-52.0f, self.tip.frame.size.width, self.tip.frame.size.height)];
    }else{
        self.tip.hidden = YES;
    }
}

-(void)loopDir:(NSString*)path block:(void (^)(NSFileManager*,NSString*))block{
    NSFileManager* fm = [NSFileManager defaultManager];
    NSError* error;
    NSArray* files = [fm contentsOfDirectoryAtPath:path error:&error];
    for (NSString* obj in files) {
        BOOL isDir;
        NSString* newPath = [path stringByAppendingPathComponent:obj];
        if ([fm fileExistsAtPath:newPath isDirectory:&isDir]) {
            if (isDir) {
                [self loopDir:newPath block:block];
            }else{
                block(fm,newPath);
            }
        }
    }

}

-(void)countCacheSize{
    __block long size = 0;
    [self loopDir:[[$ documentPath]stringByAppendingPathComponent:@"httpCache"] block:^(NSFileManager * fm, NSString *path) {
        NSDictionary *attrs = [fm attributesOfItemAtPath: path error: NULL];
        size += [attrs fileSize];
    }];
    
    [self loopDir:[[$ documentPath]stringByAppendingPathComponent:@"resources"] block:^(NSFileManager * fm, NSString *path) {
        NSDictionary *attrs = [fm attributesOfItemAtPath: path error: NULL];
        size += [attrs fileSize];
    }];
    
    self.labelCacheDetail.text=$str(@"%@K",[NSNumberFormatter localizedStringFromNumber:$long(size/1024) numberStyle:NSNumberFormatterDecimalStyle]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
