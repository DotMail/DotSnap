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

@implementation DSPDirectoryPickerButton {
	NSTrackingArea *trackingArea;
}

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
			browseCircleLayer.contents = [NSImage imageNamed:@"BrowseCircle_hover"];
			arrowLayer.contents = [NSImage imageNamed:@"Browse_Arrow_Hover"];
		} else {
			browseCircleLayer.contents = [NSImage imageNamed:@"BrowseCircle"];
			arrowLayer.contents = [NSImage imageNamed:@"Browse_Arrow"];
		}
	};
	
    return self;
}


- (void)ensureTrackingArea {
    if (trackingArea == nil) {
        trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:NSTrackingInVisibleRect | NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    }
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    [self ensureTrackingArea];
    if (![[self trackingAreas] containsObject:trackingArea]) {
        [self addTrackingArea:trackingArea];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
	self.redrawBlock(NO, YES, theEvent);
}

- (void)mouseExited:(NSEvent *)theEvent {
	self.redrawBlock(NO, NO, theEvent);
}

- (void)mouseDown:(NSEvent *)theEvent {
	
}

@end
