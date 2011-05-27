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


@interface MySimulation : NSPersistentDocument {
@private
    Simulation *simulation;
}

@property(assign,nonatomic) NSManagedObject *simulation;

-(void)createNewSimulation;
-(void)fetchSimulation;

@end
