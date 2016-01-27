//
//  SendRecordCell.m
//  Fanmore
//
//  Created by Cai Jiang on 1/23/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "SendRecordCell.h"
#import "NSDate+Fanmore.h"

@implementation SendRecordCell

- (void)fminitialization{
    [super fminitialization];
    [self.layer setBorderWidth:2];
//    [self setBackgroundColor:[UIColor whiteColor]];
//    [self.time setBackgroundColor:[UIColor whiteColor]];
//    [self.userLabel setBackgroundColor:[UIColor whiteColor]];
//    [self.time.layer setBackgroundColor:[UIColor redColor].CGColor];
}

-(void)configureSendRecord:(SendRecord*)sendRecord{
    self.time.text = [sendRecord.time fmStandString];
    self.userLabel.text = sendRecord.name;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
