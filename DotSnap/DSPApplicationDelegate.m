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

@interface DSPApplicationDelegate ()
@property (nonatomic, strong) DSPMainWindowController *windowController;
@end

@implementation DSPApplicationDelegate

+ (void)load {
	[NSUserDefaults.standardUserDefaults registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"Defaults" ofType:@"plist"]]];
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

@end
