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




/**昨日积分收益*/
@property (weak, nonatomic) IBOutlet UILabel *myYesterdayRewards;
/** 积分余额*/
@property (weak, nonatomic) IBOutlet UILabel *labelTotalScore;
/**今日浏览量*/
@property (weak, nonatomic) IBOutlet UILabel *labelBrowses;
/**今日浏览量*/
@property (weak, nonatomic) IBOutlet UILabel *staticLabelBrowseToday;

/**用户名*/
@property (weak, nonatomic) IBOutlet UILabel *labelName;


@property (weak, nonatomic) IBOutlet UILabel *staticLabelScoreTotal;
@property (weak, nonatomic) IBOutlet UILabel *labelStaticYesScore;


/**首页图标*/
@property (weak, nonatomic) IBOutlet UIImageView *homei;
/**首页图标*/
@property (weak, nonatomic) IBOutlet UILabel *homel;
/**我的账号*/
@property (weak, nonatomic) IBOutlet UIImageView *accounti;
/**我的账号*/
@property (weak, nonatomic) IBOutlet UILabel *accountl;
/**规则说明*/
@property (weak, nonatomic) IBOutlet UIImageView *rulei;
/**规则说明*/
@property (weak, nonatomic) IBOutlet UILabel *rulel;
/**更多选项*/
@property (weak, nonatomic) IBOutlet UIImageView *morei;
/**更多选项*/
@property (weak, nonatomic) IBOutlet UILabel *morel;
/**师徒联盟*/
@property (weak, nonatomic) IBOutlet UIImageView *sharei;
/**师徒联盟*/
@property (weak, nonatomic) IBOutlet UILabel *sharel;
/**今日预告*/
@property (weak, nonatomic) IBOutlet UIImageView *tnoticeI;
/**今日预告*/
@property (weak, nonatomic) IBOutlet UILabel *tnoticeL;


/** 积分值*/
@property (weak, nonatomic) IBOutlet UILabel *labelExp;// %@Exp.
@property (weak, nonatomic) IBOutlet UIImageView *imagePicture;



//@property (weak, nonatomic) IBOutlet UIImageView *redTip;
//@property (weak, nonatomic) IBOutlet UIImageView *redTip2;







@property (weak, nonatomic) IBOutlet UILabel *labelMall;
@property (weak, nonatomic) IBOutlet UIImageView *imageMall;
@property (weak, nonatomic) IBOutlet UIButton *buttonSign;
@property (weak, nonatomic) IBOutlet UILabel *staticLabelTotalScore;


@property (weak, nonatomic) IBOutlet UILabel *labelSign;
@property (weak, nonatomic) IBOutlet UIImageView *imageItem;
@property (weak, nonatomic) IBOutlet UILabel *labelItem;
@property (weak, nonatomic) IBOutlet UIImageView *imageSigngougou;
@property (weak, nonatomic) IBOutlet UILabel *labelBottomMsg;


@property (weak, nonatomic) IBOutlet UIImageView *toufangI;
@property (weak, nonatomic) IBOutlet UILabel *toufangL;




@end
