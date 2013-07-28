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

@interface DSPPreferencesViewController ()

@end

@implementation DSPPreferencesViewController

- (id)initWithContentRect:(CGRect)rect canFireSubject:(RACSubject *)canFireSubject {
	self = [super init];
	
	_contentRect = rect;
	_canFireSubject = canFireSubject;
	
	return self;
}

- (void)loadView {
	DSPMainView *view = [[DSPMainView alloc]initWithFrame:_contentRect];
	view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	view.backgroundColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000];
	
	DSPMainView *fieldBackground = [[DSPMainView alloc]initWithFrame:(NSRect){ .origin.y = 4, .size = { NSWidth(_contentRect), 150 } }];
	fieldBackground.backgroundColor = [NSColor colorWithCalibratedRed:0.850 green:0.888 blue:0.907 alpha:1.000];
	[view addSubview:fieldBackground];

	NSTextField *addTimestampLabel = [[NSTextField alloc]initWithFrame:(NSRect){ .origin.x = 24, .origin.y = 106, .size = { NSWidth(_contentRect), 36 } }];
	addTimestampLabel.bezeled = NO;
	addTimestampLabel.editable = NO;
	addTimestampLabel.drawsBackground = NO;
	addTimestampLabel.font = [NSFont fontWithName:@"HelveticaNeue" size:18.f];
	addTimestampLabel.textColor = [NSColor colorWithCalibratedRed:0.160 green:0.181 blue:0.215 alpha:1.000];
	addTimestampLabel.focusRingType = NSFocusRingTypeNone;
	addTimestampLabel.stringValue = @"Add Timestamp";
	[view addSubview:addTimestampLabel];
	
	NSBox *separatorShadow = [[NSBox alloc]initWithFrame:(NSRect){ .origin.y = 104, .size = { NSWidth(_contentRect), 1 } }];
	separatorShadow.borderType = NSLineBorder;
	separatorShadow.borderColor = [NSColor colorWithCalibratedRed:0.753 green:0.821 blue:0.849 alpha:1.000];
	separatorShadow.fillColor = [NSColor colorWithCalibratedRed:0.753 green:0.821 blue:0.849 alpha:1.000];
	separatorShadow.borderWidth = 1.f;
	separatorShadow.boxType = NSBoxCustom;
	[view addSubview:separatorShadow];
	
	NSTextField *loadDotsnapAtStartLabel = [[NSTextField alloc]initWithFrame:(NSRect){ .origin.x = 24, .origin.y = 54, .size = { NSWidth(_contentRect), 36 } }];
	loadDotsnapAtStartLabel.bezeled = NO;
	loadDotsnapAtStartLabel.editable = NO;
	loadDotsnapAtStartLabel.drawsBackground = NO;
	loadDotsnapAtStartLabel.font = [NSFont fontWithName:@"HelveticaNeue" size:18.f];
	loadDotsnapAtStartLabel.textColor = [NSColor colorWithCalibratedRed:0.160 green:0.181 blue:0.215 alpha:1.000];
	loadDotsnapAtStartLabel.focusRingType = NSFocusRingTypeNone;
	loadDotsnapAtStartLabel.stringValue = @"Load DotSnap on start";
	[view addSubview:loadDotsnapAtStartLabel];
	
	NSBox *separatorShadow2 = [[NSBox alloc]initWithFrame:(NSRect){ .origin.y = 52, .size = { NSWidth(_contentRect), 1 } }];
	separatorShadow2.borderType = NSLineBorder;
	separatorShadow2.borderColor = [NSColor colorWithCalibratedRed:0.753 green:0.821 blue:0.849 alpha:1.000];
	separatorShadow2.fillColor = [NSColor colorWithCalibratedRed:0.753 green:0.821 blue:0.849 alpha:1.000];
	separatorShadow2.borderWidth = 1.f;
	separatorShadow2.boxType = NSBoxCustom;
	[view addSubview:separatorShadow2];

	NSTextField *whateverLabel = [[NSTextField alloc]initWithFrame:(NSRect){ .origin.x = 24, .origin.y = 4, .size = { NSWidth(_contentRect), 36 } }];
	whateverLabel.bezeled = NO;
	whateverLabel.editable = NO;
	whateverLabel.drawsBackground = NO;
	whateverLabel.font = [NSFont fontWithName:@"HelveticaNeue" size:18.f];
	whateverLabel.textColor = [NSColor colorWithCalibratedRed:0.160 green:0.181 blue:0.215 alpha:1.000];
	whateverLabel.focusRingType = NSFocusRingTypeNone;
	whateverLabel.stringValue = @"Whatever";
	[view addSubview:whateverLabel];
	
	CALayer *logoLayer = CALayer.layer;
	logoLayer.contents = [NSImage imageNamed:@"DotSnapPreferencesLogo"];
	logoLayer.frame = (CGRect){ .origin.x = NSMidX(_contentRect) - 32, .origin.y = NSHeight(_contentRect) - 98, .size = { 62, 62 } };
	[view.layer addSublayer:logoLayer];
	
	NSButton *optionsButton = [[NSButton alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(_contentRect) - 28, .origin.y = NSHeight(_contentRect) - 42, .size = { 15, 15 } }];
	optionsButton.rac_command = [RACCommand commandWithCanExecuteSignal:[self.canFireSubject map:^id(NSNumber *value) {
		return @(!value.boolValue);
	}]];
	optionsButton.bordered = NO;
	optionsButton.buttonType = NSMomentaryChangeButton;
	optionsButton.image = [NSImage imageNamed:@"OptionsGearWhite"];
	[optionsButton.rac_command subscribeNext:^(NSButton *_) {
		[NSAnimationContext beginGrouping];
		[CATransaction begin];
		[CATransaction setAnimationDuration:0.3];
		[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
		
		[view.animator setAlphaValue:0.f];
		[(DSPMainWindow *)view.window setFrame:(NSRect){ .origin.x = view.window.frame.origin.x, .origin.y = view.window.frame.origin.y + 130, .size = { 400, 225 } } display:YES animate:YES];

		[CATransaction commit];
		[NSAnimationContext endGrouping];
		
		[self.canFireSubject sendNext:@YES];
	}];
	[view addSubview:optionsButton];
	
	CATextLayer *gistTextLayer = [[CATextLayer alloc]init];
	gistTextLayer.frame = (NSRect){ .origin = { 68, NSHeight(_contentRect) - 175 }, .size.width = NSWidth(_contentRect) - 136, .size.height = 62 };
	gistTextLayer.foregroundColor = NSColor.whiteColor.CGColor;
	gistTextLayer.font = CTFontCreateWithName(CFSTR("HelveticaNeue"), 14.f, NULL);
	gistTextLayer.fontSize = 14.f;
	gistTextLayer.alignmentMode = @"center";
	gistTextLayer.string = @".Snap is brought to you by \n Thomas Ragger, Tobias van Schneider, and Robert Widmann";
	[view.layer addSublayer:gistTextLayer];
	
	DSPSwitch *firstSwitch = [[DSPSwitch alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(_contentRect) - 120, .origin.y = 116, .size = { 80, 30 } }];
	firstSwitch.on = [NSUserDefaults.standardUserDefaults boolForKey:DSPAddsTimestampKey];
	[[RACObserve(firstSwitch,on) skip:1] subscribeNext:^(NSNumber *v) {
		[NSUserDefaults.standardUserDefaults setBool:v.boolValue forKey:DSPAddsTimestampKey];
	}];
	[view addSubview:firstSwitch];
	
	DSPSwitch *secondSwitch = [[DSPSwitch alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(_contentRect) - 120, .origin.y = 64, .size = { 80, 30 } }];
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
	
	DSPSwitch *thirdSwitch = [[DSPSwitch alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(_contentRect) - 120, .origin.y = 14, .size = { 80, 30 } }];
	[view addSubview:thirdSwitch];
	
	self.view = view;
}


@end
