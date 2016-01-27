//
//  ScoreOneDayCell.m
//  Fanmore
//
//  Created by Cai Jiang on 6/16/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ScoreOneDayCell.h"
#import "HXColor.h"

@implementation NSDictionary (ScoreOneDay)

-(NSDate*)getScoreOneDayDate{
    return [self[@"date"] fmToDate];
}

@end

@interface ScoreOneDayCell ()

@property(weak) UILabel* labelScore;
@property(weak) UILabel* labelBrowse;

@property(weak) UILabel* labelStaticScore;

@property CGFloat ydiffernce;

@end

@implementation ScoreOneDayCell

-(CGFloat)addMyInfos:(CGFloat)yoffset{
    yoffset += 17;
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(45, 82+yoffset, 65, 21)];
    [label setBackgroundColor:[UIColor whiteColor]];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor blackColor];
    label.text=@"当日收益：";
    [self addSubview:label];
    self.labelStaticScore = label;
    label = [[UILabel alloc]initWithFrame:CGRectMake(105, 82+yoffset, 77, 21)];
    [label setBackgroundColor:[UIColor whiteColor]];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor redColor];
    [self addSubview:label];
    self.labelScore = label;
    label = [[UILabel alloc]initWithFrame:CGRectMake(170, 82+yoffset, 65, 21)];
    [label setBackgroundColor:[UIColor whiteColor]];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor blackColor];
    label.text=@"当日浏览：";
    [self addSubview:label];
    self.labelStaticBrowse = label;
    label = [[UILabel alloc]initWithFrame:CGRectMake(232, 82+yoffset, 65, 21)];
    [label setBackgroundColor:[UIColor whiteColor]];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor redColor];
    [self addSubview:label];
    self.labelBrowse = label;
    return yoffset;
}

- (void)setFrame:(CGRect)frame {
    CGFloat inset = 2.2;
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
    [super setFrame:frame];
}

-(void)fminitialization{
    [super fminitialization];
    [self.layer setBorderColor:[UIColor colorWithHexString:@"ebebeb"].CGColor];
    
    [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    CGFloat y = [self addHeaderInfo];
    
    CGFloat orcY = y;
    
    y = [self addMyInfos:y];
    
//    y += 10.0f;
    
    self.ydiffernce = y -orcY;    
    [self endWithSendInfoAndTime:y addRewards:NO sendInfo:NO];
}

-(void)configureData:(NSDictionary*)data{
    int type = [data[@"type"] intValue];
    
    if ($safe(data[@"imageUrl"])) {
        [self updateImage:data[@"imageUrl"]];
    }
    
    [self updateHeaderInfo:data[@"title"] info:data[@"description"]];
    
    if ($safe(data[@"browseAmount"])) {
        [self.labelBrowse setText:[data[@"browseAmount"] stringValue]];
    }
    
    if ($safe(data[@"totalScore"])) {
        [self.labelScore setText:$str(@"%@",data[@"totalScore"])];
    }
    
    [self updateTime:[[data[@"date"] fmToDate] fmHumenReadableString] andSendCount:nil];
    
    if (type!=2) {
        [self.title setTextColor:[UIColor redColor]];
    }else{
        [self.title setTextColor:[UIColor blackColor]];
    }
    
    if (type!=2) {
        [self setAccessoryType:(UITableViewCellAccessoryNone)];
        if (!self.labelScore.hidden) {
            
            [[self viewWithTag:[@"endWithSendInfoAndTimecibg" hash]] offset:0.0f y:-1*self.ydiffernce];
            [[self viewWithTag:[@"endWithSendInfoAndTimetime" hash]] offset:0.0f y:-1*self.ydiffernce];
            [self.humanTime offset:0.0f y:-1*self.ydiffernce];
        }
        
        [self.labelScore hidenme];
        [self.labelStaticBrowse hidenme];
        [self.labelBrowse hidenme];
        [self.labelStaticScore hidenme];
        [self.humanTime showme];
        [[self viewWithTag:[@"endWithSendInfoAndTimecibg" hash]] showme];
        [[self viewWithTag:[@"endWithSendInfoAndTimetime" hash]] showme];
        
    }else{
        [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
        if (self.labelScore.hidden) {
            
            [[self viewWithTag:[@"endWithSendInfoAndTimecibg" hash]] offset:0.0f y:self.ydiffernce];
            [[self viewWithTag:[@"endWithSendInfoAndTimetime" hash]] offset:0.0f y:self.ydiffernce];
            [self.humanTime offset:0.0f y:self.ydiffernce];
        }
        
        [self.labelScore showme];
        [self.labelStaticBrowse showme];
        [self.labelBrowse showme];
        [self.labelStaticScore showme];
        
        [self.humanTime hidenme];
        [[self viewWithTag:[@"endWithSendInfoAndTimecibg" hash]] hidenme];
        [[self viewWithTag:[@"endWithSendInfoAndTimetime" hash]] hidenme];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
