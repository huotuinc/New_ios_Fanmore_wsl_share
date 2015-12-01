//
//  FanmoreTests.m
//  FanmoreTests
//
//  Created by Cai Jiang on 1/6/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FMUtils.h"
#import "LoadingState.h"
#import "RegexKitLite.h"

@interface FanmoreTests : XCTestCase

@end

@implementation FanmoreTests

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
