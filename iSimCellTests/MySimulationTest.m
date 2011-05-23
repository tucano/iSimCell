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
    
    testSimulation = [[MySimulation alloc] init];
}

- (void)tearDown
{
    [testSimulation release];
    
    [super tearDown];
}

- (void)testAllocAndRelease
{
   
    STAssertNotNil(testSimulation, @"test if object is not nil, got nil", testSimulation);
}

@end
