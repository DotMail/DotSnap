//
//  DSPMainViewController.m
//  DotSnap
//
//  Created by Robert Widmann on 7/24/13.
//
//

#import "DSPLabel.h"
#import "DSPMainView.h"
#import "DSPShadowBox.h"
#import "DSPMainWindow.h"
#import "DSPMainViewModel.h"
#import "DSPHistoryRowView.h"
#import "DSPBackgroundView.h"
#import "DSPHistoryTableView.h"
#import "DSPFilenameTextField.h"
#import "DSPPreferencesWindow.h"
#import "DSPMainViewController.h"
#import "DSPDirectoryPickerButton.h"
#import "DSPSpinningSettingsButton.h"
#import "DSPPreferencesViewController.h"
#import "LIFlipEffect.h"

static NSString *DSPScrubString(NSString *string) {
	NSString *cleanedString = string.stringByStandardizingPath.stringByAbbreviatingWithTildeInPath;
	if (cleanedString.pathComponents.count >= 2) {
		cleanedString = [[cleanedString.pathComponents objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(cleanedString.pathComponents.count - 2, 2)]]componentsJoinedByString:@"/"];
	}
	
	return cleanedString;
}

@interface DSPMainViewController ()
@property (nonatomic, strong, readonly) DSPMainViewModel *viewModel;
@property (nonatomic, strong) DSPPreferencesViewController *preferencesViewController;
@property (nonatomic, strong) DSPPreferencesWindow *preferencesWindow;
@property (nonatomic, copy) void (^carriageReturnBlock)();
@property (nonatomic, copy) void (^mouseDownBlock)(NSEvent *event);
@property (nonatomic, copy) void (^mouseEnteredBlock)(NSEvent *event, BOOL entered);
@property (nonatomic, strong) RACSubject *historySubject;
@end

@implementation DSPMainViewController {
	BOOL _exemptOpenPanelCancellation;
	BOOL _exemptFlagForAnimation;
}

#pragma mark - Lifecycle

- (id)initWithContentRect:(CGRect)rect {
	self = [super init];
	
	_contentFrame = rect;
	_viewModel = [DSPMainViewModel new];
	
	_preferencesViewController = [[DSPPreferencesViewController alloc]initWithContentRect:(CGRect){ .size = { 442, 372 } }];
	_preferencesWindow = [[DSPPreferencesWindow alloc]initWithView:self.preferencesViewController.view attachedToPoint:(NSPoint){ } onSide:MAPositionBottom];
	
	_historySubject = [RACSubject subject];
	
	return self;
}

- (void)loadView {
	DSPMainView *realView = [[DSPMainView alloc]initWithFrame:_contentFrame];
	realView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
		
	DSPBackgroundView *view = [[DSPBackgroundView alloc]initWithFrame:realView.contentRect];
	view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	view.backgroundColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000];
	[realView addSubview:view];
	
	DSPBackgroundTrackingView *backgroundView = [[DSPBackgroundTrackingView alloc]initWithFrame:(NSRect){ .origin.y = 36, .size = { NSWidth(_contentFrame), 150 } }];
	backgroundView.backgroundColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000];
	backgroundView.autoresizingMask = NSViewMinYMargin;
	[view addSubview:backgroundView];

	DSPShadowBox *windowShadow = [[DSPShadowBox alloc]initWithFrame:(NSRect){ .origin.y = NSHeight(_contentFrame) - 2, .size = { (NSWidth(_contentFrame)/2) - 10, 2 } }];
	[view addSubview:windowShadow];
	
	DSPShadowBox *windowShadow2 = [[DSPShadowBox alloc]initWithFrame:(NSRect){ .origin.x = (NSWidth(_contentFrame)/2) + 10, .origin.y = NSHeight(_contentFrame) - 2, .size = { (NSWidth(_contentFrame)/2) - 10, 2 } }];
	[view addSubview:windowShadow2];

	DSPShadowBox *separatorShadow = [[DSPShadowBox alloc]initWithFrame:(NSRect){ .origin.y = NSHeight(view.frame) - 138, .size = { NSWidth(_contentFrame), 2 } }];
	separatorShadow.borderColor = [NSColor colorWithCalibratedRed:0.159 green:0.468 blue:0.307 alpha:1.000];
	separatorShadow.fillColor = [NSColor colorWithCalibratedRed:0.159 green:0.468 blue:0.307 alpha:1.000];
	[view addSubview:separatorShadow];
	
	DSPShadowBox *underSeparatorShadow = [[DSPShadowBox alloc]initWithFrame:(NSRect){ .origin.y = 0, .size = { NSWidth(_contentFrame), 2 } }];
	underSeparatorShadow.autoresizingMask = NSViewMaxYMargin;
	underSeparatorShadow.borderColor = [NSColor colorWithCalibratedRed:0.168 green:0.434 blue:0.300 alpha:1.000];
	underSeparatorShadow.fillColor = [NSColor colorWithCalibratedRed:0.181 green:0.455 blue:0.315 alpha:1.000];
	[view addSubview:underSeparatorShadow];
	
	NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:(NSRect){ .origin.y = -270, .size = { 400, 246 } }];
	scrollView.autoresizingMask = NSViewMinYMargin;
	scrollView.layer = CALayer.layer;
	scrollView.wantsLayer = YES;
	scrollView.verticalScrollElasticity = NSScrollElasticityNone;
	DSPHistoryTableView *tableView = [[DSPHistoryTableView alloc] initWithFrame: scrollView.bounds];
	tableView.headerView = nil;
	tableView.focusRingType = NSFocusRingTypeNone;
	tableView.gridStyleMask = NSTableViewSolidHorizontalGridLineMask;
	NSTableColumn *firstColumn  = [[NSTableColumn alloc] initWithIdentifier:@"firstColumn"];
	firstColumn.editable = NO;
	firstColumn.width = CGRectGetWidth(view.bounds);
	[tableView addTableColumn:firstColumn];
	tableView.delegate = self;
	tableView.dataSource = self.viewModel;
	scrollView.documentView = tableView;
	tableView.enabled = NO;
	[scrollView setFrame:(NSRect){ .origin.y = 0, .size = { 400, 44 } }];
	[scrollView setAlphaValue:0.f];
	[view addSubview:scrollView];
	
	DSPBackgroundView *fieldBackground = [[DSPBackgroundView alloc]initWithFrame:(NSRect){ .origin.y = -12, .size = { NSWidth(_contentFrame), 60 } }];
	fieldBackground.layer = CALayer.layer;
	fieldBackground.wantsLayer = YES;
	fieldBackground.layer.borderColor = [NSColor colorWithCalibratedRed:0.794 green:0.840 blue:0.864 alpha:1.000].dsp_CGColor;
	fieldBackground.layer.borderWidth = 2.f;
	fieldBackground.backgroundColor = [NSColor colorWithCalibratedRed:0.850 green:0.888 blue:0.907 alpha:1.000];
	fieldBackground.autoresizingMask = NSViewMinYMargin;
	[view addSubview:fieldBackground];
	
	DSPLabel *changeFolderLabel = [[DSPLabel alloc]initWithFrame:(NSRect){ .origin.x = 96, .origin.y = NSHeight(backgroundView.frame) - 80, .size = { NSWidth(_contentFrame), 36 } }];
	changeFolderLabel.autoresizingMask = NSViewMinYMargin;
	changeFolderLabel.stringValue = @"Change Folder";
	[backgroundView addSubview:changeFolderLabel];
		
	DSPLabel *saveToLabel = [[DSPLabel alloc]initWithFrame:(NSRect){ .origin.x = 96, .origin.y = NSHeight(backgroundView.frame) - 115, .size = { NSWidth(_contentFrame), 34 } }];
	saveToLabel.autoresizingMask = NSViewMinYMargin;
	saveToLabel.font = [NSFont fontWithName:@"HelveticaNeue-Bold" size:11.f];
	saveToLabel.textColor = [NSColor colorWithCalibratedRed:0.171 green:0.489 blue:0.326 alpha:1.000];
	NSString *desktopPath = [NSUserDefaults.standardUserDefaults stringForKey:DSPDefaultFilePathKey];
	if ([desktopPath isEqualToString:@"@default"]) {
		desktopPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	}
	self.viewModel.filepath = desktopPath;
	saveToLabel.stringValue = [NSString stringWithFormat:@"SAVE TO: %@", DSPScrubString(desktopPath)];
	[backgroundView addSubview:saveToLabel];

	DSPFilenameTextField *filenameField = [[DSPFilenameTextField alloc]initWithFrame:(NSRect){ .origin.x = 30, .origin.y = -5, .size = { NSWidth(_contentFrame) - 84, 34 } }];
	filenameField.delegate = self;
	[view addSubview:filenameField];
	
	DSPDirectoryPickerButton *directoryButton = [[DSPDirectoryPickerButton alloc]initWithFrame:(NSRect){ .origin.x = 36, .origin.y = NSHeight(backgroundView.frame) - 96, .size = { 48, 48 } }];
	directoryButton.rac_command = [RACCommand command];
	[directoryButton.rac_command subscribeNext:^(NSButton *_) {
		((DSPMainWindow *)view.window).isInOpenPanel = YES;
		_exemptFlagForAnimation = YES;
		[self.openPanel beginSheetModalForWindow:view.window completionHandler:^(NSInteger result){
			((DSPMainWindow *)view.window).isInOpenPanel = NO;
			if (result == NSFileHandlingPanelOKButton) {
				NSArray *urls = [self.openPanel URLs];
				NSString *urlString = [[urls objectAtIndex:0] path];
				BOOL isDir;
				[NSFileManager.defaultManager fileExistsAtPath:urlString isDirectory:&isDir];
				if (isDir) {
					self.viewModel.filepath = urlString;
					saveToLabel.stringValue = [NSString stringWithFormat:@"SAVE TO: %@", DSPScrubString(urlString)];
				} else {
					self.viewModel.filepath = urlString.stringByDeletingLastPathComponent;
					saveToLabel.stringValue = [NSString stringWithFormat:@"SAVE TO: %@", DSPScrubString(urlString)];
				}
			} else {
				_exemptOpenPanelCancellation = YES;
			}
		}];
	}];
	[backgroundView addSubview:directoryButton];

	DSPSpinningSettingsButton *optionsButton = [[DSPSpinningSettingsButton alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(_contentFrame) - 45, .origin.y = 8, .size = { 17, 17 } } style:0];
	optionsButton.rac_command = [RACCommand command];
	[optionsButton.rac_command subscribeNext:^(NSButton *_) {
		[(DSPMainWindow *)view.window setIsFlipping:YES];
		self.preferencesViewController.presentingWindow = view.window;
		self.preferencesViewController.exemptForAnimation = _exemptFlagForAnimation;
		[[[LIFlipEffect alloc] initFromWindow:view.window toWindow:self.preferencesWindow flag:_exemptFlagForAnimation] run];
		[(DSPMainWindow *)view.window setIsFlipping:NO];
	}];
	[view addSubview:optionsButton];
	
	DSPShadowBox *historySeparatorShadow = [[DSPShadowBox alloc]initWithFrame:(NSRect){ .origin.y = -12, .size = { NSWidth(_contentFrame), 2 } }];
	historySeparatorShadow.borderColor = [NSColor colorWithCalibratedRed:0.794 green:0.840 blue:0.864 alpha:1.000];
	historySeparatorShadow.fillColor = [NSColor colorWithCalibratedRed:0.794 green:0.840 blue:0.864 alpha:1.000];
	historySeparatorShadow.alphaValue = 0.f;
	[view addSubview:historySeparatorShadow];
		
	self.view = realView;

	@unsafeify(self);
	[NSNotificationCenter.defaultCenter addObserverForName:NSControlTextDidChangeNotification object:filenameField queue:nil usingBlock:^(NSNotification *note) {
		@strongify(self);
		historySeparatorShadow.alphaValue = 0.f;
		fieldBackground.backgroundColor = [NSColor whiteColor];
		fieldBackground.layer.borderColor = [NSColor colorWithCalibratedRed:0.794 green:0.840 blue:0.864 alpha:1.000].dsp_CGColor;
		
		if (!CGSizeEqualToSize(view.window.frame.size, (CGSize){ 400, (self.viewModel.filenameHistory.count ? 214 : 224) + (60 * self.viewModel.filenameHistory.count) })) {
			[scrollView.documentView setEnabled:YES];
			
			[NSAnimationContext beginGrouping];
			
			NSRect scrollViewFrame = (NSRect){ .origin.y = NSMinY(fieldBackground.frame) - (60 * self.viewModel.filenameHistory.count), .size = { 400, (60 * self.viewModel.filenameHistory.count) } };
			[scrollView.animator setFrame:scrollViewFrame];
			[scrollView.animator setAlphaValue:self.viewModel.filenameHistory.count ? 1.f : 0.f];
			[NSAnimationContext.currentContext setCompletionHandler:^{
				NSRect rect = (NSRect){ .size = { 400, 214 + (60 * self.viewModel.filenameHistory.count) } };
				rect.origin = [(DSPMainWindow *)view.window originForNewFrame:rect];
				[(DSPMainWindow *)view.window setFrame:rect display:YES animate:YES];
				_exemptFlagForAnimation = YES;
			}];
			[NSAnimationContext endGrouping];
		}
	}];
	
	self.carriageReturnBlock = ^{
		@strongify(self);
		
		[tableView reloadData];
		
		historySeparatorShadow.alphaValue = 1.f;

		[filenameField resignFirstResponder];
		filenameField.enabled = NO;

		fieldBackground.backgroundColor = [NSColor colorWithCalibratedRed:0.850 green:0.888 blue:0.907 alpha:1.000];
		fieldBackground.layer.borderColor = [NSColor colorWithCalibratedRed:0.850 green:0.888 blue:0.907 alpha:1.000].dsp_CGColor;
		[optionsButton spinOut];

		[scrollView.documentView setEnabled:NO];
		
		[NSAnimationContext beginGrouping];
		[scrollView.animator setFrame:(NSRect){ .origin.y = 0, .size = { 400, 44 } }];
		[scrollView.animator setAlphaValue:0.f];
		
		NSRect rect = (NSRect){ .size = { 400, 214 } };
		rect.origin = [(DSPMainWindow *)view.window originForNewFrame:rect];
		[(DSPMainWindow *)view.window setFrame:rect display:YES animate:YES];
		[NSAnimationContext endGrouping];
		
		self.viewModel.filename = filenameField.stringValue;
	};
	
	self.mouseDownBlock = ^(NSEvent *theEvent) {
		if (CGRectContainsPoint(fieldBackground.frame, [theEvent locationInWindow]) && !CGRectContainsPoint(optionsButton.frame, [theEvent locationInWindow])) {
			filenameField.enabled = YES;
			[filenameField becomeFirstResponder];
			[NSNotificationCenter.defaultCenter postNotificationName:NSControlTextDidChangeNotification object:filenameField];
		} else {
			filenameField.enabled = NO;
			[filenameField resignFirstResponder];
			
			[scrollView.documentView setEnabled:YES];

			historySeparatorShadow.alphaValue = 0.f;
			fieldBackground.backgroundColor = [NSColor colorWithCalibratedRed:0.850 green:0.888 blue:0.907 alpha:1.000];
			fieldBackground.layer.borderColor = [NSColor colorWithCalibratedRed:0.850 green:0.888 blue:0.907 alpha:1.000].dsp_CGColor;

			if (CGRectContainsPoint(backgroundView.frame, [theEvent locationInWindow])) {
				[directoryButton.rac_command performSelector:@selector(execute:) withObject:@0 afterDelay:0.3];
			}
			
			if (!CGRectEqualToRect(scrollView.frame, (NSRect){ .origin.y = NSMinY(fieldBackground.frame) - 44, .size = { 400, 44 } })) {
				
				[NSAnimationContext beginGrouping];
				[scrollView.animator setFrame:(NSRect){ .origin.y = NSMinY(fieldBackground.frame) - 44, .size = { 400, 44 } }];
				[scrollView.animator setAlphaValue:0.f];
				
				NSRect rect = (NSRect){ .size = { 400, 214 } };
				rect.origin = [(DSPMainWindow *)view.window originForNewFrame:rect];
				[(DSPMainWindow *)view.window setFrame:rect display:YES animate:YES];
				[NSAnimationContext endGrouping];
			}
		}
	};
	
	self.mouseEnteredBlock = ^ (NSEvent *theEvent, BOOL entered) {
		if (entered) {
			[directoryButton mouseEntered:theEvent];
		} else {
			[directoryButton mouseExited:theEvent];
		}
	};
	
	self.viewModel.filename = [NSUserDefaults.standardUserDefaults stringForKey:DSPDefaultFilenameTemplateKey];
	[filenameField rac_liftSelector:@selector(setStringValue:) withSignals:self.historySubject, nil];
	[_historySubject sendNext:[NSUserDefaults.standardUserDefaults stringForKey:DSPDefaultFilenameTemplateKey]];
}

#pragma mark - Event Handling

- (void)mouseDown:(NSEvent *)theEvent {
	[super mouseDown:theEvent];
	self.mouseDownBlock(theEvent);
}

- (void)mouseEntered:(NSEvent *)theEvent {
	self.mouseEnteredBlock(theEvent, YES);
}

- (void)mouseExited:(NSEvent *)theEvent {
	self.mouseEnteredBlock(theEvent, NO);
}

- (void)windowDidResignKey:(NSNotification *)aNotification {
	if (!_exemptOpenPanelCancellation) {
		[NSApp endSheet:self.openPanel];
		[(DSPMainWindow *)self.view.window orderOutWithDuration:0.3 timing:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] animations:^(CALayer *layer) {
			layer.transform = CATransform3DMakeTranslation(0.f, -50.f, 0.f);
			layer.opacity = 0.f;
		}];
	}
	_exemptOpenPanelCancellation = NO;
}

#pragma mark - NSControlTextEditingDelegate

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
	if (commandSelector == @selector(insertNewline:)) {
		control.stringValue = textView.string ?: @"Screen Shot";
		[self.viewModel addFilenameToHistory:textView.string.length ? textView.string : @"Screen Shot"];
		self.carriageReturnBlock();
		return YES;
	} else if (commandSelector == @selector(cancelOperation:)) {
		self.mouseDownBlock(nil);
		return YES;
	}
	return NO;
}

- (void)controlTextDidChange:(NSNotification *)obj {
	
}

#pragma mark - NSTableViewDelegate

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	return 60.f;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	DSPHistoryRowView *tableCellView = (DSPHistoryRowView*)[tableView makeViewWithIdentifier:[tableColumn identifier] owner:self];
	return tableCellView;
}

- (void)tableView:(NSTableView *)tableView didAddRowView:(DSPHistoryRowView *)rowView forRow:(NSInteger)row {
	rowView.title = self.viewModel.filenameHistory[row];
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
	DSPHistoryRowView *rowView = [[DSPHistoryRowView alloc] initWithFrame:NSMakeRect(0, 0, NSWidth(_contentFrame), 110)];
	return rowView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
	NSTableView *table = notification.object;
	[self.historySubject sendNext:self.viewModel.filenameHistory[table.selectedRow]];
	self.carriageReturnBlock();
}

#pragma mark - Overrides

- (NSOpenPanel *)openPanel {
	static NSOpenPanel *panel;
	if (!panel) {
		panel = [NSOpenPanel openPanel];
		panel.canChooseDirectories = YES;
		panel.allowsMultipleSelection = NO;
		panel.canCreateDirectories = YES;
		[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(windowDidResignKey:) name:NSWindowDidResignKeyNotification object:panel];
	}
	return panel;
}

@end
