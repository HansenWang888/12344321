//
//  YEBChartsValueFormatter.m
//  Project
//
//  Created by fangyuan on 2019/7/25.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "YEBChartsValueFormatter.h"

@implementation YEBChartsValueFormatter

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    
    return [NSString stringWithFormat:@"%f%%", value];
    
}

@end
