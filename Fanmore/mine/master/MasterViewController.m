//
//  MasterViewController.m
//  Fanmore
//
//  Created by Cai Jiang on 7/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "MasterViewController.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "MJRefresh.h"
#import "Paging.h"
#import "ContributionCell.h"
#import "FollowerListController.h"
#import "BlocksKit+UIKit.h"

/**
 *  大小必须大于81
 *  包括师傅头像 邀请码label以及邀请码
 */
@interface TouxiangView : UIView

@property(weak) UIButton* buttonCopy;

@property(weak) UILabel* labelCode;
/**
 *  设置邀请码
 *
 *  @param str <#str description#>
 */
-(void)setLabelCodeText:(NSString*)str;

@end

/**
 *  上面一个标题 
 *  下面一行积分
 */
@interface LabelAndScore : UIView

@property(weak) UILabel* labelScore;
-(id)initWithTitle:(NSString*)title index:(int)index;
-(void)setScore:(NSNumber*)score;

@end

/**
 *  除了模拟导航栏以外以及table表体以外所有的数据
 */
@interface HeaderView : UIView

/**
 *  设置收徒描述
 *
 *  @param text <#text description#>
 */
-(void)setLabelDescText:(NSString*)text;

@property(weak) TouxiangView* touxiangView;
@property(weak) LabelAndScore* leftScore;
@property(weak) LabelAndScore* rightScore;
@property(weak) UILabel* labelDesc;
@property(weak) UIImageView* imageHelp;
@property(weak) UIButton* buttonShare;

@end

@implementation TouxiangView

-(void)centerAt:(CGFloat)y ui:(UIView*)ui size:(CGSize)size{
    CGFloat x = (self.frame.size.width - size.width)/2.0f;
    [ui setFrame:CGRectMake(x, y, size.width, size.height)];
}


-(void)setLabelCodeText:(NSString*)str{
    CGSize size = [str sizeWithFont:self.labelCode.font];
    [self centerAt:self.labelCode.frame.origin.y ui:self.labelCode size:size];
    [self.labelCode setText:str];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView* view = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@"bigtouxiang"];
        [self centerAt:0 ui:view size:CGSizeMake(81, 81)];
        [self addSubview:view];
        
        // y + 45
        UILabel* label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        NSString* str = @"邀请码";
        CGSize size = [str sizeWithFont:label.font];
        [label setText:str];
        [self centerAt:82 ui:label size:size];
        [self addSubview:label];
        
        
        
        label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        [self centerAt:82+size.height ui:label size:size];
        [self addSubview:label];
        self.labelCode = label;
        [self setLabelCodeText:@""];
        
        UIButton* button  = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"fuzi"] forState:UIControlStateNormal];
        [self centerAt:self.labelCode.frame.origin.y+size.height ui:button size:CGSizeMake(60, 35)];
        [self addSubview:button];
        self.buttonCopy = button;
//        view = [[UIImageView alloc] init];
//        view.image = [UIImage imageNamed:@"fuzi"];
//        [self centerAt:self.labelCode.frame.origin.y+size.height ui:view size:CGSizeMake(60, 35)];
//        [self addSubview:view];

    }
    return self;
}

@end

@implementation LabelAndScore

-(void)setScore:(NSNumber*)score{
    [self.labelScore setText:$str(@"%@积分",score)];
}

-(id)initWithTitle:(NSString *)title index:(int)index{
    //gap 设置为5
    //总数 为2
    self = [super initWithFrame:CGRectMake(    320.0f/2.0f*index+5.0f, 0, 320.0f/2.0f-5.0f, 86.0f)];
    if (self) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 160, 26)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label setText:title];
        [self addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 36, 160, 26)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:19];
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label setText:title];
        [self addSubview:label];
        self.labelScore = label;
    }
    return self;
}


@end

@implementation HeaderView

-(void)setLabelDescText:(NSString*)text{
    //from 13
    CGFloat fontSize = 13.0f;
    while (true) {
        CGSize size= [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.labelDesc.frame.size.width, MAXFLOAT) lineBreakMode:self.labelDesc.lineBreakMode];
//        CGSize size= [text sizeWithFont:[UIFont systemFontOfSize:fontSize] forWidth:self.labelDesc.frame.size.width lineBreakMode:self.labelDesc.lineBreakMode];
        if (size.height<self.labelDesc.frame.size.height) {
            break;
        }
        if (fontSize==0) {
            [self.labelDesc setText:text];
            return;
        }
        fontSize -= 1;
    }
    
    [self.labelDesc setFont:[UIFont systemFontOfSize:fontSize]];
    [self.labelDesc setText:text];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, 320, 213)];
//        view.image = [UIImage imageNamed:@"shoutubg"];
        UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
        view.image = [UIImage imageNamed:@"shoutubgs"];
        [self addSubview:view];
        
        
        CGFloat shifux = 120.0f;
        CGFloat shifuy = 69.0f-64.0f;
        
        TouxiangView* tview = [[TouxiangView alloc] initWithFrame:CGRectMake(shifux-10, shifuy, 81, 140)];
        [self addSubview:tview];
        self.touxiangView = tview;
        
        //    view = [[UIImageView alloc] initWithFrame:CGRectMake(shifux, shifuy, 81, 81)];
        //    view.image = [UIImage imageNamed:@"bigtouxiang"];
        //    [self.view addSubview:view];
        
        // +85
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(shifux+85.0f, shifuy+19.0f, 50, 50)];
        [button setImage:[UIImage imageNamed:@"fenxiang2"] forState:UIControlStateNormal];
        [self addSubview:button];
        self.buttonShare = button;
//        view = [[UIImageView alloc] initWithFrame:CGRectMake(shifux+85.0f, shifuy+19.0f, 50, 50)];
//        view.image = [UIImage imageNamed:@"fenxiang2"];
//        [self addSubview:view];
        
        CGFloat hide  = 14.0f;
        view = [[UIImageView alloc] initWithFrame:CGRectMake(-1*hide, shifuy+53.0f, 126, 90)];
        view.image = [UIImage imageNamed:@"leftkt"];
        [self addSubview:view];
        
        view = [[UIImageView alloc] initWithFrame:CGRectMake(320.0f-117.0f, shifuy+53.0f, 117, 89)];
        view.image = [UIImage imageNamed:@"rightkt"];
        [self addSubview:view];
        
        view = [[UIImageView alloc] initWithFrame:CGRectMake(5, shifuy+160.0f, 310.0f, 43)];
        view.image = [UIImage imageNamed:@"mastertextnode"];
        [self addSubview:view];
        
        //node
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, shifuy+163.0f, 290.0f, 43-3*2)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:10];
//        label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mastertextnode"]];
        label.numberOfLines = 5;
        [label setText:@"将此邀请码给你的好友们，他们注册为粉猫用户时填入该邀请码，即成为你的徒弟，他们会每次贡献10%的收益给你哦!！"];
        [self addSubview:label];
        self.labelDesc = label;
        
        view = [[UIImageView alloc] initWithFrame:CGRectMake(300, shifuy+163.0f+24, 14, 14)];
        view.image = [UIImage imageNamed:@"newhelp"];
        [self addSubview:view];
        self.imageHelp = view;
        
        LabelAndScore* las = [[LabelAndScore alloc] initWithTitle:@"徒弟总贡献" index:0];
        [las offset:0 y:shifuy+200.0f];
        [las setScore:@500];
        [self addSubview:las];
        self.leftScore = las;
        
        las = [[LabelAndScore alloc] initWithTitle:@"昨日总贡献" index:1];
        [las offset:0 y:shifuy+200.0f];
        [las setScore:@5000];
        [self addSubview:las];
        self.rightScore = las;
        // 205+86  = 291
        
        view = [[UIImageView alloc] initWithFrame:CGRectMake(163, shifuy+215.0f, 1, 45.0f)];
        view.image = [UIImage imageNamed:@"shuxian"];
        [self addSubview:view];
    }
    return self;
}

@end


@interface MasterViewController ()<UITableViewDataSource>


@property NSMutableArray* followers;
@property(weak) UITableView* tableView;
@property(weak) MJRefreshHeaderView *_header;//srollview owner it
@property(weak) MJRefreshFooterView *_footer;//srollview owner it
@property(weak) HeaderView* hview;

@property(weak) UIButton* buttonTudi;

@property NSString* shareDesc;
@property NSString* shareURL;

@end

@implementation MasterViewController

+(instancetype)pushMaster:(UIViewController*)controller{
    MasterViewController* mc = [[self alloc] init];
    [controller.navigationController pushViewController:mc animated:YES];
    return mc;
}

-(NSNumber*)pageTag{
    if (self.followers==nil || self.followers.count==0) {
        return @0;
    }
    NSDictionary* task=[self.followers $last];
    //            return @0;
    return [task getFlowId];
}

-(void)clickFollowers{
    [FollowerListController pushFollowers:self];
}

-(void)clickCopy{
    UIPasteboard* paster = [UIPasteboard generalPasteboard];
    [paster setString:self.hview.touxiangView.labelCode.text];
    [FMUtils alertMessage:self.view msg:@"复制完成！"];
}

-(void)clickShare{
//    NSLog(@"已配数:%d",[ShareSDK connectedPlatformTypes].count);
    if ([ShareSDK connectedPlatformTypes].count==0) {
        [AppDelegate connectAllShareManly];
    }
    
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:self.shareDesc
                                       defaultContent:self.shareDesc
                                                image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"logo"]]
                                                title:@"万事利分红"
                                                  url:self.shareURL
                                          description:self.shareDesc
                                            mediaType:SSPublishContentMediaTypeNews];
    
//    __weak MasterViewController* wself = self;
    
    SSPublishContentEventHandler _handler =^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state==SSResponseStateBegan) {
            return;
        }
        if (!end) {
            return;
        }
//        [FMUtils alertMessage:wself.view msg:@"已转发"];
    };
    
    NSMutableArray* types  = $marrnew;
    __block id<ISSContent> bcontent = publishContent;
    
    for (NSNumber* typeid in [ShareSDK connectedPlatformTypes]) {
        ShareType type =(ShareType)[typeid intValue];
        [types addObject:[ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:type] icon:[ShareTool getClientImage:(TShareType)type enable:YES] clickHandler:^(){
//            
//            if ($safe(delegate) && [delegate respondsToSelector:@selector(shouldShare:)]) {
//                if (![delegate shouldShare:type]) {
//                    return;
//                }
//            }
            
            
//            if (_sending) {
//                [FMUtils alertMessage:wcontroller.view msg:@"正在转发中……"];
//                return;
//            }
            
//            _sending = YES;
//            _block = [ShareTool bk_performBlock:^{
//                _sending = NO;
//            } afterDelay:60];
            
            //短信和邮件没有包含URL
            LOG(@"url:%@",[bcontent url]);
            if (type==ShareTypeSMS || type==ShareTypeMail || type==ShareTypeSinaWeibo) {
                [bcontent setContent:$str(@"%@\n%@",[bcontent content],[bcontent url])];
            }
            
            id<ISSAuthOptions> _auth = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:nil];
            [_auth setPowerByHidden:YES];
            
            [ShareSDK shareContent:bcontent type:type authOptions:_auth statusBarTips:YES result:_handler];
        }]];
    }

    [ShareSDK showShareActionSheet:[ShareSDK container] shareList:types content:nil statusBarTips:YES authOptions:nil shareOptions:nil result:NULL];
    
//    [ShareSDK showShareActionSheet:nil
//                         shareList:nil
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions: nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    NSLog(@"分享成功");
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
//                                }
//                            }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadGestureRecognizer];
    
    self.view.backgroundColor = fmMainColor;
    
//    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)]];
//    
//    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tudi"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)]];
    
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //291
//    [self.view addSubview:[[HeaderView alloc] initWithFrame:CGRectMake(0, 64, 320.0f, 300.0f)]];
    HeaderView* headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 276.0f)];
//    headerView.backgroundColor = [UIColor redColor];
    
    UITableView* table = [[UITableView alloc] initWithFrame:CGRectMake(0, 43, 320, [[UIScreen mainScreen] bounds].size.height-43.0f)];
    
    table.tableHeaderView = headerView;
    self.hview = headerView;
    
    [self.view addSubview:table];
    self.tableView = table;
    
    UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    view.backgroundColor = fmMainColor;
    [self.view addSubview:view];
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(16, 25, 35, 35)];
    [button setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    button = [[UIButton alloc] initWithFrame:CGRectMake(279, 25, 35, 35)];
    [button setImage:[UIImage imageNamed:@"tudi"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickFollowers) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.buttonTudi = button;
    
    [headerView.touxiangView.buttonCopy addTarget:self action:@selector(clickCopy) forControlEvents:UIControlEventTouchUpInside];
    [headerView.buttonShare addTarget:self action:@selector(clickShare) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    __weak MasterViewController* wself = self;
    
    void(^helpHandler)() = ^() {
        [FMUtils toRuleController:wself attach:@"#shoutumimi"];
    };
    
    headerView.imageHelp.userInteractionEnabled = YES;
    [headerView.imageHelp bk_whenTapped:helpHandler];
    headerView.labelDesc.userInteractionEnabled = YES;
    [headerView.labelDesc bk_whenTapped:helpHandler];
    
    // for table & data
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[ContributionCell class] forCellReuseIdentifier:@"ContributionCell"];
    self.tableView.rowHeight = 66.0f;
    self.tableView.dataSource = self;
    
    if (self.followers==Nil) {
        self.followers = $new(NSMutableArray);
    }else{
        [self.followers removeAllObjects];
    }
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
        [fos masterIndex:nil block:^(NSString *code, NSString *desc, NSString *shareDesc, NSString *shareURL, NSNumber *numbersOfFollowers, NSNumber *totalDevoteYes, NSNumber *totalDevote, NSNumber *todaySafe,NSNumber *lisiSafe,NSNumber *todayShare,NSNumber *lisiShare,NSArray *list, NSError *error) {
            if ($safe(error)) {
                [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                [refreshView endRefreshing];
                return;
            }
            if ($eql([wself pageTag],@0)) {
                [wself.hview.touxiangView setLabelCodeText:code];
                [wself.hview setLabelDescText:desc];
                // 分享
                [wself.hview.leftScore setScore:totalDevote];
                [wself.hview.rightScore setScore:totalDevoteYes];
                
                wself.shareDesc = shareDesc;
                wself.shareURL = shareURL;
                
                int oldnof = $safe([[AppDelegate getInstance] getNumberOfFollowers])?[[[AppDelegate getInstance] getNumberOfFollowers] intValue]:0;
                if ([numbersOfFollowers intValue]-oldnof>0) {
                    [wself.buttonTudi badgeValue:$str(@"%d",[numbersOfFollowers intValue]-oldnof) x:23 y:-1];
                }
            }
            
            if ($safe(list)) {
                HashAddArray(wself.followers,list)
                [wself.tableView reloadData];
            }
            [refreshView endRefreshing];

        } paging:[Paging paging:5 parameters:@{@"pageTag": [wself pageTag]}]];
    };
    self._footer = footer;
    
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [wself.followers removeAllObjects];
        wself._footer.beginRefreshingBlock(refreshView);
    };
    
    self._header = header;
    
    [header beginRefreshing];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.followers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContributionCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ContributionCell" forIndexPath:indexPath];
    @try {
        [cell config:self.followers[indexPath.row]];
    }
    @catch (NSException *exception) {
        LOG(@"错误 %@",exception);
    }
    @finally {
    }
    return cell;
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

- (void)dealloc{
    [self.tableView removeObserver:self._header forKeyPath:MJRefreshContentOffset];
    [self.tableView removeObserver:self._footer forKeyPath:MJRefreshContentOffset];
    //    [self.tableView removeObserver:self._header forKeyPath:MJRefreshContentSize];
    [self.tableView removeObserver:self._footer forKeyPath:MJRefreshContentSize];
}

@end
