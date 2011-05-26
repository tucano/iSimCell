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

@synthesize simulation;

-(id)initWithType:(NSString *)type error:(NSError **)error
{
    self = [super initWithType:type error:error];
    if (self != nil) {
        // Add your subclass-specific initialization here.
        
        // If an error occurs here, send a [self release] message and return nil.
        NSLog(@"NSPersistentDocument: InitWithType with CoreData object models");
        
        /*
         *  Create CoreData Object PREWINDOW LOAD (to init things):
         */
        
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        [[managedObjectContext undoManager] disableUndoRegistration];
        simulation = [NSEntityDescription insertNewObjectForEntityForName:@"Simulation" 
                                                        inManagedObjectContext:managedObjectContext];
        
        Configuration *defaultConfig = [NSEntityDescription insertNewObjectForEntityForName:@"Configuration" 
                                                                       inManagedObjectContext:managedObjectContext];
        
        defaultConfig.name = @"Default Config";
        [simulation addConfigurationsObject:defaultConfig];
        [managedObjectContext processPendingChanges];
        [[managedObjectContext undoManager] enableUndoRegistration];
        NSLog(@"NSPersistenDocument: Simulation Object loaded: %@", simulation.name);
        NSLog(@"NSPersistenDocument: Configuration Default Object loaded: %@", simulation.configurations);
    }
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
     NSLog(@"NSPersistentDocument: passing control to the window controller, bye bye!");
    
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    return @"SimCellWindow";
}

@end
