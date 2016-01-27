//
//  FollowerDetailController.m
//  Fanmore
//
//  Created by Cai Jiang on 7/16/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FollowerDetailController.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "MJRefresh.h"
#import "Paging.h"
#import "FollowerCell.h"
#import "ContributionPerFollowerCell.h"

@interface FollowerDetailController ()<UITableViewDataSource>

@property NSDictionary* follower;
@property NSMutableArray* followers;
@property(weak) UITableView* tableView;
@property(weak) MJRefreshHeaderView *_header;//srollview owner it
@property(weak) MJRefreshFooterView *_footer;//srollview owner it

@property(weak) UILabel* labelFollower;
@property(weak) UILabel* labelTime;
@property(weak) UILabel* labelScore;

@end

@implementation FollowerDetailController

-(NSNumber*)pageTag{
    if (self.followers==nil || self.followers.count==0) {
        return @0;
    }
    NSDictionary* task=[self.followers $last];
    //            return @0;
    return [task getID];
}



+(instancetype)pushController:(UIViewController *)controller follower:(NSDictionary *)follower{
    FollowerDetailController* fc = [[self alloc] init];
    fc.follower = follower;
    [controller.navigationController pushViewController:fc animated:YES];
    return fc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    view.backgroundColor = fmMainColor;
    [self.view addSubview:view];
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(16, 25, 35, 35)];
    [button setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 44)];
    image.image = [UIImage imageNamed:@"xiangxbg"];
    [self.view addSubview:image];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 72, 104, 44)];
    image.image = [UIImage imageNamed:@"xiangxileftkt"];
    [self.view addSubview:image];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(204, 77, 78, 39)];
    image.image = [UIImage imageNamed:@"xiangxrightkt"];
    [self.view addSubview:image];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(46, 124, 63, 63)];
    image.image = [UIImage imageNamed:@"xiangxtouxiang"];
    [self.view addSubview:image];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(117, 130, 146, 18)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    [label setText:$str(@"徒弟：%@",[self.follower getUsername])];
    [self.view addSubview:label];
    self.labelFollower = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(117, 147, 159, 18)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    [label setText:$str(@"拜师时间：%@",[[self.follower getConnectDate] fmStandStringDateOnly])];
    [self.view addSubview:label];
    self.labelTime = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(117, 165, 146, 18)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    [label setText:$str(@"总共贡献：%@",[self.follower getFollowerTotalDevote])];
    [self.view addSubview:label];
    self.labelScore = label;
    
    //195
    UITableView* table = [[UITableView alloc] initWithFrame:CGRectMake(0, 195, 320, [[UIScreen mainScreen] bounds].size.height-195)];
    
    [self.view addSubview:table];
    self.tableView = table;
    
    __weak FollowerDetailController* wself = self;
    
    
    
    // for table & data
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[ContributionPerFollowerCell class] forCellReuseIdentifier:@"ContributionPerFollowerCell"];
    self.tableView.rowHeight = 35.0f;
    self.tableView.dataSource = self;
    
    if (self.followers==Nil) {
        self.followers = $new(NSMutableArray);
    }else{
        [self.followers removeAllObjects];
    }
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
        [fos followerDetail:nil block:^(NSString *username, NSDate *date, NSNumber *totalDevote, NSArray *list, NSError *error) {
            
            if ($safe(error)) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                [refreshView endRefreshing];
                return;
            }
            
            if ($eql([wself pageTag],@0)) {
                if ($safe(username)) {
                    [wself.labelFollower setText:$str(@"徒弟：%@",username)];
                    [wself.labelTime setText:$str(@"拜师时间：%@",[date fmStandStringDateOnly])];
                    [wself.labelScore setText:$str(@"总共贡献：%@",totalDevote)];
                }
            }
            
            if ($safe(list)) {
                HashAddArray(wself.followers,list)
                [wself.tableView reloadData];
            }
            [refreshView endRefreshing];
            
            
        } followerId:[wself.follower getFollowerId] orderType:0 paging:[Paging paging:5 parameters:@{@"pageTag": [wself pageTag]}]];
        
    };
    self._footer = footer;
    
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [wself.followers removeAllObjects];
        wself._footer.beginRefreshingBlock(refreshView);
    };
    
    self._header = header;
    
    [header beginRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.followers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContributionPerFollowerCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ContributionPerFollowerCell" forIndexPath:indexPath];
    @try {
        [cell config:self.followers[indexPath.row]];
    }
    @catch (NSException *exception) {
        LOG(@"错误 %@",exception);
    }
    @finally {
    }
    return cell;
}

- (void)dealloc{
    [self.tableView removeObserver:self._header forKeyPath:MJRefreshContentOffset];
    [self.tableView removeObserver:self._footer forKeyPath:MJRefreshContentOffset];
    //    [self.tableView removeObserver:self._header forKeyPath:MJRefreshContentSize];
    [self.tableView removeObserver:self._footer forKeyPath:MJRefreshContentSize];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
