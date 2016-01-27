//
//  FlashMallListController.h
//  Fanmore
//
//  Created by Cai Jiang on 8/8/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlashMallListController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UILabel *labelScoreTemp;
@property (weak, nonatomic) IBOutlet UILabel *labelScoreActurl;
@property (weak, nonatomic) IBOutlet UITableView *table;
- (IBAction)clickRightButton:(id)sender;

@end
