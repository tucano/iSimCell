//
//  SimCellController+OutlineView.h
//  iSimCell
//
//  Created by Davide Rambaldi on 5/30/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import "SimCellController.h"
#import "ChildNode.h"

//////////////////////////////////////////////////////////
// SIDEBAR 
//////////////////////////////////////////////////////////

#define INITIAL_INFODICT		@"outlineView"		// name of the dictionary file to populate our outline view

// keys in our disk-based dictionary representing our outline view's data
#define KEY_NAME				@"name"
#define KEY_URL					@"url"
#define KEY_SEPARATOR			@"separator"
#define KEY_GROUP				@"group"
#define KEY_FOLDER				@"folder"
#define KEY_ENTRIES				@"entries"
#define KEY_SIMULATION			@"simulation"
#define KEY_CONFIGURATION		@"configuration"

// placeholders
#define SIMULATIONS_NAME        @"SIMULATIONS"
#define UNTITLED_NAME			@"Untitled"		// default name for added folders and leafs
#define HTTP_PREFIX				@"http://"

@interface SimCellController (SimCellController_OutlineView)
    -(NSMutableArray *)outlineContents;
    - (void)setOutlineContents:(NSArray*)newContents;
@end
