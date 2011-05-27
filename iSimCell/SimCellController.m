//
//  SimCellController.m
//  iSimCell
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import "SimCellController.h"

@implementation SimCellController

#pragma mark -
#pragma mark Initialization

@synthesize managedObjectContext;
@synthesize simulationController;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        simcell = [[SimCellLinker alloc] init];
        NSLog(@"SimCellController: Window alloc. created linker:: %@", simcell);
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
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    mydocument = [self document];
    simulation = [mydocument getSimulation];
    NSLog(@"SimCellController: Window Loaded. Calling Document is: %@", mydocument);
    NSLog(@"SimCellController: MySimulation Model: %@", simulation.uniqueID);
    NSLog(@"SimCellController: simulation first configuration: %@", [[[simulation.configurations allObjects] objectAtIndex:0] valueForKey:@"uniqueID"]);
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
    return [@"iSimCell - " stringByAppendingString:displayName];
}

#pragma mark -
#pragma mark Actions

- (IBAction)launchSim:(id)sender
{
    // register observer for start task
    [self addNotification:@"SimCellTaskStarted" selector:@"taskStarted:"];

    [simcell setArguments: [NSArray arrayWithObjects: @"-ographml",@"-n1",@"-T15",@"-D10",nil] ];
    [simcell launchTask];

    // register observer for complete task
    [self addNotification:@"SimCellTaskComplete" selector:@"taskFinished:"];
}

-(IBAction)terminateSim:(id)sender
{
    [simcell killTask];
}

-(IBAction)changeOutput:(id)sender
{
    NSLog(@"Current configuration: %@. Sender: %@",[[self selectedConfiguration] name],[[sender selectedItem] title]);
    [[self selectedConfiguration] setValue:[[sender selectedItem] title] 
                                    forKey:@"output"];
}

#pragma mark -
#pragma mark Notifications

-(void)taskStarted:(NSNotification *)notification
{
   [progBar startAnimation:self];
    NSLog(@"Controller for window %@. Task Control Start.", [mydocument displayName]);
}

-(void)taskFinished:(NSNotification *)notification
{
    [progBar stopAnimation:self];
    NSLog(@"Controller for window %@. Task Control End.", [mydocument displayName]);

    simulation.data = [simcell taskData];
    //NSLog(@"Data: %@", [simulation stringifyData]);
}

#pragma mark -
#pragma mark Private
-(Configuration *)selectedConfiguration
{
    return [[configurationsController selectedObjects] objectAtIndex:0];
}

-(void)addNotification:(NSString *)message selector:(NSString *)selector
{
    SEL method;
    method = NSSelectorFromString(selector);
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:method
     name:message
     object:simcell];
}

@end
