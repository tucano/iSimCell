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



/* 
 *  TEMPLATE METHODS
 */

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    }
    return self;
}

// override -makeWindowControllers to set a window Controller attached to the document
-(void)makeWindowControllers
{
    SimCellController *ctl = [ [SimCellController alloc] initWithWindowNibName: [self windowNibName] ];
    [ctl autorelease];
    [self addWindowController:ctl];
    
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    return @"SimCellWindow";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    
    NSLog(@"%@","");
}

@end
