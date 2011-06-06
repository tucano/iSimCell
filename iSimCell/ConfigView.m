//
//  ConfigView.m
//  iSimCell
//
//  Created by drambald on 6/6/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import "ConfigView.h"


@implementation ConfigView

@synthesize mainWindowController;
@synthesize simulationController;
@synthesize configurationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

// -------------------------------------------------------------------------------
//	awakeFromNib:
// -------------------------------------------------------------------------------
- (void)awakeFromNib
{
    NSLog(@"AWAKE  from NIB for : CONFIGVIEW");
    NSLog(@"Parent: %@", self.mainWindowController);
    NSLog(@"Simulation Controller: %@", self.simulationController);
    NSLog(@"Configuration Controller: %@", self.configurationController);
}

@end
