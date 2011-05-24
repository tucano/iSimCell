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
    NSPipe *fromPipeError;
    NSFileHandle *toSimcellbin;
    NSFileHandle *fromSimcellbin;
    NSFileHandle *fromSimCellError;
    NSString *path;
    NSArray *simCellArguments;
}

@property(assign) NSArray *simCellArguments;
@property(readonly) NSFileHandle *fromSimcellbin;
@property(readonly) NSFileHandle *fromSimCellError;

-(void)launch;

@end
