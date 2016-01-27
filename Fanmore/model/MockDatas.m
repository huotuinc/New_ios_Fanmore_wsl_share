//
//  MockDatas.m
//  Fanmore
//
//  Created by Cai Jiang on 1/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "MockDatas.h"
#import "NSDate+Fanmore.h"

@implementation MockDatas

@end
#ifdef FanmoreMock

@implementation LoginState (Ext)
+(instancetype)mockLoginState{
    LoginState* ls = $new(LoginState);
    ls.totalScore = [NSNumber numberWithLong:random()];
    ls.yesterdayTotalScore = [NSNumber numberWithLong:random()];
    return ls;
}
@end

@implementation LoadingState (Ext)

+(instancetype)mockLoadingState{
    LoadingState* ls = $new(LoadingState);
    ls.loginState = [LoginState mockLoginState];
    ls.updateType = [NSNumber numberWithInt:random()%5];
    NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:24*60*60];
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-24*60*60];
    NSDate *yesterday2 = [NSDate dateWithTimeIntervalSinceNow:-24*60*60*2];
    NSString*  current = [[yesterday2 fmToString]$append:@","];
    if (random()%2==0){
        [current $append:[tomorrow fmToString]];
    }else{
        [current $append:[yesterday fmToString]];
    }
    ls.showTime = current;
    
    switch (random()%5){
        case 0:
            ls.imgURL = @"http://www.iphone4jailbreak.org/wp-content/uploads/1136x640-iPhone-5-wallpaper-4.jpg";
            break;
        case 1:
            ls.imgURL = @"http://www.iphone4jailbreak.org/wp-content/uploads/1136x640-iPhone-5-wallpaper-3.jpg";
            break;
        case 2:
            ls.imgURL = @"http://www.iphone4jailbreak.org/wp-content/uploads/1136x640-iPhone-5-wallpaper-21.jpg";
            break;
        case 3:
            ls.imgURL = @"http://www.iphone4jailbreak.org/wp-content/uploads/1136x640-iPhone-5-wallpaper-2.jpg";
            break;
        case 4:
            ls.imgURL = @"http://www.iphone4jailbreak.org/wp-content/uploads/1136x640-iPhone-5-wallpaper-1.jpg";
            break;
    }
    return ls;
}

@end

@implementation Store (Mock)

+(instancetype)mockStore{
    return [self mockStore:random()%5];
}
+(instancetype)mockStore:(long)type{
    Store* store = $new(Store);
    store.fav =random()%2==1;
    switch(type%5){
        case 0:
            store.id = @"1";
            store.name = @"黑水保安";
            store.logo = @"http://www.afwing.com/intro/f104/f104_img_4.jpg";
            store.taskCount = $long(1+random()%10);
            store.intro = @"杀人不见血";
            break;
        case 1:
            store.id = @"2";
            store.name = @"钢铁侠";
            store.logo = @"http://upload.wikimedia.org/wikipedia/commons/7/73/Peugeot_104zs_79.jpg";
            store.taskCount = $long(1+random()%10);
            store.intro = @"克制严谨";
            break;
        case 2:
            store.id = @"3";
            store.name = @"骗你成人教育";
            store.logo = @"http://www.microsoft.com/taiwan/sql2008/graphics/partnersolution/104ehr_1.JPG";
            store.taskCount = $long(1+random()%10);
            store.intro = @"助你成长";
            break;
        case 3:
            store.id = @"4";
            store.name = @"地精公会";
            store.logo = @"http://science.ksc.nasa.gov/shuttle/missions/sts-104/sts-104-patch.jpg";
            store.taskCount = $long(1+random()%10);
            store.intro = @"稳赚不赔";
            break;
        case 4:
            store.id = @"5";
            store.name = @"有人要皮革制品";
            store.logo = @"http://static.jiaju.com/malljiaju/goods/52/7a/4f8d0f811ecbb082aebe_b.jpg";
            store.taskCount = $long(1+random()%10);
            store.intro = @"假一罚十";
            break;
    }
    store.openID = store.id;
    store.contact = [@[@"400",store.id,store.id,store.id,store.id,store.id,store.id,store.id]$join:@""];
    return store;
}


@end

@implementation Task (Ext)


+(instancetype)mockTask:(long)type store:(Store*)store{
    //type status
    
    Task* task = $new(Task);
    task.id = [$long(random()) stringValue];
    type = type%5;
    task.store = [Store mockStore:type];
    switch (type) {
        case 0:
            task.title = $str(@"合法杀戮，所得财物充公%ld",random());
            task.awardBrowse = $long(5*(random()%5+1));
            task.awardLink = $long(4*(random()%5+1));
            task.awardSend = $long(3*(random()%5+1));
            task.sendCount = $long(50+random()%100);
            task.endTime = [NSDate dateWithTimeIntervalSinceNow:random()%(7*24*60*60)];
            task.publishTime = [NSDate dateWithTimeIntervalSinceNow:-random()%(7*24*60*60)];
            task.info = $str(@"杀戮那是不对的 用语言 谢谢%ld",random()%7);

            task.imgURL = @"http://www.afwing.com/intro/f104/f104_img_4.jpg";
            
            task.description= @"黑水保安新年酬宾，杀一抵百";
            task.ruleDes = @"规则：人头100，左手40，右手免费";
            task.largeImgURL = task.imgURL;
            
            task.isSend = random()%2==1;
            
            if (task.isSend) {
                task.myAwardSend = task.awardSend;
            }else{
                task.myAwardSend = [NSNumber numberWithInt:0];
            }
            task.myAwardBrowse = $long(task.awardBrowse.intValue*(random()%6));
            task.myAwardLink = $long(task.awardLink.intValue*(random()%6));
            task.lastScore = $long(400+(random()%5)*100+random()%70);
            break;
        case 1:
            task.title = $str(@"一元购车%ld",random());
            task.awardBrowse = $long(3*(random()%5+1));
            task.awardLink = $long(4*(random()%5+1));
            task.awardSend = $long(5*(random()%5+1));
            task.sendCount = $long(20+random()%70);
            task.endTime = [NSDate dateWithTimeIntervalSinceNow:random()%(4*24*60*60)];
            task.publishTime = [NSDate dateWithTimeIntervalSinceNow:-random()%(5*24*60*60)];
            task.info = $str(@"%ld一元购车 绝不忽悠",random()%7);
            
            task.imgURL = @"http://upload.wikimedia.org/wikipedia/commons/7/73/Peugeot_104zs_79.jpg";
            
            task.description= @"新科技驱动新技术，New Technology New Life";
            task.ruleDes = @"规则：100辆超优惠 送完为止";
            
            task.largeImgURL = task.imgURL;
            
            task.isSend = random()%2==1;
            
            if (task.isSend) {
                task.myAwardSend = task.awardSend;
            }else{
                task.myAwardSend = [NSNumber numberWithInt:0];
            }
            task.myAwardBrowse = $long(task.awardBrowse.intValue*(random()%9));
            task.myAwardLink = $long(task.awardLink.intValue*(random()%9));
            task.lastScore = $long(200+(random()%4)*100+random()%50);
        break;
        case 2:
            task.title = $str(@"效率提升，%ld，培训先行",random());
            task.awardBrowse = $long(5*(random()%5+1));
            task.awardLink = $long(3*(random()%5+1));
            task.awardSend = $long(4*(random()%5+1));
            task.sendCount = $long(80+random()%200);
            task.endTime = [NSDate dateWithTimeIntervalSinceNow:random()%(6*24*60*60)];
            task.publishTime = [NSDate dateWithTimeIntervalSinceNow:-random()%(2*24*60*60)];
            task.info = $str(@"活到老学到老%ld",random()%7);
            task.imgURL = @"http://www.microsoft.com/taiwan/sql2008/graphics/partnersolution/104ehr_1.JPG";
            
            task.description= @"史前导师复活来教你";
            task.ruleDes = @"规则：包学包会，无效退款";
            task.largeImgURL = task.imgURL;
            
            task.isSend = random()%2==1;
            if (task.isSend) {
                task.myAwardSend = task.awardSend;
            }else{
                task.myAwardSend = [NSNumber numberWithInt:0];
            }
            task.myAwardBrowse = $long(task.awardBrowse.intValue*(random()%9));
            task.myAwardLink = $long(task.awardLink.intValue*(random()%9));
            task.lastScore = $long(200+(random()%4)*100+random()%50);
            break;
        case 3:
            task.title = $str(@"各种乱投资%ld",random());
            task.awardBrowse = $long(5*(random()%5+1));
            task.awardLink = $long(4*(random()%5+1));
            task.awardSend = $long(3*(random()%5+1));
            task.sendCount = $long(5+random()%100);
            task.endTime = [NSDate dateWithTimeIntervalSinceNow:random()%(7*24*60*60)];
            task.publishTime = [NSDate dateWithTimeIntervalSinceNow:-random()%(4*60*60)];
            task.info = $str(@"投资有风险%ld入市须谨慎",random()%7);
            task.imgURL = @"http://science.ksc.nasa.gov/shuttle/missions/sts-104/sts-104-patch.jpg";
            
            task.description= @"喜迎金融危机，只有危才带来机";
            task.ruleDes = @"规则：400万起步，1亿立刻成为VIP";
            task.largeImgURL = task.imgURL;
            
            task.isSend = random()%2==1;
            if (task.isSend) {
                task.myAwardSend = task.awardSend;
            }else{
                task.myAwardSend = [NSNumber numberWithInt:0];
            }
            task.myAwardBrowse = $long(task.awardBrowse.intValue*(random()%9));
            task.myAwardLink = $long(task.awardLink.intValue*(random()%9));
            task.lastScore = $long(600+(random()%6)*100+random()%50);
            break;
        case 4:
            task.title = $str(@"动荡的女鞋%ld",random());
            task.awardBrowse = $long(5*(random()%5+1));
            task.awardLink = $long(4*(random()%5+1));
            task.awardSend = $long(3*(random()%5+1));
            task.sendCount = $long(200+random()%90);
            task.endTime = [NSDate dateWithTimeIntervalSinceNow:random()%(7*24*60*60)];
            task.publishTime = [NSDate dateWithTimeIntervalSinceNow:-random()%(60*60)];
            task.info = $str(@"飘忽的神经%ld",random()%7);
            task.imgURL = @"http://static.jiaju.com/malljiaju/goods/52/7a/4f8d0f811ecbb082aebe_b.jpg";
            
            task.description= @"来自意大利的超前工艺助你成就人生";
            task.ruleDes = @"规则：没有均码！！！";
            task.largeImgURL = task.imgURL;
            
            task.isSend = random()%2==1;
            if (task.isSend) {
                task.myAwardSend = task.awardSend;
            }else{
                task.myAwardSend = [NSNumber numberWithInt:0];
            }
            task.myAwardBrowse = $long(task.awardBrowse.intValue*(random()%9));
            task.myAwardLink = $long(task.awardLink.intValue*(random()%9));
            task.lastScore = $long(200+(random()%4)*100+random()%50);
            break;
    }
    return task;
}

+(instancetype)mockTask{
    long type = random()%5;
    return [self mockTask:type store:[Store mockStore:type]];
}
+(instancetype)mockTask:(NSArray*)stores{
    long type = random()%5;
    return [self mockTask:type store:[stores $at:type]];
}

@end

@implementation SendRecord (Mock)

+(instancetype)mockSendRecord{
    SendRecord* sr = $new(SendRecord);
    NSString* name = @"1";
    while (name.length<11) {
        name = [name $append:$str(@"%ld",random()%10)];
    }
    sr.name = name;
    sr.time = [NSDate dateWithTimeIntervalSinceNow:-(5+(random()%(24*60*60)))];
    sr.score = $long(20+random()%20);
    return sr;
}

@end

@implementation UserInformation (Mock)
+(instancetype)mockUserInformation{
    UserInformation* ui = $new(UserInformation);
    ui.birth = [NSDate date];
    long cts = ((random()%5)+2);
    NSMutableArray* nbs = [NSMutableArray arrayWithCapacity:cts];
    while (cts-->0) {
        [nbs $push:[Contact mockContact]];
    }
    ui.contacts = [NSArray arrayWithArray:nbs];
    
    
    ui.favorites = @[@1,@2];
    ui.incoming = @1;
    ui.industry = @2;
    ui.name = @"夏雨";
    ui.phone = @"14490801212";
    ui.sex = $long(1+random()%2);
    ui.area = @190;
    ui.age = $long(17+random()%7);
    
    return ui;
}
@end

@implementation Contact (Mock)
+(instancetype)mockContact{
    Contact* cc = $new(Contact);
    cc.name = @"夏雪";
    cc.address = @"浙江杭州拱墅区";
    cc.tel = @"1871092010";
    return cc;
}
@end

@implementation CashHistory (Mock)

+(instancetype)mockCashHistory{
    CashHistory* ch = $new(CashHistory);
    ch.time =[NSDate dateWithTimeIntervalSinceNow:-random()%(7*24*60*60)];
    ch.money = $long(5+random()%8);
    ch.score = $long([ch.money intValue]*10);
    ch.status = $long(1+random()%5);    
    return ch;
}

@end

#endif