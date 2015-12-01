//
//  FanmoreTests2.m
//  FanmoreTests2
//
//  Created by Cai Jiang on 2/28/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FMUtils.h"
#import "LoadingState.h"
#import "RegexKitLite.h"
#import "Task.h"
#import <ShareSDK/ShareSDK.h>
#import "SecureHelper.h"

@interface FanmoreTests2 : XCTestCase

@end

@implementation FanmoreTests2

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testIden{
    NSUUID* uuid = [[UIDevice currentDevice] identifierForVendor];
//    NSLog([uuid UUIDString]);
    //C5CA0FC6-02BD-4242-8A27-31EB1065F7F6
    LOG(@"%@",[uuid UUIDString]);
//    rh7g0yisfwgWpW7vFtcfWQqSOklNYmpVPlS+pFFNo7Ugjldc9WqQ3/NKBBQ9PbTPZMu7fRkboc75sknemI3JdAFUFky8Qq+rgbGiIZ40DY1tD68w2ET9zPpEaE+L7hQ0WsqVeYj3ADmGN2N46rtUi4GsrTM+snhQ/ymIz5uvEbQ=
}

-(void)testRSA{
    NSData* data = [SecureHelper rsaEncryptString:@"App Name\
                    粉木耳\
                    Description\
                    粉木耳，最轻松的网赚平台\
                    正宗的价值分享，真实的赚钱神器，欢迎下载由人脉传播领导品牌粉木耳为您倾情推出的粉木耳手机软件。粉木耳，一秒钟，变达人，转的好，赚得多。\
                    \
                    What's New in this Version\
                    1.新增新浪微博和QQ空间分享渠道，让你的积分最大化获取\
                    2.优化转发的用户体验\
                    3.修正了部分用户提现有时出错的问题\
                    4.修改了输入框体可能无法选择的问题\
                    5.新增转发时间间隔限制\
                    Keywords\
                    粉木耳,理财,财务,赚钱,积分,微信,生活,优惠,分享\
                    Support URL\
                                             http://www.fanmore.cn\
                    Marketing URL (Optional)\
                                             http://www.fanmore.cn\
                    Privacy Policy URL (Optional)\
                                             http://task.fanmore.cn/appservice.html\
                    \
                    \
                    包括文件:\
                    粉木耳.ipa 投放到我们自己网站\
                    粉木耳91.ipa 投放到91\
                    粉木耳weiphone.ipa 投放到weiphone\
                    screenshots 包含3.5英寸和4英寸截屏"];
    LOG(@"%@",[data base64Encoding]);
}

-(void)testURLpara{
//    [NSBundle bundle]
//    NSBundle* rs = [NSBundle bundleWithPath:@"Resource.bundle"];
    NSBundle* rs = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"]];
    NSError* error = nil;
    [rs loadAndReturnError:&error];
    LOG(@"error: %@",error);
    LOG(@"%@ %@",rs,[NSBundle mainBundle]);
    NSString* path =  [rs pathForResource:@"Icon/sns_icon_11" ofType:@"png"];
    LOG(@"path %@",path);
    LOG(@"%@",[UIImage imageWithContentsOfFile:path]);
    LOG(@"%@",[ShareSDK getClientIconWithType:ShareTypeQQSpace]);
    LOG(@"%@",[UIImage imageNamed:@"sns_icon_11"]);
    NSString* str1  = @"QQ0605EE5C://response_from_qq?source_scheme=mqqapi&source=qq&error=0&version=1";
    NSString* str2 = @"QQ0605EE5C://response_from_qq?source_scheme=mqqapi&source=qq&error=-4&error_description=dGhlIHVzZXIgZ2l2ZSB1cCB0aGUgY3VycmVudCBvcGVyYXRpb24=&version=1";
    
    XCTAssertTrue($eql(@"0",[str1 parameterFromQuery:@"error"]));
    XCTAssertTrue($eql(@"-4",[str2 parameterFromQuery:@"error"]));
    
    XCTAssertTrue(0==[[str1 parameterFromQuery:@"error"] intValue]);
    XCTAssertTrue(-4==[[str2 parameterFromQuery:@"error"] intValue]);
}

-(void)testLocal{
    LOG(@"%@",NSLocaleIdentifier);
    LOG(@"%@",[[NSLocale currentLocale] identifier]);
    LOG(@"%@",
    NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.mm.account",nil,[NSBundle mainBundle],@"我的账号",nil));
}

-(void)testHash{
    Task* task1 = $new(Task);
    Task* task2 = $new(Task);
    Task* task3 = $new(Task);
    
    task1.taskId = @1;
    task1.taskName = @"1";
    
    task2.taskId = @2;
    task2.taskName = @"2";
    task3.taskId = @1;
    task3.taskName = @"1";
    
    XCTAssertTrue($eql(task1,task3));
    XCTAssertFalse($eql(task1,task2));
    
    XCTAssertNotEqual([task1 hash], [task2 hash]);
    XCTAssertEqual([task1 hash], [task3 hash]);
    
    NSMutableArray* arr = $marrnew;
    [arr addObject:task1];
    XCTAssertTrue(1==arr.count);
    [arr addObject:task2];
    XCTAssertTrue(2==arr.count);
//    [arr addObjectsFromArray:<#(NSArray *)#>];
    XCTAssertNotEqual([arr indexOfObject:task3],NSNotFound);
    XCTAssertEqual([arr indexOfObject:task3],[arr indexOfObject:task1]);
}

-(void)testString{
    NSDate* totest = [NSDate date];
    NSDateFormatter* df = $new(NSDateFormatter);
    
    [df setTimeStyle:NSDateFormatterMediumStyle];
    [df setDateStyle:NSDateFormatterMediumStyle];
    
    //Mar 12, 2014, 8:06:03 PM
    NSString* toteststr = [df stringFromDate:totest];
    LOG(@"%@",[df stringFromDate:totest]);
//    totest
//    XCTAssertTrue($eql(totest, [df dateFromString:toteststr]));
    LOG(@"%@",[df dateFromString:toteststr]);
    
    LOG(@"%@",[totest fmToString]);
    
    NSString* toteststr2 = @"2014-03-12 20-12-20";
    XCTAssertTrue($eql(toteststr2,[[toteststr2 fmToDate]fmToString]));
    
    toteststr2 = @"2014-03-12";
    XCTAssertTrue($eql(toteststr2,[[toteststr2 fmToDate]fmStandStringDateOnly]));
}

-(void)testPattern{
    NSString* pattern = @"^[A-Za-z]{1}[A-Za-z0-9_@.]{2,19}$";
    XCTAssertFalse([@"" isMatchedByRegex:pattern], @"");
    XCTAssertFalse([@"12345678901234567890" isMatchedByRegex:pattern], @"");
    XCTAssertFalse([@"123456789012345678900" isMatchedByRegex:pattern], @"");
    XCTAssertFalse([@"a12345678901234567890" isMatchedByRegex:pattern], @"");
    XCTAssertTrue([@"a1234567890134567890" isMatchedByRegex:pattern], @"");
    XCTAssertTrue([@"a12" isMatchedByRegex:pattern], @"");
    
    XCTAssertTrue([@"a123_567890134567890" isMatchedByRegex:pattern], @"");
    XCTAssertTrue([@"a12345678901@4567890" isMatchedByRegex:pattern], @"");
    XCTAssertTrue([@"a12345678.0134567890" isMatchedByRegex:pattern], @"");
    
    XCTAssertFalse([@"a12345中90134567890" isMatchedByRegex:pattern], @"");
    XCTAssertFalse([@"a12345;90134567890" isMatchedByRegex:pattern], @"");
    XCTAssertFalse([@"a12345%90134567890" isMatchedByRegex:pattern], @"");
    
    NSString* numberPattern = @"([0-9]+)";
    
    NSArray* arr = [@"'123'" componentsMatchedByRegex:numberPattern];
    for (id abc in arr) {
        LOG(@"%@ %@",abc,[abc class]);
    }
    NSString* match = [@"'123'" stringByMatching:numberPattern];
    XCTAssertEqual([match isEqualToString:@""], NO, @"");
    LOG(@"%@ %d",match,[match intValue]);
    XCTAssertEqual([match intValue], 123, @"");
}

-(void)testNumberformat{
    
    NSNumberFormatter* nsf1 = $new(NSNumberFormatter);
    nsf1.numberStyle =NSNumberFormatterCurrencyStyle;
    LOG(@"%@",[nsf1 stringFromNumber:@19180055]);
    nsf1.currencySymbol=@"";
    LOG(@"%@",[nsf1 stringFromNumber:@19180055]);
    [nsf1 setMaximumFractionDigits:0];
    LOG(@"%@",[nsf1 stringFromNumber:@19180055]);
    
    LOG(@"%@",
        [NSNumberFormatter localizedStringFromNumber:@1928191 numberStyle:NSNumberFormatterCurrencyStyle]);
    //￥1,928,191.00
    
    
}

-(void)testScreen{
    UIScreen* screen = [UIScreen mainScreen];
    //    CGRect rect = [screen boundsForOrientation:UIInterfaceOrientationPortraitUpsideDown];
    CGRect rect = CGRectMake(100, 40, 150, 160);
    CGRect newRect = CGRectMake(100, 400, 150, 160);
    newRect = CGRectOffset(newRect, 0, screen.bounds.size.height-5-newRect.size.height-newRect.origin.y);
    //ny = oy-dy
    //ny = X
    //dy = X-oy   dy = oy-X;
    LOG(@"height:%f  rect: %f,%f",screen.bounds.size.height,newRect.origin.x,newRect.origin.y);//
    //480-160 320-5
    CGRect tr;
    tr = [FMUtils lockAtScreen:(UISwipeGestureRecognizerDirectionDown) rect:rect offset:5];
    LOG(@"%f,%f",tr.origin.x,tr.origin.y);
    tr = [FMUtils lockAtScreen:(UISwipeGestureRecognizerDirectionUp) rect:rect offset:5];
    LOG(@"%f,%f",tr.origin.x,tr.origin.y);
    
    tr = [FMUtils lockAtScreen:(UISwipeGestureRecognizerDirectionLeft) rect:rect offset:5];
    LOG(@"%f,%f",tr.origin.x,tr.origin.y);
    tr = [FMUtils lockAtScreen:(UISwipeGestureRecognizerDirectionRight) rect:rect offset:5];
    LOG(@"%f,%f",tr.origin.x,tr.origin.y);
}


@end
