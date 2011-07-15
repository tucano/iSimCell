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
@synthesize simcellLock;

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
        Simulation *sim = [self fetchSimulation];
        [self newConfiguration:@"Default" forSimulation:sim];
        
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [simcell release];
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
    
    NSLog(@"SimCellDocument: passing control to the window controller. Simulation Name is: %@", [[self fetchSimulation] name]);
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
    
    // options create in the CoreModel
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
#pragma mark Core Data Methods
-(void)newSimulation:(NSString *)name
{
    Simulation *simulation = [NSEntityDescription insertNewObjectForEntityForName:@"Simulation" 
                                                           inManagedObjectContext:[self managedObjectContext]];
    simulation.name = name;
}

-(Simulation *)fetchSimulation
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
    
    return [array objectAtIndex:0];
}

-(Configuration *)newConfiguration:(NSString *)name forSimulation:(Simulation *)simulation;
{
    Configuration *config = [NSEntityDescription insertNewObjectForEntityForName:@"Configuration" 
                                                          inManagedObjectContext:[self managedObjectContext]];
    config.name = name;
    [simulation addConfigurationsObject:config];
    return config;
}

#pragma mark -
#pragma mark Notifications

-(void)taskStarted:(NSNotification *)notification
{
    NSLog(@"SimCellDocument: Task Control Start.");
}

-(void)taskFinished:(NSNotification *)notification
{
    NSLog(@"SimCellDocument: Task Control End.");
}

-(void)endReadingData:(NSNotification *)notification
{
    NSLog(@"SimCellDocument: End reading data.");
    unsigned long numberOfLines, index, stringLength = [[simcell currentData] length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++)
        index = NSMaxRange([[simcell currentData] lineRangeForRange:NSMakeRange(index, 0)]);
    
    NSLog(@"SimCellDocument: data length: %lu", stringLength);
    NSLog(@"SimCellDocument: data lines: %lu", numberOfLines);
    NSLog(@"SimCellDocument: data: %@", [simcell currentData]);
    
    simcellLock = NO;
}

@end
