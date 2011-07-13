//
//  Configuration.m
//  iSimCell
//
//  Created by drambald on 7/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Configuration.h"


@implementation Configuration
@dynamic develop;
@dynamic division_range;
@dynamic division_temp;
@dynamic divisions;
@dynamic facs_range;
@dynamic headers;
@dynamic key;
@dynamic latency;
@dynamic latency_temp;
@dynamic log_decades;
@dynamic name;
@dynamic nspheres;
@dynamic parent_mean;
@dynamic pkh_range;
@dynamic pkh_temp;
@dynamic prob;
@dynamic sigsplit_temp;
@dynamic size;
@dynamic timelimit;
@dynamic uniqueID;
@dynamic verbose;
@dynamic simulation;
@dynamic results;


- (void)addResultsObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"results" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"results"] addObject:value];
    [self didChangeValueForKey:@"results" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeResultsObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"results" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"results"] removeObject:value];
    [self didChangeValueForKey:@"results" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addResults:(NSSet *)value {    
    [self willChangeValueForKey:@"results" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"results"] unionSet:value];
    [self didChangeValueForKey:@"results" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeResults:(NSSet *)value {
    [self willChangeValueForKey:@"results" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"results"] minusSet:value];
    [self didChangeValueForKey:@"results" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
