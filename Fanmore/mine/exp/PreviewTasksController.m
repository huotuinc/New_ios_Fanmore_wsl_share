//
//  PreviewTasksController.m
//  Fanmore
//
//  Created by Cai Jiang on 10/16/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "PreviewTasksController.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "MJRefresh.h"
#import "PreviewTaskCell.h"
#import "ToSendTaskController.h"
#import "ItemCell.h"
#import "BugItemView.h"
#import "UITableView+SetNoDateBackImage.h"

@interface PreviewTasksController ()<UITableViewDataSource,UITableViewDelegate,BuyItemHandler,ItemsKnowlege,TableReloadAble>

@property(strong) NSMutableArray* tasks;

@property(weak) MJRefreshHeaderView *_header;//srollview owner it
@property(weak) MJRefreshFooterView *_footer;//srollview owner it

@property NSArray* items;
@property NSArray* myItems;

@property(weak) BugItemView* buyView;


@end

@implementation PreviewTasksController

-(void)reloadTable{
    [self.tableView reloadData];
}

-(NSArray*)returnItems{
    return self.items;
}

-(NSArray*)returnMyItems{
    return self.myItems;
}

-(void)buyItem:(NSDictionary *)item{
    if (self.buyView) {
        return;
    }
    BugItemView* view = [[NSBundle mainBundle] loadNibNamed:@"BugItemView" owner:nil options:nil][0];
    view.handler = self;
    [view show:self item:item];
    self.buyView = view;
}


-(void)itemsUpdate:(NSArray *)items myItems:(NSArray *)myItems{
    self.myItems = myItems;
    self.items = items;
}

-(NSNumber*)lastTaskId{
    if (self.tasks==nil || self.tasks.count==0) {
        return @0;
    }
    Task* task = [self.tasks $last];
    return task.taskId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewDidLoadGestureRecognizer];
    [self viewDidLoadFanmore];
    
    if (self.tasks==Nil) {
        self.tasks = $new(NSMutableArray);
    }else{
        [self.tasks removeAllObjects];
    }
    
    __weak PreviewTasksController* wself = self;
    
    self.tableView.delegate = wself;
    self.tableView.dataSource = wself;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = 182;
    self.tableView.allowsSelection = YES;
    [self.tableView registerClass:[PreviewTaskCell class] forCellReuseIdentifier:@"PreviewTaskCell"];
    
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [wself.tasks removeAllObjects];
        wself._footer.beginRefreshingBlock(refreshView);
    };
    
    self._header = header;
    [header beginRefreshing];
    
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
        
        [fos TodayNotice:nil block:^(NSArray *list, NSError *error) {
            if ($safe(error)) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                [refreshView endRefreshing];
                return;
            }
            if ($safe(list)) {
                HashAddArray(wself.tasks, list);
                if (wself.tasks.count) {
                    [wself.tableView setClearBackground];
                 }else{
                    wself.tableView.backgroundColor = [UIColor whiteColor];
                }
                [wself.tableView reloadData];
                [wself._header checkInset:0];
                
                [refreshView endRefreshing];
            }
        } paging:[Paging paging:10 parameters:@{@"oldTaskId":[wself lastTaskId]}]];
    };
    self._footer = footer;
    
    
    
    
    [self reloadItems];
    
}

-(void)reloadItems{
    __weak PreviewTasksController* wself = self;
    [[[AppDelegate getInstance] getFanOperations] itemList:nil block:^(NSArray *items, NSArray *myItems, NSError *error) {
        if ($safe(error)) {
//            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            [wself performSelector:@selector(reloadItems) withObject:nil afterDelay:5];
            return;
        }
        [wself itemsUpdate:items myItems:myItems];
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tasks.count == 0) {
        [tableView setClearBackground];
    }else{
        tableView.backgroundColor = [UIColor whiteColor];
    }
    return self.tasks.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Task* task = self.tasks[indexPath.row];
    
    ToSendTaskController* rmc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ToSendTaskController"];
//    TaskComingControllerStaticTask = task;
    rmc.task = task;
    rmc.hideButtonOnline = YES;
    [self.navigationController pushViewController:rmc animated:NO];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        Task* task = self.tasks[indexPath.row];
        PreviewTaskCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PreviewTaskCell" forIndexPath:indexPath];
        [cell config:task controller:self];
        return cell;
    }
    @catch (NSException *exception) {
        return [tableView dequeueReusableCellWithIdentifier:@"PreviewTaskCell" forIndexPath:indexPath];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
