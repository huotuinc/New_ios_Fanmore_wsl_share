//
//  SafeController.h
//  Fanmore
//
//  Created by Cai Jiang on 2/28/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SafeController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
//@property (weak, nonatomic) IBOutlet UITableView *tablev;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellModifyALP;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellModifyMobile;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellModifyCashPswd;

@end
