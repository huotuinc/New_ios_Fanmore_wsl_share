//
//  MoreController.h
//  Fanmore
//
//  Created by Cai Jiang on 3/1/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshStatusAble.h"

@interface MoreController : UITableViewController<RefreshStatusAble>
@property (weak, nonatomic) IBOutlet UILabel *labelCacheDetail;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellCache;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellCancelSinaWeiboAuth;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellVersionCheck;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellFeedBack;


@end
