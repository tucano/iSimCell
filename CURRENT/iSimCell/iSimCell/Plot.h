//
//  Plot.h
//  iSimCell
//
//  Created by drambald on 7/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Plot : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSManagedObject * result;

@end
