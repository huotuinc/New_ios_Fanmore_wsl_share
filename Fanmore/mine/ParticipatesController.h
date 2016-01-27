//
//  ParticipatesController.h
//  Fanmore
//
//  Created by Cai Jiang on 2/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParticipatesController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

/**
 *  类别
 *  默认为0 显示昨日的话则为1
 */
@property int participatesType;

@end
