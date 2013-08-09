//
//  DSPFilenameTextField.m
//  DotSnap
//
//  Created by Robert Widmann on 8/8/13.
//
//

#import "DSPFilenameTextField.h"
#import "DSPPNGFormatter.h"

@implementation DSPFilenameTextField

- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	
	self.bezeled = NO;
	self.drawsBackground = NO;
	self.font = [NSFont fontWithName:@"HelveticaNeue" size:16.f];
	self.textColor = [NSColor colorWithCalibratedRed:0.437 green:0.517 blue:0.559 alpha:1.000];
	self.focusRingType = NSFocusRingTypeNone;
	self.autoresizingMask = NSViewMinYMargin;
	self.enabled = NO;
	[self.cell setScrollable:YES];
	[self.cell setLineBreakMode:NSLineBreakByClipping];
	[self.cell setFormatter:[DSPPNGFormatter new]];
	
	return self;
}

@end
