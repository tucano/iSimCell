//
//  GraphView.h
//  iSimCell
//
//  Created by Davide Rambaldi on 6/6/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CorePlot/CorePlot.h"

@interface GraphView : NSViewController <CPPlotDataSource> {
@private
    CPXYGraph *graph;
}

@end
