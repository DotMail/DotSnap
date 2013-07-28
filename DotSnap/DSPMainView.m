//
//  DSPView.m
//  DotSnap
//
//  Created by Robert Widmann on 7/24/13.
//
//

#import "DSPMainView.h"

@implementation DSPMainView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];

	self.layer = CALayer.layer;
	self.layer.doubleSided = YES;
    self.wantsLayer = YES;
	
    return self;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
	self.layer.backgroundColor = backgroundColor.CGColor;
	[self.layer setNeedsDisplay];
}

@end

@implementation DSPBackgroundView {
	NSTrackingArea *trackingArea;
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
	
	self.backgroundColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000];
	
    return self;
}

- (void)mouseEntered:(NSEvent *)theEvent {
	self.backgroundColor = [NSColor colorWithCalibratedRed:0.231 green:0.682 blue:0.478 alpha:1.000];
	[self.window.nextResponder mouseEntered:theEvent];
}

- (void)mouseExited:(NSEvent *)theEvent {
	self.backgroundColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000];
	[self.window.nextResponder mouseExited:theEvent];
}

- (void)ensureTrackingArea {
    if (trackingArea == nil) {
        trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:NSTrackingInVisibleRect | NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    }
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    [self ensureTrackingArea];
    if (![[self trackingAreas] containsObject:trackingArea]) {
        [self addTrackingArea:trackingArea];
    }
}

@end
