//
//  LIFlipEffect.h
//  WindowEffects
//
//  Created by Mark Onyschuk on 17/07/09.
//  Copyright 2009 Lorem & Ipsum. All rights reserved.
//

#import "LIEffect.h"

@interface LIFlipEffect : LIEffect {
	NSUInteger done;
	NSWindow *fromWindow, *toWindow;
	NSBitmapImageRep *fromImage, *toImage;
}

#pragma mark -
#pragma mark Setup
- (id)initFromWindow:(NSWindow *)aFromWindow toWindow:(NSWindow *)aToWindow;
- (id)initFromWindow:(NSWindow *)aFromWindow toWindow:(NSWindow *)aToWindow flag:(BOOL)flag;

#pragma mark -
#pragma mark PRoperties
@property (readonly) NSWindow *fromWindow, *toWindow;

#pragma mark -
#pragma mark Actions
- (void)run;

#pragma mark -
#pragma mark Cleanup
- (void)dealloc;

@end
