//
//  CashHistoryCell.h
//  Fanmore
//
//  Created by Cai Jiang on 2/17/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CashHistory.h"

@interface CashHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelExtra;

-(void)configCashHistory:(CashHistory*)cash;
+(CGSize)sizeOfMessage:(NSString*)msg;
@end
