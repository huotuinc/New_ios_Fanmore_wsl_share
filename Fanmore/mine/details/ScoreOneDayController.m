//
//  ScoreOneDayController.m
//  Fanmore
//
//  Created by Cai Jiang on 6/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//  昨日收益

#import "ScoreOneDayController.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "ScoreOneDayCell.h"
#import "MyTaskDetail.h"
#import "FMTableView.h"
#import "UITableView+SetNoDateBackImage.h"
NSString*(^dictdategetter)(id input) = ^(id input) {
    NSString* date = input[@"date"];
    if (!$safe(date)){
        return @"";
    }
    NSRange range = [date rangeOfString:@" "];
    if(range.location==NSNotFound){
        return date;
    }
    NSString* nd = [date substringToIndex:range.location];
    return nd;
};

@interface ScoreOneDayController ()

@property NSArray* list;
@property(weak) UITableView* tableView;

@end

@implementation ScoreOneDayController

-(id)initWithDate:(NSDate*)date{
    self = [super init];
//    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.date = date;
        if (self.date) {
            self.navigationItem.title  = [self.date fmStandStringDateOnlyChinese];
        }else{
            self.navigationItem.title = @"昨日收益";
        }
    }
    return self;
}

+(instancetype)pushScoreOneDay:(NSDate*)date on:(UIViewController*)controller{
    ScoreOneDayController* obj = [[self alloc] initWithDate:date];
    [controller.navigationController pushViewController:obj animated:YES];
    return obj;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}

-(void)loadData{
    
    __weak id<FanOperations> fo = [[AppDelegate getInstance] getFanOperations];
    __weak ScoreOneDayController* wself = self;
    
    [fo TotalScoreDay:nil block:^(NSArray *list, NSError *error) {
        if ($safe(error)) {
            [FMUtils alertMessage:wself.tableView msg:[error FMDescription]];
            [wself performSelector:@selector(loadData) withObject:nil afterDelay:5];
            return;
        }
        
        if ($safe(list)) {
            //type
            //totalScore
//            browseAmount = 8;
//            date = "2014-06-05 00-00-00";
//            description = "\U6700\U6602\U8d35\U7684\U80f8\Uff0c\U7adf\U713613\U4ebf\Uff01";
//            imageUrl = "http://192.168.0.208:93/resource/taskimg/895ed4db858746bd8b0b00c4c68c3f7f_104X104.jpg";
//            title = "\U7cbe\U54c1";
            wself.list = list;
//            LOG(@"%@",list);
            if (list) {
                [wself.tableView setClearBackground];
            }else{
                wself.tableView.backgroundColor = [UIColor whiteColor];
            }
            [wself.tableView reloadData];
        }
        
    } date:self.date];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadGestureRecognizer];
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)]];
    
    CGFloat y = -23.0f;
    UITableView* table = [[FMTableView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-y) style:UITableViewStylePlain];
    
    [self.view addSubview:table];
    self.tableView = table;
    //luohaibo
    self.tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[ScoreOneDayCell class] forCellReuseIdentifier:@"ScoreOneDayCell"];
//    self.tableView.rowHeight = 147;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.tableView.backgroundColor = fmTableBorderColor;
//    [self.tableView offset:0 y:-44.0f];
//    self.tableView.sectionHeaderHeight = 0;
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* data = [FMUtils dataBy:self.list section:indexPath.section andRow:indexPath.row timeGetter:dictdategetter];
    if ([data[@"type"] intValue]==2 && data[@"id"]) {
        if (self.date) {
            [MyTaskDetail pushTaskDetail:data[@"id"] date:self.date on:self];
        }else{
            [MyTaskDetail pushTaskDetail:data[@"id"] date:[MyTaskDetail yesterDay] on:self];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([FMUtils sectionsByTaskTime:self.list timeGetter:dictdategetter]>0) {
        tableView.backgroundColor = [UIColor whiteColor];
        
    }else{
        [tableView setClearBackground];
    }
    return [FMUtils sectionsByTaskTime:self.list timeGetter:dictdategetter];
//    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.list.count;
    return [FMUtils rowsBy:self.list section:section timeGetter:dictdategetter];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreOneDayCell" forIndexPath:indexPath];
    
    // Configure the cell...
    ScoreOneDayCell* xcell = (ScoreOneDayCell*)cell;
    if (self.date) {
        [xcell.labelStaticBrowse setText:@"当日浏览："];
    }else{
        [xcell.labelStaticBrowse setText:@"昨日浏览："];
    }
    
    [xcell configureData:[FMUtils dataBy:self.list section:indexPath.section andRow:indexPath.row timeGetter:dictdategetter]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        NSDictionary* data = [FMUtils dataBy:self.list section:indexPath.section andRow:indexPath.row timeGetter:dictdategetter];
        
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    @try {
        if (section==0) {
//            return nil;
            return [[UIView alloc] initWithFrame:CGRectZero];
        }
        NSString* title = [[[FMUtils dataBy:self.list section:section andRow:0 timeGetter:dictdategetter][@"date"] fmToDate] fmStandStringDateOnly];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
