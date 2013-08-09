//
//  DSPSpinningSettingsButton.m
//  DotSnap
//
//  Created by Robert Widmann on 7/27/13.
//
//

#import "DSPSpinningSettingsButton.h"

@interface DSPSpinningSettingsButton ()
@property (nonatomic, copy) void (^redrawBlock)(BOOL highlighted, BOOL hovering, NSEvent *event);
@property (nonatomic, copy) void (^spinOutBlock)();
@end

@implementation DSPSpinningSettingsButton {
	NSTrackingArea *trackingArea;
}

- (id)initWithFrame:(NSRect)frameRect style:(DSPSpinningSettingsButtonStyle)style {
	self = [super initWithFrame:frameRect];
	
	self.layer = CALayer.layer;
	self.wantsLayer = YES;
	
	CALayer *gearLayer = CALayer.layer;
	if (style == DSPSpinningSettingsButtonStyleGrey) {
		gearLayer.contents = [NSImage imageNamed:@"Settings_Normal"];
	} else {
		gearLayer.contents = [NSImage imageNamed:@"SettingsWhite"];
	}
	gearLayer.frame = self.bounds;
	[self.layer addSublayer:gearLayer];
	
	self.autoresizingMask = NSViewMinYMargin;
	self.bordered = NO;
	self.buttonType = NSMomentaryChangeButton;
	
	self.redrawBlock = ^(BOOL highlighted, BOOL hovering, NSEvent *event) {
		if (hovering) {
			if (style == DSPSpinningSettingsButtonStyleGrey) {
				gearLayer.contents = [NSImage imageNamed:@"Settings_DarkHover"];
			} else {
				gearLayer.contents = [NSImage imageNamed:@"Settings_Normal"];
			}
			[CATransaction setDisableActions:YES];
			CABasicAnimation *spinningAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
			spinningAnimation.toValue = @(M_PI);
			spinningAnimation.duration = 0.8;
			spinningAnimation.repeatCount = HUGE_VALF;
			[gearLayer addAnimation:spinningAnimation forKey:nil];
		} else {
			[gearLayer removeAllAnimations];
			if (style == DSPSpinningSettingsButtonStyleGrey) {
				gearLayer.contents = [NSImage imageNamed:@"Settings_Normal"];
			} else {
				gearLayer.contents = [NSImage imageNamed:@"SettingsWhite"];
			}
		}
	};
	
	@weakify(self);
	self.spinOutBlock = ^{
		@strongify(self);
		CABasicAnimation *spinningAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
		spinningAnimation.toValue = @(M_PI);
		spinningAnimation.duration = 0.5;
		
		CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		opacityAnimation.toValue = @0;
		opacityAnimation.duration = 0.6;
		spinningAnimation.delegate = self;

		[[self rac_signalForSelector:@selector(animationDidStop:finished:)]subscribeNext:^(id x) {
			gearLayer.contents = [NSImage imageNamed:@"checkmark"];
			double delayInSeconds = 0.5;
			dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
			dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
				if (style == DSPSpinningSettingsButtonStyleGrey) {
					gearLayer.contents = [NSImage imageNamed:@"Settings_Normal"];
				} else {
					gearLayer.contents = [NSImage imageNamed:@"SettingsWhite"];
				}
			});
		}];
		[gearLayer addAnimation:spinningAnimation forKey:nil];
		[gearLayer addAnimation:opacityAnimation forKey:nil];
	};
	
	return self;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	
}

- (void)resetCursorRects {
	[self addCursorRect:self.bounds cursor:NSCursor.pointingHandCursor];
}

- (void)spinOut {
	self.spinOutBlock();
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

@end
