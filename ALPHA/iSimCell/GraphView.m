//
//  GraphView.m
//  iSimCell
//
//  Created by Davide Rambaldi on 6/6/11.
//  Copyright 2011 Tucano. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

// -------------------------------------------------------------------------------
//	awakeFromNib:
// -------------------------------------------------------------------------------
- (void)awakeFromNib
{
    NSLog(@"AWAKE  from NIB for : GRAPHVIEW");
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    graph = (CPTXYGraph *)[theme newGraph];
    CPTLayerHostingView *hostingView = (CPTLayerHostingView *)self.view;
    hostingView.hostedLayer = graph;
    graph.paddingLeft = 10.0;
    graph.paddingTop = 10.0;
    graph.paddingRight = 10.0;
    graph.paddingBottom = 10.0;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)
                                                   length:CPTDecimalFromFloat(100)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) 
                                                   length:CPTDecimalFromFloat(100)];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
   
    CPTXYAxis *x = axisSet.xAxis;
    
    x.majorIntervalLength = CPTDecimalFromFloat(10);
    x.minorTicksPerInterval = 2;
    x.borderWidth = 0;
    x.labelExclusionRanges = [NSArray arrayWithObjects:
                              [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-100) 
                                                          length:CPTDecimalFromFloat(300)], 
							  nil];
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPTDecimalFromFloat(10);
    y.minorTicksPerInterval = 1;
    y.labelExclusionRanges = [NSArray arrayWithObjects:
                              [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-100) 
                                                          length:CPTDecimalFromFloat(300)], 
							  nil];
    CPTScatterPlot *dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = @"AllTests";
    CPTMutableLineStyle *lineStyle = [CPTLineStyle lineStyle];
    lineStyle.lineWidth = 3.f;
    lineStyle.lineColor = [CPTColor greenColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
}


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 251;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot 
                     field:(NSUInteger)fieldEnum 
               recordIndex:(NSUInteger)index 
{
    switch (fieldEnum)
    {
        case CPTScatterPlotFieldX: 
        {
            return [NSNumber numberWithFloat:index];
        }
        case CPTScatterPlotFieldY:
        {
            if ([plot.identifier isEqual:@"AllTests"])
            {
                float r = (arc4random() % 100) + 1;
                return [NSNumber numberWithFloat:r];
            }
        }
    }
    return nil;
}

@end
