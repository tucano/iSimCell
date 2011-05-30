//
//  SimCellController.h
//  iSimCell
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SimCellLinker.h"
#import "MySimulation.h"
#import "ChildNode.h"

@interface SimCellController : NSWindowController {
@private
    MySimulation *mydocument;
    Simulation   *simulation;
    IBOutlet NSProgressIndicator *progBar;
    IBOutlet NSArrayController *configurationsController;
    IBOutlet NSPopUpButton *outputPouUp;
    IBOutlet NSManagedObjectContext *managedObjectContext;
    IBOutlet NSObjectController *simulationController;
    IBOutlet NSTreeController *outlineController;
    IBOutlet NSMutableArray *outlineContents;
}

-(IBAction)launchSim:(id)sender;
-(IBAction)terminateSim:(id)sender;
-(IBAction)changeOutput:(id)sender;

@property(nonatomic, retain) IBOutlet NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) IBOutlet NSObjectController *simulationController;
@property(nonatomic, retain) IBOutlet NSMutableArray *outlineContents;

-(Configuration *)selectedConfiguration;
-(NSMutableArray *)outlineContents;

@end
