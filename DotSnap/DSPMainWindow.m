//
//  DSPMainWindow.m
//  DotSnap
//
//  Created by Robert Widmann on 7/24/13.
//
//

#import "DSPMainWindow.h"
#import <objc/runtime.h>

static CGFloat const DPSMenuBarWindowTitleBarHeight = 0.0;
static CGFloat const DPSMenuBarWindowArrowHeight = 10.0;
static CGFloat const DPSMenuBarWindowArrowWidth = 20.0;

@implementation DSPMainWindow {
	DPSMenuBarWindowIconView *statusItemView;
}

- (MAAttachedWindow *)initWithView:(NSView *)view attachedToPoint:(NSPoint)point inWindow:(NSWindow *)window onSide:(MAWindowPosition)side atDistance:(float)distance {
    self = [super initWithView:view attachedToPoint:point inWindow:window onSide:side atDistance:distance];

	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(windowDidResignKey:)
                   name:NSWindowDidResignKeyNotification
                 object:self];

	return self;
}

- (void)setHasMenuBarIcon:(BOOL)flag
{
    if (_hasMenuBarIcon != flag)
    {
        _hasMenuBarIcon = flag;
        if (flag)
        {
            // Create the status item
            _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
            CGFloat thickness = [[NSStatusBar systemStatusBar] thickness];
            statusItemView = [[DPSMenuBarWindowIconView alloc] initWithFrame:NSMakeRect(0, 0, (self.menuBarIcon ? self.menuBarIcon.size.width : thickness) + 6, thickness)];
            statusItemView.menuBarWindow = self;
            _statusItem.view = statusItemView;
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusItemViewDidMove:) name:NSWindowDidMoveNotification object:statusItem.view.window];
        }
        else
        {
            if (statusItemView)
            {
                [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidMoveNotification object:statusItemView];
            }
            self.attachedToMenuBar = NO;
        }
    }
}


- (NSPoint)originForAttachedState
{
    if (statusItemView)
    {
        NSRect statusItemFrame = [[statusItemView window] frame];
        NSPoint midPoint = NSMakePoint(NSMidX(statusItemFrame),
                                       NSMinY(statusItemFrame));
        return NSMakePoint(midPoint.x - (self.frame.size.width / 2),
                           midPoint.y - self.frame.size.height);
    }
    else
    {
        return NSZeroPoint;
    }
}

- (void)makeKeyAndOrderFrontWithDuration:(CFTimeInterval)duration timing:(CAMediaTimingFunction *)timingFunction setup:(void (^)(CALayer *))setup animations:(void (^)(CALayer *))animations
{
    if (self.attachedToMenuBar)
    {
        [self setFrameOrigin:[self originForAttachedState]];
    }
	[super makeKeyAndOrderFrontWithDuration:duration timing:timingFunction setup:setup animations:animations];
}


#pragma mark - Active/key events

- (BOOL)canBecomeKeyWindow
{
    return YES;
}

- (void)windowDidResignKey:(NSNotification *)aNotification
{
    if (self.attachedToMenuBar && !_isInOpenPanel)
    {
		[self orderOutWithDuration:0.3 timing:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] animations:^(CALayer *layer) {
			// We can now basically whatever we want with this layer. Everything is already wrapped in a CATransaction so it is animated implicitly.
			// To change the duration and other properties, just modify the current context. It will apply to the animation.
			layer.transform = CATransform3DMakeTranslation(0.f, -50.f, 0.f);
			layer.opacity = 0.f;
		}];
    }
}


- (void)setMenuBarIcon:(NSImage *)image
{
    _menuBarIcon = image;
    if (statusItemView)
    {
        [statusItemView setFrameSize:NSMakeSize(image.size.width + 6, statusItemView.frame.size.height)];
        [statusItemView setNeedsDisplay:YES];
    }
}

- (void)setHighlightedMenuBarIcon:(NSImage *)image
{
    _highlightedMenuBarIcon = image;
    if (statusItemView)
    {
        [statusItemView setNeedsDisplay:YES];
    }
}

@end

@implementation DPSMenuBarWindowIconView

@synthesize menuBarWindow;
@synthesize highlighted;

#pragma mark - Highlighting

- (void)setHighlighted:(BOOL)flag
{
    highlighted = flag;
    [self setNeedsDisplay:YES];
}

#pragma mark - Mouse events

- (void)mouseDown:(NSEvent *)theEvent
{
    self.highlighted = YES;
    if ([self.menuBarWindow isMainWindow] || (self.menuBarWindow.isVisible && self.menuBarWindow.attachedToMenuBar))
    {
		[self.menuBarWindow orderOutWithDuration:0.3 timing:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] animations:^(CALayer *layer) {
			// We can now basically whatever we want with this layer. Everything is already wrapped in a CATransaction so it is animated implicitly.
			// To change the duration and other properties, just modify the current context. It will apply to the animation.
			layer.transform = CATransform3DMakeTranslation(0.f, -50.f, 0.f);
			layer.opacity = 0.f;
		}];
    }
    else
    {
        [NSApp activateIgnoringOtherApps:YES];
		[self.menuBarWindow makeKeyAndOrderFrontWithDuration:0.3 timing:nil setup:^(CALayer *layer) {
			// Anything done in this setup block is performed without any animation.
			// The layer will not be visible during this time so now is our chance to set initial
			// values for opacity, transform, etc.
			layer.transform = CATransform3DMakeTranslation(0.f, -50., 0.f);
			layer.opacity = 0.f;
		} animations:^(CALayer *layer) {
			
			// Now we're actually animating. In order to make the transition as seamless as possible,
			// we want to set the final values to their original states, so that when the fake window
			// is removed there will be no discernible jump to that state.
			//
			// To change the default timing and duration, just wrap the animations in an NSAnimationContext.
			layer.transform = CATransform3DIdentity;
			layer.opacity = 1.f;
		}];
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    self.highlighted = NO;
}

#pragma mark - Drawing

- (void)drawRect:(NSRect)dirtyRect
{
    if (self.highlighted)
    {
        [[NSColor selectedMenuItemColor] set];
        NSRectFill([self bounds]);
    }
    if (self.menuBarWindow && self.menuBarWindow.menuBarIcon)
    {
        NSRect rect = NSMakeRect([self bounds].origin.x + 3,
                                 [self bounds].origin.y,
                                 [self bounds].size.width - 6,
                                 [self bounds].size.height);
        
        if (self.highlighted && self.menuBarWindow.highlightedMenuBarIcon)
        {
            [self.menuBarWindow.highlightedMenuBarIcon drawInRect:rect
                                                         fromRect:NSZeroRect
                                                        operation:NSCompositeSourceOver
                                                         fraction:1.0];
        }
        else
        {
            [self.menuBarWindow.menuBarIcon drawInRect:rect
                                              fromRect:NSZeroRect
                                             operation:NSCompositeSourceOver
                                              fraction:1.0];
        }
    }
}

@end
