//
//  LIEffect.m
//  WindowEffects
//
//  Created by Mark Onyschuk on 17/07/09.
//  Copyright 2009 Lorem & Ipsum. All rights reserved.
//

#import "LIEffect.h"

#import <QuartzCore/QuartzCore.h>

@implementation LIEffect

#pragma mark -
#pragma mark Setup
- (id)initWithAnimationWindowFrame:(NSRect)aFrame {
	if ((self = [super init])) {
		animationWindow =  [[NSWindow alloc] initWithContentRect:aFrame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
		
		[animationWindow setOpaque:NO];
		[animationWindow setHasShadow:NO];
		[animationWindow setBackgroundColor:[NSColor clearColor]];
		
		[animationWindow.contentView setWantsLayer:YES];
		
		CATransform3D transform = CATransform3DIdentity;  
		transform.m34 = 1.0 / -850; 
		
		[CATransaction begin];
		CALayer *layer = [animationWindow.contentView layer];	
		layer.sublayerTransform = transform;
		[CATransaction commit];
	}
	
	return self;
}

#pragma mark -
#pragma mark Properties
- (NSWindow *)animationWindow {
	return animationWindow;
}
- (NSView *)animationView {
	return [animationWindow contentView];
}
- (CALayer *)animationLayer {
	return [animationWindow.contentView layer];
}

#pragma mark -
#pragma mark Actions
- (void)run {
	[animationWindow orderFront:self];
}

#pragma mark -
#pragma mark Cleanup
- (void)dealloc {
	[animationWindow release], animationWindow = nil;
	[super dealloc];
}

@end

@implementation NSView (LIEffects)
- (NSBitmapImageRep *)imageRep {
	BOOL visible = self.window.isVisible;
	NSRect oldFrame = self.window.frame;
	
	if (! visible) {		
		NSDisableScreenUpdates();
		[self.window setFrame:NSOffsetRect(oldFrame, -10000, -10000) display:NO];
		[self.window orderFront:self];
	}
	
	NSBitmapImageRep *rep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
	[self cacheDisplayInRect:self.bounds toBitmapImageRep:rep];
	
	if (! visible) {
		[self.window orderOut:self];
		[self.window setFrame:oldFrame display:NO];
		NSEnableScreenUpdates();
	}
	
	return rep;
}
@end

NSRect LIRectToScreen(NSRect aRect, NSView *aView) {
	aRect = [aView convertRect:aRect toView:nil];
	aRect.origin = [aView.window convertBaseToScreen:aRect.origin];
	return aRect;
}
NSRect LIRectFromScreen(NSRect aRect, NSView *aView) {
	aRect.origin = [aView.window convertScreenToBase:aRect.origin];
	aRect = [aView convertRect:aRect fromView:nil];
	return aRect;
}

NSRect LIRectFromViewToView(NSRect aRect, NSView *fromView, NSView *toView) {
	aRect = LIRectToScreen(aRect, fromView);
	aRect = LIRectFromScreen(aRect, toView);
	
	return aRect;
}

