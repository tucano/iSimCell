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

@interface MySimulation : NSPersistentDocument {
@private
    Simulation *simulation;
    // TODO MEOVE LINKER LOGIC HERE !!!
    SimCellLinker *simcell;
    
}

@property(readwrite, retain) Simulation * simulation;

-(void)newSimulation;
-(void)fetchSimulation;
-(void)newConfiguration:(NSString *)name;

@end
