//
//  SimCellController.m
//  iSimCell
//
//  Created by drambald on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimCellController.h"


@implementation SimCellController

#pragma mark -
#pragma mark Initialization

- (SimCellController *)initWithManagedObjectContext:(NSManagedObjectContext *)inMoc
{
    self = [super initWithWindowNibName:@"SimCellDocument"];
    [self setManagedObjectContext:inMoc];

    NSLog(@"SimCellController: taking control of managed object Context: %@", [self managedObjectContext]);
    
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        NSLog(@"SimCellController: Window init.");
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSLog(@"SimCellController: Window Loaded. Calling Document is: %@", [self document]);
}

-(void)awakeFromNib
{
    NSLog(@"SimCellController: AWAKE FROM NIB");
}

#pragma mark -
#pragma mark Accessors to ManagedObjectContext

- (void)setManagedObjectContext:(NSManagedObjectContext *)value
{
	// keep only weak ref
	_moc = value;
}

- (NSManagedObjectContext *)managedObjectContext
{
	return _moc;
}

@end