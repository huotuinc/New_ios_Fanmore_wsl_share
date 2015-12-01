//
//  RankingController.h
//  Fanmore
//
//  Created by Cai Jiang on 9/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *bar1Image;
@property (weak, nonatomic) IBOutlet UILabel *bar1Label;
@property (weak, nonatomic) IBOutlet UIImageView *bar2Image;
@property (weak, nonatomic) IBOutlet UILabel *bar2Label;
@property (weak, nonatomic) IBOutlet UIImageView *bar3Image;
@property (weak, nonatomic) IBOutlet UILabel *bar3Label;
@property (weak, nonatomic) IBOutlet UILabel *labelDesc;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
