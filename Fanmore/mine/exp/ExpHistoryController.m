//
//  ExpHistoryController.m
//  Fanmore
//
//  Created by Cai Jiang on 10/16/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ExpHistoryController.h"
#import "BlocksKit+UIKit.h"
#import "AppDelegate.h"
#import "ExpHistoryCell.h"
#import "MJRefresh.h"
#import "FMUtils.h"

@interface ExpHistoryController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong) NSMutableArray* historys;
@property(weak) MJRefreshHeaderView *_header;//srollview owner it
@property(weak) MJRefreshFooterView *_footer;//srollview owner it

@end

@implementation ExpHistoryController

-(NSNumber*)lastTaskId{
    if (self.historys==nil || self.historys.count==0) {
        return @0;
    }
    return [[self.historys lastObject] getExpHistoryId];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewDidLoadGestureRecognizer];
    [self viewDidLoadFanmore];
    
    UITableView* tvv = [[UITableView alloc] initWithFrame:self.tableView.frame style:UITableViewStylePlain];
    [tvv registerClass:[ExpHistoryCell class] forCellReuseIdentifier:@"ExpHistoryCell"];
    tvv.rowHeight = self.tableView.rowHeight;
    [self.tableView removeFromSuperview];
    [self.view addSubview:tvv];
    self.tableView = tvv;
    CGFloat y = [self topY];
    
    CGFloat left = self.view.frame.size.height-y;
    
    [self.tableView setFrame:CGRectMake(0, y, 320, left)];
    
    // // // // //
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (self.historys==Nil) {
        self.historys = $new(NSMutableArray);
    }
    
    __weak ExpHistoryController* wself = self;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
        [fos expHistory:nil block:^(NSArray *list, NSError *error) {
            if ($safe(error)) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                [refreshView endRefreshing];
                return;
            }
            
            if ($safe(list)) {
                [wself.historys addObjectsFromArray:list];
                [wself.tableView reloadData];
            }
            
            // 13600541783
            [wself._header checkInset:0];
            
            [refreshView endRefreshing];
        } paging:[Paging paging:10 parameters:@{@"oldId":[wself lastTaskId]}]];
    };
    self._footer = footer;
    
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [wself.historys removeAllObjects];
        wself._footer.beginRefreshingBlock(refreshView);
    };
    
    self._header = header;
    
    [header beginRefreshing];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ExpHistoryCell";
    ExpHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    @try {
        NSDictionary* data = self.historys[indexPath.row];
        [cell config:data row:indexPath.row];
    }
    @catch (NSException *exception) {
        LOG(@"Exception %@",exception);
    }
    @finally {
    }
    
    return cell;
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
