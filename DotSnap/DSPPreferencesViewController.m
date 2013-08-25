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
#import "DSPPreferencesFieldBackgroundView.h"
#import "DSPLaunchServicesManager.h"
#import "DSPSpinningSettingsButton.h"
#import "DSPGlowingNameButton.h"
#import "DSPPreferencesShadowBox.h"
#import "DSPLabel.h"
#import "DSPLogoButton.h"
#import "LIFlipEffect.h"

@implementation DSPPreferencesViewController {
	BOOL _showingVersion;
	CGRect _contentRect;
}

- (id)initWithContentRect:(CGRect)rect {
	self = [super init];
	
	_contentRect = rect;
	
	return self;
}

- (void)loadView {
	
	CTFontRef helveticaNeue = CTFontCreateWithName(CFSTR("HelveticaNeue"), 18.f, NULL);
	
	DSPMainView *realView = [[DSPMainView alloc]initWithFrame:_contentRect];
	realView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	
	DSPBackgroundView *view = [[DSPBackgroundView alloc]initWithFrame:realView.contentRect];
	view.autoresizingMask  = NSViewWidthSizable | NSViewHeightSizable;
	[realView addSubview:view];
	
	DSPPreferencesFieldBackgroundView *fieldBackground = [[DSPPreferencesFieldBackgroundView alloc]initWithFrame:(NSRect){ .origin.y = 4, .size = { NSWidth(_contentRect), 166 } }];
	fieldBackground.backgroundColor = [NSColor colorWithCalibratedRed:0.850 green:0.888 blue:0.907 alpha:1.000];
	[view addSubview:fieldBackground];

	DSPLabel *addTimestampLabel = [[DSPLabel alloc]initWithFrame:(NSRect){ .origin.x = 22, .origin.y = 118, .size = { NSWidth(_contentRect), 36 } }];
	addTimestampLabel.font = [NSFont fontWithName:@"HelveticaNeue-Medium" size:18.f];
	addTimestampLabel.textColor = [NSColor colorWithCalibratedRed:0.160 green:0.181 blue:0.215 alpha:1.000];
	addTimestampLabel.stringValue = @"Add Timestamp";
	[view addSubview:addTimestampLabel];
	
	DSPPreferencesShadowBox *separatorShadow = [[DSPPreferencesShadowBox alloc]initWithFrame:(NSRect){ .origin.y = 96, .size = { NSWidth(_contentRect), 4 } }];
	[view addSubview:separatorShadow];
	
	DSPLabel *loadDotsnapAtStartLabel = [[DSPLabel alloc]initWithFrame:(NSRect){ .origin.x = 22, .origin.y = 62, .size = { NSWidth(_contentRect), 36 } }];
	loadDotsnapAtStartLabel.font = [NSFont fontWithName:@"HelveticaNeue-Medium" size:18.f];
	loadDotsnapAtStartLabel.textColor = [NSColor colorWithCalibratedRed:0.160 green:0.181 blue:0.215 alpha:1.000];
	loadDotsnapAtStartLabel.stringValue = @"Load DotSnap on start";
	[view addSubview:loadDotsnapAtStartLabel];
	
	DSPPreferencesShadowBox *separatorShadow2 = [[DSPPreferencesShadowBox alloc]initWithFrame:(NSRect){ .origin.y = 40, .size = { NSWidth(_contentRect), 4 } }];
	[view addSubview:separatorShadow2];

	DSPLabel *autosaveInputLabel = [[DSPLabel alloc]initWithFrame:(NSRect){ .origin.x = 22, .origin.y = 6, .size = { NSWidth(_contentRect), 36 } }];
	autosaveInputLabel.font = [NSFont fontWithName:@"HelveticaNeue-Medium" size:18.f];
	autosaveInputLabel.textColor = [NSColor colorWithCalibratedRed:0.160 green:0.181 blue:0.215 alpha:1.000];
	autosaveInputLabel.stringValue = @"Autosave Input";
	[view addSubview:autosaveInputLabel];
	
	CATextLayer *versionTextLayer = [[CATextLayer alloc]init];
	versionTextLayer.frame = (NSRect){ NSMidX(_contentRect) - 100, .origin.y = NSHeight(_contentRect) - 104, .size.width = 200, .size.height = 24 };
	versionTextLayer.foregroundColor = [NSColor colorWithCalibratedRed:0.136 green:0.407 blue:0.264 alpha:1.000].dsp_CGColor;
	versionTextLayer.font = helveticaNeue;
	versionTextLayer.fontSize = 16.f;
	versionTextLayer.alignmentMode = @"center";
	versionTextLayer.string = [NSString stringWithFormat:@"Version %@", [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"]];
	versionTextLayer.opacity = 0.f;
	[view.layer addSublayer:versionTextLayer];
	
	DSPLogoButton *logoButton = [[DSPLogoButton alloc]initWithFrame:(CGRect){ .origin.x = NSMidX(_contentRect) - 32, .origin.y = NSHeight(_contentRect) - 100, .size = { 62, 62 } }];
	[logoButton.rac_command subscribeNext:^(id x) {
		if (!_showingVersion) {
			[NSAnimationContext beginGrouping];
			[NSAnimationContext.currentContext setDuration:0.5];
			[logoButton.animator setFrame:NSOffsetRect(logoButton.frame, 0, 20)];
			versionTextLayer.opacity = 1.f;
			[NSAnimationContext endGrouping];
		} else {
			[NSAnimationContext beginGrouping];
			[NSAnimationContext.currentContext setDuration:0.5];
			[logoButton.animator setFrame:NSOffsetRect(logoButton.frame, 0, -20)];
			versionTextLayer.opacity = 0.f;
			[NSAnimationContext endGrouping];
		}
		_showingVersion = !_showingVersion;
	}];
	[view addSubview:logoButton];

	DSPSpinningSettingsButton *optionsButton = [[DSPSpinningSettingsButton alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(_contentRect) - 28, .origin.y = NSHeight(_contentRect) - 38, .size = { 17, 17 } } style:1];
	optionsButton.rac_command = [RACCommand command];
	optionsButton.bordered = NO;
	optionsButton.buttonType = NSMomentaryChangeButton;
	optionsButton.image = [NSImage imageNamed:@"OptionsGearWhite"];
	
	[optionsButton.rac_command subscribeNext:^(NSButton *_) {
		[[[LIFlipEffect alloc] initFromWindow:view.window toWindow:self.presentingWindow flag:_exemptForAnimation ? -1 : 0] run];
	}];
	[view addSubview:optionsButton];
	
	DSPGlowingNameButton *dotsnapNameButton = [[DSPGlowingNameButton alloc]initWithFrame:(NSRect){ .origin = { 114, NSHeight(fieldBackground.frame) + 54 }, .size.width =  72, .size.height = 24 } name:@".Snap"];
	dotsnapNameButton.target = self;
	dotsnapNameButton.action = @selector(openDotSnap:);
	[view addSubview:dotsnapNameButton];
	
	CATextLayer *gistTextLayer = [[CATextLayer alloc]init];
	gistTextLayer.frame = (NSRect){ .origin = { 36, NSHeight(fieldBackground.frame) + 70 }, .size.width = NSWidth(_contentRect) - 72, .size.height = 24 };
	gistTextLayer.foregroundColor = NSColor.whiteColor.dsp_CGColor;
	gistTextLayer.font = helveticaNeue;
	gistTextLayer.fontSize = 18.f;
	gistTextLayer.alignmentMode = @"center";
	gistTextLayer.string = @"          is brought to you by";
	[view.layer addSublayer:gistTextLayer];
	
	DSPGlowingNameButton *tobiasNameButton = [[DSPGlowingNameButton alloc]initWithFrame:(NSRect){ .origin = { 76, NSHeight(fieldBackground.frame) + 34 }, .size.width =  200, .size.height = 24 } name:@"Tobias van Schneider"];
	tobiasNameButton.target = self;
	tobiasNameButton.action = @selector(openVanSchneider:);
	[view addSubview:tobiasNameButton];
	
	CATextLayer *andTextLayer = [[CATextLayer alloc]init];
	andTextLayer.frame = (NSRect){ .origin = { 252, NSHeight(fieldBackground.frame) + 50 }, .size.width = 36, .size.height = 24 };
	andTextLayer.foregroundColor = NSColor.whiteColor.dsp_CGColor;
	andTextLayer.font = helveticaNeue;
	andTextLayer.fontSize = 18.f;
	andTextLayer.alignmentMode = @"left";
	andTextLayer.string = @"and";
	[view.layer addSublayer:andTextLayer];
	
	DSPGlowingNameButton *codafiNameButton = [[DSPGlowingNameButton alloc]initWithFrame:(NSRect){ .origin = { 288, NSHeight(fieldBackground.frame) + 34 }, .size.width =  72, .size.height = 24 } name:@"CodaFi"];
	codafiNameButton.target = self;
	codafiNameButton.action = @selector(openCodafi:);
	[view addSubview:codafiNameButton];
	
	DSPSwitch *firstSwitch = [[DSPSwitch alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(_contentRect) - 102, .origin.y = NSMaxY(separatorShadow.frame) + 28, .size = { 84, 30 } }];
	firstSwitch.on = [NSUserDefaults.standardUserDefaults boolForKey:DSPAddsTimestampKey];
	[[RACObserve(firstSwitch,on) skip:1] subscribeNext:^(NSNumber *v) {
		[NSUserDefaults.standardUserDefaults setBool:v.boolValue forKey:DSPAddsTimestampKey];
	}];
	[view addSubview:firstSwitch];
	
	DSPSwitch *secondSwitch = [[DSPSwitch alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(_contentRect) - 102, .origin.y = NSMaxY(separatorShadow2.frame) + 26, .size = { 84, 30 } }];
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
	
	DSPSwitch *thirdSwitch = [[DSPSwitch alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(_contentRect) - 102, .origin.y = 16, .size = { 84, 30 } }];
	thirdSwitch.on = [NSUserDefaults.standardUserDefaults boolForKey:DSPAutosaveInputFieldKey];
	[[RACObserve(thirdSwitch,on) skip:1] subscribeNext:^(NSNumber *v) {
		[NSUserDefaults.standardUserDefaults setBool:v.boolValue forKey:DSPAutosaveInputFieldKey];
	}];
	[view addSubview:thirdSwitch];
	
	DSPShadowBox *underSeparatorShadow = [[DSPShadowBox alloc]initWithFrame:(NSRect){ .origin.y = -16, .size = { NSWidth(_contentRect), 2 } }];
	underSeparatorShadow.borderColor = [NSColor colorWithCalibratedRed:0.168 green:0.434 blue:0.300 alpha:1.000];
	underSeparatorShadow.fillColor = [NSColor colorWithCalibratedRed:0.181 green:0.455 blue:0.315 alpha:1.000];
	[view addSubview:underSeparatorShadow];
	
	@weakify(realView);
	realView.viewDidMoveToWindowBlock = ^{
		@strongify(realView);
		CGFloat scaleFactor = realView.window.backingScaleFactor;
		versionTextLayer.contentsScale = scaleFactor;
		gistTextLayer.contentsScale = scaleFactor;
		andTextLayer.contentsScale = scaleFactor;
	};
	
	self.view = realView;
	
	CFRelease(helveticaNeue);
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
