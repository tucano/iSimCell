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
@dynamic headers;
@dynamic key;
@dynamic latency;
@dynamic latency_temp;
@dynamic log_decades;
@dynamic name;
@dynamic parent_mean;
@dynamic pkh_range;
@dynamic pkh_temp;
@dynamic prob;
@dynamic sigsplit_temp;
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

-(NSArray *)arrayOfOptions
{
    /*
     * 1. create a MutableArray and handle special cases
     * 2. get keys from Attributes and make them a MutableDicionary
     * 3. remove bad keys
     * 4. loop 
     */
    
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    NSMutableDictionary *keys = [[NSMutableDictionary alloc] initWithDictionary:[[self entity] attributesByName]];
    
    // handle VERBOSE and HEADERS
    if ([self.verbose intValue] > 0) {
        NSString *verboseLevel = @"-";
        for (int i = 1 ; i <= [self.verbose intValue]; i++) {
            verboseLevel = [verboseLevel stringByAppendingString:@"v"];
        }
        [tmp addObject:verboseLevel];
    }
    if ([self.headers intValue] > 0) {
        [tmp addObject:@"-H"];
    }
    
    [keys removeObjectForKey:@"uniqueID"];
    [keys removeObjectForKey:@"name"];
    [keys removeObjectForKey:@"verbose"];
    [keys removeObjectForKey:@"headers"];
    
    NSEnumerator *enumerator = [keys keyEnumerator];
    id key;
    
    while ((key = [enumerator nextObject])) {
        NSString *optkey = [@"--" stringByAppendingString:key];
        optkey = [optkey stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
        optkey = [optkey stringByAppendingString:@"="];
        NSString *optvalue = [NSString stringWithFormat:@"%@",[self valueForKey:key]];
        NSString *optstr = [optkey stringByAppendingString:optvalue];        
        [tmp addObject:optstr];
    }
    
    NSArray *opt = [[NSArray alloc] initWithArray:tmp];
    [tmp release];
    return opt;
}

#pragma mark -
#pragma mark Custom Accessors
-(NSInteger)nspheres
{
    [self willAccessValueForKey:@"nspheres"];
    long n = nspheres;
    [self didAccessValueForKey:@"nspheres"];
    return n;
}

-(void)setNspheres:(NSInteger)newSpheres
{
    [self willAccessValueForKey:@"nspheres"];
    nspheres = newSpheres;
    [self didAccessValueForKey:@"nspheres"];
}

-(NSInteger)divisions
{
    [self willAccessValueForKey:@"divisions"];
    long n = divisions;
    [self didAccessValueForKey:@"divisions"];
    return n;
}

-(void)setDivisions:(NSInteger)newDivisions
{
    [self willAccessValueForKey:@"divisions"];
    divisions = newDivisions;
    [self didAccessValueForKey:@"divisions"];
}

-(NSInteger)size
{
    [self willAccessValueForKey:@"size"];
    long n = size;
    [self didAccessValueForKey:@"size"];
    return n;
}

-(void)setSize:(NSInteger)newSize
{
    [self willAccessValueForKey:@"size"];
    size = newSize;
    [self didAccessValueForKey:@"size"];
}

-(NSInteger)facs_range
{
    [self willAccessValueForKey:@"facs_range"];
    long n = facs_range;
    [self didAccessValueForKey:@"facs_range"];
    return n;
}

-(void)setFacs_range:(NSInteger)new_facs_range
{
    [self willAccessValueForKey:@"facs_range"];
    facs_range = new_facs_range;
    [self didAccessValueForKey:@"facs_range"];
}

@end
