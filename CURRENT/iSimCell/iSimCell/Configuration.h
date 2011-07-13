//
//  Configuration.h
//  iSimCell
//
//  Created by drambald on 7/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Configuration : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * develop;
@property (nonatomic, retain) NSNumber * division_range;
@property (nonatomic, retain) NSNumber * division_temp;
@property (nonatomic, retain) NSNumber * divisions;
@property (nonatomic, retain) NSNumber * facs_range;
@property (nonatomic, retain) NSNumber * headers;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * latency;
@property (nonatomic, retain) NSNumber * latency_temp;
@property (nonatomic, retain) NSNumber * log_decades;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * nspheres;
@property (nonatomic, retain) NSNumber * parent_mean;
@property (nonatomic, retain) NSNumber * pkh_range;
@property (nonatomic, retain) NSNumber * pkh_temp;
@property (nonatomic, retain) NSNumber * prob;
@property (nonatomic, retain) NSNumber * sigsplit_temp;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSNumber * timelimit;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSNumber * verbose;
@property (nonatomic, retain) NSManagedObject * simulation;
@property (nonatomic, retain) NSSet* results;

@end
