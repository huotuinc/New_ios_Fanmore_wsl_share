//
//  Task.m
//  Fanmore
//
//  Created by Cai Jiang on 1/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "Task.h"
#import "AppDelegate.h"

@interface Task ()

#ifdef FanmoreMockMall
@property BOOL randomAccounted;
@property BOOL randomType;
#endif

@end


@implementation Task

+(NSString*)ownerWorkhard:(NSString*)oriName dict:(NSDictionary*)dict class:(Class)class{
    static NSDictionary* tables;
    if (tables==Nil) {
        tables = @{@"awardBrowse":@"awardScan",@"publishTime":@"orderTime",@"myAwardBrowse":@"myAwardScan"};
    }
    NSString* target = tables[oriName];
    if ($safe(target) && $safe(dict[target])) {
        return target;
    }
    
    static NSDictionary* tables2;
    if (tables2==Nil) {
        tables2 = @{@"myAwardLink":@"awardLinkResult",@"myAwardSend":@"awardSendResult",@"myAwardBrowse":@"awardScanResult"};
    }
    
    target = tables2[oriName];
    if ($safe(target)) {
        return target;
    }
    
    static NSDictionary* tables3;
    if (tables3==Nil) {
        tables3 = @{@"sendCount":@"sendAmount"};
    }
    
    target = tables3[oriName];
    if ($safe(target)) {
        return target;
    }
    
    static NSDictionary* tables4;
    if (tables4==Nil) {
        tables4 = @{@"publishTime":@"date",@"taskName":@"desc",@"taskInfo":@"title",@"taskId":@"id"};
    }
    
    target = tables4[oriName];
    if ($safe(target)) {
        return target;
    }
    
    return nil;
}

+(void)hasMoreData:(Task*)model dict:(NSDictionary*)dict{
    //[3]	(null)	@"storeId" : (long)18
    id pk = dict[@"storeId"];
    if (model.store==Nil) {
        if ($safe(pk)) {
            model.store = [Store storeInPool:pk];
        }else{
            model.store =$new(Store);
        }
    }
    [Store modelFromDict:dict model:model.store];
}

@synthesize sendList;

@synthesize taskId;
@synthesize taskName;
@synthesize awardLink;
@synthesize awardBrowse;
@synthesize awardSend;
@synthesize endTime;
@synthesize startTime;
@synthesize publishTime;
@synthesize status;
@synthesize sendCount;
@synthesize type;
@synthesize taskInfo;
@synthesize taskPreview;
@synthesize taskSmallImgUrl;
//@synthesize storeName;
@synthesize awardDes;
@synthesize taskDes;
#pragma mark details
@synthesize lastScore;
@synthesize totalScore;
@synthesize ruleDes;
//@synthesize storeLargeImgURL;
//@synthesize openID;
//@synthesize storeID;
@synthesize taskLargeImgUrl;
#pragma mark my details
@synthesize myAwardLink;
@synthesize myAwardSend;
@synthesize myAwardBrowse;
//@synthesize isFav;
//@synthesize isSend;
@synthesize store;

@synthesize awardYesLinkResult;
@synthesize awardYesScanResult;
@synthesize awardYesSendResult;
@synthesize isAccount;

@synthesize partInAutoId;


@synthesize totalScanCount;
@synthesize yesScanCount;
@synthesize totalAmount;
@synthesize todayBrowseAmount;

@synthesize flagShowSend;
@synthesize flagHaveIntro;
@synthesize flagLimitCount;

@synthesize extraDes;
@synthesize rebate;

@synthesize online;

-(NSString*)getRebateMsg{
    if ([self isFlashMall]) {
#ifdef FanmoreDebug
        return @"好友购买成功，返利销售额10%到您粉猫账户";
#endif
        return self.rebate;
    }
    return nil;
}


-(BOOL)isReallyAccounted{
#ifdef FanmoreMockMall
    if (!self.randomAccounted) {
        self.randomAccounted = YES;
        self.isAccount = $bool(random()%2==0);
        if (![self.isAccount boolValue]) {
            self.status = $int(0);
        }
    }
#endif
    return [self.isAccount boolValue];
}

-(BOOL)isUnitedTask{
#ifdef FanmoreMockUnited
    return [self.taskId longValue]==FanmoreMockUnited;
#endif
    return $safe(self.type) && [self.type intValue]==1001000;
}

-(BOOL)isFlashMall{
#ifdef FanmoreMockMall
    if (!self.randomType) {
        self.randomType = YES;
        if (random()%2==0) {
            self.type = $int(1000300);
        }
    }
#endif
    return $safe(self.type) && [self.type intValue]==1000300;
}


-(BOOL)zeroReward{
    if ($safe(self.type) && [self.type intValue]==1000100) {
        return YES;
    }
    return NO;
}

-(BOOL)notbeAbletoSend{
    if ($safe(self.type) && [self.type intValue]==1000100) {
        return YES;
    }
    
    if ($safe(self.flagShowSend)){
        return [self.flagShowSend intValue]==0;
    }
    
    return NO;
}

-(BOOL)previewFirst{
    if ($safe(self.flagHaveIntro)){
        return [self.flagHaveIntro intValue]==0;
    }
    if ($safe(self.type) && [self.type intValue]==1000100) {
        return YES;
    }
    
    return NO;
}

-(BOOL)nolimitToSend{
    if ([self isUnitedTask]) {
        return true;
    }
    if ([self isFlashMall]) {
        return true;
    }
    return self.flagLimitCount && [self.flagLimitCount intValue]==0;
}

-(ShareMessage*)toShare:(UIImage*)input{
    ShareMessage* m = $new(ShareMessage);
    m.title = self.taskName;
    m.smdescription = self.taskName;
    m.url = self.taskInfo;
    m.thumbImageURL = self.taskLargeImgUrl;
//    
//    CGSize size = CGSizeMake(40, 40);
//    UIGraphicsBeginImageContext(size);
//    
//    // 绘制改变大小的图片
//    [self.largeImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    
//    // 从当前context中创建一个改变大小后的图片
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    // 使当前的context出堆栈
//    UIGraphicsEndImageContext();
    
    m.thumbImage = input;
    return m;
}

-(CacheResource*)largeImageCache{
    return [CacheResource cacheByTime:$str(@"task--%@---%@",self.taskId,self.taskName) time:2*60*60];
}

-(void)checkLargeImg:(void (^)(UIImage*))callback{
//    self.largeImgURL =@"http://192.168.1.208:97/uploadfile/taskimg/075a8286d6634c8ea710c8f2758c55d4_320X320.jpg";
    if ($safe(self.taskLargeImgUrl)){
        [[AppDelegate getInstance]downloadImage:self.taskLargeImgUrl handler:^(UIImage *image, NSError *error) {
            callback(image);
        } asyn:YES resource:[self largeImageCache]];
    }else{
        callback(nil);
    }
}

-(BOOL)isEqual:(id)other{
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    Task* task = other;
    if (task.taskId && !$eql(task.taskId,self.taskId)) {
        return NO;
    }
    if (task.taskName && !$eql(self.taskName,task.taskName)) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = 7290;
    hash += [[self taskId] hash];
    hash += [[self taskName] hash];
    return hash;
}

@synthesize advancedseconds;

@end
