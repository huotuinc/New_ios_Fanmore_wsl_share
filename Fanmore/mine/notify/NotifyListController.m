//
//  NotifyListController.m
//  Fanmore
//
//  Created by Cai Jiang on 9/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "NotifyListController.h"
#import "NotifyCell.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "MJRefresh.h"
#import "TaskComingController.h"


@interface NotifyListController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong) NSMutableArray* sls;
@property(weak) MJRefreshHeaderView *_header;//srollview owner it
@property(weak) MJRefreshFooterView *_footer;//srollview owner it

@end

@implementation NotifyListController


-(NSNumber*)lastTaskId{
    if (self.sls==nil || self.sls.count==0) {
        return @0;
    }
    return [[self.sls lastObject] getNotifyID];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadGestureRecognizer];
    [self viewDidLoadFanmore];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (self.sls==Nil) {
        self.sls = $new(NSMutableArray);
    }else{
        [self.sls removeAllObjects];
    }
    
    __weak NotifyListController* wself = self;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
        [fos notifyList:nil block:^(NSArray *list, NSError *error) {
            if ($safe(error)) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                [refreshView endRefreshing];
                return;
            }
            
            if ($safe(list)) {
                [wself.sls addObjectsFromArray:list];
                [wself.tableView reloadData];
            }
            
            // 13600541783
            [wself._header checkInset:0];
            
            [refreshView endRefreshing];
        } paging:[Paging paging:10 parameters:@{@"pageIndex":[wself lastTaskId]}]];
    };
    self._footer = footer;
       
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [wself.sls removeAllObjects];
        wself._footer.beginRefreshingBlock(refreshView);
    };
    
    self._header = header;
    
    [header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];
    [self.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)dealloc{
    [self.tableView removeObserver:self._header forKeyPath:MJRefreshContentOffset];
    [self.tableView removeObserver:self._footer forKeyPath:MJRefreshContentOffset];
    //    [self.tableView removeObserver:self._header forKeyPath:MJRefreshContentSize];
    [self.tableView removeObserver:self._footer forKeyPath:MJRefreshContentSize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ($eql(segue.identifier,@"ToDetail")){
//        [segue.destinationViewController setValue:sender forKey:@"sldata"];
//    }
//}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        //跳转到details
        NSDictionary* data = self.sls[indexPath.row];
        if ([[data getNotifyType] intValue]==0 && [[data getNotifyTaskStatus] intValue]==2) {
            [FMUtils alertMessage:self.view msg:@"这个任务已下架"];
        }else
            [TaskComingController checkNotify:self.navigationController data:data];
//        [self performSegueWithIdentifier:@"ToDetail" sender:data];
    }
    @catch (NSException *exception) {
        LOG(@"%@",exception);
    }
    @finally {
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NotifyCell";
    NotifyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    @try {
        NSDictionary* data = self.sls[indexPath.row];
        [cell config:data];
    }
    @catch (NSException *exception) {
        LOG(@"Exception %@",exception);
    }
    @finally {
    }
    
    return cell;
}


@end
