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

- (id)init
{
    self = [super init];
    if (self) {

    }    
    return self;
}

- (void)dealloc
{
    [task release];  
    [super dealloc];
}

- (void)launchTask
{
    // PATH
    path = [ [NSBundle mainBundle] pathForAuxiliaryExecutable:@"simCell"];
    
    // PIPES
    inputPipe = [NSPipe pipe];
    outputPipe = [NSPipe pipe];
    outputPipeError = [NSPipe pipe];
    
    // FILEHANDLES
    taskInput = [inputPipe fileHandleForWriting];
    taskOutput = [outputPipe fileHandleForReading];
    taskLog = [outputPipeError fileHandleForReading];
    
    // ALLOC TASK
    task = [[NSTask alloc] init];
   
    
    // ALLOC OUTPUTS
    [task setStandardOutput:outputPipe];
    [task setStandardError:outputPipeError];
    [task setStandardInput:inputPipe];       
    
    if ([self arguments])
        [task setArguments: [self arguments]];
    NSDictionary *defaultEnvironment = [[NSProcessInfo processInfo] environment];
    NSMutableDictionary *environment = [[NSMutableDictionary alloc] initWithDictionary:defaultEnvironment];
    
    [task setLaunchPath:path];
    [environment setObject:@"YES" forKey:@"NSUnbufferedIO"];
    [task setEnvironment:environment];
    
    [ [NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(endTask:) 
     name:NSTaskDidTerminateNotification 
     object:task];
    
    [ [NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(taskDataAvailable:) 
     name:NSFileHandleReadCompletionNotification
     object:taskOutput];
    
    [task launch];
    [taskOutput readInBackgroundAndNotify];

    [environment release];
}

- (void)sendData:(NSString *)dataString
{
    [taskInput writeData:[dataString dataUsingEncoding:[NSString defaultCStringEncoding]]];
}

-(void)killTask
{
    if ([task isRunning])
        [task terminate];
}

-(void)endTask:(NSNotification *)notification
{
    int exitCode = [[notification object] terminationStatus];
    NSLog(@"End Task with ExitCode: %i", exitCode);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Do whatever else you need to do when the task finished
}

- (void)taskDataAvailable:(NSNotification *)notif
{
    NSData *incomingData = [[notif userInfo] objectForKey:NSFileHandleNotificationDataItem];
    if (incomingData && [incomingData length])
    {
        NSString *incomingText = [[NSString alloc] initWithData:incomingData encoding:NSASCIIStringEncoding];
        // Do whatever with incomingText, the string that has some text in it
        NSLog(@"%@", incomingText);
        [taskOutput readInBackgroundAndNotify];
        [incomingText release];
        return;
    }
}

@end
