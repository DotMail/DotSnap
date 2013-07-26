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
@property (nonatomic, strong) RACSubject *canFireSubject;
@end

@implementation DSPMainViewController

- (id)initWithContentRect:(CGRect)rect {
	self = [super init];
	
	_contentFrame = rect;
	_viewModel = [DSPMainViewModel new];
	_canFireSubject = [RACSubject subject];
	_preferencesViewController = [[DSPPreferencesViewController alloc]initWithContentRect:(CGRect){ .size = { 400, 350 } } canFireSubject:_canFireSubject];
	[_canFireSubject sendNext:@YES];
	
	return self;
}

- (void)loadView {
	DSPMainView *view = [[DSPMainView alloc]initWithFrame:_contentFrame];
	view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	view.backgroundColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000];
	
	NSBox *windowShadow = [[NSBox alloc]initWithFrame:(NSRect){ .origin.y = NSHeight(_contentFrame) - 2, .size = { (NSWidth(_contentFrame)/2) - 10, 2 } }];
	windowShadow.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
	windowShadow.borderType = NSLineBorder;
	windowShadow.borderColor = [NSColor colorWithCalibratedRed:0.361 green:0.787 blue:0.568 alpha:1.000];
	windowShadow.fillColor = [NSColor colorWithCalibratedRed:0.361 green:0.787 blue:0.568 alpha:1.000];
	windowShadow.borderWidth = 2.f;
	windowShadow.boxType = NSBoxCustom;
	[view addSubview:windowShadow];
	
	NSBox *windowShadow2 = [[NSBox alloc]initWithFrame:(NSRect){ .origin.x = (NSWidth(_contentFrame)/2) + 10, .origin.y = NSHeight(_contentFrame) - 2, .size = { (NSWidth(_contentFrame)/2) - 10, 2 } }];
	windowShadow2.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
	windowShadow2.borderType = NSLineBorder;
	windowShadow2.borderColor = [NSColor colorWithCalibratedRed:0.361 green:0.787 blue:0.568 alpha:1.000];
	windowShadow2.fillColor = [NSColor colorWithCalibratedRed:0.361 green:0.787 blue:0.568 alpha:1.000];
	windowShadow2.borderWidth = 2.f;
	windowShadow2.boxType = NSBoxCustom;
	[view addSubview:windowShadow2];
	
	NSBox *separatorShadow = [[NSBox alloc]initWithFrame:(NSRect){ .origin.y = NSHeight(_contentFrame) - 146, .size = { NSWidth(_contentFrame), 2 } }];
	separatorShadow.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
	separatorShadow.borderType = NSLineBorder;
	separatorShadow.borderColor = [NSColor colorWithCalibratedRed:0.159 green:0.468 blue:0.307 alpha:1.000];
	separatorShadow.fillColor = [NSColor colorWithCalibratedRed:0.159 green:0.468 blue:0.307 alpha:1.000];
	separatorShadow.borderWidth = 2.f;
	separatorShadow.boxType = NSBoxCustom;
	[view addSubview:separatorShadow];
	
	NSBox *underSeparatorShadow = [[NSBox alloc]initWithFrame:(NSRect){ .origin.y = 2, .size = { NSWidth(_contentFrame), 2 } }];
	underSeparatorShadow.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
	underSeparatorShadow.borderType = NSLineBorder;
	underSeparatorShadow.borderColor = [NSColor colorWithCalibratedRed:0.159 green:0.468 blue:0.307 alpha:1.000];
	underSeparatorShadow.fillColor = [NSColor colorWithCalibratedRed:0.159 green:0.468 blue:0.307 alpha:1.000];
	underSeparatorShadow.borderWidth = 2.f;
	underSeparatorShadow.boxType = NSBoxCustom;
	[view addSubview:underSeparatorShadow];
	
	DSPMainView *fieldBackground = [[DSPMainView alloc]initWithFrame:(NSRect){ .origin.y = 4, .size = { NSWidth(_contentFrame), 60 } }];
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
	
	NSTextField *filenameField = [[NSTextField alloc]initWithFrame:(NSRect){ .origin.x = 30, .origin.y = 12, .size = { NSWidth(_contentFrame), 34 } }];
	filenameField.bezeled = NO;
	filenameField.drawsBackground = NO;
	filenameField.font = [NSFont fontWithName:@"HelveticaNeue" size:16.f];
	filenameField.textColor = [NSColor colorWithCalibratedRed:0.437 green:0.517 blue:0.559 alpha:1.000];
	filenameField.focusRingType = NSFocusRingTypeNone;
	filenameField.autoresizingMask = NSViewMinYMargin;
	[view addSubview:filenameField];
	
	NSButton *directoryButton = [[NSButton alloc]initWithFrame:(NSRect){ .origin.x = 36, .origin.y = NSHeight(_contentFrame) - 96, .size = { 48, 48 } }];
	directoryButton.rac_command = [RACCommand commandWithCanExecuteSignal:self.canFireSubject];
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

	NSButton *optionsButton = [[NSButton alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(_contentFrame) - 45, .origin.y = 24, .size = { 17, 17 } }];
	optionsButton.rac_command = [RACCommand commandWithCanExecuteSignal:self.canFireSubject];
	[optionsButton.rac_command subscribeNext:^(NSButton *_) {
		[filenameField resignFirstResponder];
		_preferencesViewController.view.alphaValue = 0.0f;
	
		[NSAnimationContext beginGrouping];
		[_preferencesViewController.view.animator setAlphaValue:1.f];
		[(DSPMainWindow *)view.window setFrame:(NSRect){ .origin.x = view.window.frame.origin.x, .origin.y = NSMaxY(view.window.screen.frame) - 374, .size = { 400, 350 } } display:YES animate:YES];

		[NSAnimationContext endGrouping];
		[self.canFireSubject sendNext:@NO];
	}];
	optionsButton.bordered = NO;
	optionsButton.buttonType = NSMomentaryChangeButton;
	optionsButton.image = [NSImage imageNamed:@"OptionsGear"];
	optionsButton.autoresizingMask = NSViewMinYMargin;
	[view addSubview:optionsButton];
	
	NSScrollView *scrollView = ({
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
		scrollView;
	});
	
	_preferencesViewController.view.alphaValue = 0.f;
	[view addSubview:_preferencesViewController.view];
	
	self.view = view;
	
	filenameField.stringValue = [NSUserDefaults.standardUserDefaults stringForKey:DSPDefaultFilenameTemplateKey];
	
	[NSNotificationCenter.defaultCenter addObserverForName:NSControlTextDidEndEditingNotification object:filenameField queue:nil usingBlock:^(NSNotification *note) {
		[filenameField resignFirstResponder];
		[scrollView removeFromSuperview];
		[self.viewModel addFilenameToHistory:filenameField.stringValue];
		optionsButton.image = [NSImage imageNamed:@"FilenameCheckmark.png"];
		[(DSPMainWindow *)view.window setFrame:(NSRect){ .origin.x = view.window.frame.origin.x, .origin.y = NSMaxY(view.window.screen.frame) - 244, .size = { 400, 224 } } display:YES animate:YES];
		fieldBackground.backgroundColor = [NSColor colorWithCalibratedRed:0.850 green:0.888 blue:0.907 alpha:1.000];

		double delayInSeconds = 0.5;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[NSAnimationContext beginGrouping];
			[[NSAnimationContext currentContext]setCompletionHandler:^{
				optionsButton.image = [NSImage imageNamed:@"OptionsGear"];
				[optionsButton.animator setAlphaValue:1.f];
			}];
			
			[optionsButton.animator setAlphaValue:0.f];
			[scrollView.animator setAlphaValue:0.f];
			
			[NSAnimationContext endGrouping];
		});
	}];

	__block typeof(self) bself = self;
	[NSNotificationCenter.defaultCenter addObserverForName:NSControlTextDidChangeNotification object:filenameField queue:nil usingBlock:^(NSNotification *note) {
		NSRect rect = (NSRect){ .origin.x = view.window.frame.origin.x, .origin.y = NSMaxY(view.window.screen.frame) - 474, .size = { 400, 450 } };
		if (!CGRectEqualToRect(rect, view.window.frame)) {
			[view addSubview:scrollView];
			[view setNeedsDisplay:YES];
			[(DSPMainWindow *)view.window setFrame:rect display:YES animate:YES];
			fieldBackground.backgroundColor = [NSColor whiteColor];
		}
		if (filenameField.stringValue.length == 0) {
			bself.viewModel.filename = @"Screen Shot";
		}
		bself.viewModel.filename = filenameField.stringValue;
	}];
	
	self.viewModel.filename = [NSUserDefaults.standardUserDefaults stringForKey:DSPDefaultFilenameTemplateKey];

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
