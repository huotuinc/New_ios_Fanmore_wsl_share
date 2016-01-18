//
//  MasterAndTudiViewController.m
//  Fanmore
//
//  Created by lhb on 15/12/10.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import "MasterAndTudiViewController.h"
#import <UIView+BlocksKit.h>
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "LoginState.h"
#import "FollowerListController.h"
#import "FollowListTableViewController.h"
#import "FMUtils.h"

@interface MasterAndTudiViewController ()

/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/**用户名*/
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
/**复制邀请码*/
- (IBAction)fuzhiCode:(id)sender;
/**徒弟总数*/
@property (weak, nonatomic) IBOutlet UILabel *tuDiCount;

/**徒弟列表*/
@property (weak, nonatomic) IBOutlet UIView *tuDuLieBiao;

/**徒弟总贡献*/
@property (weak, nonatomic) IBOutlet UILabel *firstLable;
/**昨日总贡献*/
@property (weak, nonatomic) IBOutlet UILabel *secondLable;
/**昨日历史浏览量*/
@property (weak, nonatomic) IBOutlet UILabel *thirdLable;
/**昨日历史转发量*/
@property (weak, nonatomic) IBOutlet UILabel *fourthLable;

- (IBAction)tuDILiebiaoClick:(id)sender;


- (IBAction)backClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *shareSdkSha;

- (IBAction)shareYaoqinMa:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *masterRuleDes;

@end

@implementation MasterAndTudiViewController



+(instancetype)pushMaster:(UIViewController*)controller{
    MasterAndTudiViewController * mc = [[self alloc] init];
    [controller.navigationController pushViewController:mc animated:YES];
    return mc;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.masterRuleDes.hidden = YES;
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    
//    self.navigationController.navigationBar.tintColor = fmMainColor;
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
//    self.navigationController.navigationBarHidden = NO;
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}



- (void) setup{
    
    __weak MasterAndTudiViewController * wself = self;
    /**用户个人信息*/
    LoginState * userData = [[AppDelegate getInstance].loadingState userData];
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:userData.picUrl] placeholderImage:[UIImage imageNamed:@"WeiXinIIconViewDefaule"] options:SDWebImageRetryFailed];
    
    
    id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
    [fos masterIndex:nil block:^(NSString *code, NSString *desc, NSString *shareDesc, NSString *shareURL, NSNumber *numbersOfFollowers, NSNumber *totalDevoteYes, NSNumber *totalDevote, NSNumber *todaySafe,NSNumber *lisiSafe,NSNumber *todayShare,NSNumber *lisiShare,NSArray *list, NSError *error) {
        LOG(@"%@------%@---%@-----%@----%@---%@--%@--%@---%@---%@----%@----%@",code,desc,shareDesc,shareURL,numbersOfFollowers,totalDevoteYes,totalDevote,todaySafe,lisiSafe,todayShare,lisiShare,list);
        wself.nameLable.text = code;
        wself.firstLable.text = [NSString stringWithFormat:@"%d",[totalDevote integerValue]];
        wself.secondLable.text = [NSString stringWithFormat:@"%d",[totalDevoteYes integerValue]];
        wself.tuDiCount.text =  [NSString stringWithFormat:@"%d",[numbersOfFollowers integerValue]];
        wself.thirdLable.text = [NSString stringWithFormat:@"%d/%d",[todaySafe integerValue] ,[lisiSafe integerValue]];
        wself.fourthLable.text = [NSString stringWithFormat:@"%d/%d",[todayShare integerValue],[lisiShare integerValue]];
        
    } paging:[Paging paging:5 parameters:@{@"pageTag": @0}]];



}



/**
 *  复制邀请码
 *
 *  @param sender <#sender description#>
 */
- (IBAction)fuzhiCode:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.nameLable.text;
    
    [FMUtils alertMessage:self.view msg:@"复制成功"];
}


- (IBAction)tuDILiebiaoClick:(id)sender {
    FollowListTableViewController * fol = [[FollowListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:fol animated:YES];
}

- (IBAction)backClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)shareYaoqinMa:(id)sender {
    
    __weak MasterAndTudiViewController * wself = self;
    ShareMessage* sm = $new(ShareMessage);
    sm.title = [NSString stringWithFormat:@"分红邀请码%@",self.nameLable.text];
    sm.smdescription = self.nameLable.text;
    
    
    LOG(@"%@",self.nameLable.text);
//    sm.url = ls.shareContent;
//    sm.thumbImage =  [UIImage imageNamed:@"logo"];
//    sm.thumbImageURL = @"logo.png";
    
    
    [ShareTool shareMessage:sm controller:self sentList:nil delegate:nil handler:^(TShareType type, ShareResult result, id data) {
        if (result==ShareResultDone) {
            [FMUtils alertMessage:wself.view msg:@"分享成功！"];
        }
    }];
    
}
@end
