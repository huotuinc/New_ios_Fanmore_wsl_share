//
//  FlashMaillDetailController.m
//  Fanmore
//
//  Created by Cai Jiang on 8/8/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FlashMallDetailController.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "FlashMallCell.h"
#import "FlashMallRecordCell.h"


@interface FlashMallDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong) NSArray* records;

@end

@implementation FlashMallDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)fillData:(NSDictionary*)data{
    [self.labelId setText:[data getSLId]];
    [self.labelName setText:[data getSLName]];
    [self.labelName wellFontFrom:17.0f];
    
    [self.labelScoreActurl setText:$str(@"%@",[data getSLScoreActurl])];
    [self.labelScoreTemp setText:$str(@"%@",[data getSLScoreTemp])];
    [self.labelStatus setText:[data getSLStatusMsg]];
    [self.labelTimeCount setText:[data getSLTimeCount]];
    [self.labelTime setText:[[data getSLDate] fmStandString]];
    [self.labelUser setText:[data getSLUser]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self viewDidLoadGestureRecognizer];
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)]];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (self.records==Nil) {
        self.records = $new(NSMutableArray);
    }
    
    __weak FlashMallDetailController* wself = self;
    
    id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
    
    NSDictionary* sldata = [self valueForKey:@"sldata"];
    if (sldata) {
        [self fillData:sldata];
        [fos flashMallDetail:nil block:^(NSDictionary *data, NSError *error) {
            if ($safe(error)) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                return;
            }
            [wself fillData:data];
            wself.records = data[@"list"];
            [wself.table reloadData];
        } orderNo:[sldata getSLId]];
        
//        [self setNilValueForKey:@"sldata"];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];
    [self.table selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier:@"FlashMallRecordCell" forIndexPath:indexPath];
//    return cell;
    @try {
        FlashMallRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlashMallRecordCell" forIndexPath:indexPath];
        [cell config:self.records[indexPath.row] count:self.records.count current:indexPath.row];
        return cell;
    }
    @catch (NSException *exception) {
        LOG(@"Exception %@",exception);
    }
    @finally {
    }
    
}


@end
