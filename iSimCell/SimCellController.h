//
//  SimCellController.h
//  iSimCell
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SimCellLinker.h"

@interface SimCellController : NSWindowController {
@private
    IBOutlet NSTextView *theText;
    SimCellLinker *simcell;
}
- (IBAction)launchSim:(id)sender;
- (void)appendString:(NSString *)string toView:(NSTextView *)view;
@end
