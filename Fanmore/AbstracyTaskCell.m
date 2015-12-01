//
//  AbstracyTaskCell.m
//  Fanmore
//
//  Created by Cai Jiang on 6/16/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "AbstracyTaskCell.h"
#import "AppDelegate.h"

static UIImage* AbstracyTaskCellDefalutImage;

@interface AbstracyTaskCell ()

@property HTTPRequestMoniter* lastRequest;
@property(weak) UIImageView* imageLeftTop;

@property(weak) UILabel* huodongLabel;
@property(weak) UIImageView* huodongImage;

@end

@implementation AbstracyTaskCell

// empty implements
-(void)updateRewards:(uint)type value:(id)value{
}
// end


+(UIImage*)DefaultImage{
    if (AbstracyTaskCellDefalutImage==NULL) {
        AbstracyTaskCellDefalutImage = [UIImage imageNamed:@"imgloding-full"];
    }
    return AbstracyTaskCellDefalutImage;
}

-(void)addHuodongInformation{
    UIImageView* iimage = [[UIImageView alloc]initWithFrame:CGRectMake(55.0f, 10.0f, 30, 20)];
    iimage.image = [UIImage imageNamed:@"task_huodong"];
    [self addSubview:iimage];
    iimage.hidden  = YES;
    self.huodongImage = iimage;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(iimage.frame.origin.x, iimage.frame.origin.y, 30, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:9.0f];
    label.text = @"活动";
    [self addSubview:label];
    label.hidden = YES;
    self.huodongLabel = label;
}

-(void)updateHuodongInformation:(Task *)task{
    
    int type = [task.type intValue];
    
    if (type==1000100) {
        self.huodongImage.hidden = NO;
        self.huodongLabel.hidden = NO;
        self.huodongLabel.text = @"公告";
    }else if (type==90100){
        self.huodongImage.hidden = NO;
        self.huodongLabel.hidden = NO;
        self.huodongLabel.text = @"求包养";
    }else if (type==1000200){
        self.huodongImage.hidden = NO;
        self.huodongLabel.hidden = NO;
        self.huodongLabel.text = @"新手";
    }else if ([task isFlashMall]){
        self.huodongImage.hidden = NO;
        self.huodongLabel.hidden = NO;
        self.huodongLabel.text = @"闪购";
    }else if ([task isUnitedTask]){
        self.huodongImage.hidden = NO;
        self.huodongLabel.hidden = NO;
        self.huodongLabel.text = @"联盟";
    }else if (type==999999){
        //普通任务
        self.huodongImage.hidden = YES;
        self.huodongLabel.hidden = YES;
    }else{
        self.huodongImage.hidden = NO;
        self.huodongLabel.hidden = NO;
        self.huodongLabel.text = @"活动";
    }

}

-(void)restoreForUnitTask{
    // 修改剩余积分
    NSArray* subviews = self.subviews;
    while (subviews.count==1) {
        UIView* sv = subviews[0];
        subviews = sv.subviews;
    }
    NSUInteger index = [subviews indexOfObject:self.lastScore];
    NSRange range = NSMakeRange(index-3, 4);
    NSArray* scoreLabels = [subviews subarrayWithRange:range];
    [scoreLabels[2] setText:@"剩余积分："];
}

-(void)adjustForUnitTask:(NSNumber *)reward{
    NSArray* subviews = self.subviews;
    while (subviews.count==1) {
        UIView* sv = subviews[0];
        subviews = sv.subviews;
    }
    NSUInteger index = [subviews indexOfObject:self.lastScore];
    NSRange range = NSMakeRange(index-3, 4);
    NSArray* scoreLabels = [subviews subarrayWithRange:range];
    // 设置总积分数值为 无上限
    // 修改剩余积分label 为 浏览奖励
    // 并且赋予值
    [self.totalScore setText:@"无上限"];
    [scoreLabels[2] setText:@"浏览奖励："];
    [self.lastScore setText:$str(@"%@",reward)];
}

-(void)updateImageLeftTop:(UIImage*)image{
    [self.imageLeftTop showme];
    [self.imageLeftTop setImage:image];
}

-(void)hideImageLeftTop{
    [self.imageLeftTop hidenme];
}

-(void)addImageLeftTop{
    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 75)];
    [self addSubview:image];
    self.imageLeftTop = image;
}

-(CGFloat)addBigRewards:(NSUInteger)type suffix:(NSString*)suffix yoffset:(CGFloat)yoffset{
    
    if (!self.rewards) {
        self.rewards = $marrnew;
    }
    if (!self.addBigRewardsViews) {
        self.addBigRewardsViews = $marrnew;
    }
    
    NSArray* types =@[@"转发",@"浏览"];
    //,@"外链"
    
    CGFloat height = 45.0f;
    CGFloat xwidth = 310.0f/(CGFloat)types.count;
    
    yoffset += 5+21;
    
    for (int i=0; i<types.count; i++) {
        UIImageView* iimage = [[UIImageView alloc]initWithFrame:CGRectMake(xwidth*i, 82+yoffset, xwidth, height)];
        iimage.image = [UIImage imageNamed:i==types.count-1?@"biaoge3右上":@"biaoge3左上"];
        [self.addBigRewardsViews addObject:iimage];
        [self addSubview:iimage];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(xwidth*i+1, 82+yoffset+4, xwidth-2, 20.0f)];
        [label setFont:[UIFont systemFontOfSize:13.0f]];
        [label setTextColor:[UIColor redColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:@"0"];
        [self.addBigRewardsViews addObject:label];
        [self addSubview:label];
        
        self.rewards[type*3+i] = label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(xwidth*i+1, 82+yoffset+21, xwidth-2, 20.0f)];
        [label setFont:[UIFont systemFontOfSize:11.0f]];
        [label setTextColor:[UIColor blackColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:$str(suffix,types[i])];
        [self.addBigRewardsViews addObject:label];
        [self addSubview:label];
    }
    UIImageView* iimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 82+yoffset+height, 310.0f, 2)];
    iimage.image = [UIImage imageNamed:@"cibg"];
    [self.addBigRewardsViews addObject:iimage];
    [self addSubview:iimage];
    return yoffset+height;
}

-(void)updateBigRewards:(NSUInteger)type send:(id)send browse:(id)browse link:(id)link{
    if (!self.rewards) {
        return;
    }
    if ([send isKindOfClass:[NSNumber class]]) {
        [self.rewards[type*3] setText:[send stringValue]];
    }else
        [self.rewards[type*3] setText:send];
    
    if ([browse isKindOfClass:[NSNumber class]]) {
        [self.rewards[type*3+1] setText:[browse stringValue]];
    }else
        [self.rewards[type*3+1] setText:browse];
    
//    if ([send isKindOfClass:[NSNumber class]]) {
//        [self.rewards[type*3+2] setText:[link stringValue]];
//    }else
//        [self.rewards[type*3+2] setText:link];
}


-(void)addRewards:(uint)type yoffset:(CGFloat)yoffset{
    UIImageView* iimage = [[UIImageView alloc]initWithFrame:CGRectMake(3, 82+yoffset, 108, 21)];
    iimage.image = [UIImage imageNamed:@"biaoge3左上"];
    [self addSubview:iimage];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(25, 82+yoffset, 66, 21)];
    label.font = [UIFont systemFontOfSize:9];
    label.text=type==0?@"转发总收益":@"昨日收益";
    [self addSubview:label];
    label = [[UILabel alloc]initWithFrame:CGRectMake(85, 82+yoffset, 26, 21)];
    label.font = [UIFont systemFontOfSize:9];
    label.textColor=[UIColor redColor];
    [self addSubview:label];
    if (type==0) {
        self.sendReward = label;
    }else{
        self.sendRewardYes = label;
    }
    
    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(111, 82+yoffset, 98, 21)];
    iimage.image = [UIImage imageNamed:@"biaoge3左上"];
    [self addSubview:iimage];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(119, 82+yoffset, 64, 21)];
    label.font = [UIFont systemFontOfSize:9];
    label.text=type==0?@"浏览总收益":@"昨日收益";
    [self addSubview:label];
    label = [[UILabel alloc]initWithFrame:CGRectMake(183, 82+yoffset, 28, 21)];
    label.font = [UIFont systemFontOfSize:9];
    label.textColor=[UIColor redColor];
    [self addSubview:label];
    if (type==0) {
        self.browseReward = label;
    }else{
        self.browseRewardYes = label;
    }
    
    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(211, 82+yoffset, 98, 21)];
    iimage.image = [UIImage imageNamed:@"biaoge3右上"];
    [self addSubview:iimage];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(223, 82+yoffset, 64, 21)];
    label.font = [UIFont systemFontOfSize:9];
    label.text=type==0?@"外链总收益":@"昨日收益";
    [self addSubview:label];
    label = [[UILabel alloc]initWithFrame:CGRectMake(283, 82+yoffset, 36, 21)];
    label.font = [UIFont systemFontOfSize:9];
    label.textColor=[UIColor redColor];
    [self addSubview:label];
    if (type==0) {
        self.linkReward = label;
    }else{
        self.linkRewardYes = label;
    }
    
    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(3, 102+yoffset, 306, 2)];
    iimage.image = [UIImage imageNamed:@"cibg"];
    [self addSubview:iimage];
}

-(CGFloat)addHeaderInfo{
    UIImageView* iimage;
    UILabel* label;
    
    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 75, 75)];
    iimage.image = [self.class DefaultImage];
    [self addSubview:iimage];
    self.image = iimage;
    
    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 75, 75)];
    iimage.image = [UIImage imageNamed:@"yuan_big"];
    [self addSubview:iimage];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(92, 15, 180, 21)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor darkGrayColor];
    [self addSubview:label];
    self.title = label;
    
    //    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(295, 100, 16, 10)];
    //    iimage.image = [UIImage imageNamed:@"jiantou_bigs"];
    //    [self addSubview:iimage];
    CGFloat yoffset = 8;
    
    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(92, 33+yoffset, 215, 2)];
    iimage.image = [UIImage imageNamed:@"cibg"];
    [self addSubview:iimage];
    
    
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(92, 41-15+yoffset, 218, 76)];
    //    label.backgroundColor = [UIColor blueColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = fmMainColor;
    label.numberOfLines = 4;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:label];
    self.info = label;
    
    return yoffset;
}


-(void)updateImage:(NSString*)url{
    if (self.lastRequest) {
        [self.lastRequest cancel];
        self.lastRequest = nil;
    }
    
    self.lastRequest =
    [[AppDelegate getInstance]downloadImage:url handler:^(UIImage *image, NSError *error) {
        self.image.image = image;
        self.lastRequest = nil;
    } asyn:YES];
}

-(void)updateHeaderInfo:(NSString*)title info:(NSString*)info{
    if ($safe(self.title) && $safe(title)) {
        [self.title setText:title];
    }
    
    if ($safe(self.info) && $safe(info)) {
        [self.info setText:info];
    }
}

-(CGFloat)addScoreInfo:(CGFloat)yoffset{
    yoffset += 17;
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(50, 82+yoffset, 60, 21)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor blackColor];
    label.text=@"总积分：";
    [self addSubview:label];
    label = [[UILabel alloc]initWithFrame:CGRectMake(95, 82+yoffset, 77, 21)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor blackColor];
    [self addSubview:label];
    self.totalScore = label;
    label = [[UILabel alloc]initWithFrame:CGRectMake(180, 82+yoffset, 65, 21)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor blackColor];
    label.text=@"剩余积分：";
    [self addSubview:label];
    label = [[UILabel alloc]initWithFrame:CGRectMake(240, 82+yoffset, 65, 21)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor blackColor];
    [self addSubview:label];
    self.lastScore = label;
    return yoffset;
}

-(void)updateScoreInfo:(id)total last:(id)last{
    if ($safe(self.totalScore) && $safe(total)) {
        if ([total isKindOfClass:[NSNumber class]]) {
            [self.totalScore setText:[total stringValue]];
        }else{
            [self.totalScore setText:total];
        }
    }
    
    if ($safe(self.lastScore) && $safe(last)) {
        if ([last isKindOfClass:[NSNumber class]]) {
            [self.lastScore setText:[last stringValue]];
        }else
            [self.lastScore setText:last];
    }
}

-(NSArray*)uisendWithSendInfos{
    if (!self.shareTypeImages) {
        return nil;
    }
    NSMutableArray* list = $marrnew;
    [list addObjectsFromArray:[self.shareTypeImages allValues]];
    [list $push:self.imgSendPic];
    [list $push:self.sendCount];
    return list;
}

-(NSArray*)uisendWithSendInfoAndTime{
    NSArray* subviews = self.subviews;
    while (subviews.count==1) {
        UIView* sv = subviews[0];
        subviews = sv.subviews;
    }
    
    NSUInteger index = [subviews indexOfObject:self.humanTime];
    if (index!=NSNotFound) {
        NSRange range = NSMakeRange(index-2, 3);
        NSArray* scoreLabels = [subviews subarrayWithRange:range];
        NSArray* uisendWithSendInfos=[self uisendWithSendInfos];
        if (!uisendWithSendInfos) {
            return scoreLabels;
        }
        NSMutableArray* list = $marrnew;
        [list addObjectsFromArray:scoreLabels];
        [list addObjectsFromArray:uisendWithSendInfos];
        return list;
    }
    return nil;
}

-(CGFloat)endWithSendInfoAndTime:(CGFloat)yoffset addRewards:(BOOL)addRewards sendInfo:(BOOL)sendInfo{
    //remove to else
    yoffset +=  21.0f;
    UIImageView* iimage = nil;
    //
    if (addRewards){
//        [self addRewards:0 yoffset:yoffset];
//        yoffset +=  21.0f;
//        [self addRewards:1 yoffset:yoffset];
        //
    }else{
        iimage = [[UIImageView alloc]initWithFrame:CGRectMake(3, 86+yoffset, 306, 2)];
        [iimage setTag:[@"endWithSendInfoAndTimecibg" hash]];
        iimage.image = [UIImage imageNamed:@"cibg"];
        [self addSubview:iimage];
        
        yoffset -= 21.0f;
    }
    
    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 115+yoffset, 12, 12)];
    iimage.image = [UIImage imageNamed:@"time"];
    [iimage setTag:[@"endWithSendInfoAndTimetime" hash]];
    [self addSubview:iimage];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(37, 110+yoffset, 157, 21)];
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = [UIColor darkGrayColor];
    [self addSubview:label];
    self.humanTime = label;
    
    //    label = [[UILabel alloc]initWithFrame:CGRectMake(239, 106+yoffset, 19, 21)];
    //    label.font = [UIFont systemFontOfSize:11];
    //    label.text=@"转发";
    //    [self addSubview:label];
    
    if (sendInfo) {
        NSArray* keys = [AppDelegate getInstance].shareTypes.allKeys;
        
        self.shareTypeImages = $mdictnew;
        
        CGFloat myx = 211;
        for (int i=keys.count-1; i>=0; i--) {
            NSString* fmtype = keys[i];
            //        TShareType type = (TShareType)[[AppDelegate getInstance].shareTypes[fmtype]intValue];
            iimage = [[UIImageView alloc]initWithFrame:CGRectMake(myx, 114+yoffset-1, 15, 15)];
            myx -= 16.0f;
            [self addSubview:iimage];
            self.shareTypeImages[fmtype] = iimage;
        }
        
        iimage = [[UIImageView alloc]initWithFrame:CGRectMake(231, 114+yoffset, 12, 11)];
        iimage.image = [UIImage imageNamed:@"zhuanfa"];
        [self addSubview:iimage];
        self.imgSendPic = iimage;
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(250, 110+yoffset, 65, 21)];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        self.sendCount = label;
    }
    
    return yoffset;
}

-(void)updateTime:(id)time andSendCount:(id)sendCount{
    if ($safe(self.humanTime) && $safe(time)) {
        if ([time isKindOfClass:[NSDate class]]) {
            [self.humanTime setText:[time fmHumenReadableString]];
        }else
            [self.humanTime setText:time];
    }
    
    if ($safe(self.sendCount) && $safe(sendCount)) {
        if ([sendCount isKindOfClass:[NSNumber class]]) {
            [self.sendCount setText:$str(@"%@人已转发",sendCount)];
        }else
            [self.sendCount setText:sendCount];
    }
}

-(void)updateSendList:(NSString*)sendlist{
    CGSize size = [self.sendCount.text sizeWithFont:self.sendCount.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [self.sendCount setFrame:CGRectMake(310.0f-size.width, self.sendCount.frame.origin.y, size.width+5.0f, self.sendCount.frame.size.height)];
    [self.imgSendPic setFrame:CGRectMake(self.sendCount.frame.origin.x-17.0f, self.imgSendPic.frame.origin.y, self.imgSendPic.frame.size.width, self.imgSendPic.frame.size.height)];
    CGFloat myx = self.imgSendPic.frame.origin.x-20.0f;
    NSArray* keys = [AppDelegate getInstance].shareTypes.allKeys;
    NSArray* sendList = [sendlist componentsSeparatedByString:@","];
    for (int i=keys.count-1; i>=0; i--) {
        NSString* fmtype = keys[i];
        UIImageView* iv = self.shareTypeImages[fmtype];
        [iv setFrame:CGRectMake(myx, iv.frame.origin.y, iv.frame.size.width, iv.frame.size.height)];
        myx -= 16.0f;
        BOOL send = [sendList containsObject:fmtype];
        TShareType type = (TShareType)[[AppDelegate getInstance].shareTypes[fmtype]intValue];
        iv.image = [ShareTool getClientImage:type enable:!send];
    }
}

-(void)appendTuzhang:(NSUInteger)type{
    UIImageView* iimage = [[UIImageView alloc]initWithFrame:CGRectMake(229, 0, 91, 72)];
    [self addSubview:iimage];
    self.tuzhang = iimage;
}

-(void)updateTuzhang:(NSUInteger)type hidden:(BOOL)hidden image:(UIImage*)image{
    [self.tuzhang setHidden:hidden];
    [self.tuzhang setImage:image];
}

-(void)appendTuzhangs:(CGFloat)yoffset{
//    UIImageView* iimage = nil;
//    if (type==UITaskCellTypeToSend){
//        iimage = [[UIImageView alloc]initWithFrame:CGRectMake(229, 0, 91, 72)];
//        iimage.hidden = YES;
//        [self addSubview:iimage];
//        self.tuzhang = iimage;
//        
//        iimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90.0f*0.75f, 75.0f*0.75f)];
//        iimage.image = [UIImage imageNamed:@"top"];
//        [self addSubview:iimage];
//        iimage.hidden = YES;
//        self.imageTop = iimage;
//        
//        //47.5
//        iimage = [[UIImageView alloc]initWithFrame:CGRectMake(55.0f, 10.0f, 30, 20)];
//        iimage.image = [UIImage imageNamed:@"task_huodong"];
//        [self addSubview:iimage];
//        iimage.hidden  = YES;
//        self.huodongImage = iimage;
//        
//        label = [[UILabel alloc] initWithFrame:CGRectMake(iimage.frame.origin.x, iimage.frame.origin.y, 30, 20)];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = [UIColor whiteColor];
//        label.font = [UIFont boldSystemFontOfSize:9.0f];
//        label.text = @"活动";
//        [self addSubview:label];
//        label.hidden = YES;
//        self.huodongLabel = label;
//    }else{
//        iimage = [[UIImageView alloc]initWithFrame:CGRectMake(200, 0, 118, 43)];
//        iimage.hidden = YES;
//        [self addSubview:iimage];
//        self.tuzhang = iimage;
//    }
}

-(void)updateTuzhangs{
//    
//    if (self.tuzhang && CGRectGetHeight(self.tuzhang.frame)==72.0f) {
//        //        BOOL isSend = [[AppDelegate getInstance]allShareTypeSent:task.sendList];
//        BOOL isSend = $safe(task.sendList) && task.sendList.length>0;
//        self.tuzhang.hidden = !(isSend || [task.lastScore intValue]==0);
//        if (isSend) {
//            self.tuzhang.image = [UIImage imageNamed:@"task_send_tag"];
//        }else if([task.lastScore intValue]==0){
//            self.tuzhang.image = [UIImage imageNamed:@"task_scoreover_tag"];
//        }
//    }
//    
//    if (self.tuzhang && CGRectGetHeight(self.tuzhang.frame)==43.0f) {
//        self.tuzhang.hidden = YES;
//        int status = [task.status intValue];
//        if (status==4 || status==5 || status==6) {
//            self.tuzhang.image = [UIImage imageNamed:@"task_tag_over"];
//            self.tuzhang.hidden = NO;
//        }else if (![task.isAccount boolValue]) {
//            self.tuzhang.image = [UIImage imageNamed:@"task_tag_not_account"];
//            self.tuzhang.hidden = NO;
//        }
//    }
//    
//    if (self.imageTop) {
//        self.imageTop.hidden = ![[AppDelegate getInstance] taskIsTop:task.taskId];
//    }
//    
//    BOOL isHuodong = [task.type intValue]!=999999;
//    self.huodongImage.hidden = !isHuodong;
//    self.huodongLabel.hidden = !isHuodong;
    
}

-(CGFloat)addSimpleInfoOneLine:(CGFloat)yoffset msg:(NSString*)msg p:(UILabel**)ptolabel{
    UILabel* label = [[UILabel alloc] init];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:13.0f]];
    [label setText:msg];
    CGSize size = [msg sizeWithFont:label.font];
    
    [label setFrame:CGRectMake(50, 107+yoffset, size.width, size.height)];
    [label setTag:[msg hash]];
    [self addSubview:label];
    
    label = [[UILabel alloc] init];
    [label setTextColor:[UIColor redColor]];
    [label setFont:[UIFont systemFontOfSize:13.0f]];
    [label setFrame:CGRectMake(50+size.width, 107+yoffset, 200, size.height)];
    [self addSubview:label];
    *ptolabel = label;
    yoffset += size.height;
    return yoffset;
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
