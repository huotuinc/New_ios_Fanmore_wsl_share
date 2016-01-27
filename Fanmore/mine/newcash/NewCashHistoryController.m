//
//  NewCashHistoryController.m
//  Fanmore
//
//  Created by Cai Jiang on 12/19/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "NewCashHistoryController.h"
#import "Paging.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "NewCashCell.h"
#import "MJRefresh.h"

@interface NewCashHistoryController ()

@property NSMutableArray* cashs;
@property(weak) MJRefreshHeaderView *_header;
@property(weak) MJRefreshFooterView *_footer;//srollview owner it


@end

@implementation NewCashHistoryController

-(id)lastId{
    if (self.cashs==nil || self.cashs.count==0) {
        return @0;
    }
    return [[self.cashs $last] getNewCashHistoryId];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewDidLoadFanmore];
    [self viewDidLoadGestureRecognizer];
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (self.cashs==Nil) {
        self.cashs = $marrnew;
    }
    
    __weak NewCashHistoryController* wself = self;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
        [fos walletHistory:nil block:^(NSArray *history, NSError *error) {
            if ($safe(error)) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                [refreshView endRefreshing];
                return;
            }
            if ($safe(history)) {
                HashAddArray(wself.cashs, history)
                
                [wself.tableView reloadData];
                [refreshView endRefreshing];
            }
        } paging:[Paging paging:10 parameters:@{@"pageTag":[wself lastId]}]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cashs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewCashHistoryCell";
    NewCashCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    @try {
        NSDictionary* data = self.cashs[indexPath.row];
        [cell.labelId setText:$str(@"%d",indexPath.row+1)];
        [cell.labelDesc setText:[data getNewCashHistoryDesc]];
        [cell.labelDate setText:[[data getNewCashHistoryTime] fmStandString]];
        // 1 2
        if ([[data getNewCashHistoryType]intValue]==1) {
            [cell.labelAmount setText:$str(@"+%@",[[data getNewCashHistoryAmount] currencyString:@"" fractionDigits:2])];
        }else{
            [cell.labelAmount setText:$str(@"%@",[[data getNewCashHistoryAmount] currencyString:@"" fractionDigits:2])];
        }

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
