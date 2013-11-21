//
//  DSPAppDelegate.m
//  DotSnap
//
//  Created by Robert Widmann on 7/24/13.
//
//

#import "DSPApplicationDelegate.h"
#import "DSPMainWindowController.h"
#import "DSPLaunchServicesManager.h"
#import "PFMoveApplication.h"

@interface DSPApplicationDelegate ()
@property (nonatomic, strong) DSPMainWindowController *windowController;
@end

void DSPWarnLionIfNecessary(void);

@implementation DSPApplicationDelegate

+ (void)load {
	[NSUserDefaults.standardUserDefaults registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"Defaults" ofType:@"plist"]]];
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
	// Call this before any interface is shown to prevent confusion
	// and hopefully move DM to the main applications folder.
	if (getenv("DOTSNAP_TEST") == NULL) {
		DSPWarnLionIfNecessary();
		PFMoveToApplicationsFolderIfNecessary();
	}
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	if (![NSUserDefaults.standardUserDefaults boolForKey:DSPHasShownPanelAtFirstLaunchKey]) {
		NSInteger result = NSRunAlertPanel(@"DotSnap", @"Let DotSnap help you organize your desktop. Do you want to open DotSnap automatically when you login?", @"Yes, please", @"No", nil);
		if (result == NSAlertDefaultReturn) {
			[DSPLaunchServicesManager.defaultManager insertCurrentApplicationInStartupItems:NO];
			[NSUserDefaults.standardUserDefaults setBool:YES forKey:DSPLoadDotSnapAtStartKey];
		}
		[NSUserDefaults.standardUserDefaults setBool:YES forKey:DSPHasShownPanelAtFirstLaunchKey];
	}
	self.windowController = [[DSPMainWindowController alloc]init];
	[self.windowController close];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	[NSUserDefaults.standardUserDefaults synchronize];
}

void DSPWarnLionIfNecessary(void) {
	if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_7) {
		NSRunAlertPanel(@"Error", @"This version of DotSnap only runs on Mountain Lion or later.  Sorry!", @"OK", nil, nil);
		[NSApplication.sharedApplication terminate:NSApp];
	}
}

@end
