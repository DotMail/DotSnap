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

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
	
	_snapDistance = 30.0;
	_hideWindowControlsWhenAttached = YES;
	_isDetachable = YES;

	// Set up the window drawing
	[self setBackgroundColor:[NSColor clearColor]];
	[self setOpaque:YES];
	[self setMovable:NO];

	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(windowDidBecomeKey:)
                   name:NSWindowDidBecomeKeyNotification
                 object:self];
    [center addObserver:self
               selector:@selector(windowDidResignKey:)
                   name:NSWindowDidResignKeyNotification
                 object:self];
    [center addObserver:self
               selector:@selector(applicationDidChangeActiveStatus:)
                   name:NSApplicationDidBecomeActiveNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(applicationDidChangeActiveStatus:)
                   name:NSApplicationDidResignActiveNotification
                 object:nil];

	// Get window's frame view class
	id class = [[[self contentView] superview] class];
	
	// Add the new drawRect: to the frame class
	Method m0 = class_getInstanceMethod([self class], @selector(drawRect:));
	class_addMethod(class, @selector(drawRectOriginal:), method_getImplementation(m0), method_getTypeEncoding(m0));
	
	// Exchange methods
	Method m1 = class_getInstanceMethod(class, @selector(drawRect:));
	Method m2 = class_getInstanceMethod(class, @selector(drawRectOriginal:));
	method_exchangeImplementations(m1, m2);

	self.layer.doubleSided = YES;
	
	return self;
}

- (void)layoutContent {
    [[self.contentView superview] viewWillStartLiveResize];
    [[self.contentView superview] viewDidEndLiveResize];
    
    
    // Position the content view
    NSRect contentViewFrame = [self.contentView frame];
    CGFloat currentTopMargin = NSHeight(self.frame) - NSHeight(contentViewFrame);
    CGFloat titleBarHeight = DPSMenuBarWindowTitleBarHeight + (self.attachedToMenuBar ? DPSMenuBarWindowArrowHeight : 0) + 1;
    CGFloat delta = titleBarHeight - currentTopMargin;
    contentViewFrame.size.height -= delta;
    [self.contentView setFrame:contentViewFrame];
    
    // Redraw the theme frame
    [[self.contentView superview] setNeedsDisplayInRect:[self titleBarRect]];
}

- (NSRect)titleBarRect
{
    return NSMakeRect(0,
                      self.frame.size.height - DPSMenuBarWindowTitleBarHeight - (self.attachedToMenuBar ? DPSMenuBarWindowArrowHeight : 0),
                      self.frame.size.width,
                      DPSMenuBarWindowTitleBarHeight + (self.attachedToMenuBar ? DPSMenuBarWindowArrowHeight : 0));
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

- (void)setAttachedToMenuBar:(BOOL)isAttached
{
    if (isAttached != _attachedToMenuBar)
    {
        _attachedToMenuBar = isAttached;
        
        if (isAttached)
        {
            NSRect newFrame = self.frame;
            newFrame.size.height += DPSMenuBarWindowArrowHeight;
            newFrame.origin.y -= DPSMenuBarWindowArrowHeight;
            [self setFrame:newFrame display:YES];
        }
        else
        {
            NSRect newFrame = self.frame;
            newFrame.size.height -= DPSMenuBarWindowArrowHeight;
            newFrame.origin.y += DPSMenuBarWindowArrowHeight;
            [self setFrame:newFrame display:YES];
        }
        
        // Set whether the window is opaque (this affects the shadow)
        [self setOpaque:!isAttached];
        
        // Reposition the content
        [self layoutContent];
        
        // Animate the window controls
        NSButton *closeButton = [self standardWindowButton:NSWindowCloseButton];
        NSButton *minimiseButton = [self standardWindowButton:NSWindowMiniaturizeButton];
        NSButton *zoomButton = [self standardWindowButton:NSWindowZoomButton];
        if (isAttached)
        {
            if (self.hideWindowControlsWhenAttached)
            {
                [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                    [context setDuration:0.15];
                    [[closeButton animator] setAlphaValue:0.0];
                    [[minimiseButton animator] setAlphaValue:0.0];
                    [[zoomButton animator] setAlphaValue:0.0];
                } completionHandler:^{
                }];
            }
        }
               
        [self setLevel:(isAttached ? NSPopUpMenuWindowLevel : NSNormalWindowLevel)];
        if (self.delegate != nil)
        {
            if (isAttached && [self.delegate respondsToSelector:@selector(windowDidAttachToStatusBar:)])
            {
                [self.delegate performSelector:@selector(windowDidAttachToStatusBar:)
                                    withObject:self];
            }
            else if (!isAttached && [self.delegate respondsToSelector:@selector(windowDidDetachFromStatusBar:)])
            {
                [self.delegate performSelector:@selector(windowDidDetachFromStatusBar:)
                                    withObject:self];
            }
        }
        [self layoutContent];
        [[self.contentView superview] setNeedsDisplay:YES];
        [self invalidateShadow];
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

- (void)applicationDidChangeActiveStatus:(NSNotification *)aNotification
{
    [[self.contentView superview] setNeedsDisplayInRect:[self titleBarRect]];
}

- (void)windowDidBecomeKey:(NSNotification *)aNotification
{
    [[self.contentView superview] setNeedsDisplayInRect:[self titleBarRect]];
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
    [[self.contentView superview] setNeedsDisplayInRect:[self titleBarRect]];
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


- (void)drawRectOriginal:(NSRect)dirtyRect
{
    // Do nothing
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (![self respondsToSelector:@selector(window)] || ![self isKindOfClass:[DSPMainWindow class]])
    {
        [self drawRectOriginal:dirtyRect];
        return;
    }
    
    DSPMainWindow *window = (DSPMainWindow *)self;
    NSRect bounds = [window.contentView superview].bounds;
    CGFloat originX = bounds.origin.x;
    CGFloat originY = bounds.origin.y;
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
    CGFloat arrowHeight = DPSMenuBarWindowArrowHeight;
    CGFloat arrowWidth = DPSMenuBarWindowArrowWidth;
    CGFloat cornerRadius = 4.0;
    
    BOOL isAttached = window.attachedToMenuBar;
    
    // Draw the window background
    [[NSColor windowBackgroundColor] set];
    NSRectFill(dirtyRect);
    
    // Erase the default title bar
    CGFloat titleBarHeight = DPSMenuBarWindowTitleBarHeight + (isAttached ? DPSMenuBarWindowArrowHeight : 0);
    [[NSColor clearColor] set];
    NSRectFillUsingOperation([window titleBarRect], NSCompositeClear);
    
    // Create the window shape
    NSPoint arrowPointLeft = NSMakePoint(originX + (width - arrowWidth) / 2.0,
                                         originY + height - (isAttached ? DPSMenuBarWindowArrowHeight : 0));
    NSPoint arrowPointMiddle;
    if (window.attachedToMenuBar)
    {
        arrowPointMiddle = NSMakePoint(originX + width / 2.0,
                                       originY + height);
    }
    else
    {
        arrowPointMiddle = NSMakePoint(originX + width / 2.0,
                                       originY + height - (isAttached ? DPSMenuBarWindowArrowHeight : 0));
    }
    NSPoint arrowPointRight = NSMakePoint(originX + (width + arrowWidth) / 2.0,
                                          originY + height - (isAttached ? DPSMenuBarWindowArrowHeight : 0));
    NSPoint topLeft = NSMakePoint(originX,
                                  originY + height - (isAttached ? DPSMenuBarWindowArrowHeight : 0));
    NSPoint topRight = NSMakePoint(originX + width,
                                   originY + height - (isAttached ? DPSMenuBarWindowArrowHeight : 0));
    NSPoint bottomLeft = NSMakePoint(originX,
                                     originY + height - arrowHeight - DPSMenuBarWindowTitleBarHeight);
    NSPoint bottomRight = NSMakePoint(originX + width,
                                      originY + height - arrowHeight - DPSMenuBarWindowTitleBarHeight);
    
    NSBezierPath *border = [NSBezierPath bezierPath];
    [border moveToPoint:arrowPointLeft];
    [border lineToPoint:arrowPointMiddle];
    [border lineToPoint:arrowPointRight];
    [border appendBezierPathWithArcFromPoint:topRight
                                     toPoint:bottomRight
                                      radius:cornerRadius];
    [border lineToPoint:bottomRight];
    [border lineToPoint:bottomLeft];
    [border appendBezierPathWithArcFromPoint:topLeft
                                     toPoint:arrowPointLeft
                                      radius:cornerRadius];
    [border closePath];
    
    // Draw the title bar
    [NSGraphicsContext saveGraphicsState];
    [border addClip];
    
    NSRect headingRect = NSMakeRect(originX,
                                    originY + height - titleBarHeight,
                                    width,
                                    DPSMenuBarWindowTitleBarHeight);
    NSRect titleBarRect = NSMakeRect(originX,
                                     originY + height - titleBarHeight,
                                     width,
                                     DPSMenuBarWindowTitleBarHeight + DPSMenuBarWindowArrowHeight);
    
    // Colors
    NSColor *bottomColor, *topColor, *topColorTransparent;
    if ([window isKeyWindow] || window.attachedToMenuBar)
    {
        bottomColor = [NSColor colorWithCalibratedWhite:0.690 alpha:1.0];
        topColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000];
        topColorTransparent = [NSColor colorWithCalibratedWhite:0.910 alpha:0.0];
    }
    else
    {
        bottomColor = [NSColor colorWithCalibratedWhite:0.85 alpha:1.0];
        topColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000];
        topColorTransparent = [NSColor colorWithCalibratedWhite:0.93 alpha:0.0];
    }
    
    // Fill the titlebar with the base colour
    [bottomColor set];
    NSRectFill(titleBarRect);
    
    // Draw some subtle noise to the titlebar if the window is the key window
    if ([window isKeyWindow])
    {
//        [[NSColor colorWithPatternImage:[self noiseImage]] set];
//        NSRectFillUsingOperation(headingRect, NSCompositeSourceOver);
    }
    
    // Draw the highlight
    NSGradient *headingGradient = [[NSGradient alloc] initWithStartingColor:topColorTransparent
                                                                endingColor:topColor];
    [headingGradient drawInRect:headingRect angle:90.0];
    
    // Highlight the tip, too
    if (isAttached)
    {
        NSColor *tipColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000];
        NSGradient *tipGradient = [[NSGradient alloc] initWithStartingColor:topColor
                                                                endingColor:tipColor];
        NSRect tipRect = NSMakeRect(arrowPointLeft.x,
                                    arrowPointLeft.y,
                                    DPSMenuBarWindowArrowWidth,
                                    DPSMenuBarWindowArrowHeight);
        [tipGradient drawInRect:tipRect angle:90.0];
    }
    
    // Draw the title bar highlight
    NSBezierPath *highlightPath = [NSBezierPath bezierPath];
    [highlightPath moveToPoint:topLeft];
    if (isAttached)
    {
        [highlightPath lineToPoint:arrowPointLeft];
        [highlightPath lineToPoint:arrowPointMiddle];
        [highlightPath lineToPoint:arrowPointRight];
    }
    [highlightPath lineToPoint:topRight];
    [[NSColor colorWithCalibratedRed:0.208 green:0.522 blue:0.360 alpha:1.000] set];
    [highlightPath setLineWidth:1.0];
    [border addClip];
    [highlightPath stroke];
    
    [NSGraphicsContext restoreGraphicsState];
    
    // Draw separator line between the titlebar and the content view
    [[NSColor colorWithCalibratedWhite:0.5 alpha:1.0] set];
    NSRect separatorRect = NSMakeRect(originX,
                                      originY + height - DPSMenuBarWindowTitleBarHeight - (isAttached ? DPSMenuBarWindowArrowHeight : 0) - 1,
                                      width,
                                      1);
    NSRectFill(separatorRect);
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
