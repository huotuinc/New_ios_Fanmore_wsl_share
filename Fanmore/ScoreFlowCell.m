//
//  ScoreFlowCell.m
//  Fanmore
//
//  Created by Cai Jiang on 3/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ScoreFlowCell.h"
#import "ShareTool.h"
#import "AppDelegate.h"

@implementation ScoreFlowCell

-(void)fminitialization{
    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(41.0f, -20.0f, 2.0f, 85.0f)];
    image.image = [UIImage imageNamed:@"biaoge3右下"];
    [self addSubview:image];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(1.0f, 22.0f, 42.0f, 21.0f)];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setTextColor:[UIColor lightGrayColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:label];
    self.labelId = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(61.0f, 10.0f, 180.0f, 21.0f)];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setTextColor:[UIColor darkGrayColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:label];
    self.labelDesc = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(61.0f, 34.0f, 150.0f, 21.0f)];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setTextColor:[UIColor lightGrayColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:label];
    self.labelTime = label;
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(238.0f, 16.0f, 33.0f, 33.0f)];
    [self addSubview:image];
    self.imageType = image;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(271.0f, 22.0f, 39.0f, 21.0f)];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setTextColor:[UIColor blackColor]];
    [label setTextAlignment:NSTextAlignmentRight];
    [self addSubview:label];
    self.labelScore = label;
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 54.0f, 45.0f)];
    [self addSubview:image];
    self.imageFlag = image;
}

-(void)configScoreFlow:(ScoreFlow*)flow index:(NSIndexPath*)index detail:(BOOL)detail{
    self.labelId.text = $str(@"%d",index.row+1);
    self.labelDesc.text = flow.operation;
    self.labelTime.text = [flow.time fmStandString];
    
    if ([flow.score floatValue]==0 && [flow.operation rangeOfString:@"转发"].location!=NSNotFound) {
        detail = NO;
    }
    
    if (detail) {
        self.labelScore.text = [flow.score stringValue];
        self.imageFlag.hidden = NO;
        if ([flow.score floatValue]>0) {
            self.imageFlag.image = [UIImage imageNamed:@"chengong"];
        }else{
            self.imageFlag.image = [UIImage imageNamed:@"yiqiangwan"];
        }
    }else{
        self.labelScore.text = @"";
        self.imageFlag.hidden = YES;
    }
    
    
    if ($safe(flow.channelType)) {
        self.imageType.hidden = NO;
        NSNumber* ttype = [AppDelegate getInstance].shareTypes[[flow.channelType stringValue]];
        TShareType type = (TShareType)[ttype intValue];
        self.imageType.image = [ShareTool getClientImage:type enable:YES];
    }else{
        self.imageType.hidden = YES;
    }
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
