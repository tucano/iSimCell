//
//  SimCellController.h
//  iSimCell
//
//  Created by drambald on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SimCellDocument.h"

@interface SimCellController : NSWindowController {
@private
     NSManagedObjectContext *_moc;
}


- (void)setManagedObjectContext:(NSManagedObjectContext *)value;
- (NSManagedObjectContext *)managedObjectContext;

- (SimCellController *)initWithManagedObjectContext:(NSManagedObjectContext *)inMoc;

@end
