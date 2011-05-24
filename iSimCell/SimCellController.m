//
//  SimCellController.m
//  iSimCell
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import "SimCellController.h"


@implementation SimCellController


/* 
 *  INIT, LOAD, DEALLOC
 */

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [simcell release];
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    NSLog(@"Window Loaded");
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
}
- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
    return [@"iSimCell - " stringByAppendingString:displayName];
}

/* 
 *  ACTIONS
 */

- (IBAction)launchSim:(id)sender
{
    simcell = [[SimCellLinker alloc] init];
    
    [ [NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(gotData:) 
     name:NSFileHandleReadCompletionNotification 
     object:[simcell fromSimcellbin]];
    
    [[simcell fromSimcellbin] readInBackgroundAndNotify];
    [simcell setSimCellArguments: [NSArray arrayWithObjects: @"-o", @"table",@"-n",@"1000", nil] ];
    [simcell launch];
    [simcell storeData];
    NSLog(@"DATA: %lu", [[simcell simCellData] length]);
}

- (void)gotData:(NSNotification *)notification
{
    NSData  *data;
    NSString  *str;
    
    data = [ [notification userInfo] objectForKey:NSFileHandleNotificationDataItem ];
    str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"%@", str);
    [[simcell fromSimcellbin] readInBackgroundAndNotify];
    [str release];
}

// USED TO APPEND STRINGS TO TEXTVIEW
- (void)appendString:(NSString *)string toView:(NSTextView *)view
{
    if (string == nil) { return; }
    
    string = [string stringByAppendingString:@"\n"];
    
    NSAttributedString *stringToAppend =
    [[NSAttributedString alloc] initWithString:string];
    
    [[view textStorage] appendAttributedString:stringToAppend];
    
    [stringToAppend release];
}

@end
