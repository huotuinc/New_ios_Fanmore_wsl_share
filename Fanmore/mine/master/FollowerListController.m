//
//  FollowerListController.m
//  Fanmore
//
//  Created by Cai Jiang on 7/11/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FollowerListController.h"
#import "FMUtils.h"
#import "MJRefresh.h"
#import "Paging.h"
#import "FollowerCell.h"
#import "BlocksKit+UIKit.h"
#import "FollowerDetailController.h"

@interface FollowerListController ()

@property NSMutableArray* followers;
@property(weak) UITableView* tableView;
@property(weak) MJRefreshHeaderView *_header;//srollview owner it
@property(weak) MJRefreshFooterView *_footer;//srollview owner it

@property int orderType;

@property(weak) UIImageView* imageTime;
@property(weak) UIImageView* imageScore;

@property(weak) UILabel* labelTime;
@property(weak) UILabel* labelScore;

@property(weak) UILabel* labelNumber;

@end

@implementation FollowerListController

-(NSNumber*)pageTag{
    if (self.followers==nil || self.followers.count==0) {
        return @0;
    }
    NSDictionary* task=[self.followers $last];
    //            return @0;
    return [task getFollowerId];
}

+(instancetype)pushFollowers:(UIViewController*)controller{
    FollowerListController* fc = [[self alloc] init];
    [controller.navigationController pushViewController:fc animated:YES];
    return fc;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"徒弟列表";
    [self viewDidLoadGestureRecognizer];
    
    __weak FollowerListController* wself = self;
    
    void(^toggleType)() = ^() {
        wself.orderType = wself.orderType==0?1:0;
        
        if(wself.orderType==0){
            [wself.imageTime showme];
            [wself.labelTime setTextColor:[UIColor whiteColor]];
            [wself.imageScore hidenme];
            [wself.labelScore setTextColor:[UIColor blackColor]];
        }else{
            [wself.imageTime hidenme];
            [wself.labelTime setTextColor:[UIColor blackColor]];
            [wself.imageScore showme];
            [wself.labelScore setTextColor:[UIColor whiteColor]];
        }
        
        [wself._header beginRefreshing];
    };
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat y = [self topY];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 21+y, 108, 21)];
    label.textAlignment = NSTextAlignmentLeft;
    [label setText:@"已有：0人"];
    [self.view addSubview:label];
    self.labelNumber = label;
    
    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(144, 20+y, 156, 24)];
    image.image = [UIImage imageNamed:@"swaniubg"];
    image.userInteractionEnabled = YES;
    [image bk_whenTapped:toggleType];
    [self.view addSubview:image];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(144, 20+y, 80, 24)];
    image.image = [UIImage imageNamed:@"swaniu1"];
    image.userInteractionEnabled = YES;
    [image bk_whenTapped:toggleType];
    [self.view addSubview:image];
    self.imageTime = image;
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(220, 20+y, 80, 24)];
    image.image = [UIImage imageNamed:@"swaniu1"];
    image.userInteractionEnabled = YES;
    [image bk_whenTapped:toggleType];
    [self.view addSubview:image];
    [image hidenme];
    self.imageScore = image;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(163, 21+y, 42, 21)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    [label setText:@"时间"];
    [self.view addSubview:label];
    self.labelTime = label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(239, 21+y, 42, 21)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
//    label.textColor = [UIColor whiteColor];
    [label setText:@"贡献度"];
    [self.view addSubview:label];
    self.labelScore = label;
    
    
    UITableView* table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+y, 320, [[UIScreen mainScreen] bounds].size.height-64-y)];
    
    [self.view addSubview:table];
    self.tableView = table;
    
    // for table & data
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[FollowerCell class] forCellReuseIdentifier:@"FollowerCell"];
    self.tableView.rowHeight = 70.0f;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    if (self.followers==Nil) {
        self.followers = $new(NSMutableArray);
    }else{
        [self.followers removeAllObjects];
    }
    
//luohaibo
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
        [fos followerList:nil block:^(NSNumber *numbersOfFollowers, NSArray *list, NSError *error) {
            
            if ($safe(error)) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                [refreshView endRefreshing];
                return;
            }
            
            if ($eql([wself pageTag],@0)) {
                if (numbersOfFollowers) {
                    [wself.labelNumber setText:$str(@"已有：%d人",[numbersOfFollowers intValue])];
                    [[AppDelegate getInstance] saveNumberOfFollowers:numbersOfFollowers];
                }
            }
            
            
            if ($safe(list)) {
                HashAddArray(wself.followers,list)
                [wself.tableView reloadData];
            }
            [refreshView endRefreshing];
            
        } orderType:wself.orderType paging:[Paging paging:5 parameters:@{@"pageTag": [wself pageTag]}]];
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.followers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowerCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FollowerCell" forIndexPath:indexPath];
    @try {
        [cell config:self.followers[indexPath.row] index:indexPath];
    }
    @catch (NSException *exception) {
        LOG(@"错误 %@",exception);
    }
    @finally {
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        [FollowerDetailController pushController:self follower:self.followers[indexPath.row]];
    }
    @catch (NSException *exception) {
        LOG(@"错误 %@",exception);
    }
    @finally {
    }
}

- (void)dealloc{
    [self.tableView removeObserver:self._header forKeyPath:MJRefreshContentOffset];
    [self.tableView removeObserver:self._footer forKeyPath:MJRefreshContentOffset];
    //    [self.tableView removeObserver:self._header forKeyPath:MJRefreshContentSize];
    [self.tableView removeObserver:self._footer forKeyPath:MJRefreshContentSize];
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


@implementation AppDelegate (FollowerInfo)

-(NSNumber*)getNumberOfFollowers{
    return self.preferences[@"getNumberOfFollowers"];
}
-(void)saveNumberOfFollowers:(NSNumber*)number{
    self.preferences[@"getNumberOfFollowers"] = number;
    [self savePreferences];
}

@end
