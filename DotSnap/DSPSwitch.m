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
	BOOL _isTracking;
	BOOL _hasMoved;
	CGFloat _oldX;
	CGFloat _deltaX;
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
	
	self.on = YES;
	
	self.layer = CALayer.layer;
	self.layer.cornerRadius = 4.f;
	self.layer.masksToBounds = YES;
	self.wantsLayer = YES;
	
	self.offLayer = CALayer.layer;
	self.offLayer.backgroundColor = [NSColor colorWithCalibratedRed:0.788 green:0.253 blue:0.258 alpha:1.000].CGColor;
	self.offLayer.frame = (NSRect){ .size = { CGRectGetWidth(frame)/2, CGRectGetHeight(frame) } };
	self.offLayer.cornerRadius = 4.f;
	self.offLayer.opacity = 0.f;
	[self.layer addSublayer:self.offLayer];
	
	CALayer *xLayer = CALayer.layer;
	xLayer.contents = [NSImage imageNamed:@"SwitchXmark"];
	xLayer.frame = (NSRect){ .origin = { 14, 9 }, .size = { 13, 13 } };
	[self.offLayer addSublayer:xLayer];
	
	self.onLayer = CALayer.layer;
	self.onLayer.backgroundColor = [NSColor colorWithCalibratedRed:0.532 green:0.753 blue:0.647 alpha:1.000].CGColor;
	self.onLayer.frame = (NSRect){ .origin.x = CGRectGetWidth(frame)/2, .size = { CGRectGetWidth(frame)/2, CGRectGetHeight(frame) } };
	self.onLayer.cornerRadius = 4.f;
	[self.layer addSublayer:self.onLayer];
	
	CALayer *checkLayer = CALayer.layer;
	checkLayer.contents = [NSImage imageNamed:@"SwitchCheckmark"];
	checkLayer.frame = (NSRect){ .origin = { 13, 9 }, .size = { 12, 13 } };
	[self.onLayer addSublayer:checkLayer];
	
	self.switchCover = CALayer.layer;
	self.switchCover.backgroundColor = [NSColor colorWithCalibratedRed:0.730 green:0.793 blue:0.825 alpha:1.000].CGColor;
	self.switchCover.frame = (NSRect){ .size = { CGRectGetWidth(frame)/2, CGRectGetHeight(frame) } };
	self.switchCover.cornerRadius = 4.f;
	[self.layer addSublayer:self.switchCover];
	
	CALayer *shadowLayer = CALayer.layer;
	shadowLayer.frame = (NSRect){ .size = { CGRectGetWidth(frame), 2 } };
	shadowLayer.backgroundColor = [NSColor colorWithCalibratedRed:0.575 green:0.665 blue:0.709 alpha:1.000].CGColor;
	[self.layer addSublayer:shadowLayer];
	
	CALayer *topShadowLayer = CALayer.layer;
	topShadowLayer.frame = (NSRect){ .origin.y = CGRectGetHeight(frame) - 2, .size = { (CGRectGetWidth(frame)/2) + 1, 3 } };
	topShadowLayer.backgroundColor = [NSColor colorWithCalibratedRed:0.762 green:0.821 blue:0.849 alpha:1.000].CGColor;
	[self.switchCover addSublayer:topShadowLayer];
	
    return self;
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
		_hasMoved = YES;
		CGRect frame = self.switchCover.frame;
		_deltaX	= _oldX - [self.switchCover convertPoint:[theEvent locationInWindow] fromLayer:self.superview.layer].x;
		CGFloat frameX = frame.origin.x;
		frameX -=  _deltaX;
		if (frameX >= 0 && frameX <= CGRectGetWidth(frame)) {
			frame.origin.x = frameX;
		}
		self.offLayer.opacity = frameX / CGRectGetWidth(frame);
		self.onLayer.opacity = 1 - (frameX / CGRectGetWidth(frame));
		self.switchCover.frame = frame;
	}
}

- (void)mouseUp:(NSEvent *)theEvent {
	[super mouseUp:theEvent];
	if (_isTracking && !_hasMoved) {
		[self setOn:!self.on animated:YES];
	} else if (_isTracking && _hasMoved) {
		[self setOn:!(_deltaX <= 0) animated:YES];
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

@end
