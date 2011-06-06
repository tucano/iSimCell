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

@synthesize simcell;
@synthesize simcellLock;
@synthesize mainWindow;

#pragma mark -
#pragma mark Initialization

- (id)init {
    self = [super init];
    if (self) {
        // Common entry point
        NSLog(@"NSPersistentDocument: INIT common entry point to open and new functions.");
        
        // init linker
        simcell = [[SimCellLinker alloc] init];
        simcellLock = NO;
        
        // Notify START TASK
        [[NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(taskStarted:)
         name:@"SimCellTaskStarted"
         object:simcell];
        
        // Notify TASK COMPLETE
        [[NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(taskFinished:)
         name:@"SimCellTaskComplete"
         object:simcell];
        
        // Notify END READING DATA
        [[NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(endReadingData:)
         name:@"SimCellEndReadingData"
         object:simcell];

    }
    return self;
}

-(id)initWithType:(NSString *)type error:(NSError **)error
{
    NSLog(@"NSPersistentDocument: Init and create file");
    self = [super initWithType:type error:error];
    
    if (self != nil) {

        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
        NSLog(@"NSPersistentDocument: InitWithType with CoreData object models. type: %@",type);
        
        //  Create CoreData Object PREWINDOW LOAD (to init things)
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        
        // disable save..
        [[managedObjectContext undoManager] disableUndoRegistration];

        [self newSimulation:@"New Simulation"];
        
        [self newSimulation:@"Another Simulation"];
        
        [managedObjectContext processPendingChanges];
        
        // enable save ...
        [[managedObjectContext undoManager] enableUndoRegistration];
        
        NSLog(@"NSPersistenDocument: Simulation and Configurations Objects Created");
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
    NSLog(@"NSPersistentDocument: Task Control End.");
}

-(void)endReadingData:(NSNotification *)notification
{
    NSLog(@"NSPersistentDocument: End reading data.");
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
    mainWindow = [ [SimCellController alloc] initWithManagedObjectContext:[self managedObjectContext]  ];
    [mainWindow autorelease];
    [self addWindowController:mainWindow];
    
    NSLog(@"NSPersistentDocument: passing control to the window controller.");
    
}

#pragma mark -
#pragma mark Core Data Methods
-(void)newSimulation:(NSString *)name
{
    Simulation *simulation = [NSEntityDescription insertNewObjectForEntityForName:@"Simulation" 
                                               inManagedObjectContext:[self managedObjectContext]];
    simulation.name = name;
    [self newConfiguration:@"Time Zero" forSimulation:simulation];
    [self newConfiguration:@"Final Population" forSimulation:simulation];
    [self newConfiguration:@"Proliferation History" forSimulation:simulation];
}

-(Configuration *)newConfiguration:(NSString *)name forSimulation:(Simulation *)simulation;
{
    Configuration *config = [NSEntityDescription insertNewObjectForEntityForName:@"Configuration" 
                                                          inManagedObjectContext:[self managedObjectContext]];
    config.name = name;
    [simulation addConfigurationsObject:config];
    return config;
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
