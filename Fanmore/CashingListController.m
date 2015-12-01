//
//  CashingListController.m
//  Fanmore
//
//  Created by Cai Jiang on 2/17/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "CashingListController.h"
#import "Paging.h"
#import "CashHistory.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "CashHistoryCell.h"
#import "MJRefresh.h"

@interface CashingListController ()

@property NSMutableArray* cashs;
@property(weak) MJRefreshHeaderView *_header;
@property(weak) MJRefreshFooterView *_footer;//srollview owner it

@property int refreshed;
@property BOOL autoRefreshing;

@end

@implementation CashingListController

-(void)doBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)lastId{
    if (self.cashs==nil || self.cashs.count==0) {
        return @0;
    }
    CashHistory* task=[self.cashs $last];
    //            return @0;
    return task.id;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadGestureRecognizer];
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    if (self.cashs==Nil) {
        self.cashs = $marrnew;
    }
    
    __weak CashingListController* wself = self;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
        [fos cashHistory:nil block:^(NSArray *cachs, NSError *error) {
            if ($safe(error)) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                [refreshView endRefreshing];
                return;
            }
            if ($safe(cachs)) {
                HashAddArray(wself.cashs, cachs)
#ifdef FanmoreDebugMockCashList
                CashHistory* ch = $new(CashHistory);
                      //                ch = $new(CashHistory);
                ch.id = @4;
                ch.money = @0.6;
                ch.score = @6;
                ch.status =@6;
                ch.extraMsg = Fanmore_RSA_PK_Base64;
                ch.time = [NSDate date];
                [wself.cashs addObject:ch];
#endif
                
                int showId = 1;
                for (CashHistory* ch in wself.cashs) {
                    ch.showId = $int(showId++);
                }
                
                [wself.tableView reloadData];
//                [wself.tableView setNeedsLayout];
                [refreshView endRefreshing];
                
                                LOG(@"fetch data refresh table n:%d newtasks:%d",wself.cashs.count,cachs.count);
                //在最近几次刷新过之内都会自动再刷新 以保证ui效果 4
                if (!wself.autoRefreshing) {
                    wself.refreshed++;
                    if (wself.refreshed<=2) {
                        wself.autoRefreshing = YES;
                        [refreshView performSelector:@selector(beginRefreshing) withObject:nil afterDelay:0.5];
                        return;
                    }
                }
                wself.autoRefreshing = NO;
            }
        } paging:[Paging paging:10 parameters:@{@"autoId":[wself lastId]}]];
    };
    self._footer = footer;
    
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [wself.cashs removeAllObjects];
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

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 计算Rect的工作 应该交给CashHistory来完成 它需要的数据 就是 maxWidth font breakMode
    CashHistory* cash = [self.cashs $at:indexPath.row];
    if ($safe(cash.extraMsg) && [cash.extraMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0) {
        CGSize size = [CashHistoryCell sizeOfMessage:cash.extraMsg];
        return 67.0f+size.height;
    }
//    [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return 67.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cashs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CashHistoryCell";
    CashHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    @try {
        [cell configCashHistory:[self.cashs $at:indexPath.row]];
    }
    @catch (NSException *exception) {
        
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

#pragma mark - delegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//    if ([cell isSelected]) {
//        return 67+25;
//    }
//    return 67;
//}

@end
