//
//  HttpFanOperations.m
//  Fanmore
//
//  Created by Cai Jiang on 2/18/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "HttpFanOperations.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "HTTPRequestMoniter.h"
#import "UIDevice+IdentifierAddition.h"
#import "AppDelegate.h"
#import "NSString+SSToolkitAdditions.h"
#import "NSString+Fanmore.h"
#import "SendRecord.h"
#import "ScoreFlow.h"
#import "SecureHelper.h"
#import "ScorePerDay.h"
#import <AdSupport/AdSupport.h>
#import "LocatedHelper.h"
#ifdef FanmoreMockNotify
#import "NotifyCell.h"
#endif
#ifdef FanmoreMockRanking
#import "RankingCell.h"
#endif
#ifdef FanmoreMockMaster
#import "FollowerCell.h"
#import "ContributionCell.h"
#import "ContributionPerFollowerCell.h"
#endif
#import "NSObject+JSON.h"
#import "ExpReceiveView.h"
#import "UserInfo.h"


@interface HttpFanOperations ()

@property NSTimeInterval timeToSV;

@property NSString* rootURL;
@property NSString* imei;
-(void)doConnect:(id<FanOpertationDelegate>)delegate interface:(NSString*)interface errorBlocker:(void (^)(NSError*))errorBlocker resultBlocker:(void (^)(id))resultBlocker parameters:(NSDictionary*)parameters urlBlocker:(void (^)(NSMutableString*))urlBlocker;
-(void)doConnect:(id<FanOpertationDelegate>)delegate interface:(NSString*)interface errorBlocker:(void (^)(NSError*))errorBlocker resultBlocker:(void (^)(id))resultBlocker parameters:(NSDictionary*)parameters;
-(void)loginCode:(NSMutableDictionary*)p;
-(NSDictionary*)toDic:(NSArray*)nameandvalue;

@end

@implementation HttpFanOperations

#pragma mark 用户

-(void)updateUserInfo:(id<FanOpertationDelegate>)delegate block:(void (^)(NSString*,NSError*))block user:(UserInformation*)user{
    NSMutableDictionary* p = $mdictnew;
    [self loginCode:p];
    if ($safe(user.name)) {
        p[@"name"] = user.name;
    }else{
        p[@"name"] = @"";
    }
    if ($safe(user.sex)) {
        p[@"sex"] = user.sex;
    }
    if ($safe(user.birth)) {
        p[@"birth"] = [user.birth fmStandStringDateOnly];
    }
    if ($safe(user.industryId)) {
        p[@"industry"] = user.industryId;
    }else{
        p[@"industry"] = @"";
    }
    if ($safe(user.incomeId)) {
        p[@"income"] = user.incomeId;
    }else{
        p[@"income"] = @"";
    }
    if ($safe(user.favoritesStr) && !$eql(user.favoritesStr,@"未知")) {
        p[@"favorite"] = user.favoritesStr;
    }else{
        p[@"favorite"] = @"";
    }
    
    [self doConnect:delegate interface:@"UpdateUserInfo" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        block(data,nil);
    } parameters:p];
}

-(void)userInfo:(id<FanOpertationDelegate>)delegate block:(void (^)(UserInformation*,NSError*))block{
    NSMutableDictionary* p = $mdictnew;
    [self loginCode:p];
    [self doConnect:delegate interface:@"UserInfo" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSDictionary* data) {
        //{"resultCode":1,"description":"成功","status":1,"resultData":{"phone":"15088659764","name":"爸爸","sex":2,"birth":"1960-01-01 00-00-00","industryId":0,"industry":"未知","favoriteId":"0","favorite":"","incomeId":0,"income":"未知","areaId":0,"area":"未知","industryList":[{"value":"1","name":"计算机软件/硬件"},{"value":"2","name":"互联网/电子商务"},{"value":"3","name":"服务行业"},{"value":"4","name":"服务行业"},{"value":"5","name":"医疗"},{"value":"6","name":"市场推广"},{"value":"7","name":"房产"},{"value":"9","name":"外包服务"},{"value":"10","name":"酒店"},{"value":"11","name":"美容"},{"value":"12","name":"电力"},{"value":"13","name":"农业"},{"value":"13","name":"其他"}],"favoriteList":[{"value":"1","name":"阅读"},{"value":"2","name":"运动"},{"value":"3","name":"购物"},{"value":"4","name":"饮食"},{"value":"5","name":"旅游"},{"value":"6","name":"音乐"},{"value":"7","name":"饮茶"},{"value":"8","name":"影视"}],"incomeList":[{"value":"1","name":"2000以下"},{"value":"2","name":"2000-4000"},{"value":"3","name":"4000-6000"},{"value":"4","name":"6000-8000"},{"value":"5","name":"8000-10000"},{"value":"6","name":"10000-20000"},{"value":"7","name":"20000以上"}]},"tip":"操作成功"}
        UserInformation* ui = [UserInformation modelFromDict:data];
        AppDelegate* ad = [AppDelegate getInstance];
        ad.favoriteList = [self toDic:data[@"favoriteList"]];
        ad.incomeList = [self toDic:data[@"incomeList"]];
        ad.industryList = [self toDic:data[@"industryList"]];        
        [AppDelegate getInstance].currentUser = ui;
        block(ui,nil);
    } parameters:p];
}

-(void)registerUser:(id<FanOpertationDelegate>)delegate block:(void (^)(LoginState*,NSError*))block userName:(NSString*)userName password:(NSString*)password code:(NSString*)code invitationCode:(NSString*)invitationCode{
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:WXQAuthBringBackUserInfo];
    UserInfo * user = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
//    parame[@"sex"] = [NSString stringWithFormat:@"%ld",(long)[user.sex integerValue]];
    parame[@"nickname"] = user.nickname;
    parame[@"openid"] = user.openid;
//    parame[@"city"] = user.city;
//    parame[@"country"] = user.country;
//    parame[@"province"] = user.province;
    parame[@"picUrl"] = user.headimgurl;
    parame[@"unionId"] = user.unionid;
    parame[@"invitationCode"] = invitationCode;
    
//    if (userName==Nil) {
//        userName = @"";
//    }
//    if(password==Nil){
//        password = @"";
//    }
//    if(code==Nil){
//        code = @"";
//    }
//    if(invitationCode==Nil){
//        invitationCode = @"";
//    }
//    NSDictionary* p = @{@"userName":userName,
//                        @"pwd":[password MD5Sum],
//                        @"code":code,
//                        @"invitationCode":invitationCode};
    
    [self doConnect:delegate interface:@"register" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSDictionary *data) {
        NSString * passwd =  data[@"loginCode"];
        NSArray * arra =  [passwd componentsSeparatedByString:@"^"];
        LOG(@"-----Userregister--%@",data);
        LOG(@"xxxx---%@---%@",data[@"userName"],arra[1]);
        [self login:delegate block:block userName:data[@"userName"] password:arra[1]];
    } parameters:parame];
}

-(void)register:(id<FanOpertationDelegate>)delegate block:(void (^)(LoginState*,NSError*))block userName:(NSString*)userName password:(NSString*)password code:(NSString*)code{
    if (userName==Nil) {
        userName = @"";
    }
    if(password==Nil){
        password = @"";
    }
    if(code==Nil){
        code = @"";
    }
    NSDictionary* p = @{@"userName":userName,@"pwd":[password MD5Sum],@"code":code};
    
    [self doConnect:delegate interface:@"register" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSDictionary *data) {
        [self login:delegate block:block userName:userName password:password];
    } parameters:p];
}

-(void)getUserTodayBrowseCount:(id<FanOpertationDelegate>)delegate block:(void(^)(NSNumber*,NSError*))block{
    NSMutableDictionary* p = $mdictnew;
    [self loginCode:p];
    [self doConnect:delegate interface:@"GetUserTodayBrowseCount" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSNumber* data) {
        AppDelegate* ad = [AppDelegate getInstance];
        ad.loadingState.userData.todayBrowseCount = data;
        block(data,nil);
    } parameters:p];
}

-(void)login:(id<FanOpertationDelegate>)delegate block:(void (^)(LoginState*,NSError*))block userName:(NSString*)userName password:(NSString*)password{
    if (userName==Nil) {
        userName = @"";
    }
    if(password==Nil){
        password = @"";
    }
    
    NSDictionary* p = @{
                        @"userName":userName,
                        @"pwd":password
//                        ,
//                        @"latitude":$double(c2d.latitude),
//                        @"longitude":$double(c2d.longitude)
                        };
    
    
    [self doConnect:delegate interface:@"Login" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSDictionary *data) {
        LOG(@"---%@",data);
        LoginState* ls = [LoginState modelFromDict:data];        
        AppDelegate* ad = [AppDelegate getInstance];
        [ad.loadingState loginAs:ls];
        [ad storeLastUserInformation:userName password:password];
        [self userInfo:Nil block:^(UserInformation *ui, NSError *error) {
            block(ls,error);
        }];
    } parameters:p];

}

#pragma mark 任务

-(void)turnTask:(id<FanOpertationDelegate>)delegate block:(void (^)(NSString*,NSError*))block task:(Task*)task type:(TShareType)type{
    NSNumber* fmtype = [[AppDelegate getInstance] fromShareType:type];
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"taskId":task.taskId,@"type":fmtype}];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"TurnTask" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSString* data) {
        
        LOG(@"ssss%@---",data);
        LoginState* ls = [AppDelegate getInstance].loadingState.userData;
        
//        task.isSend = @1;
        if (task.sendList==nil || task.sendList.length==0) {
            if (![task nolimitToSend]) {
                ls.turnAmount = $int([ls.turnAmount intValue]+1);
            }
            
            if (![task nolimitToSend] && [task.lastScore floatValue]>0) {
                ls.completeTaskCount = $int([ls.completeTaskCount intValue]+1);
            }
            
            task.sendList = [fmtype stringValue];
        }else{
            task.sendList = $str(@"%@,%@",task.sendList,fmtype);
        }
        
        // 执行task detail
        [self detailTask:nil block:^(NSArray *nnlist, NSError *nnerror) {
            block(data,nil);
        } task:task];
        
    } parameters:p];
}

-(void)detailTask:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray*,NSError*))block task:(Task*)task{
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"taskId":task.taskId}];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"TaskDetail" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSDictionary *data) {
        [Task modelFromDict:data model:task];
        NSArray* jsonArray = data[@"sendData"];
        NSMutableArray* sent = $marrnew;
        for (int i=0; i<jsonArray.count; i++) {
            sent[i] = [SendRecord modelFromDict:jsonArray[i]];
        }
        block(sent,nil);
    } parameters:p];
}

-(void)listFlashMallTask:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray* list,NSError* error))block paging:(Paging*)paging{
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    [self loginCode:p];
    [paging toParameters:p];
    
    [self doConnect:delegate interface:@"FlashMallTask" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSDictionary *data) {
        //todayTotalScore
        NSArray* jsonTasks = data[@"taskData"];
        NSMutableArray* tasks = $marrnew;
        for (int i=0; i<jsonTasks.count; i++) {
            tasks[i] = [Task modelFromDict:jsonTasks[i]];
        }
        block(tasks,Nil);
    } parameters:p];
}

-(void)listTask:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray*,NSError*))block screenType:(uint)screenType  paging:(Paging*)paging{
    //NSDictionaryOfVariableBindings
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"screenType":$int(screenType)}];
    [self loginCode:p];
    [paging toParameters:p];
    
    [self doConnect:delegate interface:@"AllTasK220" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSDictionary *data) {
        //todayTotalScore
        NSArray* jsonTasks = data[@"taskData"];
        NSNumber* tts = data[@"todayTotalScore"];
        NSString* topIds=data[@"topIds"];
        if ($safe(topIds)) {
            NSArray* _ids =[topIds componentsSeparatedByString:@","];
            if(_ids.count>0 && !$eql(_ids[0],@""))
                [AppDelegate getInstance].topTaskIds =_ids;
        }
        
        if ($safe(tts) && [tts floatValue]>0) {
            [AppDelegate getInstance].loadingState.todayTotalScore = tts;
//            [AppDelegate getInstance].todayTotalScore = tts;
//            LOG(@"todayTotalScore %@",tts);
        }
        NSMutableArray* tasks = $marrnew;
        for (int i=0; i<jsonTasks.count; i++) {
            tasks[i] = [Task modelFromDict:jsonTasks[i]];
        }
        block(tasks,Nil);
    } parameters:p];
}

-(void)listPartTask:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray*,NSError*))block  type:(uint)type  paging:(Paging*)paging{
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"type":$int(type)}];
    [self loginCode:p];
    [paging toParameters:p];
    
    [self doConnect:delegate interface:@"MyPartake" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSArray *jsonTasks) {
        NSMutableArray* tasks = $marrnew;
        for (int i=0; i<jsonTasks.count; i++) {
            tasks[i] = [Task modelFromDict:jsonTasks[i]];
        }
        block(tasks,Nil);
    } parameters:p];
}

-(void)scoreFlow:(id<FanOpertationDelegate>)delegate block:(void (^)(NSNumber* browseCount,NSNumber* linkCount,NSNumber* scoreCount,NSNumber* totalScore,NSArray* flows,NSError* error))block task:(Task*)task  type:(uint)type  paging:(Paging*)paging{
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"type":$int(type),@"taskId":task.taskId}];
    [self loginCode:p];
    [paging toParameters:p];
    
    [self doConnect:delegate interface:@"ScoreFlow" errorBlocker:^(NSError *error) {
        block(nil,nil,nil,nil,nil,error);
    } resultBlocker:^(NSDictionary* dict) {
        NSArray* jsons = dict[@"operationList"];
        NSMutableArray* tasks = $marrnew;
        for (int i=0; i<jsons.count; i++) {
            tasks[i] = [ScoreFlow modelFromDict:jsons[i]];
        }
        block(dict[@"browseCount"],dict[@"linkCount"],dict[@"scoreCount"],dict[@"totalScore"],tasks,Nil);
    } parameters:p];
}

-(void)TotalScoreList:(id<FanOpertationDelegate>)delegate block:(void (^)(NSNumber* totalScore,NSNumber* totalCount,NSNumber* maxScore,NSNumber* minScore,NSArray* list,NSError* error))block date:(NSDate*)date{
    
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"pageSize":$int(10)}];
    if (date) {
        p[@"date"] = [date fmToString];
    }else{
        p[@"date"] = @"";
    }
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"TotalScoreList" errorBlocker:^(NSError *error) {
        block(nil,nil,nil,nil,nil,error);
    } resultBlocker:^(NSDictionary* dict) {
        NSArray* list =dict[@"itemData"];
        NSMutableArray* mlist = $marrnew;
        for (NSDictionary* d in list) {
            ScorePerDay* day = $new(ScorePerDay);
            day.time = [d[@"date"] fmToDate];
            day.browse = d[@"browseAmount"];
            day.comments = d[@"extra"];//^
#ifdef FanmoreDebug
            NSMutableString* buffer = [NSMutableString string];
            int count = random()%4;
            for (int i=0; i<count; i++) {
                //1-10
                int numbers = random()%10+1;
                while (numbers-->0) {
                    [buffer appendString:@"囧"];
                }
                if (i<count-1) {
                    [buffer appendString:@"^"];
                }
            }
            if (!$safe(day.comments) || day.comments.length==0) {
                day.comments = buffer;
            }
#endif
            day.score = d[@"totalScore"];
            [mlist $push:day];
        }
        block(dict[@"totalScore"],dict[@"totalCount"],dict[@"maxScore"],dict[@"minScore"],mlist,nil);
    } parameters:p];
}

-(void)TotalScoreDay:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray* list,NSError* error))block date:(NSDate*)date{
 
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"type":$int(date?2:1)}];
    if (date) {
        p[@"date"] = [date fmToString];
    }else{
        p[@"date"] = @"";
    }
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"TotalScoreDay" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSArray* list) {
#ifdef FanmoreDebug
        if (list.count>0) {
            NSMutableArray* nlist = $marrnew;
            [nlist $push:@{@"id": @-1,@"type":@1,@"title":@"赏你的",@"description":@"说赏你就赏你，啰嗦甚",@"imageUrl":@"http://pic23.nipic.com/20120817/10145548_145019514130_2.png",@"date":@"2014-6-19 11-11-11",@"totalScore":@200}];
            [nlist addObjectsFromArray:list];
            block(nlist,Nil);
            return;
        }
#endif
        block(list,Nil);
    } parameters:p];
}

-(void)NewScoreFlow:(id<FanOpertationDelegate>)delegate block:(void (^)(NSNumber* browseCount,NSNumber* linkCount,NSNumber* dayScore,NSNumber* totalScore,NSArray* list,NSError* error))block taskid:(NSNumber*)taskid date:(NSDate*)date type:(uint)type  paging:(Paging*)paging{
    
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"type":$int(type),@"taskId":taskid}];
    if (date) {
        p[@"date"]= [date fmToString];
    }else{
        p[@"date"] = @"";
    }
    [self loginCode:p];
    [paging toParameters:p];
    
    [self doConnect:delegate interface:@"NewScoreFlow" errorBlocker:^(NSError *error) {
        block(nil,nil,nil,nil,nil,error);
    } resultBlocker:^(NSDictionary* dict) {
        NSArray* jsons = dict[@"operationList"];
        NSMutableArray* tasks = $marrnew;
        for (int i=0; i<jsons.count; i++) {
            tasks[i] = [ScoreFlow modelFromDict:jsons[i]];
        }
        block(dict[@"browseCount"],dict[@"linkCount"],dict[@"dayScore"],dict[@"totalScore"],tasks,Nil);
    } parameters:p];
}

-(void)TodayBrowseList:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray* list,NSError* error))block paging:(Paging*)paging{
    NSMutableDictionary* p = [[NSMutableDictionary alloc] init];
    [self loginCode:p];
    [paging toParameters:p];
    
    [self doConnect:delegate interface:@"TodayBrowseList" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSArray* jsonTasks) {
        
        LOG("TodayBrowseList---%@",jsonTasks);
        NSMutableArray* tasks = $marrnew;
        for (int i=0; i<jsonTasks.count; i++) {
            tasks[i] = [Task modelFromDict:jsonTasks[i]];
        }
        block(tasks,Nil);
    } parameters:p];
}

#pragma mark 其他

-(void)feedbackList:(id<FanOpertationDelegate>)delegate block:(void(^)(NSArray*,NSError*))block paging:(Paging*)paging{
    NSMutableDictionary* p = $mdictnew;
    [self loginCode:p];
    [paging toParameters:p];
    
    [self doConnect:delegate interface:@"FeedbackList" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSArray* jsonTasks) {
        block(jsonTasks,Nil);
    } parameters:p];
}

-(void)feedback:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block name:(NSString*)name contact:(NSString*)contact content:(NSString*)content{
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"name":name,@"contact":contact,@"content":content}];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"Feedback" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        block(data,nil);
    } parameters:p];
}

-(void)UpdatePushToken:(id<FanOpertationDelegate>)delegate block:(void (^)(NSError* error))block token:(NSString*)token{
    [self doConnect:delegate interface:@"UpdatePushToken" errorBlocker:block resultBlocker:^(id a) {
        block(nil);
    } parameters:@{@"token": token}];
}


//luohaibo 2015/12/8

-(void)loading:(id<FanOpertationDelegate>)delegate block:(void (^)(UIImage*,NSError*))block userName:(NSString*)userName password:(NSString*)password{
    //[self fakeTimeCost:delegate];
    [delegate foStartSpin];
//    userName = @"user2";
    if (userName==Nil) {
        userName = @"";
    }
    if(password==Nil){
        password = @"";
    }
//    password = @"111111";
    CGSize size = [UIScreen mainScreen].bounds.size;
    LOG(@"xxxxxx %f,%f",size.width,size.height);
//luohaibo 2015/12/8
    NSDictionary* p = @{
                        @"userName":userName,
                        @"pwd":password,
                        @"width":$float(size.width),
                        @"height":$float(size.height)
//                        ,
//                        @"latitude":$double(c2d.latitude),
//                        @"longitude":$double(c2d.longitude)
                        };
    
//    NSDictionary* p = @{@"userName":userName,@"pwd":[password MD5Sum]};
    
    //user2 111111
    [self doConnect:delegate interface:@"init" errorBlocker:^(NSError *error) {
        block(nil,error);
        [delegate foStopSpin];
    } resultBlocker:^(NSDictionary *data) {
        LoadingState* ls = [AppDelegate getInstance].loadingState;
        if (!$safe(ls)) {
            ls = $new(LoadingState);
            [AppDelegate getInstance].loadingState = ls;
        }
        [LoadingState modelFromDict:data model:ls];
        //luohaibo 2015/12/8
//        NSString *documentsDirectory= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSString * file = [documentsDirectory stringByAppendingPathComponent:@"initDate"];
//        [NSKeyedArchiver archiveRootObject:ls toFile:file];
//        NSLog(@"%@-----%@",ls,ls.loginStatus);
        
//        NSMutableArray* arry = [NSMutableArray array];
//        
//        LOG([data[@"checkExps"] class]);
//        for (NSString* abc in [data[@"checkExps"] componentsSeparatedByString:@"|"]) {
//            [arry addObject:abc];
//        }
//        
//        ls.checkinExps = [NSMutableArray arrayWithArray:arry];
        
        NSArray* groups = data[@"groups"];
#ifdef FanmoreDebug
        if (!groups) {
            groups = @[@{@"name": @"全部",@"type":@0},@{@"name": @"大话西游",@"type":@1},@{@"name": @"魂断红楼",@"type":@2},@{@"name": @"水浒立志传",@"type":@3},];
        }
#endif
        ls.groups = groups;
//        if ($safe(ls.todayTotalScore) && [ls.todayTotalScore intValue]>0) {
//            [AppDelegate getInstance].todayTotalScore = ls.todayTotalScore;
//            LOG(@"todayTotalScore:%@",[AppDelegate getInstance].todayTotalScore);
//        }
#ifdef FanmoreDebug
        ls.loadingImg.imgUrl = @"http://www.fanmore.cn/images/xiangxifdd.jpg";
//        ls.loadingImg.showTime = @"2014-01-01,2014-03-15";
#endif
        
        [[AppDelegate getInstance] storeLastImageShowtime:ls.loadingImg.showTime];
        //channelList
        [[AppDelegate getInstance] setupShareTypes:[data[@"channelList"] componentsSeparatedByString:@","] toShare:[NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:$str(@"%@/iossharetypes.txt2",self.rootURL)]]];
        //http://192.168.0.208:99/iossharetypes.txt
        
//        LOG(@"%@ %@ %@",ls.taskLinkScore,ls.taskBrowseScore,ls.taskTurnScore);
        [[AppDelegate getInstance] storeUpdateURL:ls.updateURL];
        NSNumber* updateType = data[@"updateType"];
        if ([updateType intValue]==3 || [updateType intValue]==4) {
            [AppDelegate getInstance].forceUpdate = YES;
        }
#if FanmoreDebugForceUpdate
        [AppDelegate getInstance].forceUpdate = YES;
#endif
        
        NSString* weixinKey = data[@"weixinKey"];
        if ($safe(weixinKey) && weixinKey.length>3) {
            [[AppDelegate getInstance] newWeixinKey:weixinKey];
        }
        
        [[AppDelegate getInstance] apiLoading];
                
        if ([[AppDelegate getInstance].loadingState hasLogined]) {
            [self userInfo:Nil block:^(UserInformation *uuu, NSError *rrrr) {
            }];
        }
        
        if ($safe(ls.loadingImg.imgUrl) && ls.loadingImg.imgUrl.length>8) {
            [[AppDelegate getInstance] downloadImage:ls.loadingImg.imgUrl handler:^(UIImage *image, NSError *err) {
                block(image,nil);
                [delegate foStopSpin];
            } asyn:YES resource:[ls.loadingImg imageCache]];
        }else{
            block(nil,nil);
            [delegate foStopSpin];
        }
//        block(ls,nil);
        
        
        
    } parameters:p];
}


#pragma mark -- fav store

-(void)myFavoriteStoreList:(id<FanOpertationDelegate>)delegate block:(void(^)(NSArray*,NSError*))block  paging:(Paging*)paging{
    NSMutableDictionary* p = $mdictnew;
    [self loginCode:p];
    [paging toParameters:p];
    
    [self doConnect:delegate interface:@"MyFavoriteStoreList" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSArray* jsonTasks) {
        NSMutableArray* tasks = $marrnew;
        for (int i=0; i<jsonTasks.count; i++) {
            //key	__NSCFString *	@"id"	0x0b855eb0
            NSDictionary* json = jsonTasks[i];
            Store* st = [Store storeInPool:json[@"id"]];
            tasks[i] = [Store modelFromDict:json model:st];
            st.fav = @1;
        }
        block(tasks,Nil);
    } parameters:p];
}

-(void)myFavoriteTaskDetail:(id<FanOpertationDelegate>)delegate block:(void(^)(NSArray*,NSError*))block  store:(Store*)store paging:(Paging*)paging{
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"storeId":store.id}];
    [self loginCode:p];
    [paging toParameters:p];
    
    [self doConnect:delegate interface:@"MyFavoriteTaskDetail" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSDictionary *data) {
        NSDictionary* storeInfo = data[@"storeInfo"];
        [Store modelFromDict:storeInfo model:store];
        NSArray* taskData = data[@"taskData"];
        
        NSMutableArray* tasks = $marrnew;
        for (int i=0; i<taskData.count; i++) {
            tasks[i] = [Task modelFromDict:taskData[i]];
        }
        block(tasks,Nil);
    } parameters:p];
}

-(void)operFavorite:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block store:(Store*)store{
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"storeId":store.id,@"type":[store.fav boolValue]?@1:@0}];
    [self loginCode:p];
    [self doConnect:delegate interface:@"OperFavorite" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSString *data) {
        LoginState* ls = [AppDelegate getInstance].loadingState.userData;
        if ([store.fav boolValue]) {
            store.fav = @0;
            ls.favoriteAmount = $int([ls.favoriteAmount intValue]-1);
        }else{
            store.fav = @1;
            ls.favoriteAmount = $int([ls.favoriteAmount intValue]+1);
        }
        block(data,Nil);
    } parameters:p];

}

#pragma mark 安全

-(void)verificationCode:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block phone:(NSString*)phone type:(NSNumber*)type{
    if ([NSDate timeIntervalSinceReferenceDate]-self.timeToSV<5) {
        return;
    }
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"type":type,@"phone":phone}];
    [self loginCode:p];
    self.timeToSV = [NSDate timeIntervalSinceReferenceDate];
    [self doConnect:delegate interface:@"VerificationCode" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        block(nil,nil);
    } parameters:p];
}
-(void)bindAlipay:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block phone:(NSString*)phone alipayAccount:(NSString*)alipayAccount alipayName:(NSString*)alipayName code:(NSString*)code{
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"phone":phone,@"alipayAccount":alipayAccount,@"alipayName":alipayName,@"code":code}];
    [self loginCode:p];
    [self doConnect:delegate interface:@"BindAlipay" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        LoginState* ls = [AppDelegate getInstance].loadingState.userData;
        ls.alipayId = alipayAccount;
        block(nil,nil);
    } parameters:p];
}
-(void)bindMobile:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block phone:(NSString*)phone code:(NSString*)code{
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"code":code,@"phone":phone}];
    [self loginCode:p];
    [self doConnect:delegate interface:@"BindMobile" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        LoginState* ls = [AppDelegate getInstance].loadingState.userData;
        [AppDelegate getInstance].currentUser.phone = phone;
        ls.isBindMobile = @1;
        ls.mobile = phone;
        block(nil,nil);
    } parameters:p];
}
-(void)releaseBindMobile:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block phone:(NSString*)phone code:(NSString*)code{
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"code":code,@"phone":phone}];
    [self loginCode:p];
    [self doConnect:delegate interface:@"ReleaseBindMobile" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        LoginState* ls = [AppDelegate getInstance].loadingState.userData;
        [AppDelegate getInstance].currentUser.phone=@"";
        ls.isBindMobile = @0;
        ls.mobile = @"";
        block(nil,nil);
    } parameters:p];
}

-(void)resetPwd:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block phone:(NSString*)phone code:(NSString*)code newPwd:(NSString*)newPwd{
    NSDictionary* p =@{@"newPwd":[newPwd MD5Sum],@"phone":phone,@"code":code};
    
    [self doConnect:delegate interface:@"ResetPwd" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSString* data) {
//        [self login:delegate block:^(LoginState* ls,NSError* error){
//        } userName:[AppDelegate getInstance].loadingState.userData.userName password:newPwd];
        block(data,nil);
    } parameters:p];
}

-(void)modifyPwd:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block newPwd:(NSString*)newPwd{
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"newPwd":[newPwd MD5Sum]}];
    
    [self loginCode:p];
    [self doConnect:delegate interface:@"ModifyPwd" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        [self login:delegate block:^(LoginState* ls,NSError* error){
        } userName:[AppDelegate getInstance].loadingState.userData.userName password:newPwd];
        block(nil,nil);
    } parameters:p];
}
-(void)setWithdrawalPassword:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block withdrawalPassword:(NSString*)withdrawalPassword oldWithdrawalPassword:(NSString*)oldWithdrawalPassword{
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"withdrawalPassword":[withdrawalPassword MD5Sum],@"oldWithdrawalPassword":oldWithdrawalPassword==nil?[AppDelegate getInstance].loadingState.userData.withdrawalPassword:[oldWithdrawalPassword MD5Sum]}];
    [self loginCode:p];
    [self doConnect:delegate interface:@"SetWithdrawalPassword" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        [AppDelegate getInstance].loadingState.userData.withdrawalPassword = [withdrawalPassword MD5Sum];
        block(nil,nil);
    } parameters:p];
}


#pragma mark -- Cash

-(void)cashHistory:(id<FanOpertationDelegate>)delegate block:(void(^)(NSArray*,NSError*))block paging:(Paging*)paging{
    NSMutableDictionary* p = $mdictnew;
    [self loginCode:p];
    [paging toParameters:p];
    
    [self doConnect:delegate interface:@"CashHistory" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSArray* jsons) {
        NSMutableArray* cashs = $marrnew;
        for (NSDictionary* json in jsons) {
            [cashs addObject:[CashHistory modelFromDict:json]];
        }
        block(cashs,Nil);
    } parameters:p];
}

-(void)cash:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block password:(NSString*)password{
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"pwd": [password MD5Sum]}];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"ScoreCash" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id rs) {
        LoginState* ls = [AppDelegate getInstance].loadingState.userData;
        NSNumber* oscore = ls.score;
        NSNumber* txscore = [ls ableToCashScore];
        
        ls.score = $float([oscore floatValue]-[txscore floatValue]);
        if (!$safe(ls.lockScore)) {
            ls.lockScore = @0;
        }
        ls.lockScore = $float([ls.lockScore floatValue]+[txscore floatValue]);
        block(rs,nil);
    } parameters:p];
}

#pragma mark master
/**
 *  收徒收益
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param paging   pageTag
 */
-(void)masterIndex:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString* code,NSString* desc,NSString* shareDesc,NSString* shareURL,NSNumber* numbersOfFollowers,NSNumber* totalDevoteYes,NSNumber* totalDevote, NSNumber *todaySafe,NSNumber *lisiSafe,NSNumber *todayShare,NSNumber *lisiShare,NSArray* list,NSError* error))block paging:(Paging*)paging{
#ifdef FanmoreMockMaster
    NSNumber* max = $long(random()%40);
    int number = MAX([max intValue],paging.pageSize);
    NSMutableArray* list = [[NSMutableArray alloc] initWithCapacity:number];
    while (number-->0) {
        [list addObject:[NSDictionary mockContribution]];
    }
    block(@"AAoppep",@"将此邀请码给你的好友们，他们注册为粉猫用户时填入该邀请码，即成为你的徒弟，他们会每次贡献10%的收益给你哦!！",
          @"sharedesc",@"http://www.baidu.com",max,$long(random()%20000),$long(random()%20000),list,nil);
#else
    NSMutableDictionary* p = $mdictnew;
    [self loginCode:p];
    [paging toParameters:p];
    
    [self doConnect:delegate interface:@"ScorePrentice" errorBlocker:^(NSError *error) {
        block(nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,error);
    } resultBlocker:^(NSDictionary* data) {
        block(data[@"inviteCode"],data[@"desc"],data[@"shareDesc"],data[@"shareUrl"],data[@"prenticeAmount"],data[@"yesterdayTotalScore"],data[@"totalScore"],data[@"yesterdayBrowseAmount"],data[@"yesterdayBrowseAmount"],data[@"yesterdayTurnAmount"],data[@"historyTotalTurnAmount"],data[@"list"],nil);
    } parameters:p];
#endif
}

/**
 *  徒弟列表
 *
 *  @param delegate  <#delegate description#>
 *  @param block     <#block description#>
 *  @param orderType 排序依据(0、拜师时间1、总贡献值)
 *  @param paging    pageTag
 */
-(void)followerList:(id<FanOpertationDelegate>)delegate block:(void(^)(NSNumber* numbersOfFollowers,NSArray* list,NSError* error))block orderType:(int)orderType paging:(Paging*)paging{
#ifdef FanmoreMockMaster
    NSNumber* max = $long(random()%40);
    int number = MAX([max intValue],paging.pageSize);
    NSMutableArray* list = [[NSMutableArray alloc] initWithCapacity:number];
    while (number-->0) {
        [list addObject:[NSDictionary mockFollower]];
    }
    block(max,list,nil);
#else
    NSMutableDictionary* p = [[NSMutableDictionary alloc] initWithDictionary:@{@"orderType": $int(orderType)}];
    [self loginCode:p];
    [paging toParameters:p];
    
    [self doConnect:delegate interface:@"PrenticeList" errorBlocker:^(NSError *error) {
        block(nil,nil,error);
    } resultBlocker:^(NSDictionary* data) {
        block(data[@"totalCount"],data[@"list"],nil);
    } parameters:p];
    
#endif
}

/**
 *  徒弟详情
 *
 *  @param delegate   <#delegate description#>
 *  @param block      <#block description#>
 *  @param followerId 徒弟的id
 *  @param orderType  排序依据(0、拜师时间1、总贡献值)
 *  @param paging     pageTag
 */
-(void)followerDetail:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString* username,NSDate* date,NSNumber* totalDevote,NSArray* list,NSError* error))block followerId:(NSNumber*)followerId orderType:(int)orderType paging:(Paging*)paging{
#ifdef FanmoreMockMaster
    NSNumber* max = $long(random()%40);
    int number = MAX([max intValue],paging.pageSize);
    NSMutableArray* list = [[NSMutableArray alloc] initWithCapacity:number];
    while (number-->0) {
        [list addObject:[NSDictionary mockContributionPerFollower]];
    }
    block(@"18606509616",[NSDate date],$long(random()%20000),list,nil);
#else
    NSMutableDictionary* p = [[NSMutableDictionary alloc] initWithDictionary:@{@"id": followerId}];
    [self loginCode:p];
    [paging toParameters:p];
    
    [self doConnect:delegate interface:@"PrenticeDetail" errorBlocker:^(NSError *error) {
        block(nil,nil,nil,nil,error);
    } resultBlocker:^(NSDictionary* data) {
        block(data[@"userName"],[data[@"time"] fmToDate],data[@"totalScore"],data[@"list"],nil);
    } parameters:p];
#endif
}


#pragma mark 新总积分趋势


-(void)newTotalScoreList:(id<FanOpertationDelegate>)delegate block:(void (^)(NSNumber* totalScore,NSNumber* totalCount,NSNumber* maxScore,NSNumber* minScore,NSArray* dateList,NSError* error))block date:(NSDate*)date{
    
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"pageSize":$int(10)}];
    if (date) {
        p[@"date"] = [date fmToString];
    }else{
        p[@"date"] = @"";
    }
    [self loginCode:p];
    
#ifdef FanmoreMockMall
    NSMutableArray* mlist = $marrnew;
    //ScorePerDay list
    NSUInteger count  = random()%10+10;
    int _c = count;
    while (_c-->0) {
        ScorePerDay* day = $new(ScorePerDay);
        day.time = [NSDate dateWithTimeIntervalSinceNow:-24*60*60*_c];
        day.browse = $int(random()%1000+100);
        day.score =$int(random()%90+10);
        //            day.comments = d[@"extra"];//^
        
        NSMutableArray* slist = $marrnew;
        int taskCount = random()%3+1;
        NSDate* date =[NSDate dateWithTimeIntervalSinceNow:-24*60*60*_c];
        
        while (taskCount-->0) {
            [slist addObject:@{@"id": @-1,@"type":@2,@"title":@"任务奖励",@"description":@"说赏你就赏你，啰嗦甚",@"imageUrl":@"http://pic23.nipic.com/20120817/10145548_145019514130_2.png",@"date":[date fmToString],@"totalScore":$int(random()%100+100),@"browseAmount":@19}];
        }
        int otherCount  = random()%2;
        if (otherCount>0) {
            [slist addObject:@{@"id": @-1,@"type":random()%2==1?@0:@1,@"title":@"非任务奖励",@"description":@"说赏你就赏你，啰嗦甚",@"imageUrl":@"http://pic23.nipic.com/20120817/10145548_145019514130_2.png",@"date":[date fmToString],@"totalScore":$int(random()%100+100),@"browseAmount":@20}];
        }
        
        day.details = slist;
        
        [mlist addObject:day];
    }
    
    block(@1000,@10,@100,@10,mlist,nil);
#else
    
    [self doConnect:delegate interface:@"NewTotalScoreList" errorBlocker:^(NSError *error) {
        block(nil,nil,nil,nil,nil,error);
    } resultBlocker:^(NSDictionary* dict) {
        NSArray* list =dict[@"itemData"];
        NSMutableArray* mlist = $marrnew;
        for (NSDictionary* d in list) {
            ScorePerDay* day = $new(ScorePerDay);
            day.time = [d[@"date"] fmToDate];
            day.browse = d[@"browseAmount"];
            day.score = d[@"totalScore"];
            day.details = d[@"awardList"];
            [mlist addObject:day];
        }
        
        block(dict[@"totalScore"],dict[@"totalCount"],dict[@"maxScore"],dict[@"minScore"],mlist,nil);

        
    } parameters:p];
#endif
}


#pragma mark 闪购

-(void)flashMallList:(id<FanOpertationDelegate>)delegate block:(void (^)(NSNumber* count,NSNumber* tempScore,NSNumber* realScore,NSArray* list,NSError* error))block  paging:(Paging*)paging{
    
#ifdef FanmoreMockMall
    
    int count = random()%10+10;
    NSMutableArray* list = [NSMutableArray array];
    
    while (count-->0) {
        [list addObject:@{
                          @"orderNo": $str(@"%d",count),
                          @"orderID": $int(count),
                          @"goodsName": @"按摩椅",
                          @"name":@"18801010101",
                          @"time": [[NSDate date] fmToString],
                          @"tempScore": $int(count),
                          @"realScore": $int(count),
                          @"timeCount": @"很快的啦",
                          @"status": $int(random()%3+1),
                          }];
    }
    
    block($int(list.count),$int(random()%100+100),$int(random()%100+100),list,nil);
#else
    
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    [paging toParameters:p];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"FlashMallList" errorBlocker:^(NSError *error) {
        block(nil,nil,nil,nil,error);
    } resultBlocker:^(NSDictionary* data) {
        //orderNo  orderID goodsName  time  name tempScore realScore timeCount status  (1、积分临时       2、积分正式       3、积分扣除)
        block(data[@"count"],data[@"tempScore"],data[@"realScore"],data[@"list"],nil);
    } parameters:p];
#endif
}

-(void)flashMallDetail:(id<FanOpertationDelegate>)delegate block:(void (^)(NSDictionary* data,NSError* error))block orderNo:(NSString*)orderNo{
    
#ifdef FanmoreMockMall
    
    int count  = random()%100+100;
    
    NSMutableDictionary* data = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"orderNo": orderNo,
                                                                                @"orderID": orderNo,
                                                                                @"goodsName": @"按摩椅",
                                                                                @"name":@"18801010101",
                                                                                @"time": [[NSDate date] fmToString],
                                                                                @"tempScore": $int(count),
                                                                                @"realScore": $int(count),
                                                                                @"timeCount": @"很快的啦",
                                                                                @"status": $int(random()%3+1)}];
    
    count = random()%5+3;
    NSArray* alist = @[@"临时",@"到账",@"退货"];
    NSMutableArray* list  = [NSMutableArray array];
    while (count-->0) {
        //临时，到账，退货
        [list addObject:@{@"time": [[NSDate date] fmToString],@"action":alist[random()%alist.count],@"score":$int(random()%10+10)}];
    }
    
    data[@"list"] = list;
    block(data,nil);
#else
    
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    p[@"orderNo"] = orderNo;
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"FlashMallDetail" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSDictionary* data) {
        block(data,nil);
    } parameters:p];
#endif
}


#pragma mark 检查该任务是否已开始
-(void)taskReleaseCheck:(id<FanOpertationDelegate>)delegate block:(void(^)(Task* taskId,int status,NSString* previewURL,NSError* error))block taskId:(NSNumber*)taskId{
    //FanmoreDebugMockRemoteTask
    //FanmoreDebugMockRemoteTaskPreviewURL
#ifdef FanmoreDebugMockRemoteTask
    //模拟阶段
    //如果没有URL 则默认成功
#ifdef FanmoreDebugMockRemoteTaskPreviewURL
    if (delegate) {
        [self listTask:nil block:^(NSArray *list, NSError *error) {
            block(list[0],YES,nil,nil);
        } screenType:0 paging:[Paging paging:10 parameters:@{@"oldTaskId": @0}]];
    }else{
        block(nil,NO,FanmoreDebugMockRemoteTaskPreviewURL,nil);
    }
#else
    [self listTask:nil block:^(NSArray *list, NSError *error) {
        block(list[0],YES,nil,nil);
    } screenType:0 paging:[Paging paging:10 parameters:@{@"oldTaskId": @0}]];
#endif
#else
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"taskId": taskId}];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"CheckTaskStatus" errorBlocker:^(NSError *error) {
        block(nil,NO,nil,error);
    } resultBlocker:^(NSDictionary* data) {
        int status = [data[@"status"] intValue];//==0
        NSString* url = data[@"webUrl"];
//        if (status==0) {
            Task* task = [[Task alloc] init];
            task.taskId = taskId;
            [self detailTask:nil block:^(NSArray *list, NSError *error) {
                block(task,status,url,error);
            } task:task];
//        }else{
//            block(nil,status,url,nil);
//        }
    } parameters:p];

#endif
}


#pragma mark 排名
-(void)ranking:(id<FanOpertationDelegate>)delegate block:(void(^)(NSNumber* myrank,NSString* desc,NSArray* list,NSError* error))block type:(uint)type{
#ifdef FanmoreMockRanking
    // size 20
    // 数据全部随机
    NSMutableArray* list = [NSMutableArray arrayWithCapacity:20];
    uint count = 20;
    NSArray* namesList = @[@"蒋才",@"陈烨",@"王立",@"徐晨静",@"姜维",@"晶哥",@"王明",@"何云",@"小郭",@"大锅"];
    while(count-->0){
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        NSMutableArray* tlist = [NSMutableArray array];
        int x = random()%10+1;
        while(x-->0){
            [tlist addObject:namesList[random()%namesList.count]];
        }
        [data setupRankingValue:$str(@"%ld积分",random()%20+20) names:[tlist componentsJoinedByString:@","]];
        [list addObject:data];
    }
    block($int(random()%20+1),@"哦哦哦哦唉唉唉唉",list,nil);
#else
    
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"type": $int(type)}];    
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"RANKING" errorBlocker:^(NSError *error) {
        block(nil,nil,nil,error);
    } resultBlocker:^(NSDictionary* data) {
        block(data[@"myRank"],data[@"des"],data[@"rankData"],nil);
    } parameters:p];
    
#endif
}

-(void)notifyList:(id<FanOpertationDelegate>)delegate block:(void(^)(NSArray* list,NSError* error))block paging:(Paging*)paging{
#ifdef FanmoreMockNotify
    uint count = random()%paging.pageSize+1;
    NSMutableArray* list = [NSMutableArray array];
    while (count-->0) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [data setNotifyId:$long(random())];
        [data setNotifyTitle:@"小暖讲了好多故事"];
        [data setNotifyDesc:@"小暖打算讲更多的故事……"];
        [data setNotifyTime:[[NSDate date] fmStandString]];
        uint type = random()%2;
        [data setNotifyWebUrl:@"http://www.baidu.com"];
        [data setNotifyType:$int(type)];
        if (type==0) {
            [data setNotifyTaskId:$long(random())];
            [data setNotifyTaskStatus:$int(random()%3)];
        }
        
        [list addObject:data];
    }
    block(list,nil);
#else
    
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    [paging toParameters:p];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"MESSAGELIST" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(NSArray* data) {
        block(data,nil);
    } parameters:p];

    
#endif
}

#pragma mark 2.3.0

-(void)advanceForward:(id<FanOpertationDelegate>)delegate block:(void(^)(NSDictionary* data,
                                                                         NSError* error))block taskId:(NSNumber*)taskId{
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"taskId":taskId}];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"AdvanceForward" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id d) {
        block(d,nil);
    } parameters:p];
}

-(void)uploadPicture:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString* tip,
                                                                        NSError* error))block image:(UIImage*)image{
    
    //png
    NSData* data = UIImagePNGRepresentation(image);
    //jpeg
//    UIImageJPEGRepresentation(image);
//    [data base64EncodedString];
    
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"pic":[data base64EncodedStringWithOptions:0]}];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"UploadPicture" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        block(data,nil);
    } parameters:p urlBlocker:nil post:YES];
}

-(void)checkInCalendar:(id<FanOpertationDelegate>)delegate block:(void(^)(
                                                                          NSNumber* lastContinues,
                                                                          NSNumber* todayscore,
                                                                          NSDate* currentdate,
                                                                          NSError* error))block{
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"CheckInCalendar" errorBlocker:^(NSError *error) {
        block(nil,nil,nil,error);
    } resultBlocker:^(NSDictionary* data) {
        block(data[@"lastcontinues"],data[@"todayscore"],[data[@"currentdate"] fmToDate],nil);
    } parameters:p];
}

-(void)checkIn:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString* tip,
                                                                  NSError* error))block{
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"CheckIn" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        LoginState* ls = [[[AppDelegate getInstance] loadingState] userData];
        ls.dayCheckIn = @1;
        ls.checkInDays = $int([ls.checkInDays intValue]+1);
        block(data,nil);
    } parameters:p];
}

-(void)handleItemsError:(void(^)(NSArray* items,NSArray* myItems,
                            NSError* error))block error:(NSError*)error{
    block(nil,nil,error);
}

-(void)handleItems:(void(^)(NSArray* items,NSArray* myItems,
                            NSError* error))block data:(id)data{
    LOG(@"👀");
    block(data[@"items"],data[@"myItems"],nil);
}

-(void)itemList:(id<FanOpertationDelegate>)delegate block:(void(^)(NSArray* items,NSArray* myItems,
                                                                   NSError* error))block{
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"PropItemList" errorBlocker:^(NSError *error) {
        [self handleItemsError:block error:error];
    } resultBlocker:^(id data) {
        [self handleItems:block data:data];
    } parameters:p];
}

-(void)rollPrentice:(id<FanOpertationDelegate>)delegate block:(void(^)(NSDictionary* user,
                                                                   NSError* error))block{
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"RollPrentice" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        block(data,nil);
    } parameters:p];
}

-(void)TodayNotice:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray* list,NSError* error))block paging:(Paging*)paging{
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    [paging toParameters:p];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"TodayNotice" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        //todayTotalScore
        NSArray* jsonTasks = data[@"taskData"];
#ifdef FanmoreMockTodayNotice
        if(jsonTasks.count==0){
            [self listTask:delegate block:^(NSArray *list, NSError *error) {
                // advancedseconds online 0 不可提前转发 1 可提前转发 2 已上线
                for (Task* task in list) {
                    task.advancedseconds = [NSDate dateWithTimeInterval:-10*60 sinceDate:task.publishTime];
                    task.online = $int(random()%3);
                }
                block(list,error);
            } screenType:0 paging:paging];
            return;
        }
#endif
        
        
        
        
        NSMutableArray* tasks = $marrnew;
        for (int i=0; i<jsonTasks.count; i++) {
            tasks[i] = [Task modelFromDict:jsonTasks[i]];
        }
        block(tasks,Nil);
    } parameters:p];
}

-(void)previewTaskList:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray* list,NSError* error))block paging:(Paging*)paging{
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    [paging toParameters:p];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"PreviewTaskList" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        //todayTotalScore
        NSArray* jsonTasks = data[@"taskData"];
        NSMutableArray* tasks = $marrnew;
        for (int i=0; i<jsonTasks.count; i++) {
            tasks[i] = [Task modelFromDict:jsonTasks[i]];
        }
        block(tasks,Nil);
    } parameters:p];
}

-(void)buyItem:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray* items,NSArray* myItems,NSError* error))block type:(int)type{
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"type":$int(type)}];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"BuyProp" errorBlocker:^(NSError *error) {
        [self handleItemsError:block error:error];
    } resultBlocker:^(id data) {
        //获取价格
        NSArray* item = data[@"items"];
        for (NSDictionary* it in item) {
            if ([it[@"type"]intValue]==type) {
                //获得价格
                LoginState* ls = [AppDelegate getInstance].loadingState.userData;
                int lastExp = [ls.exp intValue]-[it[@"exp"] intValue];
                ls.exp = $int(lastExp);
                break;
            }
        }
        [self handleItems:block data:data];
    } parameters:p];
}

-(void)useItem:(id<FanOpertationDelegate>)delegate block:(void (^)(NSNumber* count,NSError* error))block type:(int)type target:(NSNumber*)target{
    NSMutableDictionary* p = [NSMutableDictionary dictionaryWithDictionary:@{@"type":$int(type),@"rid":target}];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"UsePropItem" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        block(data[@"count"],nil);
    } parameters:p];
}

-(void)scratchTicket:(id<FanOpertationDelegate>)delegate block:(void (^)(NSNumber* id,NSNumber* residueCount,NSNumber* exp,NSError* error))block{
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"ScratchTicket" errorBlocker:^(NSError *error) {
        block(nil,nil,nil,error);
    } resultBlocker:^(id data) {
        block(data[@"id"],data[@"residueCount"],data[@"value"],nil);
    } parameters:p];
}

-(void)expHistory:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray* history,NSError* error))block paging:(Paging*)paging{
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    [paging toParameters:p];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"ExpHistory" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        block(data[@"expHistory"],nil);
    } parameters:p];
}

-(void)mywallet:(id<FanOpertationDelegate>)delegate block:(void (^)(NSNumber* scoreLast,NSNumber* walletLast,NSString* des,NSDate* recordTime,NSString* recordDes,NSNumber* recordResult,NSString* recordResultDes,NSError* error))block{
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"MyWallet" errorBlocker:^(NSError *error) {
        block(nil,nil,nil,nil,nil,nil,nil,error);
    } resultBlocker:^(id data) {
        id test = data[@"recordTime"];
        if ($safe(test)) {
            block(data[@"scoreLast"],data[@"walletLast"],data[@"des"],[data[@"recordTime"] fmToDate],data[@"recordDes"],data[@"recordResult"],data[@"recordResultDes"],nil);
        }else{
            block(data[@"scoreLast"],data[@"walletLast"],data[@"des"],nil,nil,nil,nil,nil);
        }
        
    } parameters:p];
}

-(void)moneyStoreURL:(id<FanOpertationDelegate>)delegate block:(void (^)(NSString* des,NSError* error))block{
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"duibaautologin" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        block(data,nil);
    } parameters:p];
}

-(void)cashWallet:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString* result,NSError* error))block{
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"ScoreWallet" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id rs) {
        LoginState* ls = [AppDelegate getInstance].loadingState.userData;
        NSNumber* oscore = ls.score;
        NSNumber* txscore = [ls ableToCashScore];
        
        ls.score = $float([oscore floatValue]-[txscore floatValue]);
        if (!$safe(ls.lockScore)) {
            ls.lockScore = @0;
        }
        ls.lockScore = $float([ls.lockScore floatValue]+[txscore floatValue]);
        block(rs,nil);
    } parameters:p];
}

-(void)walletHistory:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray* history,NSError* error))block paging:(Paging*)paging{
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    [paging toParameters:p];
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"MyWalletMoneyFlow" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        block(data,nil);
    } parameters:p];
}

/**
 *  获取邀请码
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param parame   <#parame description#>
 */

- (void)ToGetYaoqing:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString* result,NSError* error))block WithParam:(NSString *)iphone{
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    p[@"mobile"] = iphone;
    [self loginCode:p];
    
    [self doConnect:delegate interface:@"sms" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        block(data,nil);
    } parameters:p];
}

/**
 *  小金库数据
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param score    <#score description#>
 */
- (void)TOGetGlodDate:(id<FanOpertationDelegate>)delegate block:(void(^)(id result,NSError* error))block WithParam:(NSString *)score{
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    p[@"score"] = score;
    [self loginCode:p];
    [self doConnect:delegate interface:@"IntegralGoldInfo" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        block(data,nil);
    } parameters:p];

    
}

/**
 *  获取用户列表
 *
 *  @param delegate <#delegate description#>
 *  @param block    <#block description#>
 *  @param unionId  <#unionId description#>
 */
- (void)TOGetUserList:(id<FanOpertationDelegate>)delegate block:(void(^)(id result,NSError* error))block WithunionId:(NSString *)unionId{
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    p[@"unionId"] = unionId;
    [self loginCode:p];
    [self doConnect:delegate interface:@"GetUserList" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        block(data,nil);
    } parameters:p];
}


/**
 *  积分兑换小金库
 *
 *  @param delegate     <#delegate description#>
 *  @param block        <#block description#>
 *  @param score        <#score description#>
 *  @param cashpassword <#cashpassword description#>
 *  @param mallUserId   <#mallUserId description#>
 */
- (void)ToChangeJifenToMyBackMall:(id<FanOpertationDelegate>)delegate block:(void(^)(id result,NSError* error))block WithunionId:(NSString *)score withCashpassword:(NSString *)cashpassword withMallUserId:(NSString *)mallUserId{
    NSMutableDictionary* p = [NSMutableDictionary dictionary];
    p[@"score"] = score;
    p[@"cashpassword"] =  [cashpassword MD5Sum];
    p[@"mallUserId"] = mallUserId;
    [self loginCode:p];
    [self doConnect:delegate interface:@"Recharge" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        block(data,nil);
        NSString * passwd =  data[@"loginCode"];
        NSArray * arra =  [passwd componentsSeparatedByString:@"^"];
        LOG(@"-----Userregister--%@",data);
        LOG(@"xxxx---%@---%@",data[@"userName"],arra[1]);
        [self login:delegate block:block userName:data[@"userName"] password:arra[1]];
        
    } parameters:p];
    
    
}
//warning luohaibo 提交微信授权信息
- (void)toSouji:(id<FanOpertationDelegate>)delegate block:(void (^)(LoginState*,NSError*))block WithParam:(NSString *)phone withYanzhen:(NSString *)yanzhenma withYaoqingma:(NSString *)yaoqingma{
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"mobile"] = phone;
    parame[@"verifyCode"] = yanzhenma;
    parame[@"invitationCode"] =yaoqingma;
    [self loginCode:parame];
    [self doConnect:delegate interface:@"MobileRegister" errorBlocker:^(NSError *error) {
        block(nil,error);
    } resultBlocker:^(id data) {
        LOG(@"%@",data);
        NSString * passwd =  data[@"loginCode"];
        NSArray * arra =  [passwd componentsSeparatedByString:@"^"];
        [self login:delegate block:block userName:data[@"userName"] password:arra[1]];
    } parameters:parame];
}





#pragma mark 核心连接

-(void)doConnect:(id<FanOpertationDelegate>)delegate interface:(NSString*)interface errorBlocker:(void (^)(NSError*))errorBlocker resultBlocker:(void (^)(id))resultBlocker parameters:(NSDictionary*)parameters urlBlocker:(void (^)(NSMutableString*))urlBlocker post:(BOOL)post{
    
    AppDelegate* ad = [AppDelegate getInstance];
    CLLocationCoordinate2D c2d = [ad getLocation];
    
    @try {
        NSString* jarlBreakFlag;
#ifdef FM_JailBreak
        jarlBreakFlag = @"J";
#else
        jarlBreakFlag = @"N";
#endif
        NSDictionary* sign = @{
                               @"serial": $longlong([$double([[NSDate date] timeIntervalSince1970]*(double)1000.0f) longLongValue]),
                               @"imei6":[self.imei substringWithRange:NSMakeRange(self.imei.length-6, 6)],
                               @"key":@"caonimei"};
        
        double version = [[UIDevice currentDevice].systemVersion doubleValue];
        NSString* signStr;
        if (version>=7) {
            signStr = [[[SecureHelper rsaEncryptString:[sign myJSONString]] base64EncodedStringWithOptions:0]encodeURL];
        }else{
            signStr = [[[SecureHelper rsaEncryptString:[sign myJSONString]] base64Encoding]encodeURL];
        }
        
//        NSLog(@"1%@",[sign myJSONString]);
//        NSLog(@"2%@",[sign myJSONString]);
//        NSLog(@"3%@",[sign myJSONString]);
//        NSLog(@"4%@",[sign myJSONString]);
        
        if(signStr.length>400){ 
//            
//            
//            NSString* str1 = [sign myJSONString];
//            NSString* str2 = [[SecureHelper rsaEncryptString:str1] base64EncodedStringWithOptions:0];
//            NSLog(@"%@",str1);
//            
//            NSLog(@"1%@",[[SecureHelper rsaEncryptString:str1] base64EncodedStringWithOptions:0]);
//            NSLog(@"2%@",[[SecureHelper rsaEncryptString:str1] base64EncodedStringWithOptions:0]);
//            NSLog(@"3%@",[[SecureHelper rsaEncryptString:str1] base64EncodedStringWithOptions:0]);
//            NSLog(@"4%@",[[SecureHelper rsaEncryptString:str1] base64EncodedStringWithOptions:0]);
//            
//            NSLog(@"%@",str2);
//            NSLog(@"%@",[str2 encodeURL]);
            NSLog(@"%@ has too many length!!!",signStr);
        }
        
#ifdef FM_QD
        NSString* qd = @FM_QD;
        NSString* url = $str(@"%@/api.ashx?req=%@&operation=HuoTu2013IP%@&qd=%@&version=%@&imei=%@&sign=%@",self.rootURL,interface,,jarlBreakFlag,qd,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],self.imei,signStr);
#else
        NSString* url = $str(@"%@/api.ashx?req=%@&operation=HuoTu2013IP%@&version=%@&imei=%@&sign=%@",self.rootURL,interface,jarlBreakFlag,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],self.imei,signStr);
#endif
        
        if (!post && parameters && parameters.count>0 ) {
            url = $str(@"%@&p=%@",url,[[parameters myJSONString]encodeURL]);
        }
//        NSMutableString* url = [NSMutableString stringWithString:self.rootURL];
//        [url $append_:$str(@"/api.ashx?req=%@",interface)];
//        
//        [url $append_:$str(@"&operation=HuoTu2013IP&version=%d&imei=%@&cityCode=%ld&p=%@",FMVersion,self.imei,[[AppDelegate getInstance]getCurrentCityCode],[[parameters myJSONString]encodeURL])];
//        
        //block with url! 可选
//        if ($safe(urlBlocker)){
//            urlBlocker(url);
//        }
        
        LOG(@"%@",url);
        ASIHTTPRequest* request;
        if (post) {
            ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
            if(parameters && parameters.count>0)
                [requestForm setPostValue:[[parameters myJSONString] encodeURL] forKey:@"p"];
            request = requestForm;
        }else{
            request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        }
        
        __block HTTPRequestMoniter* moniter = [[HTTPRequestMoniter alloc]initWithASIHTTPRequest:request];
        __weak __block ASIHTTPRequest* _request = request;
        [request setCompletionBlock:^{
            if ([moniter isCancelled]) {
                return;
            }
            @try {
#ifdef FanmoreDebug
//                    NSString* rs = [[NSString alloc]initWithData:[_request responseData] encoding:[_request responseEncoding]];
//                    LOG(@"%d %@",[_request responseEncoding],rs);
#endif
//            NSDictionary* result = [self.decoder objectWithData:[_request responseData]];
                NSDictionary* result = [NSJSONSerialization JSONObjectWithData:[_request responseData] options:0 error:NULL];

#ifdef FanmoreDebugMock
            if ($eql(@"UserInfo",interface) && $eql(@"http://api.fanmore.cn",self.rootURL)) {
                NSString* tmpstr = @"{\"resultCode\":1,\"description\":\"成功\",\"status\":1,\"resultData\":{\"phone\":\"15088659764\",\"name\":\"爸爸\",\"sex\":2,\"birth\":\"1960-01-01 00-00-00\",\"industryId\":0,\"industry\":\"未知\",\"favoriteId\":\"0\",\"favorite\":\"\",\"incomeId\":0,\"income\":\"未知\",\"areaId\":0,\"area\":\"未知\",\"industryList\":[{\"value\":\"1\",\"name\":\"计算机软件/硬件\"},{\"value\":\"2\",\"name\":\"互联网/电子商务\"},{\"value\":\"3\",\"name\":\"服务行业\"},{\"value\":\"4\",\"name\":\"服务行业\"},{\"value\":\"5\",\"name\":\"医疗\"},{\"value\":\"6\",\"name\":\"市场推广\"},{\"value\":\"7\",\"name\":\"房产\"},{\"value\":\"9\",\"name\":\"外包服务\"},{\"value\":\"10\",\"name\":\"酒店\"},{\"value\":\"11\",\"name\":\"美容\"},{\"value\":\"12\",\"name\":\"电力\"},{\"value\":\"13\",\"name\":\"农业\"},{\"value\":\"13\",\"name\":\"其他\"}],\"favoriteList\":[{\"value\":\"1\",\"name\":\"阅读\"},{\"value\":\"2\",\"name\":\"运动\"},{\"value\":\"3\",\"name\":\"购物\"},{\"value\":\"4\",\"name\":\"饮食\"},{\"value\":\"5\",\"name\":\"旅游\"},{\"value\":\"6\",\"name\":\"音乐\"},{\"value\":\"7\",\"name\":\"饮茶\"},{\"value\":\"8\",\"name\":\"影视\"}],\"incomeList\":[{\"value\":\"1\",\"name\":\"2000以下\"},{\"value\":\"2\",\"name\":\"2000-4000\"},{\"value\":\"3\",\"name\":\"4000-6000\"},{\"value\":\"4\",\"name\":\"6000-8000\"},{\"value\":\"5\",\"name\":\"8000-10000\"},{\"value\":\"6\",\"name\":\"10000-20000\"},{\"value\":\"7\",\"name\":\"20000以上\"}]},\"tip\":\"操作成功\"}";
                const char * cstr= [tmpstr cStringUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpointer-sign"
                result =  [self.decoder objectWithUTF8String:cstr length:[tmpstr lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
#pragma clang diagnostic pop                
            }
#endif
                
            if (!$safe(result)) {
                
                errorBlocker([NSError errorWithDomain:@"com.fanmore" code:500 userInfo:@{NSLocalizedDescriptionKey:@"网络故障"}]);
                return;
            }
                
                // 如果发现exp 则弹出exp窗口
                NSNumber* exp = result[@"exp"];
                if ($safe(exp) && [exp intValue]>0) {
                    [ExpReceiveView showView:exp];
                    LoginState* llss = [AppDelegate getInstance].loadingState.userData;
                    llss.exp = $int([llss.exp intValue]+[exp intValue]);
                }
                
            
            if ([[result $for:@"resultCode"]intValue]!=1) {
                errorBlocker(
                             [NSError errorWithDomain:@"com.fanmore" code:[[result $for:@"resultCode"]intValue] userInfo:@{NSLocalizedDescriptionKey:[result $for:@"description"]}]
                             );
                return;
            }
            
            if ([[result $for:@"status"]intValue]!=1) {
                errorBlocker(
                             [NSError errorWithDomain:@"com.fanmore" code:[[result $for:@"status"]intValue] userInfo:@{NSLocalizedDescriptionKey:[result $for:@"tip"]}]
                             );
                return;
            }
            id rd = result[@"resultData"];
            if ($safe(rd) && !$eql(@"",rd)) {
                resultBlocker(rd);
            }else if($safe(result[@"url"])){
                resultBlocker(result[@"url"]);
            }else{
                resultBlocker(result[@"tip"]);
            }
            }
            @catch (NSException *exception) {
                NSLog(@"执行完成BLOCK时异常%@",exception);
                errorBlocker([NSError errorWithDomain:@"com.fanmore" code:600 userInfo:exception.userInfo]);
            }
            @finally {
            }
        }];
        [request setFailedBlock:^{
            if ([moniter isCancelled]) {
                return;
            }
            errorBlocker([_request error]);
        }];
        [request setRequestMethod:@"GET"];
//        [request startAsynchronous];
#ifdef FanmoreDebug
                [request startAsynchronous];
#else
                [request startAsynchronous];
#endif
        //    return moniter;

    }
    @catch (NSException *exception) {
        LOG(@"error on connect %@",exception);
        errorBlocker(
                     [NSError errorWithDomain:@"com.fanmore" code:-10000 userInfo:exception.userInfo]
                     );
    }
}

-(void)doConnect:(id<FanOpertationDelegate>)delegate interface:(NSString*)interface errorBlocker:(void (^)(NSError*))errorBlocker resultBlocker:(void (^)(id))resultBlocker parameters:(NSDictionary*)parameters urlBlocker:(void (^)(NSMutableString*))urlBlocker{
    [self doConnect:delegate interface:interface errorBlocker:errorBlocker resultBlocker:resultBlocker parameters:parameters urlBlocker:urlBlocker post:NO];
}

-(void)doConnect:(id<FanOpertationDelegate>)delegate interface:(NSString*)interface errorBlocker:(void (^)(NSError*))errorBlocker resultBlocker:(void (^)(id))resultBlocker parameters:(NSDictionary*)parameters{
    [self doConnect:delegate interface:interface errorBlocker:errorBlocker resultBlocker:resultBlocker parameters:parameters urlBlocker:Nil];
}

#pragma mark 初始化

-(id)init{
    self = [super init];
    self.rootURL = @FMROOT;
    LOG(@"init interface");
    /**
     *  nil use vendor instead
     */
    NSString* preferencesFile =[[$ documentPath]stringByAppendingPathComponent:@"preferences"];
    NSFileManager* nf = [NSFileManager defaultManager];
    NSString* ivalue;
    if(![nf fileExistsAtPath:preferencesFile]){
        ivalue =[[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
        if (!ivalue) {
            ivalue = [[[[UIDevice currentDevice]identifierForVendor] UUIDString] MD5Sum];
        }
        NSMutableDictionary* preferences = [[NSMutableDictionary alloc] init];
        preferences[@"imei"] = ivalue;
        [preferences writeToFile:preferencesFile atomically:YES];
    }else{
        NSMutableDictionary* preferences = [NSMutableDictionary dictionaryWithContentsOfFile:preferencesFile];
        if(preferences[@"imei"]){
            ivalue =preferences[@"imei"];
        }else{
            ivalue =[[[[UIDevice currentDevice]identifierForVendor] UUIDString] MD5Sum];
        }
    }
    self.imei= ivalue;
#ifdef FanmoreDebugIMEI
    self.imei = [[[[NSUUID alloc] init] UUIDString] MD5Sum];
    NSLog(@"测试IMEI:%@",self.imei);
#endif
    
//    [[UIDevice currentDevice] identifierForVendor];
    return self;
}

#pragma mark 其他

-(NSDictionary*)toDic:(NSArray*)nameandvalue{
    NSMutableDictionary* tmp = $mdictnew;
    [nameandvalue $each:^(id obj) {
        NSDictionary* data = obj;
        tmp[data[@"value"]]=data[@"name"];
    }];
    return [NSDictionary dictionaryWithDictionary:tmp];
}

-(void)loginCode:(NSMutableDictionary*)p{
    LoadingState* ls = [AppDelegate getInstance].loadingState;
    if (ls==Nil) {
        p[@"loginCode"]=@"";
        return;
    }
    LoginState* lls = ls.userData;
    if (lls==Nil || lls.loginCode==Nil) {
        p[@"loginCode"]=@"";
        return;
    }
    p[@"loginCode"]=lls.loginCode;
}

@end
