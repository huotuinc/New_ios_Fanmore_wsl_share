//
//  ParticipatesCell.m
//  Fanmore
//
//  Created by Cai Jiang on 6/17/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ParticipatesCell.h"
#import "HXColor.h"

@interface ParticipatesCell ()

//@property(weak) UILabel* labelBrowse;
@property CGFloat ydiffernce;
@property UIImageView* mask;

@end

@implementation ParticipatesCell

-(void)fminitialization{
    [super fminitialization];
    CGFloat y = [self addHeaderInfo];
//    y = [self addScoreInfo:y];
    
//    UILabel* label;
//    y = [self addSimpleInfoOneLine:y msg:@"总浏览量：" p:&label];
//    if (label) {
//        self.labelBrowse = label;
//    }
    
    CGFloat orcY = y;
    
    y += 5.0f;
    y = [self addBigRewards:0 suffix:@"%@总收益" yoffset:y];
    y -= 42.0f;
    
    self.ydiffernce = y -orcY;
    [self endWithSendInfoAndTime:y addRewards:YES sendInfo:YES];
    
    [self appendTuzhang:0];
    
    UIImageView* mask = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 203)];
    [self addSubview:mask];
    mask.backgroundColor = [UIColor colorWithHexString:@"999999" alpha:0.2];
    self.mask = mask;
}

-(void)configureTask:(Task*)task{
    self.image.image = [self.class DefaultImage];
    [self updateHeaderInfo:task.store.name info:task.taskName];
    [self updateTime:task.publishTime andSendCount:task.sendCount];
    
//    [self.labelBrowse setText:[task.totalScanCount stringValue]];
    
    [self updateBigRewards:0 send:task.myAwardSend browse:task.myAwardBrowse link:task.myAwardLink];
//    self.sendReward.text = [task.myAwardSend stringValue];
//    self.browseReward.text = [task.myAwardBrowse stringValue];
//    self.linkReward.text = [task.myAwardLink stringValue];
//    self.sendRewardYes.text = [task.awardYesSendResult stringValue];
//    self.browseRewardYes.text = [task.awardYesScanResult stringValue];
//    self.linkRewardYes.text = [task.awardYesLinkResult stringValue];
    
    [self updateSendList:task.sendList];
//    [self updateScoreInfo:task.totalScore last:task.lastScore];
    
    [self updateImage:task.taskSmallImgUrl];
    
#ifdef FanmoreDebug
    [task isReallyAccounted];
#endif
    
    int status = [task.status intValue];
    if (status==4 || status==5 || status==6) {
        [self updateTuzhang:0 hidden:NO image:[UIImage imageNamed:@"task_over"]];
    }else if (![task isReallyAccounted]) {
        [self updateTuzhang:0 hidden:NO image:[UIImage imageNamed:@"task_un"]];
    }else{
        [self updateTuzhang:0 hidden:YES image:nil];
    }
    
    if (![task isReallyAccounted]) {
        //为结算
        [self setAccessoryType:(UITableViewCellAccessoryNone)];
        //修改背景色
        [self.mask showme];
        
        if (![self.addBigRewardsViews[0] isHidden]) {
            [[self viewWithTag:[@"endWithSendInfoAndTimecibg" hash]] offset:0.0f y:-1*self.ydiffernce];
            [[self viewWithTag:[@"endWithSendInfoAndTimetime" hash]] offset:0.0f y:-1*self.ydiffernce];
            [self.humanTime offset:0.0f y:-1*self.ydiffernce];
            for(UIView* v in self.shareTypeImages.allValues){
                [v offset:0 y:-1*self.ydiffernce];
            }
            [self.imgSendPic offset:0.0f y:-1*self.ydiffernce];
            [self.sendCount offset:0.0f y:-1*self.ydiffernce];
            [[self.addBigRewardsViews lastObject] offset:0 y:-1*self.ydiffernce];
        }
        
        for (int i=0; i<self.addBigRewardsViews.count-1; i++) {
            [self.addBigRewardsViews[i] hidenme];
        }
    }else{
        [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
        [self.mask hidenme];
        
        if ([self.addBigRewardsViews[0] isHidden]) {
            [[self viewWithTag:[@"endWithSendInfoAndTimecibg" hash]] offset:0.0f y:self.ydiffernce];
            [[self viewWithTag:[@"endWithSendInfoAndTimetime" hash]] offset:0.0f y:self.ydiffernce];
            [self.humanTime offset:0.0f y:self.ydiffernce];
            for(UIView* v in self.shareTypeImages.allValues){
                [v offset:0 y:self.ydiffernce];
            }
            [self.imgSendPic offset:0.0f y:self.ydiffernce];
            [self.sendCount offset:0.0f y:self.ydiffernce];
            [[self.addBigRewardsViews lastObject] offset:0 y:self.ydiffernce];
        }
        
        for (int i=0; i<self.addBigRewardsViews.count-1; i++) {
            [self.addBigRewardsViews[i] showme];
        }
        
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
