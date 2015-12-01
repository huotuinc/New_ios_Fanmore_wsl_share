//
//  MyTaskDetail.m
//  Fanmore
//
//  Created by Cai Jiang on 6/16/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "MyTaskDetail.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "MJRefresh.h"
#import "BlocksKit+UIKit.h"
#import "Paging.h"

@interface MyTaskDetail ()

@property(weak) UILabel* labelTotalScore;

@property(weak) UILabel* labelScore;
@property(weak) UILabel* labelBrowse;
//@property(weak) UILabel* labelLink;

@property (weak, nonatomic) IBOutlet ScoreFlowSelection *sfsYes;
@property (weak, nonatomic) IBOutlet ScoreFlowSelection *sfsHistory;

@property(weak) UITableView* tableView;

@property NSMutableArray* flows;
@property(weak) MJRefreshHeaderView *_header;//srollview owner it
@property(weak) MJRefreshFooterView *_footer;//srollview owner it

@end

@implementation MyTaskDetail

+(NSDate*)yesterDay{
    static NSDate* MyTaskDetailyesterDay;
    if (!MyTaskDetailyesterDay) {
        MyTaskDetailyesterDay = [NSDate dateWithTimeIntervalSinceNow:-1*24*60*60];
    }
    return MyTaskDetailyesterDay;
}

-(void)flowSelected:(ScoreFlowSelection*)selection{
//    if (selection==self.sfsToday) {
//        self.labelLabelBrowse.text = NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.browses.today",nil,[NSBundle mainBundle],@"浏览量",nil);
//        self.labelLabelScore.text=NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.income.today",nil,[NSBundle mainBundle],@"收益",nil);
//        self.labelCountScore.text=NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.income.noaccount",nil,[NSBundle mainBundle],@"未结算",nil);
//    }else if (selection==self.sfsHistory) {
//        self.labelLabelBrowse.text = NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.browses.history",nil,[NSBundle mainBundle],@"浏览量",nil);
//        self.labelLabelScore.text=NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.income.history",nil,[NSBundle mainBundle],@"收益",nil);
//    }else if (selection==self.sfsYes) {
//        self.labelLabelBrowse.text = NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.browses.yesterday",nil,[NSBundle mainBundle],@"浏览量",nil);
//        self.labelLabelScore.text=NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.income.yesterday",nil,[NSBundle mainBundle],@"收益",nil);
//    }
    [self.flows removeAllObjects];
    [self._header beginRefreshing];
}

-(NSNumber*)lastId{
    if (self.flows==nil || self.flows.count==0) {
        return @0;
    }
    ScoreFlow* task=[self.flows $last];
    //            return @0;
    return task.id;
}

-(id)initWithDate:(NSDate*)date taskid:(NSNumber*)taskid{
    self = [super init];
    if (self) {
        self.date = date;
        self.taskid = taskid;
    }
    return self;
}

+(instancetype)pushTaskDetail:(NSNumber*)taskid date:(NSDate*)date on:(UIViewController*)controller{
    MyTaskDetail* obj = [[self alloc] initWithDate:date taskid:taskid];
    [controller.navigationController pushViewController:obj animated:YES];
    return obj;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.view.backgroundColor  = [UIColor whiteColor];    
    //568 则0
    CGFloat y = [self topY];
    
    UILabel* label;
    if (self.date) {
        self.navigationItem.title  = @"积分详情";
        //            self.navigationItem.title  = [self.date fmStandStringDateOnlyChinese];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 320, 60.0f)];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor colorWithHexString:@"FF4646"]];
        [label setFont:[UIFont systemFontOfSize:25.0f]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:@"0"];
        [self.view addSubview:label];
        self.labelTotalScore = label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(238.0f, y+26.0f, 75.0f, 21.0f)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:15.0f]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setText:@"累积收益"];
        [self.view addSubview:label];
        
        y+= 60.0f;
        ScoreFlowSelection* sfs = [[ScoreFlowSelection alloc] initWithFrame:CGRectMake(0, y, 160.0f, 54.0f)];
        [sfs setTextColor:[UIColor blackColor]];
        [sfs setFont:[UIFont systemFontOfSize:19.0f]];
        [sfs setTextAlignment:NSTextAlignmentCenter];
        if (self.date==[MyTaskDetail yesterDay]) {
            [sfs setText:@"昨日收益"];
        }else
            [sfs setText:[self.date fmStandStringDateOnlyChinese]];
        [self.view addSubview:sfs];
        self.sfsYes = sfs;
        self.sfsYes.delegate = self;
        
        sfs = [[ScoreFlowSelection alloc] initWithFrame:CGRectMake(160.0f, y, 160.0f, 54.0f)];
        [sfs setTextColor:[UIColor blackColor]];
        [sfs setFont:[UIFont systemFontOfSize:19.0f]];
        [sfs setTextAlignment:NSTextAlignmentCenter];
        [sfs setText:@"历史收益"];
        [self.view addSubview:sfs];
        self.sfsHistory = sfs;
        self.sfsHistory.delegate = self;
        y+= 54.0f;
        y+=5;
    }else{
        self.navigationItem.title = @"历史收益";
    }
    
    //浏览 收益 外联
    CGFloat xwidth = 320.0f/2.0f;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f ,y , xwidth , 26.0f)];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:23.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"0"];
    [self.view addSubview:label];
    self.labelBrowse = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(xwidth ,y , xwidth , 26.0f)];
    [label setTextColor:[UIColor redColor]];
    [label setFont:[UIFont systemFontOfSize:23.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"0"];
    [self.view addSubview:label];
    self.labelScore = label;
    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(xwidth*2 ,y , xwidth , 26.0f)];
//    [label setTextColor:[UIColor blackColor]];
//    [label setFont:[UIFont systemFontOfSize:23.0f]];
//    [label setTextAlignment:NSTextAlignmentCenter];
//    [label setText:@"0"];
//    [self.view addSubview:label];
//    self.labelLink = label;
    
    y+=26.0f;
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f ,y , xwidth , 21.0f)];
    [label setTextColor:[UIColor lightGrayColor]];
    [label setFont:[UIFont systemFontOfSize:13.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"浏览量"];
    [self.view addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(xwidth ,y , xwidth , 21.0f)];
    [label setTextColor:[UIColor lightGrayColor]];
    [label setFont:[UIFont systemFontOfSize:13.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"收益"];
    [self.view addSubview:label];
    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(xwidth*2 ,y , xwidth , 21.0f)];
//    [label setTextColor:[UIColor lightGrayColor]];
//    [label setFont:[UIFont systemFontOfSize:13.0f]];
//    [label setTextAlignment:NSTextAlignmentCenter];
//    [label setText:@"外链"];
//    [self.view addSubview:label];
    
    y += 21.0f;
    
    UITableView* table = [[UITableView alloc] initWithFrame:CGRectMake(0, y, 320, [UIScreen mainScreen].bounds.size.height-y) style:UITableViewStylePlain];
    // more
    table.rowHeight = 66.0f;
    [table registerClass:[ScoreFlowCell class] forCellReuseIdentifier:@"ScoreFlowCell"];
    table.dataSource = self;
    [self.view addSubview:table];
    self.tableView = table;
    
    [super viewDidLoadGestureRecognizer];
    __weak MyTaskDetail* wself = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (self.flows==Nil) {
        self.flows = $new(NSMutableArray);
    }else{
        [self.flows removeAllObjects];
    }
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
        
        uint type;
        if (!wself.date || [wself.sfsHistory actived]) {
            type = 3;
        }else if (wself.date && [wself.sfsYes actived] && wself.date==[MyTaskDetail yesterDay]) {
            type = 1;
        }else
            type = 2;
        
        [fos NewScoreFlow:nil block:^(NSNumber *browseCount, NSNumber *linkCount, NSNumber *dayScore, NSNumber *totalScore, NSArray *list, NSError *error) {
            if ($safe(error)) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                [refreshView endRefreshing];
                return;
            }
            
            if (wself.flows.count==0) {
                if ($safe(totalScore)) {
                    [FMUtils dynamicIncreaseLabel:wself.labelTotalScore from:@0 to:totalScore duration:0.5];
                }
                
                if ($safe(browseCount)) {
                    [FMUtils dynamicIncreaseLabel:wself.labelBrowse from:@0 to:browseCount duration:0.5];
                }
//                if ($safe(linkCount)) {
//                    [FMUtils dynamicIncreaseLabel:wself.labelLink from:@0 to:linkCount duration:0.5];
//                }
                if ($safe(dayScore)) {
                    [FMUtils dynamicIncreaseLabel:wself.labelScore from:@0 to:dayScore duration:0.5];
                }
            }
            
            if ($safe(list)) {
                HashAddArray(wself.flows, list);
                [wself.tableView reloadData];
            }
            
            [refreshView endRefreshing];
            
        } taskid:wself.taskid date:wself.date type:type paging:[Paging paging:10 parameters:@{@"autoId": [wself lastId]}]];
        
//        [fos scoreFlow:Nil block:^(NSNumber *browseCount, NSNumber *linkCount, NSNumber *scoreCount, NSNumber *totalScore, NSArray *flows, NSError *error) {
//            if ($safe(error)) {
//                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
//                [refreshView endRefreshing];
//                return;
//            }
//            
//            if ($eql(@0,[wself lastId])) {
//                if ($safe(browseCount)) {
//                    [FMUtils dynamicIncreaseLabel:wself.labelCountBrowse from:@0 to:browseCount duration:0.5];
//                }
//                if ($safe(linkCount)) {
//                    [FMUtils dynamicIncreaseLabel:wself.labelCountLink from:@0 to:linkCount duration:0.5];
//                }
//                if (type!=1 && $safe(scoreCount)) {
//                    [FMUtils dynamicIncreaseLabel:wself.labelCountScore from:@0 to:scoreCount duration:0.5];
//                }
//                if ($safe(totalScore)) {
//                    [FMUtils dynamicIncreaseLabel:wself.labelAll from:@0 to:totalScore duration:0.5];
//                }
//            }
//            if ($safe(flows)) {
//                HashAddArray(wself.flows, flows);
//                [wself.tableView reloadData];
//            }
//            
//            [refreshView endRefreshing];
//        } task:wself.task type:type paging:[Paging paging:10 parameters:@{@"autoId": [wself lastId]}]];
    };
    self._footer = footer;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [wself.flows removeAllObjects];
        wself._footer.beginRefreshingBlock(refreshView);
    };
    self._header = header;
    
    
    if (self.date) {
        [self.sfsYes activeSelection];
    }else{
        [header beginRefreshing];
    }    
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.flows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScoreFlowCell";
    ScoreFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    @try {
        [cell configScoreFlow:[self.flows $at:indexPath.row] index:indexPath detail:YES];
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
    [self.sfsYes unactive];
//    [self.sfsToday unactive];
    [self.sfsHistory unactive];
}

@end
