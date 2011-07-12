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
        
        [managedObjectContext processPendingChanges];
        
        // enable save ...
        [[managedObjectContext undoManager] enableUndoRegistration];
        
        NSLog(@"SimCellDocument: CoreData default objects created.");
        NSLog(@"SimCellDocument: CoreData managed object context: %@.", managedObjectContext);
    }
    return self;
}

#pragma mark -
#pragma mark WindowController

// override -makeWindowControllers to set a window Controller attached to the document
-(void)makeWindowControllers
{
    mainWindow = [ [SimCellController alloc] initWithManagedObjectContext:[self managedObjectContext]  ];
    [mainWindow autorelease];
    [self addWindowController:mainWindow];
    
    NSLog(@"SimCellDocument: passing control to the window controller.");
    
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    NSLog(@"SimCellDocument: window controller DidLoad the NIB.");
}

@end
