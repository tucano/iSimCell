//
//  InfoView.m
//  iSimCell
//
//  Created by Davide Rambaldi on 5/31/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import "InfoView.h"


@implementation InfoView

@synthesize mainWindowController;
@synthesize simulationController;
@synthesize configurationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Initialization code here.
        NSLog(@"Init Code for INFOVIEW.");
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
    NSLog(@"AWAKE  from NIB for : INFOVIEW");
    NSLog(@"Parent: %@", self.mainWindowController);
    NSLog(@"Simulation Controller: %@", self.simulationController);
    NSLog(@"Configuration Controller: %@", self.configurationController);
}

@end
