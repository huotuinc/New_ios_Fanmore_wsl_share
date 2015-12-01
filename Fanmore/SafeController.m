//
//  SafeController.m
//  Fanmore
//
//  Created by Cai Jiang on 2/28/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "SafeController.h"
#import "AppDelegate.h"
#import "FMUtils.h"

@interface SafeController ()
@property(weak) UILabel* labelName;
@end

@implementation SafeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[AppDelegate getInstance].loadingState useNewCash]) {
        return 3;
    }
    return 4;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadFanmore];
    [self viewDidLoadGestureRecognizer];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 300, 22)];
    label.backgroundColor  = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = ({
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 32)];
        view.backgroundColor = [UIColor redColor];
        [view addSubview:label];
        view;
    });
    
    self.labelName = label;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    //记得修改英文版
    if ($eql(identifier,@"ToMobile") && [[AppDelegate getInstance].loadingState hasBindMobile]) {
        [self performSegueWithIdentifier:@"ToReleaseMobile" sender:sender];
        return NO;
    }
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    LoadingState* ls = [AppDelegate getInstance].loadingState;
    if ([ls hasBindMobile]) {
        self.cellModifyMobile.textLabel.text = @"修改手机绑定";
    }else{
        self.cellModifyMobile.textLabel.text = @"绑定手机";
    }
    
    if ([ls hasBindALP]) {
        self.cellModifyALP.textLabel.text = @"修改支付宝绑定";
    }else{
        self.cellModifyALP.textLabel.text = @"绑定支付宝";
    }
    
    if ([ls hasSetCashPSWD]) {
        self.cellModifyCashPswd.textLabel.text = @"修改提现密码";
    }else{
        self.cellModifyCashPswd.textLabel.text = @"设置提现密码";
    }
    
    [self.labelName setText:ls.userData.userName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
