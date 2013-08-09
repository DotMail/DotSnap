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
	
	_viewController = [[DSPMainViewController alloc]initWithContentRect:(NSRect){ .size = { 400, 210 } }];
	[self setNextResponder:_viewController];

	self.window = [[DSPMainWindow alloc]initWithView:self.viewController.view attachedToPoint:(NSPoint){ } inWindow:nil onSide:MAPositionBottom atDistance:5.0];
	self.window.cornerRadius = 0.f;
	self.window.arrowHeight = 12.f;
	self.window.borderWidth = 0.f;
	self.window.backgroundColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.0];
	self.window.arrowBaseWidth = 20.f;
	self.window.menuBarIcon = [NSImage imageNamed:@"dotsnapp_appicon_normal"];
	self.window.highlightedMenuBarIcon = [NSImage imageNamed:@"dotsnapp_appicon_white_active"];
	self.window.hasMenuBarIcon = YES;
	self.window.acceptsMouseMovedEvents = YES;
	
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
