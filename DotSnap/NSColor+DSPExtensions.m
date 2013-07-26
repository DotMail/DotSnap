//
//  NSColor+DSPExtensions.m
//  DotSnap
//
//  Created by Robert Widmann on 7/25/13.
//
//

#import "NSColor+DSPExtensions.h"

#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_8

@implementation NSColor (CGColor)

- (CGColorRef)CGColor
{
    const NSInteger numberOfComponents = [self numberOfComponents];
    CGFloat components[numberOfComponents];
    CGColorSpaceRef colorSpace = [[self colorSpace] CGColorSpace];
	
    [self getComponents:(CGFloat *)&components];
	
    return (CGColorRef)[(id)CGColorCreate(colorSpace, components) autorelease];
}

+ (NSColor *)colorWithCGColor:(CGColorRef)CGColor
{
    if (CGColor == NULL) return nil;
    return [NSColor colorWithCIColor:[CIColor colorWithCGColor:CGColor]];
}

@end

#endif