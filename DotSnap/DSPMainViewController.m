//
//  DSPMainViewController.m
//  DotSnap
//
//  Created by Robert Widmann on 7/24/13.
//
//

#import "DSPMainViewController.h"
#import "DSPPreferencesViewController.h"
#import "DSPMainView.h"
#import "DSPMainWindow.h"
#import "DSPMainViewModel.h"

@interface DSPMainViewController ()
@property (nonatomic, strong, readonly) DSPMainViewModel *viewModel;
@property (nonatomic, strong) DSPPreferencesViewController *preferencesViewController;
@end

@implementation DSPMainViewController

- (id)initWithContentRect:(CGRect)rect {
	self = [super init];
	
	_contentFrame = rect;
	_viewModel = [DSPMainViewModel new];
	_preferencesViewController = [[DSPPreferencesViewController alloc]initWithContentRect:(CGRect){ .size = { 400, 350 } }];
	
	return self;
}

- (void)loadView {
	DSPMainView *view = [[DSPMainView alloc]initWithFrame:_contentFrame];
	view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	view.backgroundColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000];
	
	NSBox *separatorShadow = [[NSBox alloc]initWithFrame:(NSRect){ .origin.y = NSHeight(_contentFrame) - 136, .size = { NSWidth(_contentFrame), 2 } }];
	separatorShadow.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
	separatorShadow.borderType = NSLineBorder;
	separatorShadow.borderColor = [NSColor colorWithCalibratedRed:0.159 green:0.468 blue:0.307 alpha:1.000];
	separatorShadow.fillColor = [NSColor colorWithCalibratedRed:0.159 green:0.468 blue:0.307 alpha:1.000];
	separatorShadow.borderWidth = 2.f;
	separatorShadow.boxType = NSBoxCustom;
	[view addSubview:separatorShadow];
	
	DSPMainView *fieldBackground = [[DSPMainView alloc]initWithFrame:(NSRect){ .origin.y = 4, .size = { NSWidth(_contentFrame), 64 } }];
	fieldBackground.backgroundColor = [NSColor colorWithCalibratedRed:0.850 green:0.888 blue:0.907 alpha:1.000];
	fieldBackground.autoresizingMask = NSViewMinYMargin;
	[view addSubview:fieldBackground];
	
	NSTextField *changeFolderLabel = [[NSTextField alloc]initWithFrame:(NSRect){ .origin.x = 96, .origin.y = NSHeight(_contentFrame) - 80, .size = { NSWidth(_contentFrame), 36 } }];
	changeFolderLabel.bezeled = NO;
	changeFolderLabel.editable = NO;
	changeFolderLabel.drawsBackground = NO;
	changeFolderLabel.font = [NSFont fontWithName:@"HelveticaNeue" size:30.f];
	changeFolderLabel.textColor = [NSColor whiteColor];
	changeFolderLabel.focusRingType = NSFocusRingTypeNone;
	changeFolderLabel.stringValue = @"Change Folder";
	changeFolderLabel.autoresizingMask = NSViewMinYMargin;
	[view addSubview:changeFolderLabel];
		
	NSTextField *saveToLabel = [[NSTextField alloc]initWithFrame:(NSRect){ .origin.x = 96, .origin.y = NSHeight(_contentFrame) - 110, .size = { NSWidth(_contentFrame), 34 } }];
	saveToLabel.bezeled = NO;
	saveToLabel.editable = NO;
	saveToLabel.drawsBackground = NO;
	saveToLabel.font = [NSFont fontWithName:@"HelveticaNeue" size:12.f];
	saveToLabel.textColor = [NSColor colorWithCalibratedRed:0.171 green:0.489 blue:0.326 alpha:1.000];
	saveToLabel.focusRingType = NSFocusRingTypeNone;
	NSString *desktopPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	self.viewModel.filepath = desktopPath;
	saveToLabel.stringValue = [NSString stringWithFormat:@"Save To: %@", desktopPath];
	saveToLabel.autoresizingMask = NSViewMinYMargin;
	[view addSubview:saveToLabel];
	
	NSTextField *filenameField = [[NSTextField alloc]initWithFrame:(NSRect){ .origin.x = 30,.origin.y = 14, .size = { NSWidth(_contentFrame), 34 } }];
	filenameField.bezeled = NO;
	filenameField.drawsBackground = NO;
	filenameField.font = [NSFont fontWithName:@"HelveticaNeue" size:16.f];
	filenameField.textColor = [NSColor colorWithCalibratedRed:0.437 green:0.517 blue:0.559 alpha:1.000];
	filenameField.focusRingType = NSFocusRingTypeNone;
	filenameField.autoresizingMask = NSViewMinYMargin;
	[view addSubview:filenameField];
	
	NSButton *directoryButton = [[NSButton alloc]initWithFrame:(NSRect){ .origin.x = 36, .origin.y = NSHeight(_contentFrame) - 96, .size = { 48, 48 } }];
	directoryButton.rac_command = RACCommand.command;
	[directoryButton.rac_command subscribeNext:^(NSButton *_) {
		((DSPMainWindow *)view.window).isInOpenPanel = YES;
		[self.openPanel beginSheetModalForWindow:view.window completionHandler:^(NSInteger result){
			((DSPMainWindow *)view.window).isInOpenPanel = NO;
			if (result == NSFileHandlingPanelOKButton) {
				NSArray *urls = [self.openPanel URLs];
				NSString *urlString = [[urls objectAtIndex:0] path];
				BOOL isDir;
				[NSFileManager.defaultManager fileExistsAtPath:urlString isDirectory:&isDir];
				if (isDir) {
					self.viewModel.filepath = urlString;
					saveToLabel.stringValue = [NSString stringWithFormat:@"Save To: %@", urlString.stringByStandardizingPath.stringByAbbreviatingWithTildeInPath];
				} else {
					self.viewModel.filepath = urlString.stringByDeletingLastPathComponent;
					saveToLabel.stringValue = [NSString stringWithFormat:@"Save To: %@", urlString.stringByDeletingLastPathComponent.stringByStandardizingPath.stringByAbbreviatingWithTildeInPath];
				}
			}
		}];
	}];
	directoryButton.autoresizingMask = NSViewMinYMargin;
	directoryButton.bordered = NO;
	directoryButton.buttonType = NSMomentaryChangeButton;
	directoryButton.image = [NSImage imageNamed:@"DirectoryPickerArrow"];
	[view addSubview:directoryButton];
	
	NSButton *optionsButton = [[NSButton alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(_contentFrame) - 45, .origin.y = 26, .size = { 17, 17 } }];
	optionsButton.rac_command = RACCommand.command;
	[optionsButton.rac_command subscribeNext:^(NSButton *_) {
		[filenameField resignFirstResponder];
		_preferencesViewController.view.alphaValue = 0.0f;
		[view addSubview:_preferencesViewController.view];
	
		[NSAnimationContext beginGrouping];
		[CATransaction begin];
		[CATransaction setAnimationDuration:0.3];
		[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
		
		[_preferencesViewController.view.animator setAlphaValue:1.f];
		
		[CATransaction commit];
		[NSAnimationContext endGrouping];
		
		[(DSPMainWindow *)view.window setFrame:(NSRect){ .origin.x = view.window.frame.origin.x, .origin.y = NSMaxY(view.window.screen.frame) - 374, .size = { 400, 350 } } withDuration:0.3f timing:nil];
	}];
	optionsButton.bordered = NO;
	optionsButton.buttonType = NSMomentaryChangeButton;
	optionsButton.image = [NSImage imageNamed:@"OptionsGear"];
	optionsButton.autoresizingMask = NSViewMinYMargin;
	[view addSubview:optionsButton];
	
	NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:view.bounds];
	scrollView.hasVerticalScroller = YES;
	[scrollView setAlphaValue:0.f];
	NSTableView *tableView = [[NSTableView alloc] initWithFrame: scrollView.bounds];
	[tableView setHeaderView:nil];
	tableView.focusRingType = NSFocusRingTypeNone;
	NSTableColumn *firstColumn  = [[NSTableColumn alloc] initWithIdentifier:@"firstColumn"];
	firstColumn.editable = NO;
	firstColumn.width = CGRectGetWidth(view.bounds);
    [tableView  addTableColumn:firstColumn];
	tableView.delegate = self.viewModel;
	tableView.dataSource = self.viewModel;
	scrollView.documentView = tableView;
	[tableView.enclosingScrollView setDrawsBackground:NO];
		
	self.view = view;
	
	filenameField.stringValue = [NSUserDefaults.standardUserDefaults stringForKey:DSPDefaultFilenameTemplateKey];
	
	[NSNotificationCenter.defaultCenter addObserverForName:NSControlTextDidEndEditingNotification object:filenameField queue:nil usingBlock:^(NSNotification *note) {
		[filenameField resignFirstResponder];
		[scrollView removeFromSuperview];
		[self.viewModel addFilenameToHistory:filenameField.stringValue];
		optionsButton.image = [NSImage imageNamed:@"FilenameCheckmark.png"];
		[(DSPMainWindow *)view.window setFrame:(NSRect){ .origin.x = view.window.frame.origin.x, .origin.y = NSMaxY(view.window.screen.frame) - 230, .size = { 400, 205 } } withDuration:0.3f timing:nil];
		double delayInSeconds = 0.5;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[NSAnimationContext beginGrouping];
			[CATransaction begin];
			[CATransaction setCompletionBlock:^{
				optionsButton.image = [NSImage imageNamed:@"OptionsGear"];
				[NSAnimationContext beginGrouping];
				[CATransaction begin];
				[CATransaction setAnimationDuration:0.3];
				[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
				
				[optionsButton.animator setAlphaValue:1.f];
				
				[CATransaction commit];
				[NSAnimationContext endGrouping];

			}];
			[CATransaction setAnimationDuration:0.3];
			[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
			
			[optionsButton.animator setAlphaValue:0.f];
			[scrollView.animator setAlphaValue:0.f];
			
			[CATransaction commit];
			[NSAnimationContext endGrouping];
		});
	}];

	__block typeof(self) bself = self;
	[NSNotificationCenter.defaultCenter addObserverForName:NSControlTextDidChangeNotification object:filenameField queue:nil usingBlock:^(NSNotification *note) {
		NSRect rect = (NSRect){ .origin.x = view.window.frame.origin.x, .origin.y = NSMaxY(view.window.screen.frame) - 474, .size = { 400, 450 } };
		if (!CGRectEqualToRect(rect, view.window.frame)) {
			[view addSubview:scrollView];
			[view setNeedsDisplay:YES];
			[(DSPMainWindow *)view.window setFrame:rect withDuration:0.3f timing:nil];
			
		}
		if (filenameField.stringValue.length == 0) {
			bself.viewModel.filename = @"Screen Shot";
		}
		bself.viewModel.filename = filenameField.stringValue;
	}];
}

- (NSOpenPanel *)openPanel {
	static NSOpenPanel *panel;
	if (panel == nil) {
		panel = [NSOpenPanel openPanel];
		[panel setCanChooseDirectories:YES];
		[panel setAllowsMultipleSelection:NO];
		[panel setBecomesKeyOnlyIfNeeded:YES];
		[panel setCanCreateDirectories:YES];
		[panel setMessage:@"Import one or more files or directories."];
	}
	return panel;
}

@end
