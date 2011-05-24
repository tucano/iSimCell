//
//  SimCellLinkerTest.m
//  iSimCell
//
//  Created by tucano on 5/24/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import "SimCellLinkerTest.h"


@implementation SimCellLinkerTest

- (void)setUp
{
    [super setUp];
    linker = [[SimCellLinker alloc] init];
}

- (void)tearDown
{
    [linker release];
    [super tearDown];
}

- (void)testAllocAndRelease
{
    STAssertNotNil(linker, @"test if object is not nil, got nil", linker);
}

@end
