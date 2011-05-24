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
    SimCellLinker *simcell;
    IBOutlet NSProgressIndicator *progBar;
}

-(IBAction)launchSim:(id)sender;
-(IBAction)terminateSim:(id)sender;

@end
