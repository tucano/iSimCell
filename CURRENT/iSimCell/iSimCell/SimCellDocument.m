//
//  SimCellDocument.m
//  iSimCell
//
//  Created by drambald on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimCellDocument.h"

@implementation SimCellDocument

@synthesize mainWindow;

#pragma mark -
#pragma mark Init

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
        
        // Common entry point
        NSLog(@"SimCellDocument: INIT common entry point to open and new functions.");
    }
    return self;
}

-(id)initWithType:(NSString *)type error:(NSError **)error
{
    NSLog(@"SimCellDocument: Init and create file");

    self = [super initWithType:type error:error];
    
    if (self != nil) {
        
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
        NSLog(@"SimCellDocument: InitWithType: %@",type);
        
        //  Create CoreData Object PREWINDOW LOAD (to init things)
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        
        // disable save..
        [[managedObjectContext undoManager] disableUndoRegistration];
        
        // create MAIN core data object
        [self newSimulation:@"New Simulation"];
        
        [managedObjectContext processPendingChanges];
        
        // enable save ...
        [[managedObjectContext undoManager] enableUndoRegistration];
        
        NSLog(@"SimCellDocument: CoreData default objects created.");
        NSLog(@"SimCellDocument: CoreData managed object context: %@.", managedObjectContext);
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"SimCellDocument: dealloc document");
    [super dealloc];
}

#pragma mark -
#pragma mark WindowController

// override -makeWindowControllers to set a window Controller attached to the document
-(void)makeWindowControllers
{
    mainWindow = [ [SimCellController alloc] initWithManagedObjectContext:[self managedObjectContext]  ];
    [mainWindow autorelease];
    [self addWindowController:mainWindow];
    
    NSLog(@"SimCellDocument: passing control to the window controller. Simulation Name is: %@", [[[self fetchSimulations] objectAtIndex:0] name]);
}

#pragma mark -
#pragma mark Core Data Methods
-(void)newSimulation:(NSString *)name
{
    Simulation *simulation = [NSEntityDescription insertNewObjectForEntityForName:@"Simulation" 
                                                           inManagedObjectContext:[self managedObjectContext]];
    simulation.name = name;
}

-(Simulation *)fetchSimulation:(NSString *)uniqueID
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Simulation" 
                                                         inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init ] autorelease];
    
    [request setEntity:entityDescription];
    
    NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:
                                      @"uniqueID == %@", uniqueID];
    [request setPredicate:predicateTemplate];
    
    
    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    
    if (array == nil) {
        // Deal with error
        NSLog(@"fetchRequest NODATA");
    }
    
    return [array objectAtIndex:0];
}

-(NSArray *)fetchSimulations
{
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
    
    return array;
}

@end
