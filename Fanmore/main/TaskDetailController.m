//
//  TaskDetailController.m
//  Fanmore
//
//  Created by Cai Jiang on 1/18/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "TaskDetailController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "NSDate+Fanmore.h"
#import "SendRecordCell.h"
#import "FMUtils.h"
#import "BlocksKit+UIKit.h"
#import "Paging.h"
#import "WebController.h"
#import "ToSendTaskController.h"
#import "DisasterSendController.h"

@interface TaskDetailController ()<ShareToolDelegate>

@property(strong) NSMutableArray* records;
//@property UILabel* guizeLabel;
//@property UIImage* largeImage;
//@property(weak) UIView* left;
//@property(weak) UIView* right;
//@property CGPoint start;
//@property BOOL moving;
@property Task* task2;

@end

@implementation  TaskDetailController

-(void)updateSendButton:(UIButton *)button{
    
}

-(UIButton*)getButtonSend{
    return self.sendButton;
}
-(UIButton*)getButtonYiqiangwan{
    return self.btqiangwan;
}
-(UIButton*)getButtonYizhuanfa{
    return self.btyizhuanfa;
}

-(Task*)getTask{
    return self.task;
}
-(Task*)getTask2{
    return self.task2;
}

-(CGFloat)centerY:(UIView*)view height:(CGFloat)height{
    CGFloat line = view.frame.origin.y+view.frame.size.height/2.0f;
    return line-height/2;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view bringSubviewToFront:self.sendButton];
    [self.view bringSubviewToFront:self.btqiangwan];
    [self.view bringSubviewToFront:self.btyizhuanfa];
//    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    CGFloat y =CGRectGetHeight([UIScreen mainScreen].bounds)+scrollView.contentOffset.y-43.0f;
    y  -= [self topY];
//    if (version<7) {
//        y = y-64.0f;
//    }
    self.sendButton.frame = CGRectMake(10, y, 300, 38);
    self.btqiangwan.frame = CGRectMake(10, y, 300, 38);
    self.btyizhuanfa.frame = CGRectMake(10, y, 300, 38);
}

#pragma mark - view
- (void)initTableHeader{
    UIView* theader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    self.tableView.tableHeaderView = theader;
    
    UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(80, 0, 160, 160)];
    view.image = [UIImage imageNamed:@"imgloding-full"];
    [theader addSubview:view];
    self.largeImageView = view;
    
    view = [[UIImageView alloc] initWithFrame:CGRectMake(260, 5, 50, 50)];
    view.image = [UIImage imageNamed:@"question"];
    [theader addSubview:view];
    self.imageQuestion = view;
    
    view = [[UIImageView alloc] initWithFrame:CGRectMake(277, 68, 23, 23)];
    view.image = [UIImage imageNamed:@"jiantou_bigs"];
    [theader addSubview:view];
    self.sendIcon = view;
    
    TaskDetailView1* view1 = [[TaskDetailView1 alloc]initWithFrame:CGRectMake(10, 165, 300, 70)];
    [theader addSubview:view1];
    self.detail1 = view1;
    CGFloat offsetY = view1.frame.origin.y+view1.frame.size.height;
    
    TaskDetailAward* award = [[TaskDetailAward alloc] initWithFrame:CGRectMake(10, offsetY+10.0f, 300, 40)];
    [theader addSubview:award];
    self.viewAward = award;
    offsetY = award.frame.origin.y+award.frame.size.height;
    
    TaskDetailScore* score = [[TaskDetailScore alloc] initWithFrame:CGRectMake(10, offsetY, 300, 40)];
    [theader addSubview:score];
    self.viewScore = score;
    offsetY = score.frame.origin.y+score.frame.size.height;
    
    UIImageView* timeview = [[UIImageView alloc] initWithFrame:CGRectMake(10, offsetY+13, 12, 12)];
    timeview.image = [UIImage imageNamed:@"time"];
    [theader addSubview:timeview];
    CGFloat offsetX = timeview.frame.origin.x+timeview.frame.size.width+3.0f;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY+4.0f, 157, 15)];
    [theader addSubview:label];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor lightGrayColor];
    self.labelStartTime = label;
    offsetY = label.frame.origin.y+label.frame.size.height;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY, 157, 15)];
    [theader addSubview:label];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor lightGrayColor];
    self.labelEndTime = label;
//    offsetY = label.frame.origin.y+label.frame.size.height;
    
    view = [[UIImageView alloc] initWithFrame:CGRectMake(200, [self centerY:timeview height:10], 11, 10)];
    view.image = [UIImage imageNamed:@"zhuanfa"];
    [theader addSubview:view];
    self.imgSendPic = view;
    offsetX = view.frame.origin.x+view.frame.size.width;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(offsetX+4.0f, [self centerY:timeview height:30], 67, 30)];
    [theader addSubview:label];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor lightGrayColor];
    self.sendCount = label;
    
    offsetY = timeview.frame.origin.y+timeview.frame.size.height;
    
    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, offsetY+8.0f, 320, 19)];
    self.imageBolan = view;
    [theader addSubview:view];
    offsetY = view.frame.origin.y+view.frame.size.height;
    
    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, offsetY, 320, 45)];
    self.backgroundBottom = view;
    [theader addSubview:view];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 300, 40)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 3;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [theader addSubview:label];
    self.infoLabel = label;
    
    // 10 525 300 38
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"zhuanfabutton"] forState:UIControlStateNormal];
    self.sendButton = button;
    [self.tableView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"wuchangzhuanfa"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"wuchangzhuanfa"] forState:UIControlStateDisabled];
//    button.enabled = NO;
    self.btqiangwan = button;
    [self.tableView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"zhuanfabutton_down"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"zhuanfabutton_down"] forState:UIControlStateDisabled];
    button.enabled = NO;
    self.btyizhuanfa = button;
    [self.tableView addSubview:button];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self bindingTaskData];
    [self scrollViewDidScroll:self.tableView];
}

- (void)bindingTaskData{
    __weak TaskDetailController* wself = self;
    [self.task checkLargeImg:^(UIImage *image) {
        self.largeImageView.image = image;
    }];
//    self.largeImageView.image = self.task.largeImage;
    self.detail1.title.text = self.task.store.name;
    self.detail1.lastScore.text = [self.task.lastScore stringValue];
    self.detail1.allScore.text =[self.task.totalScore stringValue];
    
    [[AppDelegate getInstance]downloadImage:self.task.store.logo handler:^(UIImage *image, NSError *error) {
        if (!$safe(wself)) {
            return;
        }
        if ($safe(image)){
            wself.detail1.image.image = image;
        }
    } asyn:YES resource:[self.task.store logoCache]];
//    self.sendAward.text= [self.task.awardSend stringValue];
//    self.linkAward.text= [self.task.awardLink stringValue];
//    self.browseAward.text= [self.task.awardBrowse stringValue];
    
    
    
    self.viewScore.send.text= [self.task.myAwardSend stringValue];
    self.viewScore.link.text= [self.task.myAwardLink stringValue];
    self.viewScore.browse.text= [self.task.myAwardBrowse stringValue];
    
    
    self.viewAward.send.text = [self.task.awardSend stringValue];
    self.viewAward.browse.text = [self.task.awardBrowse stringValue];
    self.viewAward.link.text= [self.task.awardLink stringValue];
    
    self.sendCount.text = $str(@"%@人已转发",self.task.sendCount);
    CGSize size = [self.sendCount.text sizeWithFont:self.sendCount.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [self.sendCount setFrame:CGRectMake(315.0f-size.width, self.sendCount.frame.origin.y, size.width+5.0f, self.sendCount.frame.size.height)];
    [self.imgSendPic setFrame:CGRectMake(self.sendCount.frame.origin.x-17.0f, self.imgSendPic.frame.origin.y, self.imgSendPic.frame.size.width, self.imgSendPic.frame.size.height)];
    
    
    self.labelStartTime.text = $str(@"开始时间：%@",[self.task.startTime fmStandString]);
    self.labelEndTime.text = $str(@"结束时间：%@",[self.task.endTime fmStandString]);
    
//    self.guizeLabel.text=self.task.ruleDes;
    self.infoLabel.text = $str(@"任务详情：\n%@",self.task.taskName);
    
    [FMUtils favIconToogle:self.detail1.shoucangImage fav:[self.task.store.fav boolValue]];
    
//    self.sendButton.bounds = [FMUtils lockAtScreen:(UISwipeGestureRecognizerDirectionDown) rect:self.sendButton.bounds offset:5];
//    [self.sendButton.]
    
//    [FMUtils sendButtonsToggle:self.sendButton qiangwan:self.btqiangwan yizhuanfa:self.btyizhuanfa task:self.task sent:[[AppDelegate getInstance] allShareTypeSent:self.task.sendList]];
    [FMUtils sendButtonsToggle:self task:self.task sent:[[AppDelegate getInstance] allShareTypeSent:self.task.sendList] hideAfterOnline:NO];
}

-(void)myinit{
    LOG(@"custom initlialization");
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if ($safe(self)){
        [self myinit];
    }
    return self;
}

- (id)init{
    self = [super init];
    if ($safe(self)){
        [self myinit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self myinit];
    }
    return self;
}

-(void)tosend{
    [self performSegueWithIdentifier:@"ToSendSegue" sender:self];
}

-(void)dosend2{
    [FMUtils sendTask:self];
}

-(void)doShoucang{
    if(![[AppDelegate getInstance].loadingState hasLogined]){
        return;
    }
    
    if (!$safe(self.task) || !$safe(self.task.store)) {
        return;
    }
    
    __weak TaskDetailController* wself = self;
    [[[AppDelegate getInstance]getFanOperations] operFavorite:Nil block:^(NSString *msg, NSError *error) {
        if (!$safe(wself)) {
            return;
        }
        if ($safe(error)) {
            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            return;
        }
        if ($safe(msg)) {
            [FMUtils favIconToogle:wself.detail1.shoucangImage fav:[self.task.store.fav boolValue]];
            
            [FMUtils alertMessage:wself.view msg:msg];
        }
    } store:self.task.store];
}

-(void)_taskEffect{
    
    if (self.records.count>0) {
        return;
    }
    
    MBProgressHUD* __block HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    //设置对话框文字
    HUD.labelText = @"请稍等";
    [HUD show:YES];
    
    
    __weak TaskDetailController* wself = self;
    [[[AppDelegate getInstance]getFanOperations]detailTask:Nil block:^(NSArray *rcds, NSError *error) {
        
        if (!$safe(wself)) {
            return;
        }
//        [wself.task checkLargeImg:^{
//            wself.largeImageView.image = wself.task.largeImage;
//        }];
        
        if ($safe(rcds)) {
            [wself.records removeAllObjects];
            [wself.records addObjectsFromArray:rcds];
            [wself bindingTaskData];
            [wself.tableView reloadData];
        }
        [HUD removeFromSuperview];
        HUD = nil;
        
        if ($safe(error)) {
            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
        }
    } task:self.task];
}

-(void)handleGesture:(UIGestureRecognizer*)gestureRecognizer{
    UISwipeGestureRecognizer* ssender = (UISwipeGestureRecognizer*)gestureRecognizer;
    if (ssender.direction==UISwipeGestureRecognizerDirectionLeft){
        [self tosend];
    }
    if (ssender.direction==UISwipeGestureRecognizerDirectionRight){
        [self doBack];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadFanmore];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self initTableHeader];
	// Do any additional setup after loading the view.
    LOG(@"task detail controler didload");
    
    UIImage* bolan = [UIImage imageNamed:@"task_detail_diver"];
//    self.infoLabel.backgroundColor =[UIColor colorWithPatternImage:bolan];
    self.imageBolan.backgroundColor = [UIColor colorWithPatternImage:bolan];
    [self.backgroundBottom setBackgroundColor:fmTableBorderColor];
    
    if (self.records==Nil) {
        self.records = $new(NSMutableArray);
    }else{
        [self.records removeAllObjects];
    }
    
    
//    [self bindingTaskData];
    
    __weak TaskDetailController* wself = self;
    void (^tosendBlock)() = ^() {
        if (!$safe(wself)) {
            return;
        }
        [wself tosend];
    };
    void (^shoucangBlock)() = ^(){
        if (!$safe(wself)) {
            return;
        }
        [wself doShoucang];
    };
    
    self.detail1.shoucangLabel.userInteractionEnabled=YES;
    [self.detail1.shoucangLabel bk_whenTapped:shoucangBlock];
    self.detail1.shoucangImage.userInteractionEnabled = YES;
    [self.detail1.shoucangImage bk_whenTapped:shoucangBlock];
    
    
    for (int i = 0; i < 2; i++) {
        UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        swipeRecognizer.direction = (i == 0 ? UISwipeGestureRecognizerDirectionRight : UISwipeGestureRecognizerDirectionLeft);
        [self.view addGestureRecognizer:swipeRecognizer];
    }
    
    
    
    
    self.largeImageView.userInteractionEnabled = YES;
    [self.largeImageView bk_whenTapped:tosendBlock];
    self.infoLabel.userInteractionEnabled = YES;
    [self.infoLabel bk_whenTapped:tosendBlock];
    self.sendIcon.userInteractionEnabled = YES;
    [self.sendIcon bk_whenTapped:tosendBlock];
    [self.sendButton bk_whenTapped:^{
        [wself dosend2];
    }];
    [self.btqiangwan bk_whenTapped:^{
        [wself dosend2];
    }];
    
    if ($safe(self.task)) {
        [self _taskEffect];
    }
    
    self.imageQuestion.userInteractionEnabled = YES;
    [self.imageQuestion bk_whenTapped:^{
        [wself performSegueWithIdentifier:@"ToRule" sender:wself.imageQuestion];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void) viewWillDisappear:(BOOL)animated {
//    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
//        // back button was pressed.  We know this is true because self is no longer
//        // in the navigation stack.
//    }
//    [super viewWillDisappear:animated];
//}
//
//-(void)viewDidDisappear:(BOOL)animated{
//    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
//        // back button was pressed.  We know this is true because self is no longer
//        // in the navigation stack.
//        [self removeFromParentViewController];
//        //        LOG(@"%@",self.childViewControllers[0]);
//        self.view = Nil;
//        self.records = nil;
//        self.task = nil;
//        self.coreTableView = nil;
//    }
//}

#pragma mark - Table view data source

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
    static NSString *SendRecordCellIdentifier = @"SendRecordCell";
    SendRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:SendRecordCellIdentifier forIndexPath:indexPath];
    @try {
        [cell configureSendRecord:[self.records $at:indexPath.row]];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return cell;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ($eql(segue.identifier,@"ToSendSegue")) {
        ToSendTaskController*  tc = segue.destinationViewController;
        tc.task = self.task;
    }
    if ($eql(segue.identifier,@"ToRule")) {
        [[segue destinationViewController]viewWeb:[AppDelegate getInstance].loadingState.ruleUrl];
    }
}

-(BOOL)shouldShare:(ShareType)type{
    
    Task* tosend = [self getTask];
    if (!$safe(tosend) && $safe([self getTask2])) {
        tosend = [self getTask2];
    }
    
#ifdef FanmoreMockDisaster
    tosend.disasterFlag = @1;
    tosend.disasterUrl = FanmoreMockDisaster;
#endif
    
    if ([[[AppDelegate getInstance] loadingState] isDisater] && type==ShareTypeWeixiTimeline){
        [DisasterSendController pushController:self task:tosend];
        return NO;
    }
    
    return YES;
}


@end


//70 26 26
@implementation TaskDetailView1

-(void)myinit{
    
    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(1, 2, 65, 65)];
    image.image = [UIImage imageNamed:@"imgloding-full"];
    [self addSubview:image];
    self.image = image;
    image = [[UIImageView alloc] initWithFrame:CGRectMake(1, 2, 65, 65)];
    image.image = [UIImage imageNamed:@"yuan_big"];
    [self addSubview:image];
    
    
    //89 0 207 21
    //-10 +21  226 2
    UILabel* titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(89, 0, 207, 21)];
    titlelabel.font = [UIFont systemFontOfSize:17];
    self.title = titlelabel;
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(66+78, self.title.frame.origin.y+2.0f, 1, 80)];
    image.image = [UIImage imageNamed:@"biaoge3左下"];
    [self addSubview:image];
    image = [[UIImageView alloc] initWithFrame:CGRectMake(66+78+78, self.title.frame.origin.y+2.0f, 1, 80)];
    image.image = [UIImage imageNamed:@"biaoge3左下"];
    [self addSubview:image];
    
    [self addSubview:titlelabel];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(self.title.frame.origin.x-10.0f, self.title.frame.origin.y+25.0f, 226, 2)];
    image.image = [UIImage imageNamed:@"cibg"];
    [self addSubview:image];
    //300-65 = 235 /3  = 78
    
    //66 66+78
    //
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(66, self.title.frame.origin.y+33.0f, 78, 21)];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.allScore = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(66+78, self.title.frame.origin.y+33.0f, 78, 21)];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.lastScore = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(66, self.title.frame.origin.y+54.0f, 78, 21)];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.text=@"总积分";
    [self addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(66+78, self.title.frame.origin.y+54.0f, 78, 21)];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.text=@"剩余积分";
    [self addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(66+78+78, self.title.frame.origin.y+54.0f, 78, 21)];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.text=@"我要收藏";
    [self addSubview:label];
    self.shoucangLabel = label;
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(66+78+78+30, self.title.frame.origin.y+34.0f, 20, 20)];
    [self addSubview:image];
    self.shoucangImage = image;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self myinit];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self myinit];
    return self;
}

@end

@implementation TaskDetailBaseScore

-(void)myinit:(uint)type{
    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    image.image = [UIImage imageNamed:@"biaoge3左上"];
    [self addSubview:image];
    image = [[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 100, 40)];
    image.image = [UIImage imageNamed:@"biaoge3左上"];
    [self addSubview:image];
    image = [[UIImageView alloc] initWithFrame:CGRectMake(200, 0, 100, 40)];
    image.image = [UIImage imageNamed:@"biaoge3右上"];
    [self addSubview:image];
    
    //label x +6    y+2  50 21
    //value x +48   y+5  45 18
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(17, 2, 55, 36)];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.text = type==0?@"转发奖励:":@"我的收益:";
    label.textColor = [UIColor lightGrayColor];
    [self addSubview:label];
    label = [[UILabel alloc] initWithFrame:CGRectMake(117, 2, 55, 36)];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.text = type==0?@"浏览奖励:":@"我的收益:";
    label.textColor = [UIColor lightGrayColor];
    [self addSubview:label];
    label = [[UILabel alloc] initWithFrame:CGRectMake(217, 2, 55, 36)];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.text = type==0?@"外链奖励:":@"我的收益:";
    label.textColor = [UIColor lightGrayColor];
    [self addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(70, 4, 45, 32)];
    label.font = [UIFont systemFontOfSize:15.0f];
    self.send = label;
    label.textColor = [UIColor redColor];
    [self addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(170, 4, 45, 32)];
    label.font = [UIFont systemFontOfSize:15.0f];
    self.browse = label;
    label.textColor = [UIColor redColor];
    [self addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(270, 4, 45, 32)];
    label.font = [UIFont systemFontOfSize:15.0f];
    self.link = label;
    label.textColor = [UIColor redColor];
    [self addSubview:label];
    
    if (type==1) {
        image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 300, 1)];
        image.image = [UIImage imageNamed:@"cibg"];
        [self addSubview:image];
    }

}

-(id)initWithFrame:(CGRect)frame andType:(uint)type{
    self = [super initWithFrame:frame];
    [self myinit:type];
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder andType:(uint)type{
    self = [super initWithCoder:aDecoder];
    [self myinit:type];
    return self;
}
@end

@implementation TaskDetailAward
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame andType:0];
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder andType:0];
    return self;
}
@end

@implementation TaskDetailScore
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame andType:1];
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder andType:1];
    return self;
}
@end