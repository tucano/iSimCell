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
@synthesize outlineContents;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        
        // Initialization code here.
        NSLog(@"SimCellController: Window init.");
        
        // outlineView check example (smaple Code) sourceView
        outlineContents = [[NSMutableArray alloc] init];
        ChildNode *node = [[ChildNode alloc] init];
        [outlineContents addObject:node];
        [node release];

        
        [[NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(taskStarted:)
         name:@"SimCellTaskStarted"
         object:[mydocument simcell]];
        
        [[NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(taskFinished:)
         name:@"SimCellTaskComplete"
         object:[mydocument simcell]];
        
        [[NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(endReadingData:)
         name:@"SimCellEndReadingData"
         object:[mydocument simcell]];
    }
    
    return self;
}

- (void)dealloc
{
    [outlineContents release];
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    mydocument = [self document];
    simulation = [mydocument simulation];
    
    NSLog(@"SimName: %@", simulation.name);
    [[outlineContents objectAtIndex:0] setNodeTitle:simulation.name];
    NSLog(@"SimCellController: outlineview data: %@", outlineContents);
    
    // SET INTERFACE DEFAULTS
    [outputPouUp selectItemWithTitle:[[self selectedConfiguration] output] ];
    
    // Logging various things
    NSLog(@"SimCellController: Window Loaded. Calling Document is: %@", mydocument);
    NSLog(@"SimCellController: MySimulation Model: %@", simulation.uniqueID);
    NSLog(@"SimCellController: simulation first configuration: %@", [[[simulation.configurations allObjects] objectAtIndex:0] valueForKey:@"uniqueID"]);
    NSLog(@"Selected configuration name: %@, output: %@", [[self selectedConfiguration] name], [[self selectedConfiguration] output]);
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
    return [@"iSimCell - " stringByAppendingString:displayName];
}

#pragma mark -
#pragma mark Actions

- (IBAction)launchSim:(id)sender
{
    [mydocument runSimCell:[self selectedConfiguration]];
}

-(IBAction)terminateSim:(id)sender
{
    [mydocument killSimCell];
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
    NSLog(@"Controller for window %@. Task Start.", [mydocument displayName]);
}

-(void)taskFinished:(NSNotification *)notification
{
    NSLog(@"Controller for window %@. Task End.", [mydocument displayName]);
}

-(void)endReadingData:(NSNotification *)notification
{
    [progBar stopAnimation:self];
    NSLog(@"Controller for window %@. End Reading Data.", [mydocument displayName]);
}

#pragma mark -
#pragma mark Private

-(Configuration *)selectedConfiguration
{
    return [[configurationsController selectedObjects] objectAtIndex:0];
}

#pragma mark -
#pragma mark oulineView

- (NSMutableArray *)outlineContents
{
    return outlineContents;
}

@end
