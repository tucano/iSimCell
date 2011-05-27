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

@interface SimCellController : NSWindowController {
@private
    MySimulation *mydocument;
    Simulation   *simulation;
    SimCellLinker *simcell;
    IBOutlet NSProgressIndicator *progBar;
    IBOutlet NSArrayController *configurationsController;
    IBOutlet BOOL simcellLock;
}

-(IBAction)launchSim:(id)sender;
-(IBAction)terminateSim:(id)sender;
-(IBAction)changeOutput:(id)sender;

@property(nonatomic, retain) IBOutlet NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) IBOutlet NSObjectController *simulationController;

-(Configuration *)selectedConfiguration;
-(void)addNotification:(NSString *)message selector:(NSString *)selector;

@end
