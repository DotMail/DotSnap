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

@property (nonatomic, assign) BOOL hasMenuBarIcon;
@property (nonatomic, assign) BOOL attachedToMenuBar;
@property (nonatomic, assign) BOOL hideWindowControlsWhenAttached;
@property (nonatomic, assign) BOOL isDetachable;
@property (assign) CGFloat snapDistance;
@property (nonatomic, strong) NSImage *menuBarIcon;
@property (nonatomic, strong) NSImage *highlightedMenuBarIcon;
@property (readonly) NSStatusItem *statusItem;
@end

@interface DPSMenuBarWindowIconView : NSView

@property (assign) DSPMainWindow *menuBarWindow;
@property (nonatomic) BOOL highlighted;

@end
