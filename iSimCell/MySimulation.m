//
//  MySimulation.m
//  iSimCell
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 IFOM-FIRC. All rights reserved.
//

#import "MySimulation.h"
#import "SimCellController.h"

@implementation MySimulation

#pragma mark -
#pragma mark Initialization

-(id)initWithType:(NSString *)type error:(NSError **)error
{
    self = [super initWithType:type error:error];
    if (self != nil) {
        // Add your subclass-specific initialization here.
        
        // If an error occurs here, send a [self release] message and return nil.
        NSLog(@"NSPersistentDocument: InitWithType with CoreData object models");
        
        [self createNewSimulation];

        NSLog(@"NSPersistenDocument: Simulation Object loaded: %@", simulation.name);
        NSLog(@"NSPersistenDocument: Configuration Default Object loaded: %@", [[[simulation.configurations allObjects] objectAtIndex:0] name]);
    }
     NSLog(@"NSPersistentDocument: open...");
    return self;
}

#pragma mark -
#pragma mark WindowController

// override -makeWindowControllers to set a window Controller attached to the document
-(void)makeWindowControllers
{
    SimCellController *ctl = [ [SimCellController alloc] initWithWindowNibName: [self windowNibName] ];
    [ctl autorelease];
    [self addWindowController:ctl];
    // IF NOT object
    if (simulation == nil) {
        [self fetchSimulation];
        NSLog(@"Simulation was nil, now is: %@", simulation.name);
    }
     NSLog(@"NSPersistentDocument: passing control to the window controller. Current Object: %@", simulation.name);
    
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    return @"SimCellWindow";
}

#pragma mark -
#pragma mark Accessors

-(Simulation *)getSimulation
{
    return simulation;
}


#pragma mark -
#pragma mark Core Data Methods
-(void)createNewSimulation
{
    //  Create CoreData Object PREWINDOW LOAD (to init things)
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    [[managedObjectContext undoManager] disableUndoRegistration];

    simulation = [NSEntityDescription insertNewObjectForEntityForName:@"Simulation" 
                                               inManagedObjectContext:managedObjectContext];
    
    Configuration *defaultConfig = [NSEntityDescription insertNewObjectForEntityForName:@"Configuration" 
                                                                 inManagedObjectContext:managedObjectContext];
    
    defaultConfig.name = @"Default Config";
    [simulation addConfigurationsObject:defaultConfig];
    
    Configuration *defaultConfig2 = [NSEntityDescription insertNewObjectForEntityForName:@"Configuration" 
                                                                 inManagedObjectContext:managedObjectContext];
    
    defaultConfig2.name = @"Default Config2";
    [simulation addConfigurationsObject:defaultConfig2];
    
    [managedObjectContext processPendingChanges];
    [[managedObjectContext undoManager] enableUndoRegistration];
    
}

-(void)fetchSimulation
{
    NSLog(@"fetchRequest: -->");
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Simulation" 
                                                         inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init ] autorelease];
    
    [request setEntity:entityDescription];
    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    
    if (array == nil) {
        // Deal with error
        NSLog(@"fetchRequest NODATA");
    }
    
    simulation = [array objectAtIndex:0];
    NSLog(@"fetchRequest: %@", simulation.name);
}

@end
