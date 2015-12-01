//
//  ExpHistoryCell.h
//  Fanmore
//
//  Created by Cai Jiang on 10/16/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDictionary (ExpHistory)

-(NSNumber*)getExpHistoryId;
-(NSNumber*)getExpHistoryAmount;
-(NSString*)getExpHistoryReason;
-(NSDate*)getExpHistoryDate;

@end

@interface ExpHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelNo;

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;

-(void)config:(NSDictionary*)data row:(NSInteger)row;

@end
