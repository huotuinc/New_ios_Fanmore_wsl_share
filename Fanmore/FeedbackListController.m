//
//  FeedbackListController.m
//  Fanmore
//
//  Created by Cai Jiang on 4/29/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FeedbackListController.h"
#import "Paging.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "MJRefresh.h"
#import "NSDictionary+FeedbackFeedback.h"
#import "Message.h"
#import "MessageCell.h"
#import "MessageFrame.h"


@interface FeedbackListController ()

@property NSMutableArray* feeds;
@property(weak) MJRefreshHeaderView *_header;
@property(weak) MJRefreshFooterView *_footer;

@property NSMutableArray  *_allMessagesFrame;
//srollview owner it


@end

@implementation FeedbackListController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)lastId{
    if (self.feeds==nil || self.feeds.count==0) {
        return @0;
    }
    return [[self.feeds $last] getAutoId];
}

- (void)viewDidLoad
{
    //{
    //autoId = 10;
    //content = "\U7528\U6237\U53d1";
    //doContent = "555555
    //\n\U5ba2\U670d\U7535\U8bdd\Uff1a400-1818-357
    //\n\U5ba2\U670dQQ\Uff1a1169984133";
    //doTime = "2014-05-04 10-08-18";
   // status = 1;
  //  statusName = "\U5df2\U5904\U7406";
 //   time = "2014-05-04 09-57-10";
//}
    [super viewDidLoad];
    [self viewDidLoadFanmore];
    [self viewDidLoadGestureRecognizer];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    self._allMessagesFrame = $marrnew;
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //设置textField输入起始位置
//    _messageField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
//    _messageField.leftViewMode = UITextFieldViewModeAlways;
//    
//    _messageField.delegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (self.feeds==Nil) {
        self.feeds = $marrnew;
    }
    
    __weak FeedbackListController* wself = self;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [wself.feeds removeAllObjects];
        id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
        [fos feedbackList:nil block:^(NSArray *cachs, NSError *error) {
            if ($safe(error)) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                [refreshView endRefreshing];
                return;
            }
            if ($safe(cachs)) {
                HashAddArray(wself.feeds, cachs)
                
                
//                NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"]];
                NSString *previousTime = nil;
                [wself._allMessagesFrame removeAllObjects];
                
                for (int i=wself.feeds.count-1; i>=0; i--) {
                    NSDictionary* dict = wself.feeds[i];
                    MessageFrame *messageFrame = [[MessageFrame alloc] init];
                    Message *message = [[Message alloc] init];
                    message.time = [[dict[@"time"] fmToDate] fmStandStringDateOnly];
                    message.content = dict[@"content"];
                    message.type = MessageTypeMe;
                    messageFrame.showTime = ![previousTime isEqualToString:message.time];
                    
                    messageFrame.message = message;
                    
                    previousTime = message.time;
                    
                    [wself._allMessagesFrame addObject:messageFrame];
                    
                    NSString* doc = dict[@"doContent"];
                    if ($safe(doc) && !$eql(doc,@"")) {
                        MessageFrame *messageFrame = [[MessageFrame alloc] init];
                        Message *message = [[Message alloc] init];
                        message.time = [[dict[@"time"] fmToDate] fmStandStringDateOnly];
                        message.content = dict[@"doContent"];
                        message.type = MessageTypeOther;
                        messageFrame.showTime = ![previousTime isEqualToString:message.time];
                        
                        messageFrame.message = message;
                        
                        previousTime = message.time;
                        
                        [wself._allMessagesFrame addObject:messageFrame];
                    }

                }
                                
                [wself.tableView reloadData];
                [wself.tableView setContentOffset:CGPointMake(0, wself.tableView.contentSize.height - wself.tableView.frame.size.height)];
                [refreshView endRefreshing];
                LOG(@"fetch data refresh table n:%d newtasks:%d",wself.feeds.count,cachs.count);
                
            }
        } paging:[Paging paging:10 parameters:@{@"autoId":[wself lastId]}]];
        
    };
    self._footer = footer;
    
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
//    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
//        [wself.feeds removeAllObjects];
//        wself._footer.beginRefreshingBlock(refreshView);
//    };
    header.beginRefreshingBlock = wself._footer.beginRefreshingBlock;
    self._header = header;
    
    
    [header beginRefreshing];
    
    [AppDelegate getInstance].loadingState.userData.msgs = @[];
}
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.tableView setContentOffset:CGPointMake(0, self.table.contentSize.height - self.table.frame.size.height)];
//}

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
    return self._allMessagesFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FeedbackCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // 设置数据
    cell.messageFrame = self._allMessagesFrame[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self._allMessagesFrame[indexPath.row] cellHeight];
}

- (void)dealloc{
    [self.tableView removeObserver:self._header forKeyPath:MJRefreshContentOffset];
    [self.tableView removeObserver:self._footer forKeyPath:MJRefreshContentOffset];
    //    [self.tableView removeObserver:self._header forKeyPath:MJRefreshContentSize];
    [self.tableView removeObserver:self._footer forKeyPath:MJRefreshContentSize];
}


@end
