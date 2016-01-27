//
//  NotifyCell.m
//  Fanmore
//
//  Created by Cai Jiang on 9/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "NotifyCell.h"

#ifdef FanmoreDebug

@implementation NSMutableDictionary (NotifyCell)

-(void)setNotifyId:(NSNumber *)id{
    self[@"id"] = id;
}

-(void)setNotifyTaskId:(NSNumber *)id{
    self[@"taskId"] = id;
}


-(void)setNotifyTaskStatus:(NSNumber *)id{
    self[@"taskStatus"] = id;
}


-(void)setNotifyType:(NSNumber *)id{
    self[@"type"] = id;
}


-(void)setNotifyDesc:(NSString *)id{
    self[@"des"] = id;
}


-(void)setNotifyTime:(NSString *)id{
    self[@"time"] = id;
}


-(void)setNotifyTitle:(NSString *)id{
    self[@"title"] = id;
}


-(void)setNotifyWebUrl:(NSString *)id{
    self[@"webUrl"] = id;
}

@end

#endif

@implementation NSDictionary (NotifyCell)

//taskid = 0;
////	            type = 1;
////	            url = "http://www.baidu.com";


-(NSString*)getNotifyTime{
    return self[@"time"];
}

-(NSString*)getNotifyDesc{
    return self[@"des"];
}
-(NSString*)getNotifyTitle{
    return self[@"title"];
}
-(NSString*)getNotifyWebUrl{
    id tid = self[@"url"];
    if (tid) {
        return tid;
    }
    return self[@"webUrl"];
}
-(NSNumber*)getNotifyID{
    return self[@"id"];
}
-(NSNumber*)getNotifyTaskId{
    id tid = self[@"taskid"];
    if (tid) {
        return tid;
    }
    return self[@"taskId"];
}
-(NSNumber*)getNotifyTaskStatus{
    return self[@"taskStatus"];
}
-(NSNumber*)getNotifyType{
    //notify也是type
    return self[@"type"];
}

@end

@implementation NotifyCell

-(void)config:(NSDictionary *)data{
    [self.labelTitle setText:[data getNotifyTitle]];
    [self.labelDesc setText:[data getNotifyDesc]];
    [self.labelTime setText:[data getNotifyTime]];
    
    if ([[data getNotifyType] intValue]==0) {
        [self.labelTitle setTextColor:[UIColor redColor]];
        [self.imageTop showme];
        
        switch ([[data getNotifyTaskStatus] intValue]) {
            case 0:
                [self.imageTop setImage:[UIImage imageNamed:@"yishangxian"]];
                break;
            case 1:
                [self.imageTop setImage:[UIImage imageNamed:@"yugao"]];
                break;
            case 2:
                [self.imageTop setImage:[UIImage imageNamed:@"xiajia"]];
                break;
            default:
                break;
        }
        
    }else{
        [self.labelTitle setTextColor:[UIColor blackColor]];
        [self.imageTop hidenme];
    }
}

@end
