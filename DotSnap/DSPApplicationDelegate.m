//
//  DSPAppDelegate.m
//  DotSnap
//
//  Created by Robert Widmann on 7/24/13.
//
//

#import "DSPApplicationDelegate.h"
#import "DSPMainWindowController.h"

@interface DSPApplicationDelegate ()
@property (nonatomic, strong) DSPMainWindowController *windowController;
@end

@implementation DSPApplicationDelegate

+ (void)load {
	[NSUserDefaults.standardUserDefaults registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"Defaults" ofType:@"plist"]]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	self.windowController = [[DSPMainWindowController alloc]init];
	[self.windowController close];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	[NSUserDefaults.standardUserDefaults synchronize];
}

@end
