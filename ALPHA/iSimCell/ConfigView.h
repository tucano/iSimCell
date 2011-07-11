//
//  ConfigView.h
//  iSimCell
//
//  Created by drambald on 6/6/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SimCellController.h"
#import "Configuration.h"

@interface ConfigView : NSViewController {
@private
    IBOutlet NSPopUpButton *outputPopUp;
}

-(IBAction)changeOutput:(id)sender;

// parent window.
@property (assign) SimCellController *mainWindowController;
@property (assign) NSArrayController *simulationController;
@property (assign) NSArrayController *configurationController;

@end
