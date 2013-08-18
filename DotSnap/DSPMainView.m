//
//  DSPView.m
//  DotSnap
//
//  Created by Robert Widmann on 7/24/13.
//
//

#import "DSPMainView.h"

@implementation DSPMainView {
	BOOL showingPentagon;
}

- (void)drawRect:(NSRect)dirtyRect {
	CGRect slice, remainder;
	CGRectDivide(self.bounds, &slice, &remainder, 10, CGRectMaxYEdge);
	
	[[NSColor clearColor] set];
	NSRectFill(slice);

	[[NSColor colorWithCalibratedRed:0.357 green:0.787 blue:0.572 alpha:1.000] set];
	slice.size.height = 1;
	slice.origin.y = NSHeight(self.bounds) - 9;
	NSRectFill(slice);
	
	[[NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000] set];
	slice.size.height = 1;
	slice.origin.y = NSHeight(self.bounds) - 10;
	NSRectFill(slice);
	
	[[NSColor whiteColor] set];
	NSRectFill(remainder);
	
	BOOL shouldDisplayWindow = NO;

	[[NSImage imageNamed:@"TopPartArrow"]drawAtPoint:NSMakePoint(((NSWidth(self.bounds) - 400)/2) - 6, NSHeight(self.bounds) - 10) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.f];
	
	if (shouldDisplayWindow) {
		shouldDisplayWindow = (showingPentagon == YES);
//		[[self window] display];
		[[self window] setHasShadow:NO];
		[[self window] setHasShadow:YES];
	}
}

- (CGRect)contentRect {
	CGRect rect = self.bounds;
	rect.size.height -= 10;
	return rect;
}

@end
