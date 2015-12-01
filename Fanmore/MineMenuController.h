//
//  MineMenuController.h
//  Fanmore
//
//  Created by Cai Jiang on 2/8/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskListController.h"
#import "RefreshStatusAble.h"

@interface MineMenuController : UIViewController<RefreshStatusAble>

- (void)clickHome;
/**
 *  登出时 逻辑上清理
 */
- (void)logout;
@property TaskListController* taskListController;
@property UIImage* mainImageImage;
@property (weak, nonatomic) IBOutlet UILabel *totalTaskRewards;
@property (weak, nonatomic) IBOutlet UILabel *myYesterdayRewards;
/**首页图标*/
@property (weak, nonatomic) IBOutlet UIImageView *homei;

@property (weak, nonatomic) IBOutlet UILabel *homel;
/**我的账号*/
@property (weak, nonatomic) IBOutlet UIImageView *accounti;
@property (weak, nonatomic) IBOutlet UILabel *accountl;
@property (weak, nonatomic) IBOutlet UIImageView *rulei;
@property (weak, nonatomic) IBOutlet UILabel *rulel;
@property (weak, nonatomic) IBOutlet UIImageView *morei;
@property (weak, nonatomic) IBOutlet UILabel *morel;
@property (weak, nonatomic) IBOutlet UIImageView *redTip;
@property (weak, nonatomic) IBOutlet UIImageView *redTip2;
@property (weak, nonatomic) IBOutlet UIImageView *sharei;
@property (weak, nonatomic) IBOutlet UILabel *sharel;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalScore;
@property (weak, nonatomic) IBOutlet UILabel *labelBrowses;
@property (weak, nonatomic) IBOutlet UILabel *staticLabelBrowseToday;
@property (weak, nonatomic) IBOutlet UILabel *staticLabelScoreTotal;
@property (weak, nonatomic) IBOutlet UILabel *labelStaticYesScore;
@property (weak, nonatomic) IBOutlet UILabel *labelMall;
@property (weak, nonatomic) IBOutlet UIImageView *imageMall;
@property (weak, nonatomic) IBOutlet UIButton *buttonSign;
@property (weak, nonatomic) IBOutlet UILabel *staticLabelTotalScore;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelExp;// %@Exp.
@property (weak, nonatomic) IBOutlet UIImageView *imagePicture;
@property (weak, nonatomic) IBOutlet UILabel *labelSign;
@property (weak, nonatomic) IBOutlet UIImageView *imageItem;
@property (weak, nonatomic) IBOutlet UILabel *labelItem;
@property (weak, nonatomic) IBOutlet UIImageView *imageSigngougou;
@property (weak, nonatomic) IBOutlet UILabel *labelBottomMsg;

@property (weak, nonatomic) IBOutlet UIImageView *tnoticeI;
@property (weak, nonatomic) IBOutlet UILabel *tnoticeL;
@property (weak, nonatomic) IBOutlet UIImageView *toufangI;
@property (weak, nonatomic) IBOutlet UILabel *toufangL;



@property (weak, nonatomic) IBOutlet UIImageView *mytestImaheview;

@end
