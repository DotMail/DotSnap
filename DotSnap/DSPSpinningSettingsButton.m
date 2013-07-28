//
//  DSPSpinningSettingsButton.m
//  DotSnap
//
//  Created by Robert Widmann on 7/27/13.
//
//

#import "DSPSpinningSettingsButton.h"

@interface DSPSpinningSettingsButton ()
@property (nonatomic, copy) void(^redrawBlock)(BOOL highlighted, BOOL hovering, NSEvent *event);
@end

@implementation DSPSpinningSettingsButton {
	NSTrackingArea *trackingArea;
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
	
	self.layer = CALayer.layer;
	self.wantsLayer = YES;
	
	CALayer *gearLayer = CALayer.layer;
	gearLayer.contents = [NSImage imageNamed:@"Settings_Normal"];
	gearLayer.frame = self.bounds;
	[self.layer addSublayer:gearLayer];
	
	self.autoresizingMask = NSViewMinYMargin;
	self.bordered = NO;
	self.buttonType = NSMomentaryChangeButton;
	
	self.redrawBlock = ^(BOOL highlighted, BOOL hovering, NSEvent *event) {
		if (hovering) {
			gearLayer.contents = [NSImage imageNamed:@"Settings_DarkHover"];
			[CATransaction setDisableActions:YES];
			CABasicAnimation *spinningAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
			spinningAnimation.toValue = @(M_PI);
			spinningAnimation.duration = 0.8;
			spinningAnimation.repeatCount = HUGE_VALF;
			[gearLayer addAnimation:spinningAnimation forKey:nil];
		} else {
			[gearLayer removeAllAnimations];
			gearLayer.contents = [NSImage imageNamed:@"Settings_Normal"];
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
