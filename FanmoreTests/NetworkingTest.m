//
//  NetworkingTest.m
//  Fanmore
//
//  Created by Cai Jiang on 1/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "FanOperations.h"
#import "MockDatas.h"
#import "DonetagHolder.h"
#import "FanOperationsTester.h"

@interface NetworkingTest : XCTestCase<DonetagHolder>

@property(strong) id<FanOperations> fanOperations;
@property NSArray* tasks;
@property NSArray* favStores;
@property NSCondition* lock;
@end

@interface NetworkingTest ()
@property (nonatomic)  BOOL done;
@end

@implementation NetworkingTest


-(BOOL)isDone{
    return _done;
}

-(void)setDone:(BOOL)d{
    _done = d;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.fanOperations = [FanOperationsTester tester:[[AppDelegate getInstance]getFanOperations] holder:self];
    self.lock  = $new(NSCondition);
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

-(void)tryLogin{
    [self.fanOperations login:NULL block:^(LoginState *ls, NSError *error) {
        XCTAssertNil(error, @"登录时异常");
    } userName:@"test96" password:@"123456"];
}

-(void)testVC{
    [self tryLogin];
    
    [self.fanOperations verificationCode:Nil block:^(NSString *msg, NSError *error) {
        NSAssert1(error==nil, @"发现异常%@",error);
    } phone:@"18606509616" type:2];
}


-(void)testTaskList{
    [self.fanOperations listTask:NULL block:^(NSArray *inputs, NSError *error) {
        self.tasks = inputs;
        LOG(@"get %d tasks",inputs.count);
        NSAssert1(error==nil, @"发现异常%@",error);
        NSAssert(inputs!=Nil, @"没有获得Task List");
        NSAssert(inputs.count>0, @"没有获得有效的List");
    } screenType:0  paging:[Paging paging:20 parameters:@{@"oldTaskId":@0}]];
}

-(void)testTaskDetail{
    if (self.tasks==Nil || self.tasks.count==0) {
        [self testTaskList];
    }
    
    Task* task = [self.tasks $last];
    LOG(@"准备测试%@",task);
    //
    [self.fanOperations detailTask:Nil block:^(NSArray *inputs, NSError *error) {
        NSAssert1(error==nil, @"发现异常%@",error);
        NSAssert(inputs!=Nil, @"没有获得TaskSend List");
    } task:task];
    LOG(@"%@",task);
}


-(void)testPartTaskList{
//    if(![[AppDelegate getInstance].loadingState.loginStatus boolValue]){
        [self tryLogin];
//    }
    
    [self.fanOperations listPartTask:Nil block:^(NSArray *inputs, NSError *error) {
        LOG(@"get %d tasks",inputs.count);
        NSAssert1(error==nil, @"发现异常%@",error);
        NSAssert(inputs!=Nil, @"没有获得Task List");
        NSAssert(inputs.count>0, @"没有获得有效的List");
    } type:0 paging:[Paging paging:20 parameters:@{@"autoId":@0}]];
}

-(void)testFavStore{
    [self tryLogin];
    [self testTaskList];
    for (Task* task in self.tasks) {
        if (![task.store.fav boolValue]) {
            [self.fanOperations operFavorite:Nil block:^(NSString *msg, NSError *error) {
                XCTAssertNil(error, @"发现错误%@",error);
                XCTAssertNotNil(msg, @"");
                XCTAssertTrue([task.store.fav boolValue], @"");
            } store:task.store];
            break;
        }
    }
    
    
    for (Task* task in self.tasks) {
        if ([task.store.fav boolValue]) {
            [self.fanOperations operFavorite:Nil block:^(NSString *msg, NSError *error) {
                XCTAssertNil(error, @"发现错误%@",error);
                XCTAssertNotNil(msg, @"");
                XCTAssertFalse([task.store.fav boolValue], @"");
            } store:task.store];
            break;
        }
    }
}

-(void)testStoreList{
    [self tryLogin];
    
    [self.fanOperations myFavoriteStoreList:Nil block:^(NSArray *stores, NSError *error) {
        XCTAssertNil(error, @"发现错误%@",error);
        XCTAssertNotNil(stores, @"");
        self.favStores = stores;
    } paging:[Paging paging:20 parameters:@{@"autoId":@0}]];
}

-(void)testFavStoreDetail{
    [self testStoreList];
    Store* store = [self.favStores $first];
    
    [self.fanOperations myFavoriteTaskDetail:Nil block:^(NSArray *task, NSError *error) {
        XCTAssertNil(error, @"发现错误%@",error);
        XCTAssertNotNil(task, @"");
    } store:store paging:[Paging paging:20 parameters:@{@"oldTaskId":@0}]];
}

#ifdef FanmoreMock

- (void)testLoading
{
//    [self.fanOperations loading:Nil userName:@"" password:@""];
    Task* task = [Task mockTask];
    LOG(@"time!!!!!!! %@",[task valueForKey:@"publishTime"]);
}

-(void)testListTask{
    [self.fanOperations listTask:Nil block:^(NSArray *tasks, NSError *error) {
        if (tasks) {
            [tasks $each:^(Task* task) {
                LOG(@"%@",task.publishTime);
            }];
        }
    } loginCode:@"" sortType:0 screenType:0 pageIndex:0 pageSize:10];
}

#endif

@end
