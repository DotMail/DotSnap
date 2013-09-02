//
//  DPSMenuBarWindowIconView.m
//  DotSnap
//
//  Created by Robert Widmann on 8/9/13.
//
//

#import "DSPMenuBarWindowIconView.h"
#import "DSPMainWindow.h"

static NSMenu *contextMenu(id delegate) {
	static NSMenu *fileMenu = nil;
	if (fileMenu == nil) {
		fileMenu = [[NSMenu alloc] init];
		NSMenuItem *quitMenuItem = [[NSMenuItem alloc] initWithTitle:@"Quit DotSnap" action:@selector(terminate:) keyEquivalent:@""];
		[quitMenuItem setTarget:NSApp];
		[fileMenu addItem:quitMenuItem];
	}
	fileMenu.delegate = delegate;
	return fileMenu;
}

@implementation DSPMenuBarWindowIconView

#pragma mark - Highlighting

- (void)setHighlighted:(BOOL)flag {
	_highlighted = flag;
	[self setNeedsDisplay:YES];
}

#pragma mark - Mouse events

- (void)mouseDown:(NSEvent *)theEvent {
	self.highlighted = YES;
	if ((theEvent.modifierFlags & NSControlKeyMask) == NSControlKeyMask) {
		if ([NSApp keyWindow].isVisible) {
			[(DSPMainWindow *)[NSApp keyWindow] orderOutWithDuration:0.3 timing:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] animations:^(CALayer *layer) {
				layer.transform = CATransform3DMakeTranslation(0.f, -50.f, 0.f);
				layer.opacity = 0.f;
			}];
		}
		[self.menuBarWindow.statusItem popUpStatusItemMenu:contextMenu(self)];
		return;
	}
	
	if (([NSApp keyWindow].isMainWindow || [NSApp keyWindow].isVisible) && !self.menuBarWindow.isInOpenPanel) {
		[(DSPMainWindow *)[NSApp keyWindow] orderOutWithDuration:0.3 timing:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] animations:^(CALayer *layer) {
			layer.transform = CATransform3DMakeTranslation(0.f, -50.f, 0.f);
			layer.opacity = 0.f;
		}];
	} else if (self.menuBarWindow.isInOpenPanel) {
		[NSApp endSheet:self.menuBarWindow.attachedSheet];
		[self.menuBarWindow orderOutWithDuration:0.3 timing:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] animations:^(CALayer *layer) {
			layer.transform = CATransform3DMakeTranslation(0.f, -50.f, 0.f);
			layer.opacity = 0.f;
		}];
	} else {
		[NSApp activateIgnoringOtherApps:YES];
		[self.menuBarWindow makeKeyAndOrderFrontWithDuration:0.3 timing:nil setup:^(CALayer *layer) {
			layer.transform = CATransform3DMakeTranslation(0.f, -50., 0.f);
			layer.opacity = 0.f;
		} animations:^(CALayer *layer) {
			layer.transform = CATransform3DIdentity;
			layer.opacity = 1.f;
		}];
	}
}

- (void)rightMouseDown:(NSEvent *)theEvent{
	self.highlighted = YES;
	if ([NSApp keyWindow].isVisible) {
		[(DSPMainWindow *)[NSApp keyWindow] orderOutWithDuration:0.3 timing:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] animations:^(CALayer *layer) {
			layer.transform = CATransform3DMakeTranslation(0.f, -50.f, 0.f);
			layer.opacity = 0.f;
		}];
	}
	[self.menuBarWindow.statusItem popUpStatusItemMenu:contextMenu(self)];
}

- (void)mouseUp:(NSEvent *)theEvent {
	self.highlighted = NO;
}

- (void)menuDidClose:(NSMenu *)menu {
	self.highlighted = NO;
}

#pragma mark - Drawing

- (void)drawRect:(NSRect)dirtyRect {
	NSRect b = self.bounds;
	if (self.highlighted) {
		[NSColor.selectedMenuItemColor set];
		NSRectFill(b);
	}
	if (self.menuBarWindow && self.menuBarWindow.menuBarIcon) {
		NSRect rect = (NSRect){ .origin = { NSMinX(b) + 3, NSMinY(b) + 3 }, .size = { NSWidth(b) - 6, NSHeight(b) - 6 } };
		if (self.highlighted && self.menuBarWindow.highlightedMenuBarIcon) {
			[self.menuBarWindow.highlightedMenuBarIcon drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
		} else {
			[self.menuBarWindow.menuBarIcon drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
		}
	}
}

@end
