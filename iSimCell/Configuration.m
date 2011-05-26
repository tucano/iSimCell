//
//  Configuration.m
//  iSimCell
//
//  Created by tucano on 5/26/11.
//  Copyright (c) 2011 Tucano. All rights reserved.
//

#import "Configuration.h"
#import "Simulation.h"


@implementation Configuration

#pragma mark -
#pragma mark Initialization

@dynamic name;
@dynamic key;
@dynamic facs_range;
@dynamic output;
@dynamic parent_mean;
@dynamic uniqueID;
@dynamic division_range;
@dynamic develop;
@dynamic log_decades;
@dynamic sigsplit_temp;
@dynamic latency;
@dynamic timelimit;
@dynamic size;
@dynamic pkh_range;
@dynamic verbose;
@dynamic latency_temp;
@dynamic division_temp;
@dynamic pkh_temp;
@dynamic divisions;
@dynamic headers;
@dynamic nspheres;
@dynamic prob;
@dynamic simulation;


#pragma mark -
#pragma mark Core Data Methods
- (void) awakeFromInsert {
    // called when the object is first created.
    [self generateUniqueID];
}


#pragma mark -
#pragma mark Private

- (void) generateUniqueID {
    NSString* uniqueID = self.uniqueID;
    if ( uniqueID != nil ) return;
    self.uniqueID = [[NSProcessInfo processInfo] globallyUniqueString];
}

@end
