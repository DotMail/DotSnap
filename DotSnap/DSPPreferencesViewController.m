//
//  DSPPreferencesViewController.m
//  DotSnap
//
//  Created by Robert Widmann on 7/25/13.
//
//

#import "DSPPreferencesViewController.h"
#import "DSPMainView.h"
#import "DSPSwitch.h"
#import "DSPMainWindow.h"
#import "DSPLaunchServicesManager.h"
#import "DSPSpinningSettingsButton.h"
#import "DSPGlowingNameButton.h"
#import "DSPShadowBox.h"
#import "DSPLabel.h"
#import "LIFlipEffect.h"

@interface DSPPreferencesViewController ()

@end

@implementation DSPPreferencesViewController

- (id)initWithContentRect:(CGRect)rect {
	self = [super init];
	
	_contentRect = rect;
	
	return self;
}

- (void)loadView {
	DSPMainView *view = [[DSPMainView alloc]initWithFrame:_contentRect];
	view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	view.backgroundColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000];
	
	DSPMainView *fieldBackground = [[DSPMainView alloc]initWithFrame:(NSRect){ .origin.y = 4, .size = { NSWidth(_contentRect), 166 } }];
	fieldBackground.backgroundColor = [NSColor colorWithCalibratedRed:0.850 green:0.888 blue:0.907 alpha:1.000];
	[view addSubview:fieldBackground];

	DSPLabel *addTimestampLabel = [[DSPLabel alloc]initWithFrame:(NSRect){ .origin.x = 22, .origin.y = 116, .size = { NSWidth(_contentRect), 36 } }];
	addTimestampLabel.font = [NSFont fontWithName:@"HelveticaNeue-Medium" size:18.f];
	addTimestampLabel.textColor = [NSColor colorWithCalibratedRed:0.160 green:0.181 blue:0.215 alpha:1.000];
	addTimestampLabel.stringValue = @"Add Timestamp";
	[view addSubview:addTimestampLabel];
	
	DSPShadowBox *separatorShadow = [[DSPShadowBox alloc]initWithFrame:(NSRect){ .origin.y = 114, .size = { NSWidth(_contentRect), 1 } }];
	separatorShadow.borderColor = [NSColor colorWithCalibratedRed:0.753 green:0.821 blue:0.849 alpha:1.000];
	separatorShadow.fillColor = [NSColor colorWithCalibratedRed:0.753 green:0.821 blue:0.849 alpha:1.000];
	[view addSubview:separatorShadow];
	
	DSPLabel *loadDotsnapAtStartLabel = [[DSPLabel alloc]initWithFrame:(NSRect){ .origin.x = 22, .origin.y = 62, .size = { NSWidth(_contentRect), 36 } }];
	loadDotsnapAtStartLabel.font = [NSFont fontWithName:@"HelveticaNeue-Medium" size:18.f];
	loadDotsnapAtStartLabel.textColor = [NSColor colorWithCalibratedRed:0.160 green:0.181 blue:0.215 alpha:1.000];
	loadDotsnapAtStartLabel.stringValue = @"Load DotSnap on start";
	[view addSubview:loadDotsnapAtStartLabel];
	
	DSPShadowBox *separatorShadow2 = [[DSPShadowBox alloc]initWithFrame:(NSRect){ .origin.y = 56, .size = { NSWidth(_contentRect), 1 } }];
	separatorShadow2.borderColor = [NSColor colorWithCalibratedRed:0.753 green:0.821 blue:0.849 alpha:1.000];
	separatorShadow2.fillColor = [NSColor colorWithCalibratedRed:0.753 green:0.821 blue:0.849 alpha:1.000];
	[view addSubview:separatorShadow2];

	DSPLabel *autosaveInputLabel = [[DSPLabel alloc]initWithFrame:(NSRect){ .origin.x = 22, .origin.y = 8, .size = { NSWidth(_contentRect), 36 } }];
	autosaveInputLabel.font = [NSFont fontWithName:@"HelveticaNeue-Medium" size:18.f];
	autosaveInputLabel.textColor = [NSColor colorWithCalibratedRed:0.160 green:0.181 blue:0.215 alpha:1.000];
	autosaveInputLabel.stringValue = @"Autosave Input";
	[view addSubview:autosaveInputLabel];
	
	CALayer *logoLayer = CALayer.layer;
	logoLayer.contents = [NSImage imageNamed:@"DotSnapPreferencesLogo"];
	logoLayer.frame = (CGRect){ .origin.x = NSMidX(_contentRect) - 32, .origin.y = NSHeight(_contentRect) - 100, .size = { 62, 62 } };
	[view.layer addSublayer:logoLayer];
	
	DSPSpinningSettingsButton *optionsButton = [[DSPSpinningSettingsButton alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(_contentRect) - 28, .origin.y = NSHeight(_contentRect) - 28, .size = { 17, 17 } } style:1];
	optionsButton.rac_command = [RACCommand command];
	optionsButton.bordered = NO;
	optionsButton.buttonType = NSMomentaryChangeButton;
	optionsButton.image = [NSImage imageNamed:@"OptionsGearWhite"];
	
	[optionsButton.rac_command subscribeNext:^(NSButton *_) {
		[[[LIFlipEffect alloc] initFromWindow:view.window toWindow:self.presentingWindow] run];
	}];
	[view addSubview:optionsButton];
	
	DSPGlowingNameButton *dotsnapNameButton = [[DSPGlowingNameButton alloc]initWithFrame:(NSRect){ .origin = { 114, NSHeight(_contentRect) - 144 }, .size.width =  72, .size.height = 24 } name:@".Snap"];
	dotsnapNameButton.target = self;
	dotsnapNameButton.action = @selector(openDotSnap:);
	[view addSubview:dotsnapNameButton];
	
	CATextLayer *gistTextLayer = [[CATextLayer alloc]init];
	gistTextLayer.frame = (NSRect){ .origin = { 36, NSHeight(_contentRect) - 144 }, .size.width = NSWidth(_contentRect) - 72, .size.height = 24 };
	gistTextLayer.foregroundColor = NSColor.whiteColor.dsp_CGColor;
	gistTextLayer.font = CTFontCreateWithName(CFSTR("HelveticaNeue"), 18.f, NULL);
	gistTextLayer.fontSize = 18.f;
	gistTextLayer.alignmentMode = @"center";
	gistTextLayer.string = @"          is brought to you by";
	[view.layer addSublayer:gistTextLayer];
	
	DSPGlowingNameButton *codafiNameButton = [[DSPGlowingNameButton alloc]initWithFrame:(NSRect){ .origin = { 88, NSHeight(_contentRect) - 165 }, .size.width =  72, .size.height = 24 } name:@"CodaFi"];
	codafiNameButton.target = self;
	codafiNameButton.action = @selector(openCodafi:);
	[view addSubview:codafiNameButton];
	
	CATextLayer *andTextLayer = [[CATextLayer alloc]init];
	andTextLayer.frame = (NSRect){ .origin = { 152, NSHeight(_contentRect) - 165 }, .size.width = 36, .size.height = 24 };
	andTextLayer.foregroundColor = NSColor.whiteColor.dsp_CGColor;
	andTextLayer.font = CTFontCreateWithName(CFSTR("HelveticaNeue"), 18.f, NULL);
	andTextLayer.fontSize = 18.f;
	andTextLayer.alignmentMode = @"left";
	andTextLayer.string = @"and";
	[view.layer addSublayer:andTextLayer];
	
	DSPGlowingNameButton *tobiasNameButton = [[DSPGlowingNameButton alloc]initWithFrame:(NSRect){ .origin = { 186, NSHeight(_contentRect) - 165 }, .size.width =  200, .size.height = 24 } name:@"Tobias van Schneider"];
	tobiasNameButton.target = self;
	tobiasNameButton.action = @selector(openVanSchneider:);
	[view addSubview:tobiasNameButton];
	
	DSPSwitch *firstSwitch = [[DSPSwitch alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(_contentRect) - 102, .origin.y = 128, .size = { 80, 30 } }];
	firstSwitch.on = [NSUserDefaults.standardUserDefaults boolForKey:DSPAddsTimestampKey];
	[[RACObserve(firstSwitch,on) skip:1] subscribeNext:^(NSNumber *v) {
		[NSUserDefaults.standardUserDefaults setBool:v.boolValue forKey:DSPAddsTimestampKey];
	}];
	[view addSubview:firstSwitch];
	
	DSPSwitch *secondSwitch = [[DSPSwitch alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(_contentRect) - 102, .origin.y = 72, .size = { 80, 30 } }];
	secondSwitch.on = [NSUserDefaults.standardUserDefaults boolForKey:DSPLoadDotSnapAtStartKey];
	[[RACObserve(secondSwitch,on) skip:1] subscribeNext:^(NSNumber *v) {
		if (v.boolValue) {
			[DSPLaunchServicesManager.defaultManager insertCurrentApplicationInStartupItems:NO];
		} else {
			[DSPLaunchServicesManager.defaultManager removeCurrentApplicationFromStartupItems];
		}
		[NSUserDefaults.standardUserDefaults setBool:v.boolValue forKey:DSPLoadDotSnapAtStartKey];
	}];
	[view addSubview:secondSwitch];
	
	DSPSwitch *thirdSwitch = [[DSPSwitch alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(_contentRect) - 102, .origin.y = 16, .size = { 80, 30 } }];
	thirdSwitch.on = [NSUserDefaults.standardUserDefaults boolForKey:DSPAutosaveInputFieldKey];
	[[RACObserve(thirdSwitch,on) skip:1] subscribeNext:^(NSNumber *v) {
		[NSUserDefaults.standardUserDefaults setBool:v.boolValue forKey:DSPAutosaveInputFieldKey];
	}];
	[view addSubview:thirdSwitch];
	
	self.view = view;
}

- (void)openCodafi:(id)sender {
	[NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://github.com/CodaFi"]];
}

- (void)openVanSchneider:(id)sender {
	[NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"http://www.vanschneider.com/"]];
}

- (void)openDotSnap:(id)semder {
	[NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"http://www.dotsnapapp.com/"]];
}

@end
