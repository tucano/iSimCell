//
//  Simulation.h
//  iSimCell
//
//  Created by tucano on 5/26/11.
//  Copyright (c) 2011 Tucano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Simulation : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* configurations;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSData * data;

-(void)addConfigurationsObject:(NSManagedObject *)value;
-(void)removeConfigurationsObject:(NSManagedObject *)value;
-(void)addConfigurations:(NSSet *)value;
-(void)removeConfigurations:(NSSet *)value;

-(void)generateUniqueID;
-(NSString *)stringifyData;

@end
