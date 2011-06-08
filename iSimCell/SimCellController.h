//
//  SimCellController.h
//  iSimCell
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MySimulation.h"
#import "ImageAndTextCell.h"
#import "SeparatorCell.h"
#import "InfoView.h"
#import "ConfigView.h"
#import "GraphView.h"



//////////////////////////////////////////////////////////
// SIDEBAR 
//////////////////////////////////////////////////////////

#define COLUMNID_NAME			@"NameColumn"	// the single column name in our outline view
#define INITIAL_INFODICT		@"outlineView"		// name of the dictionary file to populate our outline view

// keys in our disk-based dictionary representing our outline view's data
#define KEY_NAME				@"name"
#define KEY_URL					@"url"
#define KEY_SEPARATOR			@"separator"
#define KEY_GROUP				@"group"
#define KEY_FOLDER				@"folder"
#define KEY_ENTRIES				@"entries"
#define KEY_SIMULATION			@"simulation"
#define KEY_CONFIGURATION		@"configuration"
#define KEY_VIEW                @"view"
#define KEY_HELP                @"help"
#define KEY_SIMULATIONGROUP     @"simulationgroup"

// Categories
#define CATEGORY_SIMULATION       @"Simulation"
#define CATEGORY_CONFIGURATION    @"Configuration"
#define CATEGORY_SIMULATIONVIEW   @"SimulationView"
#define CATEGORY_SIMULATIONGROUP  @"SimulationGroup"

// placeholders
#define SIMULATIONS_NAME        @"SIMULATIONS"
#define HELP_NAME               @"HELP"
#define UNTITLED_NAME			@"Untitled"		// default name for added folders and leafs
#define HTTP_PREFIX				@"http://"

// NIB FILES
#define INFOVIEW_NIB            @"InfoView"
#define CONFIGVIEW_NIB          @"ConfigView"
#define GRAPHVIEW_NIB           @"GraphView"

@class SeparatorCell;
@class MySimulation;
@class InfoView;
@class ConfigView;

@interface SimCellController : NSWindowController {
@private
    
    MySimulation *mydocument;
    NSManagedObjectContext *_moc;
    
    IBOutlet NSProgressIndicator *progBar;
    IBOutlet NSArrayController   *simulationController;
    IBOutlet NSArrayController   *configurationController;
    
    IBOutlet NSOutlineView		*myOutlineView;
    IBOutlet NSTreeController   *outlineController;
    IBOutlet NSMutableArray     *outlineContents;
    BOOL					    buildingOutlineView;	// signifies we are building the outline view at launch time
    SeparatorCell				*separatorCell;     	// the cell used to draw a separator line in the outline view
    
    // cached images for generic folder and url document
	NSImage						*folderImage;
	NSImage						*urlImage;
    
    //VIEWS
    IBOutlet NSView				*placeHolderView;
    InfoView                    *infoView;
    ConfigView                  *configView;
    GraphView                   *graphView;
    NSView						*currentView;    // current subView
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)value;
- (NSManagedObjectContext *)managedObjectContext;

- (SimCellController *)initWithManagedObjectContext:(NSManagedObjectContext *)inMoc;

-(IBAction)launchSim:(id)sender;
-(IBAction)terminateSim:(id)sender;

// BINDING FOR TREE CONTROLLER
-(NSMutableArray *)outlineContents;
- (void)setOutlineContents:(NSArray*)newContents;

@end
