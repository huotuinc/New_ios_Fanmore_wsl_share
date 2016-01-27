//
//  FavStoreDetailController.m
//  Fanmore
//
//  Created by Cai Jiang on 3/11/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FavStoreDetailController.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "MJRefresh.h"
#import "StoreCell.h"
#import "Paging.h"
#import "TaskListCell.h"

@interface FavStoreDetailController ()

@property NSMutableArray* tasks;
@property(weak) Store* store;
@property(weak) MJRefreshHeaderView *_header;
@property(weak) MJRefreshFooterView *_footer;//srollview owner it

@property(weak) StoreCell* scell;
@property(weak) UILabel* labelHangye;
@property(weak) UILabel* labelLianxi;

@end

@implementation FavStoreDetailController

-(void)passStore:(Store*)store{
    self.store = store;
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
    if (self.tasks==nil || self.tasks.count==0) {
        return @0;
    }
    Task* task=[self.tasks $last];
    //            return @0;
    return task.taskId;
}

-(void)updateStore{
    [self.scell configureStore:self.store];
    self.labelHangye.text = $str(@"所属行业：%@",$safe(self.store.industry)?self.store.industry:@"");
    self.labelLianxi.text = $str(@"联系方式：%@",$safe(self.store.contact)?self.store.contact:@"暂无");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadFanmore];
    [self viewDidLoadGestureRecognizer];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.title = self.store.name;
    
    if (self.tasks==Nil) {
        self.tasks = $new(NSMutableArray);
    }else{
        [self.tasks removeAllObjects];
    }
    
    __weak FavStoreDetailController* wself = self;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
        [fos myFavoriteTaskDetail:Nil block:^(NSArray *task, NSError *error) {
            if ($safe(error)) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                [refreshView endRefreshing];
                return;
            }
            [wself updateStore];
            if ($safe(task)) {
                HashAddArray(wself.tasks, task)
                [wself.tableView reloadData];
                LOG(@"fetch data refresh table n:%d newtasks:%d",wself.tasks.count,task.count);
            }
            [refreshView endRefreshing];
            
        } store:wself.store paging:[Paging paging:10 parameters:@{@"oldTaskId": [wself lastId]}]];
    };
    self._footer = footer;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [wself.tasks removeAllObjects];
        wself._footer.beginRefreshingBlock(refreshView);
    };
    
    self._header = header;
    
    self.tableView.tableHeaderView = ({
        UIView* theader = $new(UIView);
        theader.frame = CGRectMake(0, 0, 320, 150);
        CGFloat fsize= 15;
        UIColor* fcolor = [UIColor blackColor];
//        LayoutContext* lc = [LayoutContext contextByView:theader];
        
        StoreCell* sc = $new(StoreCell);
        sc.frame = CGRectMake(10.0, 5.0, 300, 100);
        [sc.layer setBorderWidth:0];
        [sc.layer setBorderColor:fmTableBorderColor.CGColor];
        self.scell = sc;
        [theader addSubview:sc];
        
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 105, 300, 21)];
        label.font = [UIFont systemFontOfSize:fsize];
        label.textColor = fcolor;
        self.labelHangye = label;
        [theader addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 126, 300, 21)];
        label.font = [UIFont systemFontOfSize:fsize];
        label.textColor = fcolor;
        self.labelLianxi = label;
        [theader addSubview:label];
        
        [self updateStore];
        
        theader;
//        UIView* header2 = $new(UIView);
//        LOG(@"%@ %@",header2,theader);
//        [header2 addSubview:theader];
//        [header2 setBounds:CGRectMake(0, 0, 320, 150)];
//        header2;
    });
    
    [header beginRefreshing];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TaskCell";
    TaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    @try {
        [cell configureTask:[self.tasks $at:indexPath.row]];
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


@end
