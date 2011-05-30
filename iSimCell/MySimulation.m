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

@synthesize simulation;
@synthesize simcell;
@synthesize simcellLock;

#pragma mark -
#pragma mark Initialization

-(id)initWithType:(NSString *)type error:(NSError **)error
{
    self = [super initWithType:type error:error];
        
    if (self != nil) {

        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
        
        NSLog(@"NSPersistentDocument: InitWithType with CoreData object models. type: %@",type);
        
        //  Create CoreData Object PREWINDOW LOAD (to init things)
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        
        // disable save..
        [[managedObjectContext undoManager] disableUndoRegistration];

        [self newSimulation];
        [self newConfiguration:@"Default Config"];
        
        [managedObjectContext processPendingChanges];
        
        // enable save ...
        [[managedObjectContext undoManager] enableUndoRegistration];
        
        NSLog(@"NSPersistenDocument: Simulation Object loaded: %@", simulation.name);
        NSLog(@"NSPersistenDocument: Configuration Default Object loaded: %@", [[[simulation.configurations allObjects] objectAtIndex:0] name]);
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [simcell release];
    [super dealloc];
}

#pragma mark -
#pragma mark Linker
-(void)runSimCell:(Configuration *)conf
{
    // back if Locked
    if (simcellLock) {
        return;
    }
    
    simcellLock = YES;
    
    NSArray *myargs = [conf arrayOfOptions];
    NSLog(@"Arguments: %@",myargs);
    
    [simcell setArguments: myargs];
    [simcell launchTask];

}

-(void)killSimCell
{
    [simcell killTask];
}

#pragma mark -
#pragma mark Notifications

-(void)taskStarted:(NSNotification *)notification
{
    NSLog(@"MySimulation: Task Control Start.");
}

-(void)taskFinished:(NSNotification *)notification
{
    NSLog(@"MySimulationDoc: Task Control End.");
}

-(void)endReadingData:(NSNotification *)notification
{
    NSLog(@"MySimulationDoc: End reading data.");
    unsigned long numberOfLines, index, stringLength = [[simcell currentData] length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++)
        index = NSMaxRange([[simcell currentData] lineRangeForRange:NSMakeRange(index, 0)]);
    
    NSLog(@"data length: %lu", stringLength);
    NSLog(@"data lines: %lu", numberOfLines);
    
    simcellLock = NO;
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
    
    // init linker
    simcell = [[SimCellLinker alloc] init];
    simcellLock = NO;
    
    // NOTOFICATIONS
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(taskStarted:)
     name:@"SimCellTaskStarted"
     object:simcell];
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(taskFinished:)
     name:@"SimCellTaskComplete"
     object:simcell];
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(endReadingData:)
     name:@"SimCellEndReadingData"
     object:simcell];

    NSLog(@"NSPersistentDocument: passing control to the window controller. Current Object: %@", simulation.name);
    
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    return @"SimCellWindow";
}


#pragma mark -
#pragma mark Core Data Methods
-(void)newSimulation
{
    simulation = [NSEntityDescription insertNewObjectForEntityForName:@"Simulation" 
                                               inManagedObjectContext:[self managedObjectContext]];
}

-(Configuration *)newConfiguration:(NSString *)name
{
    Configuration *config = [NSEntityDescription insertNewObjectForEntityForName:@"Configuration" 
                                                          inManagedObjectContext:[self managedObjectContext]];
    config.name = name;
    [simulation addConfigurationsObject:config];
    return config;
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
