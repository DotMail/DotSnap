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
	self.menuBarIcon = [NSImage imageNamed:@"dotsnapp_appicon_normal"];
    self.highlightedMenuBarIcon = [NSImage imageNamed:@"dotsnapp_appicon_white_active"];
    self.hasMenuBarIcon = YES;
	self.acceptsMouseMovedEvents = YES;
	
	return self;
}

@end
