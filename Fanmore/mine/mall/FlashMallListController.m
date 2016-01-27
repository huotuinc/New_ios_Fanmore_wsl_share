//
//  FlashMallListController.m
//  Fanmore
//
//  Created by Cai Jiang on 8/8/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FlashMallListController.h"
#import "FlashMallCell.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "MJRefresh.h"


@interface FlashMallListController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong) NSMutableArray* sls;
@property(weak) MJRefreshHeaderView *_header;//srollview owner it
@property(weak) MJRefreshFooterView *_footer;//srollview owner it


@end

@implementation FlashMallListController

-(NSString*)lastTaskId{
    if (self.sls==nil || self.sls.count==0) {
        return @"";
    }
    return [[self.sls lastObject] getSLOrderTime];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadGestureRecognizer];
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)]];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (self.sls==Nil) {
        self.sls = $new(NSMutableArray);
    }else{
        [self.sls removeAllObjects];
    }
    
    __weak FlashMallListController* wself = self;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.table;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
        [fos flashMallList:nil block:^(NSNumber *count, NSNumber *tempScore, NSNumber *realScore, NSArray *list, NSError *error) {
            if ($safe(error)) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                [refreshView endRefreshing];
                return;
            }
            
            if(count && tempScore && realScore && wself.sls.count==0){
                [wself.labelCount setText:$str(@"闪购%@单",count)];
                [wself.labelScoreTemp setText:$str(@"%@分",tempScore)];
                [wself.labelScoreActurl setText:$str(@"%@分",realScore)];
            }
            
            if ($safe(list)) {                
                for (id newobj in list) {
                    id equalsable = [newobj performSelector:@selector(getSLOrderId)];
                    BOOL founed = NO;
                    for (id inlist in wself.sls) {
                        id equalsable2 = [inlist performSelector:@selector(getSLOrderId)];
                        if ([equalsable2 isEqual:equalsable]) {
                            founed = YES;
                            break;
                        }
                    }
                    if (!founed) {
                        [wself.sls addObject:newobj];
                    }
                }
                
//                HashAddArray(wself.sls , list)
                [wself.table reloadData];
            }
            [refreshView endRefreshing];
            
        } paging:[Paging paging:10 parameters:@{@"pageTag":[wself lastTaskId]}]];
    };
    self._footer = footer;
    
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.table;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [wself.sls removeAllObjects];
        wself._footer.beginRefreshingBlock(refreshView);
    };
    
    self._header = header;
    
    [header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    [self.table selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)dealloc{
    [self.table removeObserver:self._header forKeyPath:MJRefreshContentOffset];
    [self.table removeObserver:self._footer forKeyPath:MJRefreshContentOffset];
    //    [self.tableView removeObserver:self._header forKeyPath:MJRefreshContentSize];
    [self.table removeObserver:self._footer forKeyPath:MJRefreshContentSize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ($eql(segue.identifier,@"ToDetail")){
        [segue.destinationViewController setValue:sender forKey:@"sldata"];
    }
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        //跳转到details
        NSDictionary* data = self.sls[indexPath.row];
        
        [self performSegueWithIdentifier:@"ToDetail" sender:data];
    }
    @catch (NSException *exception) {
        LOG(@"%@",exception);
    }
    @finally {
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FlashMallCell";
    FlashMallCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    @try {
        [cell config:self.sls[indexPath.row]];
    }
    @catch (NSException *exception) {
        LOG(@"Exception %@",exception);
    }
    @finally {
    }
    
    return cell;
}

- (IBAction)clickRightButton:(id)sender {
    [FMUtils toRuleController:self attach:@"#sandianmimi"];
}
@end
