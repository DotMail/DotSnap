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
	[self setFrameOrigin:[self originForAttachedState]];
	[super makeKeyAndOrderFrontWithDuration:duration timing:timingFunction setup:setup animations:animations];
}


#pragma mark - Active/key events

- (BOOL)canBecomeKeyWindow
{
    return YES;
}

- (BOOL)canBecomeMainWindow {
	return YES;
}

- (void)windowDidResignKey:(NSNotification *)aNotification
{
    if (!_isInOpenPanel && !_isFlipping)
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

- (void)endEditingGracefully
{
	// Courtesy of Daniel Jalkut, modified slightly
	// http://www.red-sweater.com/blog/229
	
	// Save the current first responder, respecting the fact
	// that it might conceptually be the delegate of the
	// field editor that is "first responder."
	id oldFirstResponder = [self firstResponder];
	if ((oldFirstResponder != nil) &&
		[oldFirstResponder isKindOfClass:[NSText class]] &&
		[oldFirstResponder isFieldEditor])
	{
		// A field editor's delegate is the view we're editing
		oldFirstResponder = [oldFirstResponder delegate];
		if ([oldFirstResponder isKindOfClass:[NSResponder class]] == NO)
		{
			// Eh...we'd better back off if
			// this thing isn't a responder at all
			oldFirstResponder = nil;
		}
	}
	
	// Gracefully end all editing in our window (from Erik Buck).
	// This will cause the user's changes to be committed.
	if ([self makeFirstResponder:self])
	{
		// All editing is now ended and delegate messages sent etc.
	}
	else
	{
		// For some reason the text object being edited will
		// not resign first responder status so force an
		// end to editing anyway
		[self endEditingFor:nil];
	}
	
	// If we had a first responder before, restore it
	if (oldFirstResponder != nil)
	{
		[self makeFirstResponder:oldFirstResponder];
	}
}

- (IBAction)clearFirstResponder:(id)sender {
	[self performSelector:@selector(makeFirstResponder:) withObject:nil afterDelay:0];
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
    if ([self.menuBarWindow isMainWindow] || self.menuBarWindow.isVisible)
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
                                 [self bounds].origin.y + 4,
                                 [self bounds].size.width - 6,
                                 [self bounds].size.height - 6);
        
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

#define DURATION (0.75)

// We subclass NSAnimation to maximize frame rate, instead of using progress marks.

@interface FliprAnimation : NSAnimation {
}
@end

@implementation FliprAnimation

// We initialize the animation with some huge default value.

- (id)initWithAnimationCurve:(NSAnimationCurve)animationCurve {
	self = [super initWithDuration:1.0E8 animationCurve:animationCurve];
	return self;
}

// We call this to start the animation just beyond the first frame.

- (void)startAtProgress:(NSAnimationProgress)value withDuration:(NSTimeInterval)duration {
	[super setCurrentProgress:value];
	[self setDuration:duration];
	[self startAnimation];
}

// Called periodically by the NSAnimation timer.

- (void)setCurrentProgress:(NSAnimationProgress)progress {
	// Call super to update the progress value.
	[super setCurrentProgress:progress];
	if ([self isAnimating]&&(progress<0.99)) {
		/// Update the window unless we're nearly at the end. No sense duplicating the final window.
		// We can be sure the delegate responds to display.
		[(NSWindow *)[self delegate] display];
	}
}

@end

// This is the flipping window's content view.

@interface FliprView : NSView <NSAnimationDelegate> {
	NSRect originalRect;			// this rect covers the initial and final windows.
	NSWindow* initialWindow;
	NSWindow* finalWindow;
    CIImage* finalImage;			// this is the rendered image of the final window.
	CIFilter* transitionFilter;
	NSShadow* shadow;
	FliprAnimation* animation;
	float direction;				// this will be 1 (forward) or -1 (backward).
	float frameTime;				// time for last drawRect:
}
@end

@implementation FliprView

// The designated initializer; will be called when the flipping window is set up.

- (id)initWithFrame:(NSRect)frame andOriginalRect:(NSRect)rect {
	self = [super initWithFrame:frame];
	if (self) {
		originalRect = rect;
		initialWindow = nil;
		finalWindow = nil;
		finalImage = nil;
		animation = nil;
		frameTime = 0.0;
		// Initialize the CoreImage filter.
		transitionFilter = [CIFilter filterWithName:@"CIPerspectiveTransform"];
		[transitionFilter setDefaults];
		// These parameters come from http://boredzo.org/imageshadowadder/ by Peter Hosey,
		// and reproduce reasonably well the standard Tiger NSWindow shadow.
		// You should change these when flipping NSPanels and/or on Leopard.
		shadow = [[NSShadow alloc] init];
		[shadow setShadowColor:[[NSColor shadowColor] colorWithAlphaComponent:0.8]];
		[shadow setShadowBlurRadius:23];
		[shadow setShadowOffset:NSMakeSize(0,-8)];
	}
	return self;
}


// This view, and the flipping window itself, are mostly transparent.

- (BOOL)isOpaque {
	return NO;
}


// This is called to calculate the transition images and to start the animation.
// The initial and final windows aren't retained, so weird things might happen if
// they go away during the animation. We assume both windows have the exact same frame.

- (void)setInitialWindow:(NSWindow*)initial andFinalWindow:(NSWindow*)final forward:(BOOL)forward {
	NSWindow* flipr = [DSPMainWindow flippingWindow];
	if (flipr) {
		[NSCursor hide];
		initialWindow = initial;
		finalWindow = final;
		direction = forward?1:-1;
		// Here we reposition and resize the flipping window so that originalRect will cover the original windows.
		NSRect frame = [initialWindow frame];
		NSRect flp = [flipr frame];
		flp.origin.x = frame.origin.x-originalRect.origin.x;
		flp.origin.y = frame.origin.y-originalRect.origin.y;
		flp.size.width += frame.size.width-originalRect.size.width;
		flp.size.height += frame.size.height-originalRect.size.height;
		[flipr setFrame:flp display:NO];
		originalRect.size = frame.size;
		// Here we get an image of the initial window and make a CIImage from it.
		NSView* view = [[initialWindow contentView] superview];
		flp = [view bounds];
		NSBitmapImageRep* bitmap = [view bitmapImageRepForCachingDisplayInRect:flp];
		[view cacheDisplayInRect:flp toBitmapImageRep:bitmap];
		CIImage* initialImage = [[CIImage alloc] initWithBitmapImageRep:bitmap];
		// We immediately pass the initial image to the filter and release it.
		[transitionFilter setValue:initialImage forKey:@"inputImage"];

		// To prevent flicker...
		NSDisableScreenUpdates();
		// We bring the final window to the front in order to build the final image.
		[finalWindow makeKeyAndOrderFront:self];
		// Here we get an image of the final window and make a CIImage from it.
		view = [[finalWindow contentView] superview];
		flp = [view bounds];
		bitmap = [view bitmapImageRepForCachingDisplayInRect:flp];
		[view cacheDisplayInRect:flp toBitmapImageRep:bitmap];
		finalImage = [[CIImage alloc] initWithBitmapImageRep:bitmap];
		// To save time, we don't order the final window out, just make it completely transparent.
		[finalWindow setAlphaValue:0];
		[initialWindow orderOut:self];
		// This will draw the first frame at value 0, duplicating the initial window. This is not really optimal,
		// but we need to compensate for the time spent here, which seems to be about 3 to 5x what's needed
		// for subsequent frames.
		animation = [[FliprAnimation alloc] initWithAnimationCurve:NSAnimationEaseInOut];
		[animation setDelegate:self];
		// This is probably redundant...
		[animation setCurrentProgress:0.0];
		[flipr orderWindow:NSWindowBelow relativeTo:[finalWindow windowNumber]];
		float duration = DURATION;
		// Slow down by a factor of 5 if the shift key is down.
		if ([[NSApp currentEvent] modifierFlags]&NSShiftKeyMask) {
			duration *= 5.0;
		}
		// We accumulate drawing time and draw a second frame at the point where the rotation starts to show.
		float totalTime = frameTime;
		[animation setCurrentProgress:DURATION/15];
		// Now we update the screen and the second frame appears, boom! :-)
		NSEnableScreenUpdates();
		totalTime += frameTime;
		// We set up the animation. At this point, totalTime will be the time needed to draw the first two frames,
		// and frameTime the time for the second (normal) frame.
		// We stretch the duration, if necessary, to make sure at least 5 more frames will be drawn.
		if ((duration-totalTime)<(frameTime*5)) {
			duration = totalTime+frameTime*5;
		}
		// ...and everything else happens in the animation delegates. We start the animation just
		// after the second frame.
		[animation startAtProgress:totalTime/duration withDuration:duration];
	}
}

// This is called when the animation has finished.

- (void)animationDidEnd:(NSAnimation*)theAnimation {
	// We order the flipping window out and make the final window visible again.
	NSDisableScreenUpdates();
	[[DSPMainWindow flippingWindow] orderOut:self];
	[finalWindow setAlphaValue:1.0];
	[finalWindow display];
	NSEnableScreenUpdates();
	// Clear stuff out...
	animation = nil;
	initialWindow = nil;
	[NSCursor unhide];
}

// All the magic happens here... drawing the flipping animation.

- (void)drawRect:(NSRect)rect {
	if (!initialWindow) {
		// If there's no window yet, we don't need to draw anything.
		return;
	}
	// For calculating the draw time...
	AbsoluteTime startTime = UpTime();
	// time will vary from 0.0 to 1.0. 0.5 means halfway.
	float time = [animation currentValue];
	// This code was adapted from http://www.macs.hw.ac.uk/~rpointon/osx/coreimage.html by Robert Pointon.
	// First we calculate the perspective.
	float radius = originalRect.size.width/2;
	float width = radius;
	float height = originalRect.size.height/2;
	float dist = 1600; // visual distance to flipping window, 1600 looks about right. You could try radius*5, too.
	float angle = direction*M_PI*time;
	float px1 = radius*cos(angle);
	float pz = radius*sin(angle);
	float pz1 = dist+pz;
	float px2 = -px1;
	float pz2 = dist-pz;
	if (time>0.5) {
		// At this point,  we need to swap in the final image, for the second half of the animation.
		if (finalImage) {
			[transitionFilter setValue:finalImage forKey:@"inputImage"];
			finalImage = nil;
		}
		float ss;
		ss = px1; px1 = px2; px2 = ss;
		ss = pz1; pz1 = pz2; pz2 = ss;
	}
	float sx1 = dist*px1/pz1;
	float sy1 = dist*height/pz1;
	float sx2 = dist*px2/pz2;
	float sy2 = dist*height/pz2;
	// Everything is set up, we pass the perspective to the CoreImage filter
	[transitionFilter setValue:[CIVector vectorWithX:width+sx1 Y:height+sy1] forKey:@"inputTopRight"];
	[transitionFilter setValue:[CIVector vectorWithX:width+sx2 Y:height+sy2] forKey:@"inputTopLeft" ];
	[transitionFilter setValue:[CIVector vectorWithX:width+sx1 Y:height-sy1] forKey:@"inputBottomRight"];
	[transitionFilter setValue:[CIVector vectorWithX:width+sx2 Y:height-sy2] forKey:@"inputBottomLeft"];
	CIImage* outputCIImage = [transitionFilter valueForKey:@"outputImage"];
	// This will make the standard window shadow appear beneath the flipping window
	[shadow set];
	// And we draw the result image.
	NSRect bounds = [self bounds];
	[outputCIImage drawInRect:bounds fromRect:NSMakeRect(-originalRect.origin.x,-originalRect.origin.y,bounds.size.width,bounds.size.height) operation:NSCompositeSourceOver fraction:1.0];
	// Calculate the time spent drawing
	frameTime = UnsignedWideToUInt64(AbsoluteDeltaToNanoseconds(UpTime(),startTime))/1E9;
}

@end

@implementation DSPMainWindow (NSWindow_Flipr)

// This function checks if the CPU can perform flipping. We assume all Intel Macs can do it,
// but PowerPC Macs need AltiVec.

static BOOL CPUIsSuitable() {
#ifdef __LITTLE_ENDIAN__
	return YES;
#else
	int altivec = 0;
	size_t length = sizeof(altivec);
	int error = sysctlbyname("hw.optional.altivec",&altivec,&length,NULL,0);
	return error?NO:altivec!=0;
#endif
}

// There's only one flipping window!

static NSWindow* flippingWindow = nil;

// Get (and initialize, if necessary) the flipping window.

+ (NSWindow*)flippingWindow {
	if (!flippingWindow) {
		// We initialize the flipping window if the CPU can do it...
		if (CPUIsSuitable()) {
			// This is a little arbitary... the window will be resized every time it's used.
			NSRect frame = NSMakeRect(128,128,512,768);
			flippingWindow = [[NSWindow alloc] initWithContentRect:frame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
			[flippingWindow setBackgroundColor:[NSColor clearColor]];
			[flippingWindow setOpaque:NO];
			[flippingWindow setHasShadow:NO];
			[flippingWindow setOneShot:YES];
			frame.origin = NSZeroPoint;
			// The inset values seem large enough so the animation doesn't slop over the frame.
			// They could be calculated more exactly, though.
			FliprView* view = [[FliprView alloc] initWithFrame:frame andOriginalRect:NSInsetRect(frame,64,256)];
			[view setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
			[flippingWindow setContentView:view];
		}
	}
	return flippingWindow;
}

// Release the flipping window.

+ (void)releaseFlippingWindow {
	flippingWindow = nil;
}

// This is called from outside to start the animation process.

- (void)flipToShowWindow:(NSWindow*)window forward:(BOOL)forward {
	// We resize the final window to exactly the same frame.
//	[window setFrame:[self frame] display:NO];
	NSWindow* flipr = [DSPMainWindow flippingWindow];
	if (!flipr) {
		// If we fall in here, the CPU isn't able to animate and we just change windows.
		[window makeKeyAndOrderFront:self];
		[self orderOut:self];
		return;
	}
	[(FliprView*)[flipr contentView] setInitialWindow:self andFinalWindow:window forward:forward];
}

@end

