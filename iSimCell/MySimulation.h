//
//  MySimulation.h
//  iSimCell
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 IFOM-FIRC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Simulation.h"
#import "Configuration.h"
#import "SimCellLinker.h"
#import "SimCellController.h"

@class SimCellController;

@interface MySimulation : NSPersistentDocument {
@private
    SimCellLinker *simcell;
    SimCellController *mainWindow;
    bool simcellLock;
}

@property(readonly, assign) SimCellLinker * simcell;
@property(readonly, assign) bool simcellLock;
@property(nonatomic, retain) SimCellController *mainWindow;

-(void)runSimCell:(Configuration *)conf;
-(void)killSimCell;

-(void)newSimulation:(NSString *)name;
-(NSArray *)fetchSimulations;
-(Simulation *)fetchSimulation:(NSString *)uniqueID;
-(Configuration *)newConfiguration:(NSString *)name forSimulation:(Simulation *)simulation;


@end
