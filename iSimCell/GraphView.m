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
    graph = [[CPXYGraph alloc] initWithFrame: self.view.bounds];
    CPLayerHostingView *hostingView = (CPLayerHostingView *)self.view;
    hostingView.hostedLayer = graph;
    graph.paddingLeft = 20.0;
    graph.paddingTop = 20.0;
    graph.paddingRight = 20.0;
    graph.paddingBottom = 20.0;
    
    CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-6)
                                                   length:CPDecimalFromFloat(12)];
    plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-5) 
                                                   length:CPDecimalFromFloat(30)];

    
    CPMutableLineStyle *lineStyle = [CPLineStyle lineStyle];
    lineStyle.lineColor = [CPColor blackColor];
    lineStyle.lineWidth = 2.0f;
    
    CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
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
    
    CPScatterPlot *xSquaredPlot = [[CPScatterPlot alloc] init];
    
    xSquaredPlot.identifier = @"X Squared Plot";
    
    lineStyle = [[xSquaredPlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth = 1.0f;
    lineStyle.lineColor = [CPColor redColor];
    xSquaredPlot.dataLineStyle = lineStyle;
    xSquaredPlot.dataSource = self;
    [graph addPlot:xSquaredPlot];
    
    CPPlotSymbol *greenCirclePlotSymbol = [CPPlotSymbol ellipsePlotSymbol];
    greenCirclePlotSymbol.fill = [CPFill fillWithColor:[CPColor redColor]];
    greenCirclePlotSymbol.size = CGSizeMake(2.0, 2.0);
    
    [xSquaredPlot setPlotSymbol:greenCirclePlotSymbol];
    
    CPScatterPlot *xInversePlot = [[CPScatterPlot alloc] init];
    xInversePlot.identifier = @"X Inverse Plot";
    lineStyle = [[xInversePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth = 2.0f;
    lineStyle.lineColor = [CPColor yellowColor];
    xInversePlot.dataLineStyle = lineStyle;
    xInversePlot.dataSource = self;
    [graph addPlot:xInversePlot];

}

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
    return 51;
}

-(NSNumber *)numberForPlot:(CPPlot *)plot 
                     field:(NSUInteger)fieldEnum 
               recordIndex:(NSUInteger)index 
{
    double val = (index/5.0)-5;
    
    if(fieldEnum == CPScatterPlotFieldX)
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
