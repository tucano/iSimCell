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

// placeholders
#define SIMULATIONS_NAME        @"SIMULATIONS"
#define UNTITLED_NAME			@"Untitled"		// default name for added folders and leafs
#define HTTP_PREFIX				@"http://"


@class SeparatorCell;

@interface SimCellController : NSWindowController {
@private
    
    MySimulation *mydocument;
    
    IBOutlet NSProgressIndicator *progBar;
    IBOutlet NSArrayController *configurationsController;
    IBOutlet NSPopUpButton *outputPouUp;
    IBOutlet NSManagedObjectContext *managedObjectContext;
    IBOutlet NSObjectController *simulationController;
    
    IBOutlet NSOutlineView		*myOutlineView;
    IBOutlet NSTreeController   *outlineController;
    IBOutlet NSMutableArray     *outlineContents;
    BOOL					    buildingOutlineView;	// signifies we are building the outline view at launch time
    SeparatorCell				*separatorCell;     	// the cell used to draw a separator line in the outline view
    
    // cached images for generic folder and url document
	NSImage						*folderImage;
	NSImage						*urlImage;
}

-(IBAction)launchSim:(id)sender;
-(IBAction)terminateSim:(id)sender;
-(IBAction)changeOutput:(id)sender;

@property(nonatomic, retain) IBOutlet NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) IBOutlet NSObjectController *simulationController;

-(Configuration *)selectedConfiguration;

@end
