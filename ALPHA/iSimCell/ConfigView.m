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

#pragma mark -
#pragma mark Private

-(Configuration *)selectedConfiguration
{
    return [[self.configurationController selectedObjects] objectAtIndex:0];
}


#pragma mark -
#pragma mark Initialization

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


#pragma mark -
#pragma mark Actions

-(IBAction)changeOutput:(id)sender
{
    NSLog(@"Current configuration: %@. Sender: %@",[[self selectedConfiguration] name],[[sender selectedItem] title]);
    [[self selectedConfiguration] setValue:[[sender selectedItem] title] 
                                    forKey:@"output"];
}

#pragma mark -
#pragma mark AwakeFromNib

- (void)awakeFromNib
{
    NSLog(@"AWAKE  from NIB for : CONFIGVIEW");
    NSLog(@"Parent: %@", self.mainWindowController);
    NSLog(@"Simulation Controller: %@", self.simulationController);
    NSLog(@"Configuration Controller: %@", self.configurationController);
    
    [outputPopUp selectItemWithTitle:[[self selectedConfiguration] output]];
    
    NSLog(@"PopUp Output: %@", [outputPopUp titleOfSelectedItem]);
}

@end
