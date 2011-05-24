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

- (void)testLaunch
{
    [linker launch];
    STAssertNotNil(linker, @"test if object is not nil, got nil", linker);
    STAssertNotNil([linker fromSimcellbin], @"Test if stdoutput is not nil, got nil");
    STAssertNotNil([linker fromSimCellError], @"Test if stdouterror is not nil, got nil");
}
@end
