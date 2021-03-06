//
//  Configuration.h
//  iSimCell
//
//  Created by tucano on 5/26/11.
//  Copyright (c) 2011 Tucano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Simulation;

@interface Configuration : NSManagedObject {
    NSInteger nspheres;
    NSInteger divisions;
    NSInteger size;
    NSInteger facs_range;
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * output;
@property (nonatomic, retain) NSNumber * parent_mean;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSNumber * division_range;
@property (nonatomic, retain) NSNumber * develop;
@property (nonatomic, retain) NSNumber * log_decades;
@property (nonatomic, retain) NSNumber * sigsplit_temp;
@property (nonatomic, retain) NSNumber * latency;
@property (nonatomic, retain) NSNumber * timelimit;
@property (nonatomic, retain) NSNumber * pkh_range;
@property (nonatomic, retain) NSNumber * verbose;
@property (nonatomic, retain) NSNumber * latency_temp;
@property (nonatomic, retain) NSNumber * division_temp;
@property (nonatomic, retain) NSNumber * pkh_temp;
@property (nonatomic, retain) NSNumber * headers;
@property (nonatomic, retain) NSNumber * prob;
@property (nonatomic, retain) Simulation * simulation;

// CUSTOM
@property NSInteger nspheres;
@property NSInteger divisions;
@property NSInteger size;
@property NSInteger facs_range;

- (void) generateUniqueID;
-(NSArray *)arrayOfOptions;

@end
