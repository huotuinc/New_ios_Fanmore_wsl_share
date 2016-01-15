//
//  TaskListController.m
//  Fanmore
//
//  Created by Cai Jiang on 1/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "TaskListController.h"
#import "AppDelegate.h"
#import "TaskListCell.h"
//#import "TaskDetailPagesController.h"
#import "TaskDetailController.h"
#import "UIView+SSToolkitAdditions.h"
#import "MineMenuController.h"
#import "FMUtils.h"
#import "MJRefresh.h"
#import "BlocksKit+UIKit.h"
#import "MLPPopupMenu.h"
#import "LayoutContext.h"
#import "ToSendTaskController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PayModel.h"
#import "MJExtension.h"
#import "UITableView+SetNoDateBackImage.h"

@interface PopupMenuManager : NSObject<UITableViewDataSource,UITableViewDelegate>
@property uint type;
@property(weak) TaskListController* controller;
@end

@interface TaskListController ()

@property BOOL shaking;
@property(strong) NSMutableArray* tasks;
@property int selection;
@property(weak) MJRefreshHeaderView *_header;//srollview owner it
@property(weak) MJRefreshFooterView *_footer;//srollview owner it
@property MLPPopupMenu* popupMenu;
@property PopupMenuManager* pmm;

@property BOOL doCash;
@property BOOL doCash2;
#ifdef FanmoreDebug
@property BOOL debugCashPswdDoing;
#endif

@end

@implementation TaskListController

-(NSNumber*)lastTaskId{
    if (self.tasks==nil || self.tasks.count==0) {
        return @0;
    }
    Task* task=[self.tasks $last];
//            return @0;
    return task.taskId;
}

-(void)doBack{
    if (self.popupMenu.isPopped) {
        [self.popupMenu hidenme];
        [self.popupMenu hide];
        return;
    }
    [super doBack];
}

-(void)clickCenterMenu{
    if (self.popupMenu.isPopped) {
        [self.popupMenu hide];
        return;
    }
    if(self.selection!=1)
        return;
    // ↓
    [self.popupMenu showme];
//    self.popupMenu.layer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dis_bg.9"]].CGColor;
    self.popupMenu.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    self.popupMenu.layer.borderWidth=0.3;
    [self.popupMenu popInView:self.nTitleView andPadding:170];
}


/**
 *  屏幕拖拽方法
 *
 *  @param gestureRecognizer <#gestureRecognizer description#>
 */
-(void)handleGesture:(UIGestureRecognizer*)gestureRecognizer{
    UISwipeGestureRecognizer* ssender = (UISwipeGestureRecognizer*)gestureRecognizer;
    if (ssender.direction==UISwipeGestureRecognizerDirectionLeft){
        if (self.selection==1) {
            [self changeSelection:2];
        }
    }
    if (ssender.direction==UISwipeGestureRecognizerDirectionRight){
        if (self.selection==1) {
            [self clickMenu:ssender];
        }else{
            [self changeSelection:1];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.upperView setBackgroundColor:fmMainColor];
    
    self.title = @"分红";
    [self.titleLabel setText:self.title];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    if (self.tasks==Nil) {
        self.tasks = $new(NSMutableArray);
    }else{
        [self.tasks removeAllObjects];
    }
    
    __weak TaskListController* wself = self;
    
    for (int i = 0; i < 2; i++) {
        UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        swipeRecognizer.direction = (i == 0 ? UISwipeGestureRecognizerDirectionRight : UISwipeGestureRecognizerDirectionLeft);
        [self.view addGestureRecognizer:swipeRecognizer];
    }
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [wself.tasks removeAllObjects];
        wself._footer.beginRefreshingBlock(refreshView);
    };
    self._header = header;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        LOG(@"show mine controller:%@",[AppDelegate getInstance].mineNav);
        id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
        if (wself.selection==1) {
            [fos listTask:Nil block:^(NSArray *task, NSError *error) {
                if ($safe(error)) {
                    [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                    [refreshView endRefreshing];
                    return;
                }
                if ($safe(task)) {
                    HashAddArray(wself.tasks, task)
                    [wself.tableView reloadData];
                    [refreshView endRefreshing];
                    LOG(@"fetch data refresh table n:%d newtasks:%d",wself.tasks.count,task.count);
                }
            } screenType:wself.pmm.type paging:[Paging paging:10 parameters:@{@"oldTaskId":[wself lastTaskId]}]];
        }else if (wself.selection==2){
            [fos listFlashMallTask:nil block:^(NSArray *task, NSError *error) {
                if ($safe(error)) {
                    [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                    [refreshView endRefreshing];
                    return;
                }
                if ($safe(task)) {
                    HashAddArray(wself.tasks, task)
                    [wself.tableView reloadData];
                    [refreshView endRefreshing];
                    LOG(@"fetch data refresh table n:%d newtasks:%d",wself.tasks.count,task.count);
                }
            } paging:[Paging paging:10 parameters:@{@"oldTaskId":[wself lastTaskId]}]];
        }
        
    };
    self._footer = footer;
    
    
    
    self.titleLabel.userInteractionEnabled = YES;
    self.pmm = $new(PopupMenuManager);
    self.pmm.controller = self;
    self.popupMenu = [[MLPPopupMenu alloc]initWithDataSource:self.pmm andDelegate:self.pmm];
    self.popupMenu.direction = MLPopupMenuDown;
    [self.titleLabel bk_whenTapped:^{
        [wself clickCenterMenu];
    }];
    
    // border radius
    [self.popupMenu.layer setCornerRadius:2.0f];
    
    // border
//    [self.popupMenu.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [self.popupMenu.layer setBorderWidth:1.5f];
    
    
    // drop shadow
    [self.popupMenu.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.popupMenu.layer setShadowOpacity:0.8];
    [self.popupMenu.layer setShadowRadius:4.0];
    [self.popupMenu.layer setShadowOffset:CGSizeMake(3.0, 3.0)];
    
//    self.tableView.tableHeaderView = ({
//        UIView* theader = $new(UIView);
//        theader.frame = CGRectMake(0, 0, 320, 19);
//        CGFloat fsize= 12;
//        UIColor* fcolor = [UIColor grayColor];
//        LayoutContext* lc = [LayoutContext contextByView:theader];
//        LoadingState* ls = [AppDelegate getInstance].loadingState;
//        NSNumberFormatter* formatter = $new(NSNumberFormatter);
//        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//        [formatter setMaximumFractionDigits:1];
//        [formatter setCurrencySymbol:@"￥"];
//        [formatter setNegativePrefix:@"-"];
//        [formatter setNegativeSuffix:@""];
//        
//        UILabel* label = [UILabel autoView:@"zf" context:lc];
//        label.font = [UIFont systemFontOfSize:fsize];
//        label.textColor = fcolor;
//        label.text = @"转发";
//        label = [UILabel autoView:@"zfi" context:lc];
//        label.font = [UIFont systemFontOfSize:fsize];
//        label.textColor = fcolor;
//        label.text = [formatter stringFromNumber:$float([ls.taskTurnScore floatValue]/10.0f)];
//        
//        label = [UILabel autoView:@"lh" context:lc];
//        label.font = [UIFont systemFontOfSize:fsize];
//        label.textColor = fcolor;
//        label.text = @"好友浏览";
//        label = [UILabel autoView:@"lhi" context:lc];
//        label.font = [UIFont systemFontOfSize:fsize];
//        label.textColor = fcolor;
//        label.text = $str(@"%@/次",[formatter stringFromNumber:$float([ls.taskBrowseScore floatValue]/10.0f)]);
//        
//        [lc addMetirc:@"top" number:@5];
//        [lc addMetirc:@"merge" number:@50];
//        [lc addMetirc:@"labelHeight" number:@11];
//        [lc visualFormat:@"|-merge-[zf]-5-[zfi]-merge@1-[lh]-5-[lhi]-merge-|" options:0];
//        
//        [lc visualFormat:@"V:|-top-[zf(labelHeight)]" options:0];
//        
//        [lc equalsCenterY:@"zf" view2:@"zfi"];
//        [lc equalsCenterY:@"zfi" view2:@"lh"];
//        [lc equalsCenterY:@"lh" view2:@"lhi"];
//        
//        [lc commit];
//        
//        UIView* header2 = $new(UIView);
//        [header2 addSubview:theader];
//        [header2 setBounds:CGRectMake(0, 0, 320, 19)];
//        header2;
//    });
    
    [__header beginRefreshing];
    
    [self.nselectionLabel1 setUserInteractionEnabled:YES];
    [self.nselectionLabel2 setUserInteractionEnabled:YES];
    [self.nselectionImage1 setUserInteractionEnabled:YES];
    [self.nselectionImage2 setUserInteractionEnabled:YES];
    
    [self.nselectionLabel1 bk_whenTapped:^{
        if(wself.selection==1){
            [wself clickCenterMenu];
            return;
        }
        [wself changeSelection:1];
        //如果当前选择是1  则呼出菜单！
    }];
    [self.nselectionImage1 bk_whenTapped:^{
        if(wself.selection==1){
            [wself clickCenterMenu];
            return;
        }
        [wself changeSelection:1];
    }];
    [self.nselectionLabel2 bk_whenTapped:^{
        [wself changeSelection:2];
    }];
    [self.nselectionImage2 bk_whenTapped:^{
        [wself changeSelection:2];
    }];
    
    
    
    [self.selectLabel1 setUserInteractionEnabled:YES];
    [self.selectLabel2 setUserInteractionEnabled:YES];
    [self.selectImage1 setUserInteractionEnabled:YES];
    [self.selectImage2 setUserInteractionEnabled:YES];
    
    [self.selectLabel1 bk_whenTapped:^{
        [wself changeSelection:1];
    }];
    [self.selectImage1 bk_whenTapped:^{
        [wself changeSelection:1];
    }];
    [self.selectLabel2 bk_whenTapped:^{
        [wself changeSelection:2];
    }];
    [self.selectImage2 bk_whenTapped:^{
        [wself changeSelection:2];
    }];
    
    
    [self.castOver addGestureRecognizer:[UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        if (location.x<160) {
            [wself changeSelection:1];
        }else
            [wself changeSelection:2];
    }]];
    
    if ([UIScreen mainScreen].bounds.size.height!=568.0f){
#warning luohaibo 2015/12/2
//        [self showGuide:@"guidelist35" on:nil];
    }else
#warning luohaibo 2015/12/2
//        [self showGuide:@"guidelist" on:nil];
    
    [self changeSelection:1];
    
    //luohaibo 获取支付参数
    [[[AppDelegate getInstance] getFanOperations] TOGetPayParames:nil block:^(id result, NSError *error) {
        if (!error) {
            NSArray * payType = [PayModel objectArrayWithKeyValuesArray:result];
            NSMutableData *data = [[NSMutableData alloc] init];
            //创建归档辅助类
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            //编码
            [archiver encodeObject:payType forKey:PayTypeflat];
            //结束编码
            [archiver finishEncoding];
            NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:PayTypeflat];
            //写入
            [data writeToFile:filename atomically:YES];
        }

    }];
    
}

-(void)changeSelection:(uint)type{
    if (self.selection==type) {
        return;
    }
    self.selection = type;
    
    [self.selectImage1 hidenme];
    [self.selectImage2 hidenme];
    [self.selectLabel1 setTextColor:[UIColor whiteColor]];
    [self.selectLabel2 setTextColor:[UIColor whiteColor]];
    
    [self.nselectionImage1 hidenme];
    [self.nselectionImage2 hidenme];
    [self.nselectionLabel1 setTextColor:[UIColor whiteColor]];
    [self.nselectionLabel2 setTextColor:[UIColor whiteColor]];
    
    switch (self.selection) {
        case 1:
            [self.nselectionImage1 showme];
            [self.nselectionLabel1 setTextColor:fmMainColor];
            
            [self.selectImage1 showme];
            [self.selectLabel1 setTextColor:fmMainColor];
            self.title = @"分红";
            [self.titleLabel setText:self.title];
            break;
        case 2:
            //取消 栏目选择
            [self.popupMenu selectRowAtIndexPath:nil animated:NO scrollPosition:UITableViewScrollPositionNone];
            if ([self.popupMenu isPopped]) {
                [self.popupMenu hide];
            }
            self.pmm.type = 0;
            self.title = @"分红";
            [self.titleLabel setText:self.title];
            [self.selectImage2 showme];
            [self.selectLabel2 setTextColor:fmMainColor];
            
            [self.nselectionImage2 showme];
            [self.nselectionLabel2 setTextColor:fmMainColor];
            break;
        default:
            break;
    }
    
    [self._header beginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    
    @try {
        NSIndexPath* selected = self.tableView.indexPathForSelectedRow;
        if ($safe(selected)) {
            TaskListCell *cell = (TaskListCell*)[self.tableView cellForRowAtIndexPath:selected];
            Task* task = [FMUtils dataBy:self.tasks section:selected.section andRow:selected.row];
            if ($safe(cell) && $safe(task)) {
                [cell configureTask:task];
            }
            
            // 应小郭要求 剩余积分为0时 刷新任务列表
            if ([[task lastScore] floatValue]==0) {
                [self._header beginRefreshing];
            }
        }
    }
    @catch (NSException *exception) {
//        [self.tasks removeAllObjects];
//        [self.tableView reloadData];
    }
    @finally {
    }
    
    [self.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
        
    if (self.doCash && self.doCash2) {
        [self bk_performBlock:^(id obj) {
            [obj clickCash:nil];
        } afterDelay:0.5f];
    }
    
    self.doCash = NO;
    self.doCash2 = NO;
    [self showNoshadowNavigationBar];
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

//#pragma mark  delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    LOG(@"%d",indexPath.row);
//}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        Task* task = [FMUtils dataBy:self.tasks section:indexPath.section andRow:indexPath.row];
//        if ([task isUnitedTask]) {
//            return 193;
//        }
        CGFloat height;
        if ([task zeroReward]) {
            height = 163-30;
        }else
            height = 163;
        
        
        NSString* msg = [task getRebateMsg];
        if ($safe(msg) && msg.length>0) {
            LOG(@"TaskList %@ %@ %@",[task taskName],[task totalScore],[task lastScore]);
            if ([[task totalScore] floatValue]<=1 || [[task lastScore] floatValue]<=0) {
                return height;
            }else
                return height+30;
        }else
            return height;
    }
    @catch (NSException *exception) {
        LOG(@"Exception %@",exception);
        [self.tasks removeAllObjects];
        [self.tableView reloadData];
    }
    @finally {
    }
    return 163.0f;
}

#pragma mark yaoyao

- (void)shake{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    LoginState* data = [[[AppDelegate getInstance] loadingState] userData];
    __weak TaskListController* wself = self;
    if ([data.dayCheckIn intValue]==1) {
        [FMUtils alertMessage:self.view msg:@"您今日已签到"];
        return;
    }
    [[[AppDelegate getInstance] getFanOperations] checkIn:nil block:^(NSString *tip, NSError *error) {
        if ($safe(error)) {
            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            return;
        }
        //noop
    }];
}

//- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    //检测到摇动
//    self.shaking = YES;
//}
//
//- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    //摇动取消
//    self.shaking = NO;
//}
//
//
//- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    //摇动结束
//    if (event.subtype == UIEventSubtypeMotionShake) {
//        //something happens
//        if (self.shaking) {
//            self.shaking = NO;
//            //
//            LOG(@"shaking!!!");
//            [self shake];
//        }
//    }
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([FMUtils sectionsByTaskTime:self.tasks]) {
        [tableView setClearBackground];
    }else{
        tableView.backgroundColor = [UIColor whiteColor];
    }
    return [FMUtils sectionsByTaskTime:self.tasks];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [FMUtils rowsBy:self.tasks section:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TaskCell";
    TaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    @try {
        [cell configureTask:[FMUtils dataBy:self.tasks section:indexPath.section andRow:indexPath.row]];
    }
    @catch (NSException *exception) {
        LOG(@"Exception %@",exception);
        [self.tasks removeAllObjects];
        [self.tableView reloadData];
    }
    @finally {
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    @try {
        if (section==0) {
            return [[UIView alloc] initWithFrame:CGRectZero];
        }
        NSString* title = [[[FMUtils dataBy:self.tasks section:section andRow:0] publishTime] fmStandStringDateOnly];
        UIView* sview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
        sview.backgroundColor = fmTableBorderColor;
        UILabel* view = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 310, 16)];
        [view setBackgroundColor:[UIColor clearColor]];
        view.text = title;
        view.textAlignment = NSTextAlignmentRight;
        view.font = [UIFont systemFontOfSize:11];
        view.textColor = [UIColor lightGrayColor];
        
        [sview addSubview:view];
        return sview;
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    return nil;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Task* task ;
    @try {
        task = [FMUtils dataBy:self.tasks section:indexPath.section andRow:indexPath.row];
        if (!task) {
            return;
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
//    if ([task previewFirst]) {
        [self performSegueWithIdentifier:@"ToSendSegue" sender:task];
//    }else{
//        [self performSegueWithIdentifier:@"ToDetail" sender:task];
//    }
    
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (self.popupMenu.isPopped) {
        [self.popupMenu hide];
    }
    
    if ($eql(segue.identifier,@"ToSendSegue")) {
        Task* task = sender;
        if (task) {
            ToSendTaskController* tc = segue.destinationViewController;
            tc.task = task;
        }
    }
    
    if ($eql(segue.identifier,@"ToDetail")) {
        Task* task = sender;
        if (task) {
            TaskDetailController* tc = segue.destinationViewController;
            tc.task = task;
        }        
    }
}

- (IBAction)clickMenu:(id)sender {
    if (self.popupMenu.isPopped) {
        [self.popupMenu hidenme];
        [self.popupMenu hide];
    }
    UIStoryboard* mine = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
    UINavigationController* vc = [mine instantiateInitialViewController];
    MineMenuController* mmvc =(MineMenuController*)vc.topViewController;
    mmvc.taskListController = self;
    
    UIView* currentView = self.view;
    while (currentView.superview!=nil) {
        currentView = currentView.superview;
    }
    mmvc.mainImageImage =[currentView imageRepresentation];    
    [self presentViewController:[mmvc parentViewController] animated:NO completion:NULL];
}

-(void)beginOtherControllerForCash{
    self.doCash = YES;
    self.doCash2 = NO;
}

-(void)actionDone{
    if (self.doCash) {
        self.doCash2 = YES;
    }
}

-(void)iclickCash{
    if ([self.popupMenu isPopped]) {
        [self.popupMenu hide];
    }
    
    if (![[AppDelegate getInstance].loadingState useNewCash]) {
        if (![[AppDelegate getInstance].loadingState hasLogined]) {
            [FMUtils afterLogin:@selector(iclickCash) invoker:self];
            return;
        }
    }
    
    [StandCash pushStandCash:self];
}

- (IBAction)clickCash:(id)sender {
    [self iclickCash];
}

-(void)refreshStatus{
    self.navigationController.navigationBarHidden = NO;
    if ([self.popupMenu isPopped]) {
        [self.popupMenu hide];
    }
    
    [self._header beginRefreshing];
}

-(void)beforeDismissLoginFrame{
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)clickRefresh:(id)sender {
    if (self.popupMenu.isPopped) {
        [self.popupMenu hide];
    }
    
    if ($safe(sender)) {
        [self._header beginRefreshing];
    }else{
        self._header.beginRefreshingBlock(nil);
    }
    
}

- (void)dealloc{
    [self.tableView removeObserver:self._header forKeyPath:MJRefreshContentOffset];
    [self.tableView removeObserver:self._footer forKeyPath:MJRefreshContentOffset];
//    [self.tableView removeObserver:self._header forKeyPath:MJRefreshContentSize];
    [self.tableView removeObserver:self._footer forKeyPath:MJRefreshContentSize];
}

@end



@implementation PopupMenuManager
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [AppDelegate getInstance].loadingState.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CenterMenuItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [AppDelegate getInstance].loadingState.groups[indexPath.row][@"name"];
//    cell.textLabel.text = [NSString stringWithFormat:@"Item %i", indexPath.row];
//    switch (indexPath.row) {
//        case 0:
//            cell.textLabel.text = @"只显示有分";
////            cell.imageView.image = [UIImage imageNamed:@"zuixin"];
//            break;
////        case 1:
////            cell.textLabel.text = @"热门";
////            cell.imageView.image = [UIImage imageNamed:@"ermen"];
////            break;
////        case 2:
////            cell.textLabel.text = @"活动";
////            cell.imageView.image = [UIImage imageNamed:@"huodong"];
////            break;
//        case 1:
//            cell.textLabel.text = @"显示全部";
////            cell.imageView.image = [UIImage imageNamed:@"tuwen"];
//            break;
//        default:
//            break;
//    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MLPPopupMenu* popupMenu = (MLPPopupMenu*)tableView;
    if (popupMenu.isPopped) {
        [popupMenu hide];
    }
    
    self.type = [[AppDelegate getInstance].loadingState.groups[indexPath.row][@"type"] intValue];
    if (self.type==0) {
        self.controller.title = @"粉猫↓";
    }else{
        self.controller.title = [AppDelegate getInstance].loadingState.groups[indexPath.row][@"name"];
    }
    
//    switch (indexPath.row) {
//        case 0:
////            self.controller.title = @"推荐";
//            self.type = 5;
//            break;
//        case 1:
////            self.controller.title = @"热门";
//            self.type = 0;
//            break;
////        case 2:
////            self.controller.title = @"活动";
////            self.type = 2;
////            break;
////        case 3:
////            self.controller.title = @"粉猫";
////            self.type = 0;
////            break;
//        default:
//            break;
//    }
    self.controller.titleLabel.text = self.controller.title;
    [self.controller clickRefresh:tableView];
}
@end
