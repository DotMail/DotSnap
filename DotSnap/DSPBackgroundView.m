//
//  DSPBackgroundView.m
//  DotSnap
//
//  Created by Robert Widmann on 8/11/13.
//
//

#import "DSPBackgroundView.h"

@implementation DSPBackgroundView

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	
	self.layer = CALayer.layer;
	self.layer.doubleSided = YES;
	self.layer.delegate = self;
	self.wantsLayer = YES;
	self.backgroundColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000];
	
	return self;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
	self.layer.backgroundColor = backgroundColor.dsp_CGColor;
	[self.layer setNeedsDisplay];
	[self setNeedsDisplay:YES];
}

- (void)viewDidMoveToWindow {
	[super viewDidMoveToWindow];
	self.layer.contentsScale = self.window.backingScaleFactor;
}

@end

@implementation DSPBackgroundTrackingView {
	NSTrackingArea *trackingArea;
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
	if (!trackingArea) {
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

- (void)resetCursorRects {
	[self addCursorRect:self.bounds cursor:NSCursor.pointingHandCursor];
}

@end
