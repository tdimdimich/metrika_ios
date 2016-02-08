//
//  metrika_Tests.m
//  metrika Tests
//
//  Created by Dmitry Korotchenkov on 09/10/13.
//  Copyright (c) 2013 Progress Engine. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "YMUtils.h"
#import "YMValueTypeStringFormat.h"

@interface metrika_Tests : SenTestCase

@end

@implementation metrika_Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testTimeFormat {
    YMValueTypeStringFormat *format;
    format = [YMValueTypeStringFormat timeFormatFromSeconds:56];
    STAssertTrue(([format.value isEqualToString:@"56"] && [format.type isEqualToString:@"сек"]), nil);
    format = [YMValueTypeStringFormat timeFormatFromSeconds:60];
    STAssertTrue(([format.value isEqualToString:@"1"] && [format.type isEqualToString:@"м"]), nil);
    format = [YMValueTypeStringFormat timeFormatFromSeconds:156];
    STAssertTrue(([format.value isEqualToString:@"2.6"] && [format.type isEqualToString:@"м"]), nil);
    format = [YMValueTypeStringFormat timeFormatFromSeconds:8054];
    STAssertTrue(([format.value isEqualToString:@"2.2"] && [format.type isEqualToString:@"ч"]), nil);
    format = [YMValueTypeStringFormat timeFormatFromSeconds:3600 * 3];
    STAssertTrue(([format.value isEqualToString:@"3"] && [format.type isEqualToString:@"ч"]), nil);
    format = [YMValueTypeStringFormat timeFormatFromSeconds:805004];
    STAssertTrue(([format.value isEqualToString:@"9.3"] && [format.type isEqualToString:@"д"]), nil);
    format = [YMValueTypeStringFormat timeFormatFromSeconds:3600 * 24 * 5];
    STAssertTrue(([format.value isEqualToString:@"5"] && [format.type isEqualToString:@"д"]), nil);
}

@end
