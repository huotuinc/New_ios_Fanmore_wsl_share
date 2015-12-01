//
//  MineSafeTest.m
//  Fanmore
//
//  Created by Cai Jiang on 2/28/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "FanOperations.h"
#import "MockDatas.h"
#import "DonetagHolder.h"
#import "FanOperationsTester.h"

@interface MineSafeTest : XCTestCase<DonetagHolder>

@property(strong) id<FanOperations> fanOperations;
@property NSArray* tasks;
@property NSArray* favStores;
@property NSCondition* lock;
@end

@interface MineSafeTest ()
@property (nonatomic)  BOOL done;
@end

@implementation MineSafeTest

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


-(void)testCPA{
    //IMEI:f6cd63df3535e97cc7498e4303d07e42
    //IMEI:cc393e5b2f5fe3b3fe119a63ce7d9462
//    IMEI:baf099fdfaaffdea835b614cc774c91a
    
    [self.fanOperations register:nil block:^(LoginState *ls, NSError *error) {
    } userName:@"18606509611" password:@"111111" code:nil];
    
//    [self.fanOperations loading:nil block:^(UIImage *imsg, NSError *error) {
//        //7819bfa2d8c422a3c13b78e90d1c2963
//        //IMEI:d17ea0483e40ac09ae0bcb09bbd5b5d8
//        //IMEI:d585043f8f509b3de8315073cd67fb67
//        NSLog(@"测试激活完成");
//        
//    } userName:nil password:nil];
}

-(void)tryLogin{
    [self.fanOperations login:NULL block:^(LoginState *ls, NSError *error) {
        XCTAssertNil(error, @"登录时异常");
    } userName:@"test96" password:@"123456"];
}

-(void)testVC{
    if (![[AppDelegate getInstance].loadingState.loginStatus boolValue]) {
        [self tryLogin];
    }
    
    [self.fanOperations verificationCode:Nil block:^(NSString *msg, NSError *error) {
        NSAssert1(error==nil, @"发现异常%@",error);
    } phone:@"18606509616" type:@2];
}

@end
