//
//  FlashMallRecordCell.h
//  Fanmore
//
//  Created by Cai Jiang on 8/8/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FmTableCell.h"

@interface NSDictionary (SLCellRecord)

-(NSDate*)getSLCRTime;
-(NSString*)getSLCRAction;
-(NSNumber*)getSLCRScore;

@end

@interface FlashMallRecordCell : FmTableCell
@property (weak, nonatomic) IBOutlet UIImageView *imageLineUp;
@property (weak, nonatomic) IBOutlet UIImageView *imageLineButtom;
@property (weak, nonatomic) IBOutlet UIImageView *imageYuanBig;
@property (weak, nonatomic) IBOutlet UIImageView *imageYuanSmall;
@property (weak, nonatomic) IBOutlet UIImageView *imageLineRight;
@property (weak, nonatomic) IBOutlet UILabel *labelAction;
@property (weak, nonatomic) IBOutlet UILabel *labelScore;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;

-(void)config:(NSDictionary*)data count:(NSUInteger)count current:(NSInteger)current;

@end
