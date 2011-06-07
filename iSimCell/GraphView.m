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
    graph = [[CPTXYGraph alloc] initWithFrame: self.view.bounds];
    CPTLayerHostingView *hostingView = (CPTLayerHostingView *)self.view;
    hostingView.hostedLayer = graph;
    graph.paddingLeft = 20.0;
    graph.paddingTop = 20.0;
    graph.paddingRight = 20.0;
    graph.paddingBottom = 20.0;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-6)
                                                   length:CPTDecimalFromFloat(12)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-5) 
                                                   length:CPTDecimalFromFloat(30)];

    
    CPTMutableLineStyle *lineStyle = [CPTLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 2.0f;
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    axisSet.xAxis.majorIntervalLength = [[NSDecimalNumber decimalNumberWithString:@"1"] decimalValue];
    axisSet.xAxis.minorTicksPerInterval = 4;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.minorTickLength = 5.0f;
    axisSet.xAxis.majorTickLength = 7.0f;
    //axisSet.xAxis.axisLabelOffset = 3.0f;
    
    axisSet.yAxis.majorIntervalLength = [[NSDecimalNumber decimalNumberWithString:@"5"] decimalValue];
    axisSet.yAxis.minorTicksPerInterval = 4;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 7.0f;
    //axisSet.yAxis.axisLabelOffset = 3.0f;
    
    CPTScatterPlot *xSquaredPlot = [[CPTScatterPlot alloc] init];
    
    xSquaredPlot.identifier = @"X Squared Plot";
    
    lineStyle = [[xSquaredPlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth = 1.0f;
    lineStyle.lineColor = [CPTColor redColor];
    xSquaredPlot.dataLineStyle = lineStyle;
    xSquaredPlot.dataSource = self;
    [graph addPlot:xSquaredPlot];
    
    CPTPlotSymbol *greenCirclePlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    greenCirclePlotSymbol.fill = [CPTFill fillWithColor:[CPTColor redColor]];
    greenCirclePlotSymbol.size = CGSizeMake(2.0, 2.0);
    
    [xSquaredPlot setPlotSymbol:greenCirclePlotSymbol];
    
    CPTScatterPlot *xInversePlot = [[CPTScatterPlot alloc] init];
    xInversePlot.identifier = @"X Inverse Plot";
    lineStyle = [[xInversePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth = 2.0f;
    lineStyle.lineColor = [CPTColor yellowColor];
    xInversePlot.dataLineStyle = lineStyle;
    xInversePlot.dataSource = self;
    [graph addPlot:xInversePlot];

}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 51;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot 
                     field:(NSUInteger)fieldEnum 
               recordIndex:(NSUInteger)index 
{
    double val = (index/5.0)-5;
    
    if(fieldEnum == CPTScatterPlotFieldX)
    { return [NSNumber numberWithDouble:val]; }
    else
    { 
        if(plot.identifier == @"X Squared Plot")
        { return [NSNumber numberWithDouble:val*val]; }
        else
        { return [NSNumber numberWithDouble:1/val]; }
    }
}

@end
