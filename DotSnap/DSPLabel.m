//
//  DSPLabel.m
//  DotSnap
//
//  Created by Robert Widmann on 8/8/13.
//
//

#import "DSPLabel.h"

@implementation DSPLabel

- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	
	self.bezeled = NO;
	self.editable = NO;
	self.drawsBackground = NO;
	self.font = [NSFont fontWithName:@"HelveticaNeue" size:30.f];
	self.textColor = NSColor.whiteColor;
	self.focusRingType = NSFocusRingTypeNone;
	
	return self;
}

@end
