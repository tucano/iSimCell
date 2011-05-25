//
//  SimCellController.m
//  iSimCell
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import "SimCellController.h"

@implementation SimCellController

/* 
 *  INIT, LOAD, DEALLOC
 */

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        simcell = [[SimCellLinker alloc] init];       
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [simcell release];
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    NSLog(@"Window Loaded");
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
    return [@"iSimCell - " stringByAppendingString:displayName];
}


/* 
 *  ACTIONS
 */
- (IBAction)launchSim:(id)sender
{
    // register observer for start task
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(taskStarted:) 
     name:@"SimCellTaskStarted" 
     object:simcell];

    [simcell setArguments: [NSArray arrayWithObjects: @"-ographml",@"-n1",@"-T15",@"-D10",nil] ];
    [simcell launchTask];

    // register observer for complete task
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(taskFinished:) 
     name:@"SimCellTaskComplete" 
     object:simcell];
}

-(IBAction)terminateSim:(id)sender
{
    [simcell killTask];
}

-(void)taskStarted:(NSNotification *)notification
{
   [progBar startAnimation:self];
    NSLog(@"Controller for window %@. Task Control Start.", [[self document] displayName]);
}

-(void)taskFinished:(NSNotification *)notification
{
    [progBar stopAnimation:self];
    NSLog(@"Controller for window %@. Task Control End.", [[self document] displayName]);
}
@end
