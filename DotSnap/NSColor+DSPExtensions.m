//
//  NSColor+DSPExtensions.m
//  DotSnap
//
//  Created by Robert Widmann on 7/25/13.
//
//

#import "NSColor+DSPExtensions.h"

@implementation NSColor (CGColor)

- (CGColorRef)dsp_CGColor {
	const NSInteger numberOfComponents = [self numberOfComponents];
	CGFloat components[numberOfComponents];
	CGColorSpaceRef colorSpace = [[self colorSpace] CGColorSpace];
	
	[self getComponents:(CGFloat *)&components];
	
	return (CGColorRef)[(id)CGColorCreate(colorSpace, components) autorelease];
}

+ (NSColor *)dsp_colorWithCGColor:(CGColorRef)CGColor {
	if (CGColor == NULL) return nil;
	return [NSColor colorWithCIColor:[CIColor colorWithCGColor:CGColor]];
}

@end