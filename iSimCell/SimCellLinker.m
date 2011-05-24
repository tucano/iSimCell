//
//  SimCellLinker.m
//  iSimCell
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import "SimCellLinker.h"


@implementation SimCellLinker

@synthesize fromSimcellbin, fromSimCellError, simCellArguments, simCellData;

- (id)init
{
    path = 0;
    self = [super init];
    if (self) {

        // PATH
        path = [ [NSBundle mainBundle] pathForAuxiliaryExecutable:@"simCell"];
        
        // PIPES
        toPipe = [NSPipe pipe];
        fromPipe = [NSPipe pipe];
        fromPipeError = [NSPipe pipe];
        
        // FILEHANDLES
        toSimcellbin = [toPipe fileHandleForWriting];
        fromSimcellbin = [fromPipe fileHandleForReading];
        fromSimCellError = [fromPipeError fileHandleForReading];
        
        // ALLOC TASK
        simcellbin = [[NSTask alloc] init];
        [simcellbin setLaunchPath:path];
        
        // ALLOC OUTPUTS
        [simcellbin setStandardOutput:fromPipe];
        [simcellbin setStandardError:fromPipeError];
        [simcellbin setStandardInput:toPipe];        
    }
    
    return self;
}

- (void)dealloc
{
    [simcellbin terminate];
    [simcellbin release];
    [super dealloc];
}

- (void) launch
{
    if ([self simCellArguments])
        [simcellbin setArguments: [self simCellArguments]];
    
    [simcellbin launch];
}

- (void) storeData
{
    [self setSimCellData:[[self fromSimcellbin] readDataToEndOfFile]];
}

@end
