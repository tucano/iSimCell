//
//  Plot.m
//  iSimCell
//
//  Created by drambald on 7/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Plot.h"


@implementation Plot
@dynamic name;
@dynamic notes;
@dynamic uniqueID;
@dynamic result;

#pragma mark -
#pragma mark Core Data Methods
- (void) awakeFromInsert 
{
    // called when the object is first created.
    [self generateUniqueID];
}


#pragma mark -
#pragma mark Custom Actions

- (void) generateUniqueID 
{
    NSString* uniqueID = self.uniqueID;
    if ( uniqueID != nil ) return;
    self.uniqueID = [[NSProcessInfo processInfo] globallyUniqueString];
}

@end
