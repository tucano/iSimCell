//
//  iSimCellTests.m
//  iSimCellTests
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 IFOM-FIRC. All rights reserved.
//

#import "iSimCellTests.h"


@implementation iSimCellTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    // Simple Test
    int pippo = 1;
    STAssertEquals(1, pippo, @"Test if pippo is 1, got: %i", pippo);
}

@end
