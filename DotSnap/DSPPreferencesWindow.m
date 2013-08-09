//
//  DSPPreferencesWindow.m
//  DotSnap
//
//  Created by Robert Widmann on 7/28/13.
//
//

#import "DSPPreferencesWindow.h"

@interface DSPPreferencesWindow ()

@end

@implementation DSPPreferencesWindow

- (MAAttachedWindow *)initWithView:(NSView *)view attachedToPoint:(NSPoint)point {
	self = [super initWithView:view attachedToPoint:point];
	
	self.cornerRadius = 0.f;
	self.arrowHeight = 12.f;
	self.borderWidth = 0.f;
	self.borderColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000];
	self.backgroundColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000];
	self.arrowBaseWidth = 20.f;
	
	return self;
}

- (void)orderOutWithDuration:(CFTimeInterval)duration timing:(CAMediaTimingFunction *)timingFunction animations:(void (^)(CALayer *))animations {
	[super orderOutWithDuration:duration timing:timingFunction animations:animations];
}

@end
