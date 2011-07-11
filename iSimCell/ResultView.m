//
//  ResultView.m
//  iSimCell
//
//  Created by drambald on 7/11/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import "ResultView.h"

@implementation ResultView

@synthesize mainWindowController;

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
#pragma mark AwakeFromNib

- (void)awakeFromNib
{
    NSLog(@"AWAKE  from NIB for : RESULTVIEW");
    NSLog(@"Parent: %@", self.mainWindowController);
    NSLog(@"MyDocument: %@", [self.mainWindowController document]);
    
    // FIXME deve fare update not in LOAD
    if ([[[self.mainWindowController document] simcell] currentData] != nil)
        NSLog(@"MyLinker data: %@", [[[self.mainWindowController document] simcell] currentData]);
}

@end
