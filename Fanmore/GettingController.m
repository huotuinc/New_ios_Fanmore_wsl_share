//
//  GettingController.m
//  Fanmore
//
//  Created by Cai Jiang on 6/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "GettingController.h"
#import "GettingHeader.h"
#import "FakeNavigationBar.h"
#import "ScorePerDay.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "MJRefresh.h"
//#import "ScoreDetailTableCell.h"
#import "ScoreOneDayCell.h"
#import "MyTaskDetail.h"
#import "DIYView.h"
#import "HXColor.h"
//#import "ScoreOneDayController.h"

//NSString*(^gcdictdategetter)(id input) = ^(id input) {
//    NSString* date = input[@"date"];
//    if (!$safe(date)){
//        return @"";
//    }
//    NSRange range = [date rangeOfString:@" "];
//    if(range.location==NSNotFound){
//        return date;
//    }
//    NSString* nd = [date substringToIndex:range.location];
//    return nd;
//};

@interface GettingController ()<UIScrollViewDelegate>

@property(weak) GettingHeader* getterHeader;

@property(strong) NSMutableArray* days;
@property (nonatomic)  NSInteger selectedRow;
@property NSTimeInterval reloadTime;
@property NSUInteger maxCount;

@property(weak) MJRefreshHeaderView *_header;//srollview owner it
@property(weak) MJRefreshFooterView *_footer;//srollview owner it


@end

@implementation GettingController

-(void)doBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSDate*)lastTaskId{
    if (self.days==nil || self.days.count==0) {
        return nil;
    }
    for (int i=self.days.count-1; i>=0; i--) {
        if ([self.days[i] time]!=nil) {
            return [self.days[i] time];
        }
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!safeController(self))
        return;
    if (!$safe(self.getterHeader)) {
        return;
    }
    if (!scrollView) {
        return;
    }
    //    LOG(@"%f",scrollView.contentOffset.y);
    //在数据中 直接加入一列数据 以记录占用高度 这样scroll就可以准确计算出哪个元素正在被指向
    //2 137
    //!2 147
    //header ?
    CGFloat header = 49+7;
    //一开始是0
    CGFloat current = 0;
    
    if (!self.days) {
        return;
    }
    for (int i=0; i<self.days.count; i++) {
        current += header;
        ScorePerDay* sd = self.days[i];
        if (!sd || !sd.details) {
            return;
        }
        for (int j=0; j<sd.details.count; j++) {
            NSDictionary* data = sd.details[j];
            if ([data[@"type"] intValue]==2) {
                current += 137;
            }else
                current += 147;
            if (current>scrollView.contentOffset.y) {
                //bingo!
                [self.getterHeader selectDate:[sd time]];
                return;
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadGestureRecognizer];
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)]];
    
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat offset = 0;
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0+offset, 320, 20)];
    v.backgroundColor = fmMainColor;
//    v.backgroundColor = [UIColor redColor];
    [self.view addSubview:v];
    [self.view addSubview:[[FakeNavigationBar alloc] initWithController:self]];
    GettingHeader* gheader = [[GettingHeader alloc]initWithFrame:CGRectMake(0, 64+offset, 320, 130)];
    [self.view addSubview:gheader];
    self.getterHeader = gheader;
    
    //mock data
    //今日起 20天数据
    //积分 从1-110间
    NSMutableArray* list = $marrnew;
    
    for (int i=0; i<20; i++) {
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:-i*24*60*60];
        ScorePerDay* spd = [[ScorePerDay alloc] init];
//        spd.pk = $int(i+1);
        spd.time = date;
        spd.score =  $int(random()%110+1);
        spd.browse = $long(random()%5600+2);
        [list $push:spd];
    }
    //mock done
    
    
    NSNumber* max = $int(0);
    NSNumber* min = $float(MAXFLOAT);
    
    for (ScorePerDay* day in list) {
        if([day.score floatValue]>[max floatValue]){
            max = day.score;
        }
        
        if ([day.score floatValue]<[min floatValue]) {
            min = day.score;
        }
    }
    
//    [self.getterHeader updateScores:list max:max min:min];
    
//    [self testUpdateIndex];
    
//    self.cells = $marrnew;
    self.selectedRow = -1;
    
    if ([UIScreen mainScreen].bounds.size.height>568) {
        self.maxCount = 3;
    }else if ([UIScreen mainScreen].bounds.size.height<568){
        self.maxCount = 1;
    }else{
        self.maxCount = 2;
    }
    
    self.maxCount = 0;
    
    
    if (self.days==Nil) {
        self.days = $new(NSMutableArray);
    }else{
        [self.days removeAllObjects];
    }
        
    __weak GettingController* wself = self;
    
    wself.table.delegate = wself;
    wself.table.dataSource = wself;
//    [wself.table setBackgroundColor:[UIColor colorWithHexString:@"797979"]];
    wself.table.sectionHeaderHeight = 49;
    wself.table.sectionFooterHeight = 7;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.table;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
//        HashAddArray(wself.days, list);
//        // TODO 排序 以及除0
//        int x = wself.maxCount-1;
//        while (x-->0) {
//            [wself.days $push:$new(ScorePerDay)];
//        }
//        wself.selectedRow = -1;
//        wself.reloadTime = [NSDate timeIntervalSinceReferenceDate];
//        [wself.table reloadData];
//        [refreshView endRefreshing];
        
        
        [fos newTotalScoreList:nil block:^(NSNumber *totalScore, NSNumber *totalCount, NSNumber *maxScore, NSNumber *minScore, NSArray *list,NSError *error) {
            
            if ($safe(error)) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                [refreshView endRefreshing];
                return;
            }
//            LOG(@"%@",list);
            
            int oldSize = wself.days.count;
            
            [wself.days filterUsingPredicate:[NSPredicate predicateWithFormat:@"time != null"]];
            HashAddArray(wself.days, list);
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time"
                                                         ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            [wself.days sortUsingDescriptors:sortDescriptors];
            
            [wself.getterHeader updateScores:[NSArray arrayWithArray:wself.days] max:maxScore min:minScore];
            
//            int x = wself.maxCount-1;
            int x = wself.maxCount;
            while (x-->0) {
                [wself.days $push:$new(ScorePerDay)];
            }
            
            //test
//            [wself.getterHeader selectDate:[wself.days[0] time]];
            
            [wself.table reloadData];
            if (wself.days.count!=oldSize) {
                if (wself.selectedRow==0) {
                    wself.selectedRow = -1;
                }
//                if (oldSize==0) {
                    wself.reloadTime = [NSDate timeIntervalSinceReferenceDate];
//                }
                [wself.table reloadData];
            }
            
            [refreshView endRefreshing];
            
            if (wself.days.count-wself.maxCount==0) {
                [FMUtils alertMessage:wself.view msg:@"暂无已获得的积分信息，加油！" block:^{
                    if (safeController(wself)) {
                        [wself doBack];
                    }
                }];
            }
            
        } date:[wself lastTaskId]];
        
//        [fos listPartTask:Nil block:^(NSArray *task, NSError *error) {
//            if ($safe(error)) {
//                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
//                [refreshView endRefreshing];
//                return;
//            }
//            if ($safe(task)) {
//                HashAddArray(wself.days, task)
//                [wself.table reloadData];
//                LOG(@"fetch data refresh table n:%d newtasks:%d",wself.days.count,task.count);
//            }
//            [refreshView endRefreshing];
//        } type:wself.participatesType paging:[Paging paging:10 parameters:@{@"autoId":[wself lastTaskId]}]];
    };
    self._footer = footer;
    
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.table;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [wself.days removeAllObjects];
        wself._footer.beginRefreshingBlock(refreshView);
    };
    
    self._header = header;
    
    [header beginRefreshing];
       
    
    DIYView* diy = [[DIYView alloc] initWithFrame:CGRectMake(0, 64.0f+self.getterHeader.frame.size.height, 320.0f, 30.0f)];
    [self.view addSubview:diy];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    self.table.delegate = self;
    [self.table selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.table.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)dealloc{
    [self.table removeObserver:self._header forKeyPath:MJRefreshContentOffset];
    [self.table removeObserver:self._footer forKeyPath:MJRefreshContentOffset];
    [self.table removeObserver:self._footer forKeyPath:MJRefreshContentSize];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        NSDictionary* data = [self.days[indexPath.section] details][indexPath.row];
        NSDate* date = [data getScoreOneDayDate];
        if ([data[@"type"] intValue]==2 && data[@"id"]) {
            if (date) {
                [MyTaskDetail pushTaskDetail:data[@"id"] date:date on:self];
            }else{
                [MyTaskDetail pushTaskDetail:data[@"id"] date:[MyTaskDetail yesterDay] on:self];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)setSelectedRow:(NSInteger)selectedRow{
    if (!self.days || !self.table) {
        _selectedRow = selectedRow;
        return;
    }
    LOG(@"update SelectedRow %d count:%d",selectedRow,self.maxCount);
    
    @try {
        ScorePerDay* sd = self.days[selectedRow];
        if (!sd || !sd.time) {
            return;
        }
        
        _selectedRow = selectedRow;
        if (_selectedRow>-1) {
//            for (int i=0; i<self.days.count; i++) {
//                @try {
//                    id c = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//                    if(c){
//                        ScoreDetailTableCell* xcell = (ScoreDetailTableCell*)c;
//                        if(xcell)
//                            xcell.focuxed = NO;
//                    }
//                }
//                @catch (NSException *exception) {
//                    LOG(@"Exception %@",exception);
//                }
//                
//            }
//            ScoreDetailTableCell* xcell = (ScoreDetailTableCell*)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:0]];
//            if(xcell)
//                xcell.focuxed = YES;
            [self.getterHeader selectDate:[self.days[_selectedRow] time]];
        }

    }
    @catch (NSException *exception) {
        LOG(@"Exception %@",exception);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        NSDictionary* data = [self.days[indexPath.section] details][indexPath.row];
        
        int type = [data[@"type"] intValue];
        if (type==2) {
            return 137;
        }else{
            return 147;
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    return 147;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flowdetailtop"]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    UIImageView* bk = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 320, 42)];
    bk.image = [UIImage imageNamed:@"flowdetailbottom"];
    [view addSubview:bk];
    @try {
       
        ScorePerDay* sd = self.days[section];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 17, 140, 22)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextColor:[UIColor darkGrayColor]];
        [view addSubview:label];
        [label setText:$str(@"%@收益",[sd.time fmStandStringDateOnly])];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(199, 17, 60, 22)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:13]];
        [label setTextColor:[UIColor whiteColor]];
        [label setText:[sd.browse stringValue]];
        [view addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(270, 17, 80, 22)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:13]];
        [label setTextColor:[UIColor whiteColor]];
        [label setText:[sd.score currencyStringMax2Digits]];
//        [label setText:$str(@"%@",sd.score)];
        [view addSubview:label];
        
//        if (section==0) {
//            return [[UIView alloc] initWithFrame:CGRectZero];
//        }
//        
//        NSDate* time = [self.days[section] time];
//        
//        NSString* title = [time fmStandStringDateOnly];
//        UILabel* view = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 10)];
//        [view setBackgroundColor:fmTableBorderColor];
//        view.text = title;
//        view.textAlignment = NSTextAlignmentRight;
//        view.font = [UIFont systemFontOfSize:11];
//        view.textColor = [UIColor lightGrayColor];
        

    }
    @catch (NSException *exception) {
        LOG(@"%@",exception);
    }
    @finally {
        return view;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.days.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        return [self.days[section] details].count;
    }
    @catch (NSException *exception) {
        return 0;
    }
    @finally {
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreOneDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreOneDayCell" forIndexPath:indexPath];
    @try {
        NSDictionary* data = [self.days[indexPath.section] details][indexPath.row];
        [cell configureData:data];
    }
    @catch (NSException *exception) {
        //这里应该可以考虑 给予全白色的cell!!!
    }
    @finally {
    }
    return cell;
}


@end
