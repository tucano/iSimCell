//
//  SimCellController.m
//  iSimCell
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import "SimCellController.h"

//////////////////////////////////////////////////////////
// SIDEBAR 
//////////////////////////////////////////////////////////

#define INITIAL_INFODICT		@"outlineView"		// name of the dictionary file to populate our outline view

// keys in our disk-based dictionary representing our outline view's data
#define KEY_NAME				@"name"
#define KEY_URL					@"url"
#define KEY_SEPARATOR			@"separator"
#define KEY_GROUP				@"group"
#define KEY_FOLDER				@"folder"
#define KEY_ENTRIES				@"entries"
#define KEY_SIMULATION			@"simulation"
#define KEY_CONFIGURATIONS		@"configurations"

// placeholders
#define SIMULATIONS_NAME        @"SIMULATIONS"
#define UNTITLED_NAME			@"Untitled"		// default name for added folders and leafs
#define HTTP_PREFIX				@"http://"



// -------------------------------------------------------------------------------
//	TreeAdditionObj
//
//	This object is used for passing data between the main and secondary thread
//	which populates the outline view.
// -------------------------------------------------------------------------------
@interface TreeAdditionObj : NSObject
{
	NSIndexPath *indexPath;
	NSString	*nodeURL;
	NSString	*nodeName;
	BOOL		selectItsParent;
}

@property (readonly) NSIndexPath *indexPath;
@property (readonly) NSString *nodeURL;
@property (readonly) NSString *nodeName;
@property (readonly) BOOL selectItsParent;
@end

@implementation TreeAdditionObj
@synthesize indexPath, nodeURL, nodeName, selectItsParent;

// -------------------------------------------------------------------------------
- (id)initWithURL:(NSString *)url withName:(NSString *)name selectItsParent:(BOOL)select
{
	self = [super init];
	
	nodeName = name;
	nodeURL = url;
	selectItsParent = select;
	
	return self;
}
@end


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
        NSLog(@"SimCellController: Window init.");
        
        // test outlineVIEW
        // outlineView check example (smaple Code) sourceView
        outlineContents = [[NSMutableArray alloc] init];
        
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
    NSLog(@"SimName: %@", simulation.name);
    NSLog(@"SimCellController: outlineview data: %@", outlineContents);
    NSLog(@"SimCellController: Window Loaded. Calling Document is: %@", mydocument);
    NSLog(@"SimCellController: MySimulation Model: %@", simulation.uniqueID);
    NSLog(@"SimCellController: simulation first configuration: %@", [[[simulation.configurations allObjects] objectAtIndex:0] valueForKey:@"uniqueID"]);
    NSLog(@"SimCellController: selected configuration name: %@, output: %@", [[self selectedConfiguration] name], [[self selectedConfiguration] output]);
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

// -------------------------------------------------------------------------------
//	outlineView: notifications
// -------------------------------------------------------------------------------

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSLog(@"Controller for window %@. Selection changed", [mydocument displayName]);
}

- (void)outlineViewSelectionIsChanging:(NSNotification *)notification
{
    NSLog(@"Controller for window %@. Selection is changing", [mydocument displayName]);
}


#pragma mark -
#pragma mark Private

-(Configuration *)selectedConfiguration
{
    return [[configurationsController selectedObjects] objectAtIndex:0];
}

#pragma mark -
#pragma mark oulineView

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

// -------------------------------------------------------------------------------
//	selectParentFromSelection:
//
//	Take the currently selected node and select its parent.
// -------------------------------------------------------------------------------
- (void)selectParentFromSelection
{
	if ([[outlineController selectedNodes] count] > 0)
	{
		NSTreeNode* firstSelectedNode = [[outlineController selectedNodes] objectAtIndex:0];
		NSTreeNode* parentNode = [firstSelectedNode parentNode];
		if (parentNode)
		{
			// select the parent
			NSIndexPath* parentIndex = [parentNode indexPath];
			[outlineController setSelectionIndexPath:parentIndex];
		}
		else
		{
			// no parent exists (we are at the top of tree), so make no selection in our outline
			NSArray* selectionIndexPaths = [outlineController selectionIndexPaths];
			[outlineController removeSelectionIndexPaths:selectionIndexPaths];
		}
	}
}

// -------------------------------------------------------------------------------
//	performAddFolder:treeAddition
// -------------------------------------------------------------------------------
-(void)performAddFolder:(TreeAdditionObj *)treeAddition
{
	// NSTreeController inserts objects using NSIndexPath, so we need to calculate this
	NSIndexPath *indexPath = nil;
	
	// if there is no selection, we will add a new group to the end of the contents array
	if ([[outlineController selectedObjects] count] == 0)
	{
		// there's no selection so add the folder to the top-level and at the end
		indexPath = [NSIndexPath indexPathWithIndex:[outlineContents count]];
	}
	else
	{
		// get the index of the currently selected node, then add the number its children to the path -
		// this will give us an index which will allow us to add a node to the end of the currently selected node's children array.
		//
		indexPath = [outlineController selectionIndexPath];
		if ([[[outlineController selectedObjects] objectAtIndex:0] isLeaf])
		{
			// user is trying to add a folder on a selected child,
			// so deselect child and select its parent for addition
			[self selectParentFromSelection];
		}
		else
		{
			indexPath = [indexPath indexPathByAddingIndex:[[[[outlineController selectedObjects] objectAtIndex:0] children] count]];
		}
	}
	
	ChildNode *node = [[ChildNode alloc] init];
	[node setNodeTitle:[treeAddition nodeName]];
	
	// the user is adding a child node, tell the controller directly
	[outlineController insertObject:node atArrangedObjectIndexPath:indexPath];
	
	[node release];
}

// -------------------------------------------------------------------------------
//	addFolder:folderName:
// -------------------------------------------------------------------------------
- (void)addFolder:(NSString *)folderName
{
	TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithURL:nil withName:folderName selectItsParent:NO];
	
	if (buildingOutlineView)
	{
		// add the folder to the tree controller, but on the main thread to avoid lock ups
		[self performSelectorOnMainThread:@selector(performAddFolder:) withObject:treeObjInfo waitUntilDone:YES];
	}
	else
	{
		[self performAddFolder:treeObjInfo];
	}
	
	[treeObjInfo release];
}

// -------------------------------------------------------------------------------
//	addConfigurations:
// -------------------------------------------------------------------------------
-(void)performAddConfiguration:(TreeAdditionObj *)treeAddition
{
    // NSTreeController inserts objects using NSIndexPath, so we need to calculate this
	NSIndexPath *indexPath = nil;
	
	// if there is no selection, we will add a new group to the end of the contents array
	if ([[outlineController selectedObjects] count] == 0)
	{
		// there's no selection so add the folder to the top-level and at the end
		indexPath = [NSIndexPath indexPathWithIndex:[outlineContents count]];
	}
	else
	{
		// get the index of the currently selected node, then add the number its children to the path -
		// this will give us an index which will allow us to add a node to the end of the currently selected node's children array.
		//
		indexPath = [outlineController selectionIndexPath];
		if ([[[outlineController selectedObjects] objectAtIndex:0] isLeaf])
		{
			// user is trying to add a COnfiguration on a selected child,
			// so deselect child and select its parent for addition
			[self selectParentFromSelection];
		}
		else
		{
			indexPath = [indexPath indexPathByAddingIndex:[[[[outlineController selectedObjects] objectAtIndex:0] children] count]];
		}
	}
    
    ChildNode *node = [[ChildNode alloc] init];
    [node setNodeTitle:[treeAddition nodeName]];
    [outlineController insertObject:node atArrangedObjectIndexPath:indexPath];
    [node release];
    
}

-(void)addConfiguration:(NSString *)nameStr selectParent:(BOOL)select
{
    TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithURL:nil withName:nameStr selectItsParent:YES];
	
	if (buildingOutlineView)
	{
		// add the child node to the tree controller, but on the main thread to avoid lock ups
		[self performSelectorOnMainThread:@selector(performAddConfiguration:) withObject:treeObjInfo waitUntilDone:YES];
	}
	else
	{
		[self performAddConfiguration:treeObjInfo];
	}
	
	[treeObjInfo release];
}


// -------------------------------------------------------------------------------
//	addSimulation:
// -------------------------------------------------------------------------------
-(void)performAddSimulation:(TreeAdditionObj *)treeAddition 
{
    // NSTreeController inserts objects using NSIndexPath, so we need to calculate this
	NSIndexPath *indexPath = nil;
	
	// if there is no selection, we will add a new group to the end of the contents array
	if ([[outlineController selectedObjects] count] == 0)
	{
		// there's no selection so add the folder to the top-level and at the end
		indexPath = [NSIndexPath indexPathWithIndex:[outlineContents count]];
	}
	else
	{
		// get the index of the currently selected node, then add the number its children to the path -
		// this will give us an index which will allow us to add a node to the end of the currently selected node's children array.
		//
		indexPath = [outlineController selectionIndexPath];
		if ([[[outlineController selectedObjects] objectAtIndex:0] isLeaf])
		{
			// user is trying to add a Simulation on a selected child,
			// so deselect child and select its parent for addition
			[self selectParentFromSelection];
		}
		else
		{
			indexPath = [indexPath indexPathByAddingIndex:[[[[outlineController selectedObjects] objectAtIndex:0] children] count]];
		}
	}
    
    ChildNode *node = [[ChildNode alloc] init];
    [node setNodeTitle:[treeAddition nodeName]];
    [outlineController insertObject:node atArrangedObjectIndexPath:indexPath];
    [node release];
    
}

- (void)addSimulation:(NSString *)nameStr selectParent:(BOOL)select
{
	TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithURL:nil withName:nameStr selectItsParent:YES];
	
	if (buildingOutlineView)
	{
		// add the child node to the tree controller, but on the main thread to avoid lock ups
		[self performSelectorOnMainThread:@selector(performAddSimulation:) withObject:treeObjInfo waitUntilDone:YES];
	}
	else
	{
		[self performAddSimulation:treeObjInfo];
	}
	
	[treeObjInfo release];
}

// -------------------------------------------------------------------------------
//	performAddChild:treeAddition
// -------------------------------------------------------------------------------
-(void)performAddChild:(TreeAdditionObj *)treeAddition
{
	if ([[outlineController selectedObjects] count] > 0)
	{
		// we have a selection
		if ([[[outlineController selectedObjects] objectAtIndex:0] isLeaf])
		{
			// trying to add a child to a selected leaf node, so select its parent for add
			[self selectParentFromSelection];
		}
	}
	
	// find the selection to insert our node
	NSIndexPath *indexPath;
	if ([[outlineController selectedObjects] count] > 0)
	{
		// we have a selection, insert at the end of the selection
		indexPath = [outlineController selectionIndexPath];
		indexPath = [indexPath indexPathByAddingIndex:[[[[outlineController selectedObjects] objectAtIndex:0] children] count]];
	}
	else
	{
		// no selection, just add the child to the end of the tree
		indexPath = [NSIndexPath indexPathWithIndex:[outlineContents count]];
	}
	
	// create a leaf node
	ChildNode *node = [[ChildNode alloc] initLeaf];
	[node setURL:[treeAddition nodeURL]];
	
	if ([treeAddition nodeURL])
	{
		if ([[treeAddition nodeURL] length] > 0)
		{
			// the child to insert has a valid URL, use its display name as the node title
			if ([treeAddition nodeName])
				[node setNodeTitle:[treeAddition nodeName]];
			else
				[node setNodeTitle:[[NSFileManager defaultManager] displayNameAtPath:[node urlString]]];
		}
		else
		{
			// the child to insert will be an empty URL
			[node setNodeTitle:UNTITLED_NAME];
			[node setURL:HTTP_PREFIX];
		}
	}
	
	// the user is adding a child node, tell the controller directly
	[outlineController insertObject:node atArrangedObjectIndexPath:indexPath];
    
	[node release];
	
	// adding a child automatically becomes selected by NSOutlineView, so keep its parent selected
	if ([treeAddition selectItsParent])
		[self selectParentFromSelection];
}

// -------------------------------------------------------------------------------
//	addChild:url:withName:
// -------------------------------------------------------------------------------
- (void)addChild:(NSString *)url withName:(NSString *)nameStr selectParent:(BOOL)select
{
	TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithURL:url withName:nameStr selectItsParent:select];
	
	if (buildingOutlineView)
	{
		// add the child node to the tree controller, but on the main thread to avoid lock ups
		[self performSelectorOnMainThread:@selector(performAddChild:) withObject:treeObjInfo waitUntilDone:YES];
	}
	else
	{
		[self performAddChild:treeObjInfo];
	}
	
	[treeObjInfo release];
}


-(void)addEntries:(NSDictionary *)entries
{
    NSEnumerator *entryEnum = [entries objectEnumerator];
    
    id entry;
	while ((entry = [entryEnum nextObject]))
    {
        NSString *urlStr = [entry objectForKey:KEY_URL];
        
        if ([entry objectForKey:KEY_SIMULATION]) {
            // add simulation FIXME SIMULATION STATIC
            [self addSimulation:simulation.name selectParent:YES];
            // add its children
            NSDictionary *entries = [entry objectForKey:KEY_ENTRIES];
            [self addEntries:entries];
            [self selectParentFromSelection];
            NSLog(@"simulation: %@", [entry objectForKey:KEY_SIMULATION]);
            NSLog(@"with entries: %@", entries);
        }
        else if ([entry objectForKey:KEY_CONFIGURATIONS])
        {
            // add configurations FIXME STATIC ON FIRST
            [self addConfiguration:[[[simulation.configurations allObjects] objectAtIndex:0] valueForKey:@"name"] selectParent:YES];
            [self selectParentFromSelection];
        }
        else if ([entry objectForKey:KEY_SEPARATOR])
        {
            // its a separator mark, we treat is as a leaf
            [self addChild:nil withName:nil selectParent:YES];
        }
        else if ([entry objectForKey:KEY_FOLDER])
        {
            // its a file system based folder,
            // we treat is as a leaf and show its contents in the NSCollectionView
            NSString *folderName = [entry objectForKey:KEY_FOLDER];
            [self addChild:urlStr withName:folderName selectParent:YES];
        }
        else if ([entry objectForKey:KEY_URL])
        {
            // its a leaf item with a URL
            NSString *nameStr = [entry objectForKey:KEY_NAME];
            [self addChild:urlStr withName:nameStr selectParent:YES];
        }
        else
        {
            // it's a generic container
            NSString *folderName = [entry objectForKey:KEY_GROUP];
            [self addFolder:folderName];
            
            // add its children
            NSDictionary *entries = [entry objectForKey:KEY_ENTRIES];
            [self addEntries:entries];
            
            [self selectParentFromSelection];
        }
    }
    
    // inserting children automatically expands its parent, we want to close it
	if ([[outlineController selectedNodes] count] > 0)
	{
		NSTreeNode *lastSelectedNode = [[outlineController selectedNodes] objectAtIndex:0];
		[myOutlineView collapseItem:lastSelectedNode];
	}
}

// -------------------------------------------------------------------------------
//	populateOutline:
//
//	Populate the tree controller from disk-based dictionary (Outline.dict)
// -------------------------------------------------------------------------------
- (void)populateOutline
{
	NSDictionary *initData = [NSDictionary dictionaryWithContentsOfFile:
                              [[NSBundle mainBundle] pathForResource:INITIAL_INFODICT ofType:@"dict"]];
	NSDictionary *entries = [initData objectForKey:KEY_ENTRIES];
	[self addEntries:entries];
}

// -------------------------------------------------------------------------------
//	addSimulationsSection:
// -------------------------------------------------------------------------------
- (void)addSimulationsSection
{
	// add the "Simulations" section
	[self addFolder:SIMULATIONS_NAME];
}

// -------------------------------------------------------------------------------
//	populateOutlineContents:inObject
//
//	This method is being called on a separate thread to avoid blocking the UI
//	a startup time.
// -------------------------------------------------------------------------------
- (void)populateOutlineContents:(id)inObject
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	buildingOutlineView = YES;		// indicate to ourselves we are building the default tree at startup
    
	[myOutlineView setHidden:YES];	// hide the outline view - don't show it as we are building the contents
	
	[self addSimulationsSection];   // add the "Devices" outline section
	[self populateOutline];			// populateOutline (under SimulationsSections)
	
	buildingOutlineView = NO;		// we're done building our default tree
	
	// remove the current selection
	NSArray *selection = [outlineController selectionIndexPaths];
	[outlineController removeSelectionIndexPaths:selection];
	
	[myOutlineView setHidden:NO];	// we are done populating the outline view content, show it again
	
	[pool release];
}

@end
