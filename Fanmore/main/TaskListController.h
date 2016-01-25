//
//  TaskListController.h
//  Fanmore
//
//  Created by Cai Jiang on 1/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshStatusAble.h"
#import "StandCash.h"

@interface TaskListController : UIViewController<UITableViewDataSource,UITableViewDelegate,RefreshStatusAble,AbleStartCash>
- (IBAction)clickMenu:(id)sender;
- (IBAction)clickCash:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)clickRefresh:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *selectImage1;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage2;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel1;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel2;
@property (weak, nonatomic) IBOutlet UIView *castOver;
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UIImageView *nselectionImage2;
@property (weak, nonatomic) IBOutlet UILabel *nselectionLabel2;
@property (strong, nonatomic) IBOutlet UIView *nTitleView;
@property (weak, nonatomic) IBOutlet UIImageView *nselectionImage1;
@property (weak, nonatomic) IBOutlet UILabel *nselectionLabel1;
@end
