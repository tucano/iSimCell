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

- (SimCellController *)initWithManagedObjectContext:(NSManagedObjectContext *)inMoc
{
    NSLog(@"OVERRRIDE OK: taking control of managed object Context: %@", [self managedObjectContext]);
    self = [super initWithWindowNibName:@"SimCellWindow"];
    [self setManagedObjectContext:inMoc];
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        
        // Initialization code here.
        NSLog(@"SimCellController: Window init.");
        
        // outlineView binding container
        outlineContents = [[NSMutableArray alloc] init];
        
        // cache the reused icon images
		folderImage = [[[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericFolderIcon)] retain];
		[folderImage setSize:NSMakeSize(16,16)];
		
		urlImage = [[[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericURLIcon)] retain];
		[urlImage setSize:NSMakeSize(16,16)];
        
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
    [folderImage release];
	[urlImage release];
    
    [infoView release];
    
    [outlineContents release];
    [separatorCell release];
    [super dealloc];
}

-(void)awakeFromNib
{
    NSLog(@"SimCellController: AWAKE FROM NIB");
    
    // load the info view controller for later use
	infoView = [[InfoView alloc] initWithNibName:INFOVIEW_NIB bundle:nil];
    [infoView setValue:self forKey:@"mainWindowController"];
    [infoView setValue:simulationController forKey:@"simulationController"];
    
    // apply our custom ImageAndTextCell for rendering the first column's cells
	NSTableColumn *tableColumn = [myOutlineView tableColumnWithIdentifier:COLUMNID_NAME];
	ImageAndTextCell *imageAndTextCell = [[[ImageAndTextCell alloc] init] autorelease];
	[imageAndTextCell setEditable:YES];
	[tableColumn setDataCell:imageAndTextCell];
    
	separatorCell = [[SeparatorCell alloc] init];
    [separatorCell setEditable:NO];
    
    // build our default tree on a separate thread,
	// some portions are from disk which could get expensive depending on the size of the dictionary file:
	[NSThread detachNewThreadSelector:	@selector(populateOutlineContents:)
                             toTarget:self		// we are the target
                           withObject:nil];
    
    // scroll to the top in case the outline contents is very long
	[[[myOutlineView enclosingScrollView] verticalScroller] setFloatValue:0.0];
	[[[myOutlineView enclosingScrollView] contentView] scrollToPoint:NSMakePoint(0,0)];
	
	// make our outline view appear with gradient selection, and behave like the Finder, iTunes, etc.
	[myOutlineView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    mydocument = [self document];
    
    // test place InfoView
    NSView *subView = [infoView view];
    [placeHolderView addSubview: subView];
    
    // Logging various things
    NSLog(@"SimCellController: Window Loaded. Calling Document is: %@", mydocument);
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
    NSLog(@"SimCellController: simulations Controller selection: %@",[[simulationController selectedObjects] objectAtIndex:0]);
    NSLog(@"SimCellController: configuration Controller: %@",[configurationController selectedObjects]);
   // Simulation *aS = [[simulationController selectedObjects] objectAtIndex:0];
    Configuration *aC = [[configurationController selectedObjects] objectAtIndex:0];
    [mydocument runSimCell:aC];
}

-(IBAction)terminateSim:(id)sender
{
    [mydocument killSimCell];
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
#pragma mark Accessors to binding values

// -------------------------------------------------------------------------------
//	setContents:newContents
// -------------------------------------------------------------------------------
- (void)setOutlineContents:(NSArray*)newContents
{
	if (outlineContents != newContents)
	{
		[outlineContents release];
		outlineContents = [[NSMutableArray alloc] initWithArray:newContents];
	}
}

// -------------------------------------------------------------------------------
//	contents:
// -------------------------------------------------------------------------------
- (NSMutableArray *)outlineContents
{
	return outlineContents;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)value
{
	// keep only weak ref
	_moc = value;
}

- (NSManagedObjectContext *)managedObjectContext
{
	return _moc;
}

#pragma mark -
#pragma mark Private

@end
