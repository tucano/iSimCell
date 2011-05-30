//
//  MySimulationTest.m
//  iSimCell
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 IFOM-FIRC. All rights reserved.
//

#import "MySimulationTest.h"


@implementation MySimulationTest

-(void)setUp
{
    [super setUp];    
    testsimulation = [[MySimulation alloc] initWithType:@"XML" error:0];
}

-(void)tearDown
{
    [testsimulation release];
    [super tearDown];
}

-(void)testAllocAndRelease
{   
    STAssertNotNil(testsimulation, @"test if object is not nil, got nil: %@", testsimulation);
    STAssertNotNil([testsimulation fetchSimulations], @"test if object is not nil, got nil: %@", [testsimulation fetchSimulations]);
    STAssertFalse([testsimulation simcellLock], @"test if simcell lock id FALSE, got TRUE.");
    STAssertNotNil([testsimulation managedObjectContext], @"test if there is a managed object context. Got nilL %@", [testsimulation managedObjectContext]);
}

-(void)testNibLoad
{
    // test strings with equalObjects
    NSString *nibName = [testsimulation windowNibName];
    STAssertEqualObjects(@"SimCellWindow", nibName, @"test if nib connected is SimCellWindow, got %@", nibName);
}

-(void)fetchSimulation
{
    NSString *simulation_first = [[[testsimulation fetchSimulations] objectAtIndex:0] uniqueID];
    STAssertEqualObjects(simulation_first, [testsimulation fetchSimulation:simulation_first], @"test if nib connected is SimCellWindow, got %@", [testsimulation fetchSimulation:simulation_first]);
}

-(void)testSimulationName
{
    NSString *simulation_name = [[[testsimulation fetchSimulations]objectAtIndex:0] name];
    STAssertEqualObjects(@"New Simulation", simulation_name, @"test if simulation name, got %@", simulation_name);
}

-(void)testConfigName
{
//    NSString *config_name = [[[[testsimulation simulation].configurations allObjects] objectAtIndex:0] name];
//    STAssertEqualObjects(@"Default Config", config_name, @"test config default name, got %@", config_name);
}

-(void)testNewSimulation
{
    STAssertNoThrow([testsimulation newSimulation], @"Test newSimulation");
}

-(void)testNewConfiguration
{
//    Configuration *config = [testsimulation newConfiguration:@"NewConfig"];
//    STAssertNotNil(config, @"Test New configuration, got nil");
//    STAssertEqualObjects(@"NewConfig", config.name, @"test name of new config equal to NewConfig, got", config.name);
}


@end
