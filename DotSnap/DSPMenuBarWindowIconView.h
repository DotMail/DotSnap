//
//  DPSMenuBarWindowIconView.h
//  DotSnap
//
//  Created by Robert Widmann on 8/9/13.
//
//

@class DSPMainWindow;

@interface DSPMenuBarWindowIconView : NSView <NSMenuDelegate>

@property (assign) DSPMainWindow *menuBarWindow;
@property (nonatomic) BOOL highlighted;

@end
