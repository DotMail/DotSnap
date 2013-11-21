//
//  DSPPreferencesShadowBox.m
//  DotSnap
//
//  Created by Robert Widmann on 8/14/13.
//
//

#import "DSPPreferencesShadowBox.h"

@implementation DSPPreferencesShadowBox

- (void)drawRect:(NSRect)dirtyRect {
	[[NSColor colorWithCalibratedRed:0.860 green:0.892 blue:0.912 alpha:1.000]drawSwatchInRect:(NSRect){ .origin = { 0, 3 }, .size = { NSWidth(self.bounds), 1 } }];
	[[NSColor colorWithCalibratedRed:0.803 green:0.854 blue:0.878 alpha:1.000]drawSwatchInRect:(NSRect){ .origin = { 0, 2 }, .size = { NSWidth(self.bounds), 1 } }];
	[[NSColor colorWithCalibratedRed:0.762 green:0.826 blue:0.854 alpha:1.000]drawSwatchInRect:(NSRect){ .origin = { 0, 1 }, .size = { NSWidth(self.bounds), 1 } }];
	[[NSColor colorWithCalibratedRed:0.860 green:0.892 blue:0.912 alpha:1.000]drawSwatchInRect:(NSRect){ .origin = { 0, 0 }, .size = { NSWidth(self.bounds), 1 } }];
}

@end
