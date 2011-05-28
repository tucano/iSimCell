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
    
    testsimulation = [[MySimulation alloc] initWithType:@"XML" error:0];
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

- (void)testSimulationName
{
    NSString *simulation_name = [[testsimulation simulation] name];
    STAssertEqualObjects(@"New Simulation", simulation_name, @"test if simulation name, got %@", simulation_name);
}

- (void)testConfigName
{
    NSString *config_name = [[[[testsimulation simulation].configurations allObjects] objectAtIndex:0] name];
    STAssertEqualObjects(@"Default Config", config_name, @"test config default name, got %@", config_name);
}
@end
