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
    
    NSTask *task;
    
    NSPipe *outputPipe;
    NSPipe *outputPipeError;
    
    NSFileHandle *taskOutput;
    NSFileHandle *taskLog;
    
    NSString *path;
    NSArray *arguments;
    
    NSString *currentData;
}

@property(readonly, assign) NSString *currentData;
@property(assign) NSArray *arguments;

-(void)launchTask;
-(void)killTask;

@end
