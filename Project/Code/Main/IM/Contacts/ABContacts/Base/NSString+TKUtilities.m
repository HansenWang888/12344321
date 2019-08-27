//
//  UIImage+TKUtilities.m
//  Project
//
//  Created by Mike on 2019/6/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "NSString+TKUtilities.h"

@implementation NSString (TKUtilities)

- (BOOL)containsString:(NSString *)aString
{
	NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
	return range.location != NSNotFound;
}

- (NSString*)initTelephoneWithReformat
{
    
    if ([self containsString:@"-"])
    {
        self = [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    if ([self containsString:@" "])
    {
        self = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    if ([self containsString:@"("])
    {
        self = [self stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    
    if ([self containsString:@")"])
    {
        self = [self stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    
    return self;
}

@end
