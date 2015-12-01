//
//  AccountViewController.h
//  Fanmore
//
//  Created by Cai Jiang on 2/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextChangeController.h"
#import "StandCash.h"

@interface AccountViewController : UIViewController<TextChangeDelegate,UITableViewDataSource,AbleStartCash>
//@property (weak, nonatomic) IBOutlet UIButton *updatesImage;
//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *bttixian;
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *zfbImage;
//@property (weak, nonatomic) IBOutlet UILabel *zfbLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *phoneImage;
//@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *btlogout;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *tickedScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *todaySendLabel;
- (IBAction)refresh:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)actionDone;
@property (weak, nonatomic) IBOutlet UIButton *buttonMobile;
@property (weak, nonatomic) IBOutlet UIButton *buttonZfb;
@property (weak, nonatomic) IBOutlet UILabel *labelMobile;
@property (weak, nonatomic) IBOutlet UILabel *labelZfb;
@property (weak, nonatomic) IBOutlet UIImageView *imagePicture;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelExp;

@property (weak, nonatomic) IBOutlet UIScrollView *viewMain;
@property (weak, nonatomic) IBOutlet UIImageView *imageInformationHinter;
@property (weak, nonatomic) IBOutlet UIView *innerButtonView;

@end
