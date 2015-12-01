//
//  ItemsController.h
//  Fanmore
//
//  Created by Cai Jiang on 10/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imagePicture;

@property (weak, nonatomic) IBOutlet UILabel *labelExp;
@property (weak, nonatomic) IBOutlet UILabel *labelMyitem;
@property (weak, nonatomic) IBOutlet UILabel *labelItemMark;
//@property (weak, nonatomic) IBOutlet UITableView *tableMyitem;
@property (weak, nonatomic) IBOutlet UITableView *tableAllItem;
- (IBAction)clickHistory:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonHistory;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UILabel *labelMyitemIg;
@property (weak, nonatomic) IBOutlet UIScrollView *viewMyitem;
@property (weak, nonatomic) IBOutlet UIImageView *imageMaskTopView;
@property (weak, nonatomic) IBOutlet UIImageView *imageJTTopView;
- (IBAction)clickRight:(id)sender;

@end
