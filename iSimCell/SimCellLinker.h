//
//  SimCellLinker.h
//  iSimCell
//
//  Created by tucano on 5/23/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SimCellLinker : NSObject {
@private
    NSTask *simcellbin;
    NSPipe *toPipe;
    NSPipe *fromPipe;
    NSFileHandle *toSimcellbin;
    NSFileHandle *fromSimcellbin;
    NSString *path;
}
@property(readonly) NSFileHandle *fromSimcellbin;
-(void)launch;

@end
