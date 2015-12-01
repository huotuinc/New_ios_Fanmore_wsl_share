//
//  FanOperationsMock.m
//  Fanmore
//
//  Created by Cai Jiang on 1/8/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#ifdef FanmoreMock
#import "MockFanOperations.h"
#import "ASIHTTPRequest.h"
#import "ASICacheDelegate.h"
#import "A2DynamicDelegate.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "Task.h"
#import "MockDatas.h"

@interface MockFanOperations()

@property(strong)NSMutableArray* taskStore;
@property(strong)NSArray* storeStore;

@end

@implementation MockFanOperations

-(id)init{
    self = [super init];
    self.storeStore = @[[Store mockStore:0],[Store mockStore:1],[Store mockStore:2],[Store mockStore:3],[Store mockStore:4]];
    uint taskCount = 35+random()%20;
    self.taskStore = $new(NSMutableArray);
    while (taskCount-->0) {
        [self.taskStore addObject:[Task mockTask:self.storeStore]];
    }
    return self;
}

-(void)fakeTimeCost:(id<FanOpertationDelegate>)delegate progress:(BOOL)progress base:(int)base dynac:(int)dynac{
    NSLog(@"try to fake a timecosting show:%d base:%d",progress,base);
    if (progress) {
        CGFloat timetocost = base+(random()%dynac);
        CGFloat current = 0;
        while (current<timetocost) {
            [delegate foSetProgress:current/timetocost];
            [NSThread sleepForTimeInterval:1];
            current++;
        }
    } else {
        [delegate foStartSpin];
        [NSThread sleepForTimeInterval:base+(random()%dynac)];
        [delegate foStopSpin];
    }
}

-(void)fakeTimeCost:(id<FanOpertationDelegate>)delegate{
    [self fakeTimeCost:delegate progress:(random()%2)==0 base:2 dynac:4];
}

-(void)loading:(id<FanOpertationDelegate>)delegate block:(void (^)(LoadingState*,NSError*))block userName:(NSString*)userName password:(NSString*)password{
    //[self fakeTimeCost:delegate];
    
    LoadingState* ls = [LoadingState mockLoadingState];
    __weak __block LoadingState* _ls = ls;
    
    [[AppDelegate getInstance]downloadImage:ls.imgURL handler:^(UIImage *image, NSError *error) {
        if (image!=nil) {
            _ls.image = image;
            LOG(@"fetch new image:%@ %@",image,_ls);
            block(ls,nil);
        } else {
            block(nil,error);
        }
    } asyn:YES];
}


-(void)listTask:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray*,NSError*))block screenType:(uint)screenType paging:(Paging*)paging{
    NSArray* results;
    switch (sortType) {
//        case 0:
//            results = [self.taskStore sortedArrayUsingComparator:^NSComparisonResult(Task* obj1, Task* obj2) {
//                
//                return NSOrderedAscending;
//            }];
//            break;
            
        default:
            results = [self.taskStore sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"publishTime" ascending:NO]]];
            break;
    }
    
    uint startAt = pageIndex*pageSize;
    NSRange range = NSMakeRange(startAt, pageSize);
    block([results subarrayWithRange:range],Nil);
}

-(void)detailTask:(id<FanOpertationDelegate>)delegate block:(void (^)(NSArray*,NSError*))block task:(Task*)task{
    
    NSArray* srs = @[
                     [SendRecord mockSendRecord],
                     [SendRecord mockSendRecord],
                     [SendRecord mockSendRecord],
                     [SendRecord mockSendRecord],
                     [SendRecord mockSendRecord],
                     [SendRecord mockSendRecord],
                     [SendRecord mockSendRecord],
                     [SendRecord mockSendRecord],
                     [SendRecord mockSendRecord],
                     [SendRecord mockSendRecord],
                     ];
    [srs bk_performBlock:^(NSArray* obj) {
        block(obj,nil);
    } afterDelay:2+random()%5];
}

-(void)userInfo:(id<FanOpertationDelegate>)delegate block:(void (^)(UserInformation*))block{
    
    AppDelegate* app = [AppDelegate getInstance];
    
    app.incomeList = @{@0:@"小于3000",@1:@"小于5000",@2:@"小于10000",@3:@"小于20000",@4:@"大于20000"};
    app.industryList = @{@0:@"建筑建材",@1:@"冶金矿产",@2:@"石油化工",@3:@"水利水电",@4:@"交通运输",@5:@"信息产业",@6:@"机械机电",@7:@"轻工食品",@8:@"服装纺织",@9:@"专业服务"};
    app.favoriteList = @{@0:@"运动",@1:@"阅读",@2:@"旅游",@3:@"游戏",@4:@"电影",@5:@"音乐"};
    
    block([UserInformation mockUserInformation]);
}



#pragma mark -- fav store

-(void)myFavoriteStoreList:(id<FanOpertationDelegate>)delegate block:(void(^)(NSArray*,NSError*))block  paging:(Paging*)paging{
    
    NSMutableArray* sts = $marrnew;
    [self.storeStore $each:^(id obj) {
        Store* store = obj;
        if (store.fav) {
            [sts $push:store];
        }
    }];
    block(sts,nil);
}

-(void)myFavoriteTaskDetail:(id<FanOpertationDelegate>)delegate block:(void(^)(Store*,NSError*))block storeId:(NSString*)storeId{
    [self.storeStore $eachWithStop:^(id obj, BOOL *stop) {
        Store* store = obj;
        if ($eql(storeId,store.id)) {
            block(store,nil);
            *stop = YES;
        }
    }];
}

-(void)operFavorite:(id<FanOpertationDelegate>)delegate block:(void(^)(NSString*,NSError*))block store:(Store*)store{
    
    store.fav = !store.fav;
    if (store.fav) {
        block(@"收藏成功！",nil);
    } else {
        block(@"取消收藏成功！",nil);
    }
}

#pragma mark -- Cash
-(void)cashHistory:(id<FanOpertationDelegate>)delegate block:(void(^)(NSArray*,NSError*))block paging:(Paging*)paging{
    uint number = random()%20+6;
    NSMutableArray* buf = $marrnew;
    for (uint i=0; i<number; i++) {
        CashHistory* ch = [CashHistory mockCashHistory];
        ch.id = $int(i+1);
        [buf $push:ch];
    }
    block(buf,nil);
}
@end
#endif
