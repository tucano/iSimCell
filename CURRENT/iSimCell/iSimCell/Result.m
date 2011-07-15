//
//  Result.m
//  iSimCell
//
//  Created by drambald on 7/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Result.h"
#import "Configuration.h"
#import "Plot.h"


@implementation Result
@dynamic name;
@dynamic notes;
@dynamic uniqueID;
@dynamic configuration;
@dynamic plots;
@dynamic data;

- (void)addPlotsObject:(Plot *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"plots" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"plots"] addObject:value];
    [self didChangeValueForKey:@"plots" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removePlotsObject:(Plot *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"plots" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"plots"] removeObject:value];
    [self didChangeValueForKey:@"plots" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addPlots:(NSSet *)value {    
    [self willChangeValueForKey:@"plots" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"plots"] unionSet:value];
    [self didChangeValueForKey:@"plots" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removePlots:(NSSet *)value {
    [self willChangeValueForKey:@"plots" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"plots"] minusSet:value];
    [self didChangeValueForKey:@"plots" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

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
