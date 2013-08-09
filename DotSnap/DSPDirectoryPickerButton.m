//
//  DSPDirectoryPickerButton.m
//  DotSnap
//
//  Created by Robert Widmann on 7/27/13.
//
//

#import "DSPDirectoryPickerButton.h"

@interface DSPDirectoryPickerButton ()
@property (nonatomic, copy) void(^redrawBlock)(BOOL highlighted, BOOL hovering, NSEvent *event);
@end

@implementation DSPDirectoryPickerButton

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	self.layer = CALayer.layer;
	self.wantsLayer = YES;
	
	CALayer *browseCircleLayer = CALayer.layer;
	browseCircleLayer.contents = [NSImage imageNamed:@"BrowseCircle"];
	browseCircleLayer.frame = self.bounds;
	[self.layer addSublayer:browseCircleLayer];
	
	CALayer *arrowLayer = CALayer.layer;
	arrowLayer.contents = [NSImage imageNamed:@"Browse_Arrow"];
	arrowLayer.frame = self.bounds;
	[self.layer addSublayer:arrowLayer];
	
	self.autoresizingMask = NSViewMinYMargin;
	self.bordered = NO;
	self.buttonType = NSMomentaryChangeButton;
	
	self.redrawBlock = ^(BOOL highlighted, BOOL hovering, NSEvent *event) {
		if (hovering) {
			browseCircleLayer.contents = [NSImage imageNamed:@"BrowseCircle_Hover"];
			arrowLayer.contents = [NSImage imageNamed:@"Browse_Arrow_Hover"];
			
			CABasicAnimation *spinningAnimation = [CABasicAnimation animationWithKeyPath:@"transform.x"];
			spinningAnimation.toValue = @170;
			spinningAnimation.duration = 0.5;
		} else {
			browseCircleLayer.contents = [NSImage imageNamed:@"BrowseCircle"];
			arrowLayer.contents = [NSImage imageNamed:@"Browse_Arrow"];
		}
	};
	
	return self;
}

- (void)resetCursorRects {
	[self addCursorRect:self.bounds cursor:NSCursor.pointingHandCursor];
}

- (void)mouseEntered:(NSEvent *)theEvent {
	self.redrawBlock(NO, YES, theEvent);
}

- (void)mouseExited:(NSEvent *)theEvent {
	self.redrawBlock(NO, NO, theEvent);
}

@end
