//
//  DSPGlowingNameButton.m
//  DotSnap
//
//  Created by Robert Widmann on 8/8/13.
//
//

#import "DSPGlowingNameButton.h"

@interface DSPGlowingNameButton ()
@property (nonatomic, copy) void (^redrawBlock)(BOOL highlighted, BOOL hovering, NSEvent *event);
@property (nonatomic, copy) void (^viewDidMoveToWindowBlock)();
@end

@implementation DSPGlowingNameButton {
	NSTrackingArea *trackingArea;
}

- (id)initWithFrame:(NSRect)frameRect name:(NSString *)name {
	self = [super initWithFrame:frameRect];
	
	self.layer = CALayer.layer;
	self.wantsLayer = YES;
	
	CTFontRef font = CTFontCreateWithName(CFSTR("HelveticaNeue"), 18.f, NULL);
	CATextLayer *nameLayer = CATextLayer.layer;
	nameLayer.frame = self.bounds;
	nameLayer.foregroundColor = [NSColor colorWithCalibratedRed:0.136 green:0.407 blue:0.264 alpha:1.000].dsp_CGColor;
	nameLayer.font = font;
	nameLayer.fontSize = 18.f;
	nameLayer.alignmentMode = @"left";
	nameLayer.string = name;
	[self.layer addSublayer:nameLayer];
	
	self.autoresizingMask = NSViewMinYMargin;
	self.bordered = NO;
	self.buttonType = NSMomentaryChangeButton;
	
	self.redrawBlock = ^(BOOL highlighted, BOOL hovering, NSEvent *event) {
		if (hovering) {
			nameLayer.foregroundColor = NSColor.whiteColor.dsp_CGColor;
		} else {
			nameLayer.foregroundColor = [NSColor colorWithCalibratedRed:0.136 green:0.407 blue:0.264 alpha:1.000].dsp_CGColor;

		}
	};
	
	@weakify(self);
	self.viewDidMoveToWindowBlock = ^{
		@strongify(self);
		nameLayer.contentsScale = self.window.backingScaleFactor;
	};
	
	CFRelease(font);
	
	return self;
}

- (void)ensureTrackingArea {
	if (!trackingArea) {
		trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:NSTrackingInVisibleRect | NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
	}
}

- (void)updateTrackingAreas {
	[super updateTrackingAreas];
	[self ensureTrackingArea];
	if (![self.trackingAreas containsObject:trackingArea]) {
		[self addTrackingArea:trackingArea];
	}
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

- (void)viewDidMoveToWindow {
	[super viewDidMoveToWindow];
	self.viewDidMoveToWindowBlock();
}

@end
