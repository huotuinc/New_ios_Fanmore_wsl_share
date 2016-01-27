//
//  FlashMallRecordCell.m
//  Fanmore
//
//  Created by Cai Jiang on 8/8/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FlashMallRecordCell.h"

@implementation NSDictionary (SLCellRecord)

-(NSDate*)getSLCRTime{
    NSString* time =  self[@"time"];
    return [time fmToDate2];
}
-(NSString*)getSLCRAction{
    return self[@"action"];
}

-(NSNumber*)getSLCRScore{
    return self[@"score"];
}

@end

@implementation FlashMallRecordCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)fminitialization{
//    [super fminitialization];
//    [self.layer setBorderWidth:1];
}

-(void)config:(NSDictionary *)data count:(NSUInteger)count  current:(NSInteger)current{
    //
    [self.labelAction setText:[data getSLCRAction]];
    [self.labelScore setText:$str(@"%@积分",[data getSLCRScore])];
    [self.labelDate setText:[[data getSLCRTime]fmStandStringDateOnly]];
    
    BOOL last = current>=count-1;
    
    if (current==0) {
        [self.imageLineButtom setHidden:YES];
    }else{
        [self.imageLineButtom setHidden:NO];
    }
    
    if (last) {
        [self.labelAction setTextColor:[UIColor blackColor]];
        [self.labelScore setTextColor:[UIColor blackColor]];
        [self.labelDate setTextColor:[UIColor blackColor]];
        
        [self.imageLineUp setHidden:YES];//imageLineUp
        [self.imageLineRight setHidden:NO];
        
        [self.imageYuanBig setHidden:NO];
        [self.imageYuanSmall setHidden:YES];
        
    }else{
        [self.labelAction setTextColor:[UIColor lightGrayColor]];
        [self.labelScore setTextColor:[UIColor lightGrayColor]];
        [self.labelDate setTextColor:[UIColor lightGrayColor]];
        
        [self.imageLineUp setHidden:NO];
        [self.imageLineRight setHidden:YES];
        
        [self.imageYuanBig setHidden:YES];
        [self.imageYuanSmall setHidden:NO];
    }
    
}

@end
