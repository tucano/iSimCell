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
#pragma mark Initialization & Dealloc

@synthesize managedObjectContext;
@synthesize simulationController;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        
        // Initialization code here.
        NSLog(@"SimCellController: Window init.");
        
        // test outlineVIEW
        // outlineView check example (sample Code) sourceView
        outlineContents = [[NSMutableArray alloc] init];
        
        // Notify START TASK
        [[NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(taskStarted:)
         name:@"SimCellTaskStarted"
         object:[mydocument simcell]];

        // Notify TASK COMPLETE
        [[NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(taskFinished:)
         name:@"SimCellTaskComplete"
         object:[mydocument simcell]];
        
        // Notify END READING DATA
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
    
    // build our default tree on a separate thread,
	// some portions are from disk which could get expensive depending on the size of the dictionary file:
	[NSThread detachNewThreadSelector:	@selector(populateOutlineContents:)
                             toTarget:self		// we are the target
                           withObject:nil];
    
    // SET INTERFACE DEFAULTS
    [outputPouUp selectItemWithTitle:[[self selectedConfiguration] output] ];
    
    // scroll to the top in case the outline contents is very long
	[[[myOutlineView enclosingScrollView] verticalScroller] setFloatValue:0.0];
	[[[myOutlineView enclosingScrollView] contentView] scrollToPoint:NSMakePoint(0,0)];
	
	// make our outline view appear with gradient selection, and behave like the Finder, iTunes, etc.
	[myOutlineView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
    
    // Logging various things
    //NSLog(@"SimCellController: outlineview data: %@", outlineContents);
    NSLog(@"SimCellController: Window Loaded. Calling Document is: %@", mydocument);
    NSLog(@"SimCellController: simulations: %@", [mydocument fetchSimulations]);
    //NSLog(@"SimCellController: simulation first configuration: %@", [[[simulation.configurations allObjects] objectAtIndex:0] valueForKey:@"uniqueID"]);
    //NSLog(@"SimCellController: selected configuration name: %@, output: %@", [[self selectedConfiguration] name], [[self selectedConfiguration] output]);
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

@end
