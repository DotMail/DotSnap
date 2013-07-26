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
	
	NSUInteger styleMask = NSClosableWindowMask;
	self.window = [[DSPMainWindow alloc]initWithContentRect:(NSRect){ .origin.y = NSMaxY(NSScreen.mainScreen.frame) - 230, .size = { 400, 205 } } styleMask:styleMask backing:NSBackingStoreBuffered defer:YES];
	self.window.menuBarIcon = [NSImage imageNamed:@"Status"];
    self.window.highlightedMenuBarIcon = [NSImage imageNamed:@"StatusHighlighted"];
    self.window.hasMenuBarIcon = YES;
    self.window.attachedToMenuBar = YES;
    self.window.isDetachable = YES;
	
	self.viewController = [[DSPMainViewController alloc]initWithContentRect:(NSRect){ .size = { 400, 205 } }];
	[self.window.contentView addSubview:self.viewController.view];
		
	return self;
}

- (DSPMainWindow *)window {
	return (DSPMainWindow *)[super window];
}

@end
