//
//  ParticipatesController.m
//  Fanmore
//
//  Created by Cai Jiang on 2/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ParticipatesController.h"
#import "ParticipatesCell.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "MJRefresh.h"
#import "MyTaskDetail.h"

@interface ParticipatesController ()

@property(strong) NSMutableArray* tasks;
@property(weak) MJRefreshHeaderView *_header;//srollview owner it
@property(weak) MJRefreshFooterView *_footer;//srollview owner it

@end

@implementation ParticipatesController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSNumber*)lastTaskId{
    if (self.tasks==nil || self.tasks.count==0) {
        return @0;
    }
    Task* task=[self.tasks $last];
    //            return @0;
    return task.partInAutoId;
}

-(void)doBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];
    [self.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadGestureRecognizer];
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (self.tasks==Nil) {
        self.tasks = $new(NSMutableArray);
    }else{
        [self.tasks removeAllObjects];
    }
    
    __weak ParticipatesController* wself = self;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
        [fos listPartTask:Nil block:^(NSArray *task, NSError *error) {
            if ($safe(error)) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                [refreshView endRefreshing];
                return;
            }
            if ($safe(task)) {
                HashAddArray(wself.tasks, task)
                [wself.tableView reloadData];
                LOG(@"fetch data refresh table n:%d newtasks:%d",wself.tasks.count,task.count);
            }
            [refreshView endRefreshing];
        } type:wself.participatesType paging:[Paging paging:10 parameters:@{@"autoId":[wself lastTaskId]}]];
    };
    self._footer = footer;
    
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [wself.tasks removeAllObjects];
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

- (void)dealloc{
    [self.tableView removeObserver:self._header forKeyPath:MJRefreshContentOffset];
    [self.tableView removeObserver:self._footer forKeyPath:MJRefreshContentOffset];
//    [self.tableView removeObserver:self._header forKeyPath:MJRefreshContentSize];
    [self.tableView removeObserver:self._footer forKeyPath:MJRefreshContentSize];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        Task* task  = [FMUtils dataBy:self.tasks section:indexPath.section andRow:indexPath.row];
        if (![task isReallyAccounted]) {
            return 170;
        }
        return 203;
    }
    @catch (NSException *exception) {
        LOG(@"Exception %@",exception);
    }
    @finally {
    }
    
    return 238;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        Task* task = [FMUtils dataBy:self.tasks section:indexPath.section andRow:indexPath.row];
        if ($safe(task) && [task isReallyAccounted]) {
            //如果显示昨日 这里应该打开的是昨日 对吧
            [MyTaskDetail pushTaskDetail:task.taskId date:self.participatesType==1?[MyTaskDetail yesterDay]:nil on:self];
            //                ParticipatesDetailController* pc = segue.destinationViewController;
            //                pc.task = task;
            //                pc.participatesType=self.participatesType;
        }
    }
    @catch (NSException *exception) {
    }
    @finally {        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [FMUtils sectionsByTaskTime:self.tasks];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [FMUtils rowsBy:self.tasks section:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ParticipatesCell";
    ParticipatesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    @try {
        [cell configureTask:[FMUtils dataBy:self.tasks section:indexPath.section andRow:indexPath.row]];
    }
    @catch (NSException *exception) {
        LOG(@"Exception %@",exception);
    }
    @finally {
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    @try {
//        if (section==0) {
//            return [[UIView alloc] initWithFrame:CGRectZero];
//        }
        NSString* title = [[[FMUtils dataBy:self.tasks section:section andRow:0] publishTime] fmStandStringDateOnly];
        UILabel* view = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 16)];
        [view setBackgroundColor:fmTableBorderColor];
        view.text = title;
        view.textAlignment = NSTextAlignmentRight;
        view.font = [UIFont systemFontOfSize:11];
        view.textColor = [UIColor lightGrayColor];
        return view;
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    return nil;
    
}

@end
