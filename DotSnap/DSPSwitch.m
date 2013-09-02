//
//  DSPSwitch.m
//  DotSnap
//
//  Created by Robert Widmann on 7/25/13.
//
//

#import "DSPSwitch.h"

@interface DSPSwitch ()
@property (nonatomic, strong) CALayer *offLayer;
@property (nonatomic, strong) CALayer *onLayer;
@property (nonatomic, strong) CALayer *switchCover;
@end

@implementation DSPSwitch {
	NSTrackingArea *trackingArea;
	BOOL _isTracking;
	BOOL _hasMoved;
	CGFloat _oldX;
	CGFloat _deltaX;
	BOOL _pushedClosedHandCursor;
}

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	
	self.on = YES;
	
	self.layer = CALayer.layer;
	self.layer.cornerRadius = 4.f;
	self.layer.masksToBounds = YES;
	self.wantsLayer = YES;
	
	CALayer *underLayer = CALayer.layer;
	underLayer.frame = self.layer.bounds;
	underLayer.backgroundColor = [NSColor colorWithCalibratedRed:0.729 green:0.779 blue:0.811 alpha:1.000].dsp_CGColor;
	[self.layer addSublayer:underLayer];
	
	self.offLayer = CALayer.layer;
	self.offLayer.contents = [NSImage imageNamed:@"SwitchXMark"];
	self.offLayer.frame = (NSRect){ .size = { CGRectGetWidth(frame)/2, CGRectGetHeight(frame) } };
	self.offLayer.opacity = 0.f;
	[self.layer addSublayer:self.offLayer];
	
	self.onLayer = CALayer.layer;
	self.onLayer.contents = [NSImage imageNamed:@"SwitchCheckmark"];
	self.onLayer.frame = (NSRect){ .origin.x = CGRectGetWidth(frame)/2, .size = { CGRectGetWidth(frame)/2, CGRectGetHeight(frame) } };
	[self.layer addSublayer:self.onLayer];
	
	CALayer *topShadowLayer = CALayer.layer;
	topShadowLayer.frame = (NSRect){ .origin.y = CGRectGetHeight(frame) - 2, .size = { (CGRectGetWidth(frame)/2) + 1, 3 } };
	topShadowLayer.backgroundColor = [NSColor colorWithCalibratedRed:0.762 green:0.821 blue:0.849 alpha:1.000].dsp_CGColor;
	[self.switchCover addSublayer:topShadowLayer];
	
	self.switchCover = CALayer.layer;
	self.switchCover.backgroundColor = [NSColor colorWithCalibratedRed:0.730 green:0.793 blue:0.825 alpha:1.000].dsp_CGColor;
	self.switchCover.frame = (NSRect){ .size = { CGRectGetWidth(frame)/2, CGRectGetHeight(frame) } };
	self.switchCover.cornerRadius = 4.f;
	[self.layer addSublayer:self.switchCover];
	
	CALayer *shadowLayer = CALayer.layer;
	shadowLayer.frame = (NSRect){ .size = { CGRectGetWidth(self.switchCover.bounds), 2 } };
	shadowLayer.backgroundColor = [NSColor colorWithCalibratedRed:0.575 green:0.665 blue:0.709 alpha:1.000].dsp_CGColor;
	[self.switchCover addSublayer:shadowLayer];
	
	
	return self;
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

- (void)mouseEntered:(NSEvent *)theEvent {
	if (CGRectContainsPoint(self.switchCover.bounds, [self.switchCover convertPoint:[theEvent locationInWindow] fromLayer:self.superview.layer])) {
		_isTracking = YES;
		_oldX = [self.switchCover convertPoint:[theEvent locationInWindow] fromLayer:self.superview.layer].x;
	}
}

- (void)mouseDown:(NSEvent *)theEvent {
	[super mouseDown:theEvent];
	_hasMoved = NO;
	_deltaX = 0;
	if (CGRectContainsPoint(self.switchCover.bounds, [self.switchCover convertPoint:[theEvent locationInWindow] fromLayer:self.superview.layer])) {
		_isTracking = YES;
		_oldX = [self.switchCover convertPoint:[theEvent locationInWindow] fromLayer:self.superview.layer].x;
	}
}

- (void)mouseDragged:(NSEvent *)theEvent {
	if (_isTracking) {
		if (!_pushedClosedHandCursor) {
			_pushedClosedHandCursor = YES;
			[NSCursor.closedHandCursor push];
		}
		_hasMoved = YES;
		CGRect frame = self.switchCover.frame;
		_deltaX	= _oldX - [self.switchCover convertPoint:[theEvent locationInWindow] fromLayer:self.superview.layer].x;
		CGFloat frameX = frame.origin.x;
		frameX -=  _deltaX;
		if (frameX >= 0 && frameX <= CGRectGetWidth(frame)) {
			frame.origin.x = frameX;
		}
		self.offLayer.opacity = frameX / CGRectGetWidth(frame);
		self.onLayer.opacity = 1 - ((2 * frameX) / CGRectGetWidth(frame));
		self.switchCover.frame = frame;
	}
}

- (void)mouseUp:(NSEvent *)theEvent {
	[super mouseUp:theEvent];
	if (_isTracking && !_hasMoved) {
		[self setOn:!self.on animated:YES];
	} else if (_isTracking && _hasMoved) {
		[self setOn:!(_deltaX <= 0) animated:YES];
	} else if (!_hasMoved) {
		[self setOn:!self.on animated:YES];
	}
	if (_pushedClosedHandCursor) {
		_pushedClosedHandCursor = NO;
		[NSCursor.currentCursor pop];
	}
	_isTracking = NO;
	_hasMoved = NO;
}

- (void)setOn:(BOOL)on {
	[self setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
	if (animated) {
		[NSAnimationContext beginGrouping];
		[CATransaction begin];
		[CATransaction setAnimationDuration:0.3];
		[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
	}

	self.switchCover.frame = (NSRect){ .origin.x = on ? 0 : CGRectGetWidth(self.frame)/2, .size = { CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame) } };
	self.onLayer.opacity = on ? 1.f : 0.f;
	self.offLayer.opacity = on ? 0.f : 1.f;

	if (animated) {
		[CATransaction commit];
		[NSAnimationContext endGrouping];
	}
	
	[self willChangeValueForKey:@"on"];
	_on = on;
	[self didChangeValueForKey:@"on"];
}

- (void)resetCursorRects {
	[self addCursorRect:self.bounds cursor:NSCursor.pointingHandCursor];
}

@end
