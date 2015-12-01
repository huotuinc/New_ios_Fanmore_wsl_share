//
//  NewCashCell.h
//  Fanmore
//
//  Created by Cai Jiang on 12/19/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FmTableCell.h"

@interface NSDictionary (NewCashHistory)

-(NSNumber*)getNewCashHistoryId;
-(NSNumber*)getNewCashHistoryType;
-(NSNumber*)getNewCashHistoryAmount;
-(NSDate*)getNewCashHistoryTime;
-(NSString*)getNewCashHistoryDesc;

@end

@interface NewCashCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelId;
@property (weak, nonatomic) IBOutlet UILabel *labelDesc;
@property (weak, nonatomic) IBOutlet UILabel *labelAmount;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@end
