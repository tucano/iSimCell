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
    
    NSArray *simulations;

    SimCellLinker *simcell;
    bool simcellLock;
}

@property(readonly, assign) SimCellLinker * simcell;
@property(readonly, assign) bool simcellLock;

-(void)runSimCell:(Configuration *)conf;
-(void)killSimCell;

-(void)newSimulation;
-(NSArray *)fetchSimulations;
-(Simulation *)fetchSimulation:(NSString *)uniqueID;
-(Configuration *)newConfiguration:(NSString *)name forSimulation:(Simulation *)simulation;


@end
