//
//  TodayBrowseController.m
//  Fanmore
//
//  Created by Cai Jiang on 6/17/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "TodayBrowseController.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "MJRefresh.h"
#import "BrowseTaskCell.h"
#import "FMTableView.h"
#import "UITableView+SetNoDateBackImage.h"
@interface TodayBrowseController ()


@property(strong) NSMutableArray* tasks;

@property(weak) MJRefreshHeaderView *_header;//srollview owner it
@property(weak) MJRefreshFooterView *_footer;//srollview owner it


@end

@implementation TodayBrowseController

+(instancetype)pushTodayBrowse:(UIViewController*)controller{
    TodayBrowseController* cl = [[self alloc] initWithStyle:UITableViewStylePlain];
    [controller.navigationController pushViewController:cl animated:YES];
    return cl;
}

-(NSNumber*)lastTaskId{
    if (self.tasks==nil || self.tasks.count==0) {
        return @0;
    }
    Task* task = [self.tasks $last];
    return task.taskId;
}

-(void)loadView{
//    [super loadView];
    CGFloat y = -0.0f;
    self.tableView = [[FMTableView alloc] initWithFrame:CGRectMake(0, y, 320, [UIScreen mainScreen].bounds.size.height-64.0f-y) style:UITableViewStylePlain];
    self.view = self.tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadGestureRecognizer];
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)]];
    self.navigationItem.title = @"今日浏览";
    
    if (self.tasks==Nil) {
        self.tasks = $new(NSMutableArray);
    }else{
        [self.tasks removeAllObjects];
    }
    
    __weak TodayBrowseController* wself = self;
    
    self.tableView.delegate = wself;
    self.tableView.dataSource = wself;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = 178-21;
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[BrowseTaskCell class] forCellReuseIdentifier:@"BrowseTaskCell"];
    
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [wself.tasks removeAllObjects];
#ifdef FanmoreCatdata
        [[[AppDelegate getInstance] getFanOperations] listTask:nil block:^(NSArray *list, NSError *error) {
            if ($safe(list)) {
                [wself.tasks addObjectsFromArray:list];
            }
            wself._footer.beginRefreshingBlock(refreshView);
        } screenType:0 paging:[Paging paging:2 parameters:@{@"oldTaskId":@0}]];
#else
        wself._footer.beginRefreshingBlock(refreshView);
#endif
        
    };
    
    self._header = header;
    
#ifdef FanmoreCatdata
    [footer beginRefreshing];
#else
    [header beginRefreshing];
#endif
    
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
        
        [fos TodayBrowseList:nil block:^(NSArray *list, NSError *error) {
            if ($safe(error)) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                [refreshView endRefreshing];
                return;
            }
            if ($safe(list)) {
                HashAddArray(wself.tasks, list);
                [wself.tableView reloadData];
                [refreshView endRefreshing];
            }
        } paging:[Paging paging:10 parameters:@{@"autoId":[wself lastTaskId]}]];
    };
    self._footer = footer;
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    [self.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self.tableView removeObserver:self._header forKeyPath:MJRefreshContentOffset];
    [self.tableView removeObserver:self._footer forKeyPath:MJRefreshContentOffset];
    //    [self.tableView removeObserver:self._header forKeyPath:MJRefreshContentSize];
    [self.tableView removeObserver:self._footer forKeyPath:MJRefreshContentSize];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    @try {
        
        if ([FMUtils sectionsByTaskTime:self.tasks]) {
            [tableView setClearBackground];
        }else{
            tableView.backgroundColor = [UIColor whiteColor];
        }
        return [FMUtils sectionsByTaskTime:self.tasks];
    }
    @catch (NSException *exception) {
        LOG(@"%@",exception);
    }
    @finally {
        
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        return [FMUtils rowsBy:self.tasks section:section];
    }
    @catch (NSException *exception) {
        LOG(@"%@",exception);
    }
    @finally {
    }
    return self.tasks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        Task* task = [FMUtils dataBy:self.tasks section:indexPath.section andRow:indexPath.row];
        BrowseTaskCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BrowseTaskCell" forIndexPath:indexPath];
        [cell configTask:task];
        return cell;
    }
    @catch (NSException *exception) {
        LOG(@"%@",exception);
    }
    @finally {
    }
    return [tableView dequeueReusableCellWithIdentifier:@"BrowseTaskCell" forIndexPath:indexPath];
}


@end
