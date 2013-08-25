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
@property (nonatomic, copy) void (^viewDidMoveToWindowBlock)();
@end

@implementation DSPDirectoryPickerButton

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	self.layer = CALayer.layer;
	self.layer.masksToBounds = YES;
	self.wantsLayer = YES;
	
	CALayer *browseCircleLayer = CALayer.layer;
	browseCircleLayer.contents = [NSImage imageNamed:@"BrowseCircle"];
	browseCircleLayer.frame = self.bounds;
	[self.layer addSublayer:browseCircleLayer];
	
	CALayer *arrowLayer = CALayer.layer;
	arrowLayer.contents = [NSImage imageNamed:@"Browse_Arrow"];
	arrowLayer.frame = self.bounds;
	[self.layer addSublayer:arrowLayer];
	
	CALayer *hoverArrowLayer = CALayer.layer;
	hoverArrowLayer.contents = [NSImage imageNamed:@"Browse_Arrow_Hover"];
	hoverArrowLayer.frame = self.bounds;
	hoverArrowLayer.frame = CGRectOffset(hoverArrowLayer.frame, -(NSWidth(browseCircleLayer.frame)/2) - 10, 0);
	[self.layer addSublayer:hoverArrowLayer];
	
	self.autoresizingMask = NSViewMinYMargin;
	self.bordered = NO;
	self.buttonType = NSMomentaryChangeButton;
	
	@weakify(self);
	self.redrawBlock = ^(BOOL highlighted, BOOL hovering, NSEvent *event) {
		@strongify(self);
		if (hovering) {
			browseCircleLayer.contents = [NSImage imageNamed:@"BrowseCircle_Hover"];
			arrowLayer.contents = [NSImage imageNamed:@"Browse_Arrow_Hover"];
			arrowLayer.frame = CGRectOffset(arrowLayer.frame, NSWidth(browseCircleLayer.frame)/2 + 10, 0);
			hoverArrowLayer.frame = self.bounds;
		} else {
			browseCircleLayer.contents = [NSImage imageNamed:@"BrowseCircle"];
			arrowLayer.contents = [NSImage imageNamed:@"Browse_Arrow"];
			arrowLayer.frame = self.bounds;
			hoverArrowLayer.frame = CGRectOffset(hoverArrowLayer.frame, -(NSWidth(browseCircleLayer.frame)/2) - 10, 0);

		}
	};
	
	self.viewDidMoveToWindowBlock = ^{
		@strongify(self);
		CGFloat scaleFactor = self.window.backingScaleFactor;
		browseCircleLayer.contentsScale = scaleFactor;
		arrowLayer.contentsScale = scaleFactor;
		hoverArrowLayer.contentsScale = scaleFactor;
	};
	
	return self;
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
