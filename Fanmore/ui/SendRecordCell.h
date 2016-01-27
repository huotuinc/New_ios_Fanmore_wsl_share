//
//  SendRecordCell.h
//  Fanmore
//
//  Created by Cai Jiang on 1/23/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendRecord.h"
#import "FmTableCell.h"

@interface SendRecordCell : FmTableCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

-(void)configureSendRecord:(SendRecord*)sendRecord;

@end
