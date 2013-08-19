//
//  DSPMainWindowController.m
//  DotSnap
//
//  Created by Robert Widmann on 7/24/13.
//
//

#import "DSPMainWindowController.h"
#import "DSPMainViewController.h"
#import "DSPMainWindow.h"

@interface DSPMainWindowController ()
@property (nonatomic, strong) DSPMainViewController *viewController;
@end

@implementation DSPMainWindowController

- (id)init {
	self = [super init];
	
	_viewController = [[DSPMainViewController alloc]initWithContentRect:(NSRect){ .size = { 400, 196 } }];
	[self setNextResponder:_viewController];

	self.window = [[DSPMainWindow alloc]initWithView:self.viewController.view attachedToPoint:(NSPoint){ } inWindow:nil onSide:MAPositionBottom atDistance:5.0 mainWindow:YES];
	self.window.cornerRadius = 0.f;
	self.window.arrowHeight = 12.f;
	self.window.borderWidth = 0.f;
	self.window.backgroundColor = NSColor.clearColor;
	self.window.arrowBaseWidth = 20.f;
	self.window.menuBarIcon = [NSImage imageNamed:@"MenubarIcon"];
	self.window.highlightedMenuBarIcon = [NSImage imageNamed:@"MenubarIcon_Highlighted"];
	self.window.acceptsMouseMovedEvents = YES;
	
	NSRect rect = (NSRect){ .size = { 400, 214 } };
	rect.origin = [(DSPMainWindow *)self.window originForNewFrame:rect];
	[(DSPMainWindow *)self.window setFrame:rect display:YES animate:YES];
	
	return self;
}

- (DSPMainWindow *)window {
	return (DSPMainWindow *)[super window];
}

- (BOOL)validateProposedFirstResponder:(NSResponder *)responder forEvent:(NSEvent *)event {
	if ([responder isKindOfClass:NSTextField.class] && !event) {
		return NO;
	}
	return [super validateProposedFirstResponder:responder forEvent:event];
}

@end
