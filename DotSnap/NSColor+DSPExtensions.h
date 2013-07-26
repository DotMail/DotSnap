//
//  NSColor+DSPExtensions.h
//  DotSnap
//
//  Created by Robert Widmann on 7/25/13.
//
//

#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_8

@interface NSColor (CGColor)

//
// The Quartz color reference that corresponds to the receiver's color.
//
@property (nonatomic, readonly) CGColorRef CGColor;

//
// Converts a Quartz color reference to its NSColor equivalent.
//
+ (NSColor *)colorWithCGColor:(CGColorRef)color;

@end

#endif