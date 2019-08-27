//
//  YEBProfitsDetailView.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/23.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "YEBProfitsDetailView.h"
#import "YEBChartsValueFormatter.h"
#import "YEBNetwork.h"
@interface YEBProfitsDetailView ()<IChartAxisValueFormatter>

@property (nonatomic, weak) UISegmentedControl *segment;
@property (nonatomic, weak) LineChartView *lineChartView;

@property (nonatomic, strong) NSMutableArray *dataSources;

@end

@implementation YEBProfitsDetailView



- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self loadData];
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    if (self.tableHeaderView == nil) {
        self.tableHeaderView = [self crateHeaderView];
        self.tableHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 215);
        [self setChartsData];
    }
   
    
    
}
- (void)segmentValueChanged {

    [self updateDataWithIndex:self.segment.selectedSegmentIndex];
    
}

- (void)loadData {
    [SVProgressHUD showWithStatus:nil];
    
    [[YEBNetwork getProfitList] dy_startRequestWithFinished:^(id  _Nonnull responseObject, DYNetworkError * _Nonnull error) {
        
        if (!error) {
            [SVProgressHUD dismiss];
            self.dataSources = [[NSMutableArray alloc] initWithCapacity:3];
            NSInteger maxSevenDayAnnualRate = [responseObject[@"maxSevenDayAnnualRate"] integerValue];
            NSArray *sevenDayAnnualRate = responseObject[@"sevenDayAnnualRate"];
            [self.dataSources addObject:[self generateDataWithArray:sevenDayAnnualRate maxY:maxSevenDayAnnualRate]];
            NSArray *thirtyDayAnnualRate = responseObject[@"thirtyDayAnnualRate"];
            NSInteger maxThirtyDayAnnualRate = [responseObject[@"maxThirtyDayAnnualRate"] integerValue];
            [self.dataSources addObject:[self generateDataWithArray:thirtyDayAnnualRate maxY:maxThirtyDayAnnualRate]];
            NSArray *tenThousandEarnings = responseObject[@"tenThousandEarnings"];
            NSInteger maxEarnings = [responseObject[@"maxEarnings"] integerValue];
            [self.dataSources addObject:[self generateDataWithArray:tenThousandEarnings maxY:maxEarnings]];
            [self updateDataWithIndex:0];
        } else {
            [SVProgressHUD showErrorWithStatus:error.errorMessage];
        }
    }];
    
}

- (NSDictionary<NSString*, id> *)generateDataWithArray:(NSArray *)array maxY:(NSInteger)maxY {
    
    NSMutableDictionary *dictM = @{}.mutableCopy;
    
    NSMutableArray *xData = @[].mutableCopy;
    NSMutableArray *data = @[].mutableCopy;
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *time = [obj objectForKey:@"createDate"];
        NSString *number = [NSString stringWithFormat:@"%@",obj[@"annualRate"]];
        if (obj[@"annualRate"] == nil) {
            number = [NSString stringWithFormat:@"%@",obj[@"earnings"]];
        }
        [xData addObject:[time substringWithRange:NSMakeRange(time.length - 5, 5)]];
        [data addObject:number];
    }];
    dictM[@"xdata"] = xData;
    dictM[@"ydata"] = @(maxY);
    dictM[@"data"]  = data;
    
    return dictM.copy;
    
}

- (void)updateDataWithIndex:(NSInteger)index {
    
//    NSArray *amounts = @[@(7),@(30),@(10)];
//    NSMutableArray *arrayM = [[NSMutableArray alloc] initWithCapacity:[amounts[index] integerValue]];
//    NSMutableArray *yData = [[NSMutableArray alloc] initWithCapacity:[amounts[index] integerValue]];
//
//    for (int i = 0; i < [amounts[index] integerValue]; ++i) {
//
//        [arrayM addObject:[NSString stringWithFormat:@"07-%d",i + 1]];
//        [yData addObject:@(arc4random() % 100)];
//
//    }
//    self.dateArray = arrayM.copy;
//    self.lineData = yData.copy;
//    self.yData = @[@"5.00%",@"10.00%",@"15.00%",@"5.00%",@"20.00%",@"25.00%",@"30.00%"];
    if (self.lineChartView) {
        [self setChartsData];
    }
}

- (UIView *)crateHeaderView {
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"七日年化",@"30日年化",@"万份收益"]];
    self.segment = segment;
    [segment addTarget:self action:@selector(segmentValueChanged) forControlEvents:UIControlEventValueChanged];
    segment.tintColor = kColorWithHex(0xfe4c56);
    segment.selectedSegmentIndex = 0;
    [self segmentValueChanged];
    [headerView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8);
        make.right.offset(-8);
        make.top.offset(12);
        make.height.offset(24);
    }];
    
    LineChartView *chartV = [[LineChartView alloc] init];
    chartV.scaleXEnabled = YES;
    chartV.legend.enabled = NO;
    chartV.drawGridBackgroundEnabled = YES;
    chartV.tintColor = [UIColor redColor];
    chartV.rightAxis.enabled = NO;
    
    chartV.leftAxis.gridLineDashLengths = @[@(5),@(5)];
    chartV.leftAxis.axisMaximum = [self.dataSources[self.segment.selectedSegmentIndex][@"ydata"] doubleValue];
    chartV.leftAxis.axisMinimum = 0;
    chartV.leftAxis.gridColor = kColorWithHex(0xcccccc);
    chartV.leftAxis.labelTextColor = kColorWithHex(0x999999);
    chartV.leftAxis.valueFormatter = self;
    
    chartV.leftAxis.labelCount = 7;
    chartV.leftAxis.forceLabelsEnabled = YES;

    chartV.leftAxis.drawLimitLinesBehindDataEnabled = YES;
//    [chartV.viewPortHandler setMinimumScaleX:1.5];
    
    chartV.xAxis.labelPosition = XAxisLabelPositionBottom;
    chartV.xAxis.gridColor = [UIColor clearColor];
    chartV.xAxis.labelTextColor = kColorWithHex(0x666666);
    chartV.xAxis.valueFormatter = self;
    chartV.xAxis.granularityEnabled = YES;

    
    self.lineChartView = chartV;
    
    [headerView addSubview:chartV];
    [chartV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(8);
        make.right.offset(-8);
        make.top.equalTo(segment.mas_bottom).offset(10);
    }];
    return headerView;
}

- (void)setChartsData {
    if (self.dataSources.count == 0) {
        return;
    }
    self.lineChartView.leftAxis.axisMaximum = [self.dataSources[self.segment.selectedSegmentIndex][@"ydata"] doubleValue];

    //定义一个数组承接数据
    //对应Y轴上面需要显示的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    NSArray *chartsData = self.dataSources[self.segment.selectedSegmentIndex][@"data"];
    for (int i = 0; i < chartsData.count; i++) {
        
        //将横纵坐标以ChartDataEntry的形式保存下来，注意横坐标值一般是i的值，而不是你的数据    //里面具体的值，如何将具体数据展示在X轴上我们下面将会说到。
        
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[ chartsData[i] floatValue]];
        [yVals addObject:entry];
    }
    
    LineChartDataSet *set1 = nil;
    
    //请注意这里，如果你的图表以前绘制过，那么这里直接重新给data赋值就行了。
    //如果没有，那么要先定义set的属性。
//    if (self.lineChartView.data.dataSetCount > 0) {
//        LineChartData *data = (LineChartData *)self.lineChartView.data;
//        set1 = (LineChartDataSet *)data.dataSets[0];
//        //        set1.yVals = yVals;
//
//        set1 = (LineChartDataSet *)self.lineChartView.data.dataSets[0];
//
//        //通知data去更新
//        [self.lineChartView.data notifyDataChanged];
//        //通知图表去更新
//        [self.lineChartView notifyDataSetChanged];
//
//    }else{
    
    //创建LineChartDataSet对象
    set1 = [[LineChartDataSet alloc] initWithEntries:yVals];
    //自定义set的各种属性
    //折线拐点样式
    set1.drawCirclesEnabled = YES;//是否绘制拐点
    //设置折线的样式
    //折线颜色
    [set1 setColor:UIColor.redColor];
    //折线点的颜色
    [set1 setCircleColor:UIColor.redColor];
    //折线的宽度
    set1.lineWidth = 1.0;
    //折线点的宽度
    set1.circleRadius = 3.0;
    
    set1.circleHoleRadius = 2.0;
    //是否画空心圆
    set1.drawCircleHoleEnabled = YES;
    set1.valueFont = [UIFont systemFontOfSize:8];
    
    set1.drawIconsEnabled = NO;
    set1.formLineWidth = 1.1;//折线宽度
    set1.formSize = 15.0;
    set1.drawValuesEnabled = YES;//是否在拐点处显示数据
    set1.valueColors = @[[UIColor blackColor]];//折线拐点处显示数据的颜色
    [set1 setColor:kColorWithHex(0xf6b2b5)];//折线颜色
    //第二种填充样式:渐变填充
    set1.drawFilledEnabled = YES;//是否填充颜色
    NSArray *gradientColors = @[(id)kColorWithHex(0xf7e7e8).CGColor,(id)kColorWithHex(0xfaa2a6).CGColor];
    CGGradientRef gradientRef = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
    set1.fillAlpha = 1.0f;//透明度
    set1.fill = [ChartFill fillWithLinearGradient:gradientRef angle:90.0f];//赋值填充颜色对象
    CGGradientRelease(gradientRef);//释放gradientRef
    
    //点击选中拐点的交互样式
    set1.highlightEnabled = YES;//选中拐点,是否开启高亮效果(显示十字线)
    set1.highlightColor = [UIColor blackColor];//点击选中拐点的十字线的颜色
    set1.highlightLineWidth = 1.1/[UIScreen mainScreen].scale;//十字线宽度
    set1.highlightLineDashLengths = @[@5, @5];//十字线的虚线样式
    
    //将 LineChartDataSet 对象放入数组中
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    //创建 LineChartData 对象, 此对象就是lineChartView需要最终数据对象
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont systemFontOfSize:8.f]];//文字字体
    [data setValueTextColor:[UIColor blackColor]];//文字颜色
    
    self.lineChartView.data = data;
    //这里可以调用一个加载动画即1s出来一个绘制点
    [self.lineChartView animateWithXAxisDuration:1.0f];
    
}



#pragma mark - IChartAxisValueFormatter
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    
    NSString *valueStr = nil;
    
    if (axis == self.lineChartView.leftAxis) {
        
        valueStr = [NSString stringWithFormat:@"%ld%%",(NSInteger)value];
        if (self.segment.selectedSegmentIndex == 2) {
            valueStr = [NSString stringWithFormat:@"%.2f",value];
        }
    } else if (self.lineChartView.xAxis) {
        
        NSArray *xdata = self.dataSources[self.segment.selectedSegmentIndex][@"xdata"];
        if (value < xdata.count && value >= 0) {
            valueStr = [NSString stringWithFormat:@"%@",xdata[(NSInteger)value]];
        }
        
    }
    return valueStr;
}
@end
