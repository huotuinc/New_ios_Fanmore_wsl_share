//
//  TaskListCell.m
//  Fanmore
//
//  Created by Cai Jiang on 6/18/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "TaskListCell.h"
#import "AppDelegate.h"

@interface TaskListCell ()

@property(weak) UIImageView* imageTop;
@property(weak) UILabel* labelRelate;

@property CGFloat manyInformationMoved;
@property CGFloat sendInfoMoved;
/**
 *  位移了30单位
 */
@property BOOL offset30;
@property BOOL hideScore;
/**
 *  只是隐藏了剩余积分
 */
@property BOOL onlyHideLastScore;

//@property BOOL fsHideScore;
//@property BOOL fsInformationMoved;

/**
 *  已按照联盟模式隐藏 右移 包括转发标记在内的转发信息
 */
//@property BOOL flagUnitMoved;

@end

@implementation TaskListCell

-(void)fminitialization{
    [super fminitialization];
    
    CGFloat y = [self addHeaderInfo];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(50, 82+y+17, 220, 21)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor blackColor];
    label.text=@"总积分：";
    [label hidenme];
    [self addSubview:label];
    self.labelRelate = label;
    y = [self addScoreInfo:y];
    
    [self endWithSendInfoAndTime:y addRewards:NO sendInfo:YES];
    
    [self appendTuzhang:0];
    
    UIImageView* iimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90.0f*0.75f, 75.0f*0.75f)];
    iimage.image = [UIImage imageNamed:@"top"];
    [self addSubview:iimage];
    iimage.hidden = YES;
    self.imageTop = iimage;
    
    //47.5
    [self addHuodongInformation];
    
    [self addImageLeftTop];
}

-(void)workingWithScoreLabels:(BOOL)normal{
    NSArray* subviews = self.subviews;
    while (subviews.count==1) {
        UIView* sv = subviews[0];
        subviews = sv.subviews;
    }
    
    NSUInteger index = [subviews indexOfObject:self.lastScore];
    if (index!=NSNotFound) {
        NSRange range = NSMakeRange(index-3, 4);
        NSArray* scoreLabels = [subviews subarrayWithRange:range];
        
        // 50 60 95 77
        
        if (normal) {
            UILabel* l1 = scoreLabels[0];
            UILabel* l2 = scoreLabels[1];
            CGRect r1 = l1.frame;
            CGRect r2 = l2.frame;
            [l1 setFrame:CGRectMake(50, r1.origin.y, 60, r1.size.height)];
            [l2 setFrame:CGRectMake(95, r2.origin.y, 77, r2.size.height)];
//            LOG(@"x1:%f w1:%f  x2:%f,w2:%f",l1.frame.origin.x,l1.frame.size.width,l2.frame.origin.x,l2.frame.size.width);
            [scoreLabels makeObjectsPerformSelector:@selector(showme)];
            [scoreLabels[0] setText:@"总积分："];
        }else{
            UILabel* l1 = scoreLabels[0];
            UILabel* l2 = scoreLabels[1];
//            LOG(@"x1:%f w1:%f  x2:%f,w2:%f",l1.frame.origin.x,l1.frame.size.width,l2.frame.origin.x,l2.frame.size.width);
            CGRect r1 = l1.frame;
            CGRect r2 = l2.frame;
            [l1 setFrame:CGRectMake(50, r1.origin.y, 70, r1.size.height)];
            [l2 setFrame:CGRectMake(110, r2.origin.y, 77, r2.size.height)];
            
            [scoreLabels[0] setText:@"浏览奖励："];
            [scoreLabels[2] hidenme];
            [scoreLabels[3] hidenme];
        }
    }
}

-(void)workingWithScoreLabels:(CGFloat)offset op:(SEL)op{
    NSArray* subviews = self.subviews;
    while (subviews.count==1) {
        UIView* sv = subviews[0];
        subviews = sv.subviews;
    }
    
    NSUInteger index = [subviews indexOfObject:self.lastScore];
    if (index!=NSNotFound) {
        NSRange range = NSMakeRange(index-3, 4);
        NSArray* scoreLabels = [subviews subarrayWithRange:range];
        if (offset!=0) {
            for (UIView* u in scoreLabels) {
                [u offset:0 y:offset];
            }
        }
        if (op) {
            [scoreLabels makeObjectsPerformSelector:op];
        }
    }
}

/**
 *  对最后一行UI进行操作
 *
 *  @param offset <#offset description#>
 *  @param op     <#op description#>
 */
-(void)workingWithUnderUIS:(CGFloat)offset op:(SEL)op{
    
    if (offset!=0) {
        for (UIView* u in [self uisendWithSendInfoAndTime]) {
            [u offset:0 y:offset];
        }
    }
    if (op) {
        [[self uisendWithSendInfoAndTime] makeObjectsPerformSelector:op];
    }


}

-(void)configureTask:(Task *)task{
    NSArray* subviews = self.subviews;
    while (subviews.count==1) {
        UIView* sv = subviews[0];
        subviews = sv.subviews;
    }
    LOG(@"159");
    // 还原
    [self restoreForUnitTask];
    [self hideImageLeftTop];
    LOG(@"163");
    NSUInteger index = [subviews indexOfObject:self.lastScore];
    NSRange range = NSMakeRange(index-3, 4);
    NSArray* scoreLabels = [subviews subarrayWithRange:range];
    
    NSArray* sendInfos = [self uisendWithSendInfos];
    LOG(@"169");
    if(self.onlyHideLastScore && !self.hideScore){
        self.onlyHideLastScore = NO;
        [scoreLabels[2] showme];
        [scoreLabels[3] showme];
    }
    LOG(@"175");
    if (self.hideScore) {
        self.hideScore = NO;
        [self workingWithScoreLabels:0 op:@selector(showme)];
    }
    LOG(@"180");
    if(self.offset30){
        self.offset30 = NO;
        [self workingWithUnderUIS:30.0f op:NULL];
    }
    LOG(@"185");
    if(self.sendInfoMoved!=0){
        CGFloat xx = -1*self.sendInfoMoved;
        self.sendInfoMoved = 0;
        for (id tomove in sendInfos) {
            [tomove offset:xx y:0];
        }
    }
    LOG(@"193");
    if(self.manyInformationMoved!=0){
        CGFloat xx = -1*self.manyInformationMoved;
        self.manyInformationMoved = 0;
        [self workingWithScoreLabels:xx op:NULL];
        [self workingWithUnderUIS:xx op:NULL];
    }
    
    [self.labelRelate hidenme];
    
    // 还原  结束
    LOG(@"204");
    self.image.image = [UIImage imageNamed:@"imgloding-full"];
    LOG(@"205");
    [self updateHeaderInfo:task.store.name info:task.taskName];
    LOG(@"206");
    [self updateTime:task.publishTime andSendCount:task.sendCount];
    LOG(@"207");
    [self updateScoreInfo:task.totalScore last:task.lastScore];
    LOG(@"208");
    [self updateSendList:task.sendList];
    LOG(@"209");
    LOG(@"%@",task.taskSmallImgUrl);
    [self updateImage:task.taskSmallImgUrl];
    LOG(@"210");
    //是否置顶
    if (self.imageTop) {
        self.imageTop.hidden = ![[AppDelegate getInstance] taskIsTop:task.taskId];
    }
    LOG(@"211");
    [self updateHuodongInformation:task];
    LOG(@"218");
    if ([task zeroReward]) {
        self.hideScore = YES;
        [self workingWithScoreLabels:0 op:@selector(hidenme)];
        self.offset30 = YES;
        [self workingWithUnderUIS:-30.0f op:NULL];
    }
    
//    if ([task zeroReward]!=self.hideScore) {
//        //对几个积分label将执行的处理
//        self.hideScore = !self.hideScore;
//        SEL scoreOP = [task zeroReward]?@selector(hidenme):@selector(showme);
//        
//        //对下方几个View即将执行的位移
//        CGFloat offset = ([task zeroReward]?-1.0f:1.0f)*30.0f;
//        
//        [self workingWithScoreLabels:0 op:scoreOP];
//        [self workingWithUnderUIS:offset op:NULL];
//    }
    LOG(@"237");
    if ([task notbeAbletoSend]) {
        //对于一些无法转发的任务 自然也没有已转发或者已抢完的盖章
        [self updateTuzhang:0 hidden:YES image:nil];
        [sendInfos makeObjectsPerformSelector:@selector(hidenme)];
    }else{
        [sendInfos makeObjectsPerformSelector:@selector(showme)];
    }
    
    // 新版本 联盟任务和闪购任务处理方式几乎一模一样
    // 区别在于 原来显示 返利说明的地方 显示浏览奖励 Done
    //         剩余积分应该不显示                Done
    LOG(@"249");
    if ([task isFlashMall]) {
        CGFloat xx = self.frame.size.width-self.imgSendPic.frame.origin.x-3;
        self.sendInfoMoved = xx;
        for (id tomove in sendInfos) {
            [tomove offset:xx y:0];
        }
    }
    
    // 开始处理返利信息
    NSString* relateMsg = [task getRebateMsg];
    LOG(@"260");
    if ($safe(relateMsg) && relateMsg.length>0) {
        //存在返利
        LOG(@"TaskCell %@ %@ %@",[task taskName],[task totalScore],[task lastScore]);
        BOOL hideScores= [[task totalScore] floatValue]<=1 || [[task lastScore] floatValue]<=0;
        
        if ([task isUnitedTask]) {
            hideScores = NO;
        }
        
        [self.labelRelate showme];
        [self.labelRelate setText:relateMsg];
        
        if (hideScores) {
            //不存在积分 隐藏掉积分
            self.hideScore = YES;
            [self workingWithScoreLabels:0 op:@selector(hidenme)];
            
        }else{
            self.manyInformationMoved = 30;
            [self workingWithScoreLabels:30 op:NULL];
            [self workingWithUnderUIS:30 op:NULL];
        }
    }
    LOG(@"284");
    //已转发和已抢完的 2个章
    BOOL isSend = $safe(task.sendList) && task.sendList.length>0;
    if (isSend) {
        [self updateTuzhang:0 hidden:NO image:[UIImage imageNamed:@"task_send_tag"]];
    }else if ([task.lastScore floatValue]<=0 && !self.lastScore.hidden){
        [self updateTuzhang:0 hidden:NO image:[UIImage imageNamed:@"task_scoreover_tag"]];
    }else{
        [self updateTuzhang:0 hidden:YES image:nil];
    }
     LOG(@"294");
    if ([task.status intValue]==8){
        // 联盟任务下架
        [self updateImageLeftTop:[UIImage imageNamed:@"yijieshu"]];
    }
    
    if ([task isUnitedTask]) {
        [self adjustForUnitTask:task.awardBrowse];
    }
}

@end
