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

@class SimCellController;

@interface SimCellDocument : NSPersistentDocument {
@private
    SimCellController *mainWindow;
}

@property(nonatomic, retain) SimCellController *mainWindow;

-(void)newSimulation:(NSString *)name;
-(NSArray *)fetchSimulations;
-(Simulation *)fetchSimulation:(NSString *)uniqueID;

@end
