//
//  SimCellDocument.h
//  iSimCell
//
//  Created by drambald on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SimCellController.h"
#import "Simulation.h"
#import "SimCellLinker.h"

@class SimCellController;
@class SimCellLinker;

@interface SimCellDocument : NSPersistentDocument {
@private
    SimCellLinker     *simcell;
    SimCellController *mainWindow;
}

@property(nonatomic, retain) SimCellController *mainWindow;

-(void)newSimulation:(NSString *)name;
-(Simulation *)fetchSimulation;

@end
