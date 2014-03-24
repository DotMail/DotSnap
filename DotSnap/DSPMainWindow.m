//
//  DSPMainWindow.m
//  DotSnap
//
//  Created by Robert Widmann on 7/24/13.
//
//

#import "DSPMainWindow.h"
#import "DSPMenuBarWindowIconView.h"
#import <objc/runtime.h>

//static CGFloat const DPSMenuBarWindowTitleBarHeight = 0.0;
//static CGFloat const DPSMenuBarWindowArrowHeight = 10.0;
//static CGFloat const DPSMenuBarWindowArrowWidth = 20.0;

@implementation DSPMainWindow {
	BOOL _resized;
}

#pragma mark - Lifecycle

- (instancetype)initWithView:(NSView *)view attachedToPoint:(NSPoint)point inWindow:(NSWindow *)window onSide:(MAWindowPosition)side atDistance:(float)distance mainWindow:(BOOL)flag {
	self = [super initWithView:view attachedToPoint:point inWindow:window onSide:side atDistance:distance];

	if (flag) {
		_statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
		CGFloat thickness = [[NSStatusBar systemStatusBar] thickness];
		_statusItemView = [[DSPMenuBarWindowIconView alloc] initWithFrame:NSMakeRect(0, 0, (self.menuBarIcon ? self.menuBarIcon.size.width : thickness) + 6, thickness)];
		_statusItemView.menuBarWindow = self;
		_statusItem.view = _statusItemView;
		[NSNotificationCenter.defaultCenter addObserverForName:NSWindowDidMoveNotification object:_statusItem.view.window queue:nil usingBlock:^(NSNotification *note) {
			self.frameOrigin = self.originForAttachedState;
		}];
		[NSNotificationCenter.defaultCenter addObserverForName:NSWindowDidResignKeyNotification object:self queue:nil usingBlock:^(NSNotification *note) {
			if (!_isInOpenPanel && !_isFlipping) {
				[self orderOutWithDuration:0.3 timing:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] animations:^(CALayer *layer) {
					layer.transform = CATransform3DMakeTranslation(0.f, -50.f, 0.f);
					layer.opacity = 0.f;
				}];
				_statusItemView.highlighted = NO;
			}
		}];
	}

	return self;
}

- (NSPoint)originForAttachedState {
	if (_statusItemView) {
		NSRect statusItemFrame = _statusItemView.window.frame;
		NSPoint midPoint = (NSPoint){ NSMidX(statusItemFrame), NSMinY(statusItemFrame) };
		return (NSPoint){ midPoint.x - (NSWidth(self.frame) / 2) + 1, midPoint.y - NSHeight(self.frame) + ((_resized) ? -2 : 10) };
	}
	return NSZeroPoint;
}

- (NSPoint)originForNewFrame:(NSRect)rect {
	if (_statusItemView) {
		NSRect statusItemFrame = _statusItemView.window.frame;
		NSPoint midPoint = (NSPoint){ NSMidX(statusItemFrame), NSMinY(statusItemFrame) };
		return (NSPoint){ midPoint.x - (NSWidth(rect) / 2) + 1, midPoint.y - NSHeight(rect) - 2 };
	}
	return NSZeroPoint;
}

- (void)makeKeyAndOrderFrontWithDuration:(CFTimeInterval)duration timing:(CAMediaTimingFunction *)timingFunction setup:(void (^)(CALayer *))setup animations:(void (^)(CALayer *))animations {
	[self setFrameOrigin:[self originForAttachedState]];
	[super makeKeyAndOrderFrontWithDuration:duration timing:timingFunction setup:setup animations:animations];
}

- (void)setFrame:(NSRect)frameRect display:(BOOL)displayFlag animate:(BOOL)animateFlag {
	if (!_resized && animateFlag) {
		_resized = YES;
	}
	[super setFrame:frameRect display:displayFlag animate:animateFlag];
	[self setFrameOrigin:[self originForAttachedState]];
}

#pragma mark - Active/key events

- (BOOL)canBecomeKeyWindow {
	return YES;
}

- (BOOL)canBecomeMainWindow {
	return YES;
}

- (void)setMenuBarIcon:(NSImage *)image {
	_menuBarIcon = image;
	if (_statusItemView) {
		[_statusItemView setFrameSize:NSMakeSize(image.size.width + 6, _statusItemView.frame.size.height)];
		[_statusItemView setNeedsDisplay:YES];
	}
}

- (void)setHighlightedMenuBarIcon:(NSImage *)image {
	_highlightedMenuBarIcon = image;
	if (_statusItemView)
	{
		[_statusItemView setNeedsDisplay:YES];
	}
}

@end
