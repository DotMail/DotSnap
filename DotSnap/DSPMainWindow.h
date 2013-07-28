//
//  DSPMainWindow.h
//  DotSnap
//
//  Created by Robert Widmann on 7/24/13.
//
//

#import "MAAttachedWindow.h"

@interface DSPMainWindow : MAAttachedWindow

@property (nonatomic, assign) BOOL isInOpenPanel;
@property (nonatomic, assign) BOOL isFlipping;

@property (nonatomic, assign) BOOL hasMenuBarIcon;
@property (assign) CGFloat snapDistance;
@property (nonatomic, strong) NSImage *menuBarIcon;
@property (nonatomic, strong) NSImage *highlightedMenuBarIcon;
@property (readonly) NSStatusItem *statusItem;

- (void)endEditingGracefully;

@end

@interface DPSMenuBarWindowIconView : NSView

@property (assign) DSPMainWindow *menuBarWindow;
@property (nonatomic) BOOL highlighted;

@end

@interface DSPMainWindow (Flipr)

// Call during initialization this to prepare the flipping window.
// If you don't call this, the first flip will take a little longer.

+ (NSWindow*)flippingWindow;

// Call this if you want to release the flipping window. If you flip
// again after calling this, it will take a little longer.

+ (void)releaseFlippingWindow;

// Call this on a visible window to flip it and show the parameter window,
// which is supposed to not be on-screen.

- (void)flipToShowWindow:(NSWindow*)window forward:(BOOL)forward;
@end