//
//  SimCellControllerTest.m
//  iSimCell
//
//  Created by tucano on 5/24/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import "SimCellControllerTest.h"


@implementation SimCellControllerTest

- (void)setUp
{
    [super setUp];
    ctl = [[SimCellController alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    [ctl release];
    [super tearDown];
}

- (void)testAllocAndRelease
{
    
    STAssertNotNil(ctl, @"test if object is not nil, got nil", ctl);
}

@end
