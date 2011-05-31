//
//  SimCellController+OutlineView.h
//  iSimCell
//
//  Created by Davide Rambaldi on 5/30/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import "SimCellController.h"
#import "ChildNode.h"

@interface SimCellController (SimCellController_OutlineView)
    -(NSMutableArray *)outlineContents;
    - (void)setOutlineContents:(NSArray*)newContents;
@end
