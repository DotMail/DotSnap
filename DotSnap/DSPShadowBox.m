//
//  DSPShadowBox.m
//  DotSnap
//
//  Created by Robert Widmann on 8/8/13.
//
//

#import "DSPShadowBox.h"

@implementation DSPShadowBox

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	
	self.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
	self.borderType = NSLineBorder;
	self.borderColor = [NSColor colorWithCalibratedRed:0.361 green:0.787 blue:0.568 alpha:1.000];
	self.fillColor = [NSColor colorWithCalibratedRed:0.361 green:0.787 blue:0.568 alpha:1.000];
	self.borderWidth = 2.f;
	self.boxType = NSBoxCustom;
	
	return self;
}

@end
