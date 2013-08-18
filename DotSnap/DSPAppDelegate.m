//
//  DSPAppDelegate.m
//  DotSnap
//
//  Created by Robert Widmann on 7/24/13.
//
//

#import "DSPAppDelegate.h"
#import "DSPMainWindowController.h"

@interface DSPAppDelegate ()
@property (nonatomic, strong) DSPMainWindowController *windowController;
@end

@implementation DSPAppDelegate

+ (void)load {
	[NSUserDefaults.standardUserDefaults registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"Defaults" ofType:@"plist"]]];
	[NSUserDefaults resetStandardUserDefaults];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	self.windowController = [[DSPMainWindowController alloc]init];
	[self.windowController close];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	[NSUserDefaults.standardUserDefaults synchronize];
}

@end
