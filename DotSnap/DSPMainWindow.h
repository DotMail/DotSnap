//
//  DSPMainWindow.h
//  DotSnap
//
//  Created by Robert Widmann on 7/24/13.
//
//

#import "MAAttachedWindow.h"

@interface DSPMainWindow : MAAttachedWindow

- (instancetype)initWithView:(NSView *)view attachedToPoint:(NSPoint)point inWindow:(NSWindow *)window onSide:(MAWindowPosition)side atDistance:(float)distance mainWindow:(BOOL)flag;

@property (nonatomic, assign) BOOL isInOpenPanel;
@property (nonatomic, assign) BOOL isFlipping;

@property (assign) CGFloat snapDistance;
@property (nonatomic, strong) NSImage *menuBarIcon;
@property (nonatomic, strong) NSImage *highlightedMenuBarIcon;
@property (readonly) NSStatusItem *statusItem;

@end
