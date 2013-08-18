//
//  DSPLogoButton.m
//  DotSnap
//
//  Created by Robert Widmann on 8/18/13.
//
//

#import "DSPLogoButton.h"

@implementation DSPLogoButton

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	
	self.layer = CALayer.layer;
	self.wantsLayer = YES;
	
	self.bordered = NO;
	self.buttonType = NSMomentaryChangeButton;
	
	CALayer *logoLayer = CALayer.layer;
	logoLayer.contents = [NSImage imageNamed:@"PreferencesLogo"];
	logoLayer.frame = self.bounds;
	[self.layer addSublayer:logoLayer];
	
	self.rac_command = RACCommand.command;
	
	return self;
}

- (void)resetCursorRects {
	[self addCursorRect:self.bounds cursor:NSCursor.pointingHandCursor];
}

@end
