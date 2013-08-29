//
//  DSPPreferencesWindow.m
//  DotSnap
//
//  Created by Robert Widmann on 7/28/13.
//
//

#import "DSPPreferencesWindow.h"
#import "DSPMenuBarWindowIconView.h"

@interface DSPPreferencesWindow ()

@end

@implementation DSPPreferencesWindow

- (MAAttachedWindow *)initWithView:(NSView *)view attachedToPoint:(NSPoint)point onSide:(MAWindowPosition)side {
	self = [super initWithView:view attachedToPoint:point onSide:side];
	
	self.arrowHeight = 12.f;
	self.borderColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000];
	self.backgroundColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000];
	
	[NSNotificationCenter.defaultCenter addObserverForName:NSWindowDidResignKeyNotification object:self queue:nil usingBlock:^(NSNotification *note) {
		[self orderOutWithDuration:0.3 timing:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] animations:^(CALayer *layer) {
			layer.transform = CATransform3DMakeTranslation(0.f, -50.f, 0.f);
			layer.opacity = 0.f;
		}];
		self.statusItemView.highlighted = NO;
	}];
	
	return self;
}

@end
