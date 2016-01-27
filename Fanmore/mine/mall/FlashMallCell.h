//
//  FlashMallCell.h
//  Fanmore
//
//  Created by Cai Jiang on 8/8/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FmTableCell.h"

@interface NSDictionary (SLCell)

-(NSNumber*)getSLOrderId;
-(NSString*)getSLOrderTime;
-(NSString*)getSLId;
-(NSString*)getSLName;
-(NSString*)getSLUser;
-(NSDate*)getSLDate;
-(NSNumber*)getSLScoreTemp;
-(NSNumber*)getSLScoreActurl;

-(NSString*)getSLTimeCount;
-(NSNumber*)getSLStatus;
-(NSString*)getSLStatusMsg;

@end

@interface FlashMallCell : FmTableCell
@property (weak, nonatomic) IBOutlet UILabel *labelID;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelUser;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelScoreTemp;
@property (weak, nonatomic) IBOutlet UILabel *labelScoreActurl;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeCount;

-(void)config:(NSDictionary*)data;

@end
