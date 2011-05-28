//
//  SimCellLinker.m
//  iSimCell
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import "SimCellLinker.h"


@implementation SimCellLinker

@synthesize arguments;

#pragma mark -
#pragma mark Initialization

- (id)init
{
    self = [super init];
    if (self) {
        
        //Register Notification for taskEnd
        [ [NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(endTask:) 
         name:NSTaskDidTerminateNotification 
         object:task];

        //Register Notification for NSfileHandle ReadToEnd
        [ [NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(readPipe:) 
         name:NSFileHandleReadToEndOfFileCompletionNotification
         object:taskOutput];
    }    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark -
#pragma mark Actions

- (void)launchTask
{
    path = [ [NSBundle mainBundle] pathForAuxiliaryExecutable:@"simCell"];

    // PIPES
    outputPipe = [NSPipe pipe];
    outputPipeError = [NSPipe pipe];
    
    // FILEHANDLES
    taskOutput = [outputPipe fileHandleForReading];
    taskLog = [outputPipeError fileHandleForReading];
    
    // ALLOC TASK
    task = [[NSTask alloc] init];
   
    
    // ALLOC OUTPUTS
    [task setStandardOutput:outputPipe];
    [task setStandardError:outputPipeError];
    [task setStandardInput:[NSPipe pipe]];
    
    if ([self arguments])
        [task setArguments: [self arguments]];
    NSDictionary *defaultEnvironment = [[NSProcessInfo processInfo] environment];
    NSMutableDictionary *environment = [[NSMutableDictionary alloc] initWithDictionary:defaultEnvironment];
    
    [task setLaunchPath:path];
    [environment setObject:@"YES" forKey:@"NSUnbufferedIO"];
    [task setEnvironment:environment];
    
    [task launch];
    
    // Post started task
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SimCellTaskStarted" object:self];
    
    [taskOutput readToEndOfFileInBackgroundAndNotify];

    [environment release];
}

-(void)killTask
{
    if ([task isRunning])
        [task terminate];
}

#pragma mark -
#pragma mark Notification

-(void)endTask:(NSNotification *)notification
{
    // FIXME
    int exitCode = [[notification object] terminationStatus];
    
    NSLog(@"End Task with ExitCode: %i", exitCode);
    
    if (exitCode != 0) {
        NSLog(@"Task failed with error: %@", [[NSString alloc] initWithData:[taskLog readDataToEndOfFile] 
                                                                   encoding:NSASCIIStringEncoding]);
    }
    
    // Do whatever else you need to do when the task finished
    
    // Post completed task
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SimCellTaskComplete" object:self];
    
    [task release];
}

- (void)readPipe:(NSNotification *)notification
{
    NSLog(@"Reading...");
    
    if( [notification object] != taskOutput ) return;
    
    NSData *incomingData = [[notification userInfo] objectForKey:NSFileHandleNotificationDataItem];

    if (incomingData && [incomingData length])
    {
        NSLog(@"DATA TO END OF FILE. FILE HANDLE\n: %@", [[NSString alloc] initWithData:incomingData encoding:NSASCIIStringEncoding]);
    }
}

@end
