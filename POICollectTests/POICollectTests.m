//
//  POICollectTests.m
//  POICollectTests
//
//  Created by 常敏 on 15-6-18.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSString+AXNetworkingMethods.h"

@interface POICollectTests : XCTestCase

@end

@implementation POICollectTests

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

- (void)testExample
{
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");

    NSLog(@"随机的字符串 -- %@", [NSString currentDateStr]);
    NSLog(@"随机的字符串 -- %@", [NSString currentDateStr]);
    NSLog(@"随机的字符串 -- %@", [NSString currentDateStr]);
    NSLog(@"随机的字符串 -- %@", [NSString currentDateStr]);

    NSLog(@"随机的数字 -- %li", (long)[[NSString currentDateStr] integerValue]);
    NSLog(@"随机的数字 -- %li", (long)[[NSString currentDateStr] integerValue]);

    NSLog(@"随机的数字 -- %li", (long)[[NSString currentDateStr] integerValue]);

    NSLog(@"随机的数字 -- %li", (long)[[NSString currentDateStr] integerValue]);
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
