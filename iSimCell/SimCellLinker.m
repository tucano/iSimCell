//
//  SimCellLinker.m
//  iSimCell
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import "SimCellLinker.h"


@implementation SimCellLinker

@synthesize simCellArguments;

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
        simcellTask = [[NSTask alloc] init];
        [simcellTask setLaunchPath:path];
        
        // ALLOC OUTPUTS
        [simcellTask setStandardOutput:fromPipe];
        [simcellTask setStandardError:fromPipeError];
        [simcellTask setStandardInput:toPipe];        
    }
    
    return self;
}

- (void)dealloc
{
    [simcellTask release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void) launch
{
    if ([self simCellArguments])
        [simcellTask setArguments: [self simCellArguments]];
    
    [ [NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(endTask:) 
     name:NSTaskDidTerminateNotification 
     object:simcellTask];
    
    [simcellTask launch];
}

- (void) storeData
{
    simCellData = [fromSimcellbin readDataToEndOfFile];
    NSLog(@"FINAL DATA LENGHT: %lu", [simCellData length]);
}

-(void)endTask:(NSNotification *)notification
{
    NSLog(@"End Task");
}


@end
