//
//  SimCellController.h
//  iSimCell
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MySimulation.h"

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
}

-(IBAction)launchSim:(id)sender;
-(IBAction)terminateSim:(id)sender;
-(IBAction)changeOutput:(id)sender;

@property(nonatomic, retain) IBOutlet NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) IBOutlet NSObjectController *simulationController;

-(Configuration *)selectedConfiguration;

@end
