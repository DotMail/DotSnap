//
//  LIEffect.h
//  WindowEffects
//
//  Created by Mark Onyschuk on 17/07/09.
//  Copyright 2009 Lorem & Ipsum. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CALayer;

@interface LIEffect : NSObject {
	NSWindow *animationWindow;
}

#pragma mark -
#pragma mark Setup
- (id)initWithAnimationWindowFrame:(NSRect)aFrame;

#pragma mark -
#pragma mark Properties
@property (readonly) NSView *animationView;
@property (readonly) CALayer *animationLayer;
@property (readonly) NSWindow *animationWindow;

#pragma mark -
#pragma mark Actions
- (void)run;

#pragma mark -
#pragma mark Cleanup
- (void)dealloc;

@end

@interface NSView (LIEffects)
- (NSBitmapImageRep *)imageRep;
@end

extern NSRect LIRectToScreen(NSRect aRect, NSView *aView);
extern NSRect LIRectFromScreen(NSRect aRect, NSView *aView);
extern NSRect LIRectFromViewToView(NSRect aRect, NSView *fromView, NSView *toView);

