//
//  Simulation.m
//  iSimCell
//
//  Created by tucano on 5/26/11.
//  Copyright (c) 2011 Tucano. All rights reserved.
//

#import "Simulation.h"


@implementation Simulation

#pragma mark -
#pragma mark Initialization

@dynamic name;
@dynamic configurations;
@dynamic uniqueID;

#pragma mark -
#pragma mark Accessors/Mutators

- (void)addConfigurationsObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"configurations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"configurations"] addObject:value];
    [self didChangeValueForKey:@"configurations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeConfigurationsObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"configurations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"configurations"] removeObject:value];
    [self didChangeValueForKey:@"configurations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addConfigurations:(NSSet *)value {    
    [self willChangeValueForKey:@"configurations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"configurations"] unionSet:value];
    [self didChangeValueForKey:@"configurations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeConfigurations:(NSSet *)value {
    [self willChangeValueForKey:@"configurations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"configurations"] minusSet:value];
    [self didChangeValueForKey:@"configurations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

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
