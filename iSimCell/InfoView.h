//
//  InfoView.h
//  iSimCell
//
//  Created by Davide Rambaldi on 5/31/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Simulation.h"
#import "SimCellController.h"

@class SimCellController;

@interface InfoView : NSViewController {
@private
    
}

// parent window.
@property (assign) SimCellController *mainWindowController;
@property (assign) NSArrayController *simulationController;

@end
