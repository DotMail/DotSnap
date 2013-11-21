//
//  LIFlipEffect.m
//  WindowEffects
//
//  Created by Mark Onyschuk on 17/07/09.
//  Copyright 2009 Lorem & Ipsum. All rights reserved.
//

#import "LIFlipEffect.h"
#import <QuartzCore/QuartzCore.h>

@implementation LIFlipEffect

- (id)initFromWindow:(NSWindow *)w1 toWindow:(NSWindow *)w2 {
	CGFloat maxWidth = MAX(NSWidth(w1.frame), NSWidth(w2.frame));
	CGFloat maxHeight = MAX(NSHeight(w1.frame), NSHeight(w2.frame));
	
	// add some slop for our rotation
	maxWidth += 2;
	maxHeight += 200;
	
	NSRect animationFrame;
	animationFrame.origin.x = NSMidX(w1.frame) - (maxWidth / 2);
	animationFrame.origin.y = NSMidY(w1.frame) - (maxHeight / 2);
	animationFrame.size.width = maxWidth;
	animationFrame.size.height = maxHeight;

	if ((self = [super initWithAnimationWindowFrame:animationFrame])) {
		fromWindow = [w1 retain];
		toWindow = [w2 retain];
		
		// fix window positions so that toWindow is positioned similarly to fromWindow
		
		NSRect fromFrame = fromWindow.frame;
		NSRect toFrame = toWindow.frame;
		
		toFrame.origin.x = NSMidX(fromFrame) - (NSWidth(toFrame) / 2);
		toFrame.origin.y = NSMaxY(fromFrame) - NSHeight(toFrame);
		
		[toWindow setFrame:toFrame display:NO];
	}
	return self;
}

- (id)initFromWindow:(NSWindow *)w1 toWindow:(NSWindow *)w2 flag:(BOOL)flag {
	CGFloat maxWidth = MAX(NSWidth(w1.frame), NSWidth(w2.frame));
	CGFloat maxHeight = MAX(NSHeight(w1.frame), NSHeight(w2.frame));
	
	// add some slop for our rotation
	maxWidth += 2;
	maxHeight += 200;
	
	NSRect animationFrame;
	animationFrame.origin.x = NSMidX(w1.frame) - (maxWidth / 2);
	animationFrame.origin.y = NSMidY(w1.frame) - (maxHeight / 2) + (flag ? -100 : -200);
	animationFrame.size.width = maxWidth;
	animationFrame.size.height = maxHeight;
	
	if ((self = [super initWithAnimationWindowFrame:animationFrame])) {
		fromWindow = [w1 retain];
		toWindow = [w2 retain];
		
		// fix window positions so that toWindow is positioned similarly to fromWindow
		
		NSRect fromFrame = fromWindow.frame;
		NSRect toFrame = toWindow.frame;
		
		toFrame.origin.x = NSMidX(fromFrame) - (NSWidth(toFrame) / 2);
		toFrame.origin.y = NSMaxY(fromFrame) - NSHeight(toFrame);
		
		[toWindow setFrame:toFrame display:flag];
	}
	return self;
}

#pragma mark -
#pragma mark Properties
@synthesize fromWindow, toWindow;

#pragma mark -
#pragma mark Actions

#define PI 3.14159

- (void)run {
	NSView *fromView, *toView;
	fromView = [fromWindow.contentView superview];
	toView = [toWindow.contentView superview];
	
	fromImage = [fromView.imageRep retain];

	[toWindow setAlphaValue:0.0];
	[toWindow makeKeyAndOrderFront:self];

	toImage = [toView.imageRep retain];

	CATransform3D fromStart = CATransform3DMakeRotation(0, 0, 1, 0);
	CATransform3D fromEnd = CATransform3DMakeRotation(PI, 0, 1, 0);

	CATransform3D toStart = CATransform3DMakeRotation(PI, 0, 1, 0);
	CATransform3D toEnd = CATransform3DMakeRotation(PI * 2, 0, 1, 0);

	CALayer *fromLayer = [CALayer layer];
	fromLayer.contents = (id)fromImage.CGImage;
	fromLayer.frame = NSRectToCGRect(LIRectFromViewToView(fromView.frame, fromView, self.animationView));
	fromLayer.transform = fromStart;
	fromLayer.doubleSided = NO;

	[self.animationLayer addSublayer:fromLayer];
	
	CALayer *toLayer = [CALayer layer];
	toLayer.contents = (id)toImage.CGImage;
	toLayer.frame = NSRectToCGRect(LIRectFromViewToView(toView.frame, toView, self.animationView));
	toLayer.transform = toStart;
	toLayer.doubleSided = NO;
	
	[self.animationLayer addSublayer:toLayer];

	[super run];
	
	[fromWindow orderOut:self];
	
	CABasicAnimation *fromAnimation = [[CABasicAnimation animationWithKeyPath:@"transform"]retain];
	fromAnimation.duration = 0.35;
	fromAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	fromAnimation.toValue = [NSValue valueWithBytes:&fromEnd objCType:@encode(CATransform3D)];
	
	fromAnimation.fillMode = kCAFillModeForwards;
	fromAnimation.removedOnCompletion = NO;
	
	CABasicAnimation *toAnimation = [[CABasicAnimation animationWithKeyPath:@"transform"]retain];
	toAnimation.duration = 0.35;
	toAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	toAnimation.toValue = [NSValue valueWithBytes:&toEnd objCType:@encode(CATransform3D)];

	toAnimation.fillMode = kCAFillModeForwards;
	toAnimation.removedOnCompletion = NO;

	toAnimation.delegate = self;
	
	[CATransaction begin];
	[fromLayer addAnimation:fromAnimation forKey:@"flip"];
	[toLayer addAnimation:toAnimation forKey:@"flip"];
	[CATransaction commit];
	
	done = 0;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	if (flag) {
		[toWindow setAlphaValue:1.0];
		[self.animationWindow orderOut:self];
		
		[self release];
	}
}

#pragma mark -
#pragma mark Cleanup
- (void)dealloc {
	[fromWindow release], fromWindow = nil;
	[toWindow release], toWindow = nil;

	[fromImage release], fromImage = nil;
	[toImage release], toImage = nil;
	
	[super dealloc];
}

@end
