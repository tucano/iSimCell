//
//  SimCellController+OutlineView.m
//  iSimCell
//
//  Created by Davide Rambaldi on 5/30/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import "SimCellController+OutlineView.h"

#pragma mark -
#pragma mark TreeAdditionObj

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
    NSString    *uniqueID;
    NSString    *category;
	BOOL		selectItsParent;
}

@property (readonly) NSIndexPath *indexPath;
@property (readonly) NSString *nodeURL;
@property (readonly) NSString *nodeName;
@property (readonly) NSString *uniqueID;
@property (readonly) NSString *category;
@property (readonly) BOOL selectItsParent;

@end

@implementation TreeAdditionObj
@synthesize indexPath, nodeURL, nodeName, selectItsParent, uniqueID, category;

// -------------------------------------------------------------------------------
//   INITIALIZATIONS
// -------------------------------------------------------------------------------
- (id)initWithURL:(NSString *)url withName:(NSString *)name selectItsParent:(BOOL)select
{
	self = [super init];
	
	nodeName = name;
	nodeURL = url;
	selectItsParent = select;
	
	return self;
}

-(id)initWithUniqueID:(NSString *)uid withName:(NSString *)name withCategory:(NSString *)cat selectItsParent:(BOOL)select
{
    self = [super init];
    nodeName = name;
	uniqueID = uid;
	selectItsParent = select;
    category = cat;
    return self;
}

@end

#pragma mark -
#pragma mark OutlineView Control

@implementation SimCellController (SimCellController_OutlineView)

#pragma mark -
#pragma mark Selections

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
//	isSpecialGroup:
// -------------------------------------------------------------------------------
- (BOOL)isSpecialGroup:(BaseNode *)groupNode
{ 
	return ([groupNode nodeIcon] == nil &&
			[[groupNode nodeTitle] isEqualToString:SIMULATIONS_NAME] || [[groupNode nodeTitle] isEqualToString:HELP_NAME]);
}

// -------------------------------------------------------------------------------
//	identifyCurrentSimulation:
//
//	Take the currently selected node and identify is parent: a simulation.
// -------------------------------------------------------------------------------
-(NSTreeNode *)getParentNode
{
    if ([[outlineController selectedNodes] count] > 0)
    {
        NSTreeNode* firstSelectedNode = [[outlineController selectedNodes] objectAtIndex:0];
		NSTreeNode* parentNode = [firstSelectedNode parentNode];
        if (parentNode) {
            return parentNode;
        } 
        else
        {
            // no parent exists (we are at the top of tree)
            return nil;
        }
            
    }
    return nil;
}

#pragma mark -
#pragma mark Add Actions

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


#pragma mark -
#pragma mark Special Add Actions

// -------------------------------------------------------------------------------
//	addSimulationGroup:treeAddition
// -------------------------------------------------------------------------------
-(void)performAddSimulationGroup:(TreeAdditionObj *)treeAddition
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
    [node setDescription:[treeAddition uniqueID]];
	[node setCategory:[treeAddition category]];
    
	// the user is adding a child node, tell the controller directly
	[outlineController insertObject:node atArrangedObjectIndexPath:indexPath];
	
	[node release];
}

-(void)performAddSimulationObject:(TreeAdditionObj *)treeAddition
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
	[node setNodeTitle:[treeAddition nodeName]];
	[node setDescription:[treeAddition uniqueID]];
    [node setCategory:[treeAddition category]];
    
	// the user is adding a child node, tell the controller directly
	[outlineController insertObject:node atArrangedObjectIndexPath:indexPath];
    
	[node release];
	
	// adding a child automatically becomes selected by NSOutlineView, so keep its parent selected
	if ([treeAddition selectItsParent])
		[self selectParentFromSelection];
}

// -------------------------------------------------------------------------------
//	addSimulationGroup:
// -------------------------------------------------------------------------------
- (void)addSimulationGroup:(NSString *)folderName withUniqueID:(NSString *)uid withCategory:(NSString *)category
{
	TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithUniqueID:uid 
                                                                    withName:folderName
                                                                withCategory:category
                                                             selectItsParent:YES];
	
	if (buildingOutlineView)
	{
		// add the folder to the tree controller, but on the main thread to avoid lock ups
		[self performSelectorOnMainThread:@selector(performAddSimulationGroup:) withObject:treeObjInfo waitUntilDone:YES];
	}
	else
	{
		[self performAddSimulationGroup:treeObjInfo];
	}
	
	[treeObjInfo release];
}


// -------------------------------------------------------------------------------
//	addConfigurations:
// -------------------------------------------------------------------------------

-(void)addConfiguration:(NSString *)nameStr selectParent:(BOOL)select withUniqueID:(NSString *)uid withCategory:(NSString *)category
{
    TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithUniqueID:uid 
                                                                    withName:nameStr 
                                                                withCategory:category
                                                             selectItsParent:YES ];
	
	if (buildingOutlineView)
	{
		// add the child node to the tree controller, but on the main thread to avoid lock ups
		[self performSelectorOnMainThread:@selector(performAddSimulationObject:) withObject:treeObjInfo waitUntilDone:YES];
	}
	else
	{
		[self performAddSimulationObject:treeObjInfo];
	}
	
	[treeObjInfo release];
}

// -------------------------------------------------------------------------------
//	addSimulation:
// -------------------------------------------------------------------------------

- (void)addSimulation:(NSString *)nameStr selectParent:(BOOL)select withUniqueID:(NSString *)uid withCategory:(NSString *)category
{
	TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithUniqueID:uid 
                                                                    withName:nameStr
                                                                withCategory:category
                                                             selectItsParent:YES];
	
	if (buildingOutlineView)
	{
		// add the child node to the tree controller, but on the main thread to avoid lock ups
		[self performSelectorOnMainThread:@selector(performAddSimulationGroup:) withObject:treeObjInfo waitUntilDone:YES];
	}
	else
	{
		[self performAddSimulationGroup:treeObjInfo];
	}
	
	[treeObjInfo release];
}

// -------------------------------------------------------------------------------
//	addView:
// -------------------------------------------------------------------------------
- (void)addView:(NSString *)nameStr selectParent:(BOOL)select withUniqueID:(NSString *)uid withCategory:(NSString *)category
{
	TreeAdditionObj *treeObjInfo = [[TreeAdditionObj alloc] initWithUniqueID:uid 
                                                                    withName:nameStr
                                                                withCategory:category
                                                             selectItsParent:YES];
	
	if (buildingOutlineView)
	{
		// add the child node to the tree controller, but on the main thread to avoid lock ups
		[self performSelectorOnMainThread:@selector(performAddSimulationObject:) withObject:treeObjInfo waitUntilDone:YES];
	}
	else
	{
		[self performAddSimulationObject:treeObjInfo];
	}
	
	[treeObjInfo release];
}


// -------------------------------------------------------------------------------
//	add Special Sections:
// -------------------------------------------------------------------------------
- (void)addSimulationsSection
{
	// add the "Simulations" section
	[self addFolder:SIMULATIONS_NAME];
}

- (void)addHelpSection
{
	// add the "Simulations" section
	[self addFolder:HELP_NAME];
}

// -------------------------------------------------------------------------------
//	addSeparator
// -------------------------------------------------------------------------------
- (void)addSeparator
{
	// its a separator mark, we treat is as a leaf
    [self addChild:nil withName:nil selectParent:YES];
}

#pragma mark -
#pragma mark AddEntries (main loop)

// -------------------------------------------------------------------------------
//	addEntries:
// -------------------------------------------------------------------------------
-(void)addEntries:(NSDictionary *)entries
{
    NSEnumerator *entryEnum = [entries objectEnumerator];
    
    id entry;
	while ((entry = [entryEnum nextObject]))
    {
        NSString *urlStr = [entry objectForKey:KEY_URL];
        
        // MY SPECIAL CASES FIRSTS
        if ([entry objectForKey:KEY_SIMULATION]) 
        {
            // add simulations
            NSEnumerator *enumerator = [[mydocument fetchSimulations] objectEnumerator];
            id anObject;

            while ((anObject = [enumerator nextObject])) 
            {
                Simulation *simulation = anObject;
                [self addSimulation:simulation.name selectParent:YES withUniqueID:simulation.uniqueID withCategory:CATEGORY_SIMULATION];
                // add its children
                NSDictionary *entries = [entry objectForKey:KEY_ENTRIES];
                [self addEntries:entries];
                [self selectParentFromSelection];
            }            
        }
        else if ([entry objectForKey:KEY_CONFIGURATION])
        {
            // add configurations: simulation is the parent node of the current node
            NSTreeNode *node = [self getParentNode];
            NSString *uid = [[node representedObject] description];
            Simulation *aSimulation = [mydocument fetchSimulation:uid];

            if (aSimulation != nil)
            {
                NSEnumerator *enumerator = [aSimulation.configurations objectEnumerator];
                id anObject;
                while ((anObject = [enumerator nextObject])) 
                {
                    Configuration *aConfig = anObject;
                    [self addConfiguration:aConfig.name selectParent:YES withUniqueID:aConfig.uniqueID withCategory:CATEGORY_CONFIGURATION];
                }
            }
        }
        else if ([entry objectForKey:KEY_SIMULATIONGROUP])
        {
            // is a group internal to a simulation, current simulation is the current node
            NSTreeNode* node = [[outlineController selectedNodes] objectAtIndex:0];
            NSString *uid = [[node representedObject] description];
            Simulation *aSimulation = [mydocument fetchSimulation:uid];
            
            NSString *folderName = [entry objectForKey:KEY_SIMULATIONGROUP];
            [self addSimulationGroup:folderName withUniqueID:aSimulation.uniqueID withCategory:CATEGORY_SIMULATIONGROUP];
            
            // add its children
            NSDictionary *entries = [entry objectForKey:KEY_ENTRIES];
            [self addEntries:entries];
            
            [self selectParentFromSelection];
        }
        else if ([entry objectForKey:KEY_VIEW])
        {
            // its a view (actually only the INFO view)
            // current simulation is the current node
            // is a group internal to a simulation, current simulation is the current node
            NSTreeNode* node = [[outlineController selectedNodes] objectAtIndex:0];
            NSString *uid = [[node representedObject] description];
            Simulation *aSimulation = [mydocument fetchSimulation:uid];
            
            NSString *viewName = [entry objectForKey:KEY_VIEW];
            [self addView:viewName selectParent:YES withUniqueID:aSimulation.uniqueID withCategory:CATEGORY_SIMULATIONVIEW];
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

#pragma mark -
#pragma mark populate

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

- (void)populateHelp
{
	NSDictionary *initData = [NSDictionary dictionaryWithContentsOfFile:
                              [[NSBundle mainBundle] pathForResource:INITIAL_INFODICT ofType:@"dict"]];
	NSDictionary *entries = [initData objectForKey:KEY_HELP];
	[self addEntries:entries];
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
    
    // remove the current selection
	NSArray *selection = [outlineController selectionIndexPaths];
	[outlineController removeSelectionIndexPaths:selection];
    
    [self addSeparator];
    [self addHelpSection];
    [self populateHelp];
    
	buildingOutlineView = NO;		// we're done building our default tree
	
	// remove the current selection
	selection = [outlineController selectionIndexPaths];
	[outlineController removeSelectionIndexPaths:selection];
	
	[myOutlineView setHidden:NO];	// we are done populating the outline view content, show it again
	
	[pool release];
}

#pragma mark -
#pragma mark SubViews

// -------------------------------------------------------------------------------
//	removeSubview:
// -------------------------------------------------------------------------------
- (void)removeSubview
{
	// empty selection
	NSArray *subViews = [placeHolderView subviews];
	if ([subViews count] > 0)
	{
		[[subViews objectAtIndex:0] removeFromSuperview];
	}
	
	[placeHolderView displayIfNeeded];	// we want the removed views to disappear right away
}

// -------------------------------------------------------------------------------
//	changeItemView:
// ------------------------------------------------------------------------------
- (void)changeItemView
{
    NSArray		*selection = [outlineController selectedNodes];	
    ChildNode   *node = [[selection objectAtIndex:0] representedObject];
    NSString    *name = [node nodeTitle];
    NSString    *category = [node category];
    
    NSLog(@"Attemping to change view to: %@", name);
    
    if (currentView != nil) {
        // remove the old subview
        [self removeSubview];
        currentView = nil;
    }
    
    if ([name isEqualToString:@"Info"] || [category isEqualToString:@"Simulation"])  
    {
        NSView *subView = [infoView view];
        [placeHolderView addSubview: subView];
        currentView = subView;
    } 
    else if ([category isEqualToString:@"Configuration"])
    {
        NSView *subView = [configView view];
        [placeHolderView addSubview: subView];
        currentView = subView;
    }
}

#pragma mark -
#pragma mark Notifications

// -------------------------------------------------------------------------------
//	outlineView: notifications
// -------------------------------------------------------------------------------

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    if (buildingOutlineView)	// we are currently building the outline view, don't change any view selections
		return;
   
    // ask the tree controller for the current selection
	NSArray *selection = [outlineController selectedObjects];
	if ([selection count] > 1)
	{
		// multiple selection - clear the right side view
		[self removeSubview];
		currentView = nil;
	}
	else
	{
		if ([selection count] == 1)
		{
			// single selection
            ChildNode *currentSelection = [[outlineController selectedObjects] objectAtIndex:0];
            
            if ([[currentSelection category] isEqualToString:CATEGORY_SIMULATION]) 
            {
                NSLog(@"SELECTED SIMULATION");
                NSLog(@"Node title: %@ , category: %@, uniqueID: %@, URL: %@", 
                      [currentSelection nodeTitle], [currentSelection category], 
                      [currentSelection description], [currentSelection urlString]);
                Simulation *aSimulation = [mydocument fetchSimulation:[currentSelection description]];
                NSLog(@"Sim: %@", aSimulation);
                
                BOOL result = [simulationController setSelectedObjects:[[[NSArray alloc] initWithObjects:aSimulation, nil] autorelease]];
                
                if  (result) {
                    NSLog(@"Selecting simulation in the simulationController: %@", [[simulationController selectedObjects] objectAtIndex:0]);
                } else {
                    NSLog(@"Can't select current simulation in the NSArrayController");
                }
                [self changeItemView];
            }
            else if ([[currentSelection category] isEqualToString:CATEGORY_CONFIGURATION])
            {
                // FIXME BUG: 
                // should also select current Simulation otherwise if I choose a config from another simulation Index out of bounds....
                
                NSLog(@"SELECTED CONFIGURATION");
                
                ChildNode *simNode = [[[self getParentNode] parentNode] representedObject];
                Simulation *aSimulation = [mydocument fetchSimulation:[simNode description]];
                
                BOOL simresult = [simulationController setSelectedObjects:[[[NSArray alloc] initWithObjects:aSimulation, nil] autorelease]];
                
                if  (simresult) {
                    NSLog(@"Selecting simulation in the simulationController");
                } else {
                    NSLog(@"Can't select current simulation in the NSArrayController");
                }
                
                NSLog(@"SELECTED parent Simulation: %@", aSimulation.name);                
                NSLog(@"Node title: %@ , category: %@, uniqueID: %@, URL: %@", 
                      [currentSelection nodeTitle], [currentSelection category], 
                      [currentSelection description], [currentSelection urlString]);
                NSLog(@"Collecting current configuration: %@",[currentSelection description]);
                
                Configuration *aConfig = [mydocument fetchConfiguration:[currentSelection description]];
                
                NSLog(@"Conf: %@", aConfig.name);
                
                BOOL result = [configurationController setSelectedObjects:[[[NSArray alloc] initWithObjects:aConfig, nil] autorelease]];
                
                if  (result) {
                    NSLog(@"Selecting configuration in the configurationController: %@", [[configurationController selectedObjects] objectAtIndex:0]);
                } else {
                    NSLog(@"Can't select current configuration in the NSArrayController");
                }
                [self changeItemView];
                
            }
            else if ([[currentSelection category] isEqualToString:CATEGORY_SIMULATIONVIEW])
            {
                NSLog(@"SELECTED SIMULATION VIEW");
                NSLog(@"Node title: %@ , category: %@, uniqueID: %@, URL: %@", 
                      [currentSelection nodeTitle], [currentSelection category], 
                      [currentSelection description], [currentSelection urlString]);
                
                if ([[currentSelection nodeTitle] isEqualToString:@"Info"]) {
                    NSLog(@"Collecting current simulation: %@",[currentSelection description]);
                    Simulation *aSimulation = [mydocument fetchSimulation:[currentSelection description]];
                    NSLog(@"Sim: %@", aSimulation);
                    
                    BOOL result = [simulationController setSelectedObjects:[[[NSArray alloc] initWithObjects:aSimulation, nil] autorelease]];
                    
                    if  (result) {
                        NSLog(@"Selecting simulation in the simulationController: %@", [[simulationController selectedObjects] objectAtIndex:0]);
                    } else {
                        NSLog(@"Can't select current simulation in the NSArrayController");
                    }
                    [self changeItemView];
                }
            }
            else if ([[currentSelection category] isEqualToString:CATEGORY_SIMULATIONGROUP])
            {
                NSLog(@"SELECTED SIMULATION GROUP");
                NSLog(@"Node title: %@ , category: %@, uniqueID: %@, URL: %@", 
                      [currentSelection nodeTitle], [currentSelection category], 
                      [currentSelection description], [currentSelection urlString]);
            }
            else
            {
                NSLog(@"SELECTED DEFAULT NODE");
                NSLog(@"Node title: %@ , category: %@, uniqueID: %@, URL: %@", 
                      [currentSelection nodeTitle], [currentSelection category], 
                      [currentSelection description], [currentSelection urlString]);
            }
		}
		else
		{
			// there is no current selection - no view to display
			[self removeSubview];
            
            // TEST
            NSView *subView = [graphView view];
            [placeHolderView addSubview: subView];
            currentView = subView;
		}
	}
}

- (void)outlineViewSelectionIsChanging:(NSNotification *)notification
{
    if (buildingOutlineView)	// we are currently building the outline view, don't change any view selections
		return;
}


#pragma mark - NSOutlineView delegate

// -------------------------------------------------------------------------------
//	shouldSelectItem:item
// -------------------------------------------------------------------------------
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item;
{
	// don't allow special group nodes (Devices and Places) to be selected
	BaseNode* node = [item representedObject];
	return (![self isSpecialGroup:node]);
}

// -------------------------------------------------------------------------------
//	dataCellForTableColumn:tableColumn:row
// -------------------------------------------------------------------------------
- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	NSCell* returnCell = [tableColumn dataCell];
	
	if ([[tableColumn identifier] isEqualToString:COLUMNID_NAME])
	{
		// we are being asked for the cell for the single and only column
		BaseNode* node = [item representedObject];
		if ([node nodeIcon] == nil && [[node nodeTitle] length] == 0)
			returnCell = separatorCell;
	}
	
	return returnCell;
}

// -------------------------------------------------------------------------------
//	textShouldEndEditing:
// -------------------------------------------------------------------------------
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
	if ([[fieldEditor string] length] == 0)
	{
		// don't allow empty node names
		return NO;
	}
	else
	{
		return YES;
	}
}

// -------------------------------------------------------------------------------
//	shouldEditTableColumn:tableColumn:item
//
//	Decide to allow the edit of the given outline view "item".
// -------------------------------------------------------------------------------
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	BOOL result = YES;
	
	item = [item representedObject];
	if ([self isSpecialGroup:item])
	{
		result = NO; // don't allow special group nodes to be renamed
	}
	else
	{
		if ([[item urlString] isAbsolutePath])
			result = NO;	// don't allow file system objects to be renamed
	}
	
	return result;
}

// -------------------------------------------------------------------------------
//	outlineView:willDisplayCell
// -------------------------------------------------------------------------------
- (void)outlineView:(NSOutlineView *)olv willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{	
	if ([[tableColumn identifier] isEqualToString:COLUMNID_NAME])
	{
		// we are displaying the single and only column
		if ([cell isKindOfClass:[ImageAndTextCell class]])
		{
			item = [item representedObject];
			if (item)
			{
				if ([item isLeaf])
				{
					// does it have a URL string?
					NSString *urlStr = [item urlString];
					if (urlStr)
					{
						if ([item isLeaf])
						{
							NSImage *iconImage;
							if ([[item urlString] hasPrefix:HTTP_PREFIX])
								iconImage = urlImage;
							else
								iconImage = [[NSWorkspace sharedWorkspace] iconForFile:urlStr];
							[item setNodeIcon:iconImage];
						}
						else
						{
							NSImage* iconImage = [[NSWorkspace sharedWorkspace] iconForFile:urlStr];
							[item setNodeIcon:iconImage];
						}
					}
					else
					{
						// it's a separator, don't bother with the icon
					}
				}
				else
				{
					// check if it's a special folder (DEVICES or PLACES), we don't want it to have an icon
					if ([self isSpecialGroup:item])
					{
						[item setNodeIcon:nil];
					}
					else
					{
						// it's a folder, use the folderImage as its icon
						[item setNodeIcon:folderImage];
					}
				}
			}
			
			// set the cell's image
			[(ImageAndTextCell*)cell setImage:[item nodeIcon]];
		}
	}
}

@end
