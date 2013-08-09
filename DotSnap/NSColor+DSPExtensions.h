//
//  NSColor+DSPExtensions.h
//  DotSnap
//
//  Created by Robert Widmann on 7/25/13.
//
//

@interface NSColor (DSPCGColor)

//
// The Quartz color reference that corresponds to the receiver's color.
//
@property (nonatomic, readonly) CGColorRef dsp_CGColor;

//
// Converts a Quartz color reference to its NSColor equivalent.
//
+ (NSColor *)dsp_colorWithCGColor:(CGColorRef)color;

@end
