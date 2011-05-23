//
//  MySimulationTest.m
//  iSimCell
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 IFOM-FIRC. All rights reserved.
//

#import "MySimulationTest.h"


@implementation MySimulationTest

- (void)setUp
{
    [super setUp];
    
    testsimulation = [[MySimulation alloc] init];
}

- (void)tearDown
{
    [testsimulation release];
    
    [super tearDown];
}

- (void)testAllocAndRelease
{
   
    STAssertNotNil(testsimulation, @"test if object is not nil, got nil", testsimulation);
}

- (void)testNibLoad
{
    // test strings with equalObjects
    NSString *nibName = [testsimulation windowNibName];
    STAssertEqualObjects(@"SimCellWindow", nibName, @"test if nib connected is SimCellWindow, got %@", nibName);
}

@end
