//
//  SimCellLinker.m
//  iSimCell
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import "SimCellLinker.h"


@implementation SimCellLinker

@synthesize fromSimcellbin;

- (id)init
{
    path = 0;
    self = [super init];
    if (self) {
        path = [ [NSBundle mainBundle] pathForAuxiliaryExecutable:@"simCell"];
        toPipe = [NSPipe pipe];
        fromPipe = [NSPipe pipe];
        
        toSimcellbin = [toPipe fileHandleForWriting];
        fromSimcellbin = [fromPipe fileHandleForReading];
        
        simcellbin = [[NSTask alloc] init];
        [simcellbin setLaunchPath:path];
        
        [simcellbin setStandardOutput:fromPipe];
        [simcellbin setStandardInput:toPipe];
        
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [simcellbin release];
    [super dealloc];
}

- (void) launch
{
    [simcellbin launch];
}

@end
