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
@dynamic output;
@dynamic parent_mean;
@dynamic uniqueID;
@dynamic division_range;
@dynamic develop;
@dynamic log_decades;
@dynamic sigsplit_temp;
@dynamic latency;
@dynamic timelimit;
@dynamic pkh_range;
@dynamic verbose;
@dynamic latency_temp;
@dynamic division_temp;
@dynamic pkh_temp;
@dynamic headers;
@dynamic nspheres;
@dynamic prob;
@dynamic simulation;


#pragma mark -
#pragma mark Core Data Methods
- (void) awakeFromInsert 
{
    // called when the object is first created.
    [self generateUniqueID];
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
    
    NSLog(@"verbose: %@", self.verbose);

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

@end
