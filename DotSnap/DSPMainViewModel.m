//
//  DSPMainViewModel.m
//  DotSnap
//
//  Created by Robert Widmann on 7/25/13.
//
//

#import "DSPMainViewModel.h"
#import "DSPHistoryRowView.h"

static NSUInteger const DPSUniqueFilenameDepthLimit = 500;

@interface DSPMainViewModel ()
@property (nonatomic, strong) NSMetadataQuery *screenshotQuery;
@property (nonatomic, strong) NSMutableArray *filenameHistory;
@end

@implementation DSPMainViewModel

#pragma mark - Lifecycle

- (id)init {
	self = [super init];
	
	_filenameHistory = [NSUserDefaults.standardUserDefaults arrayForKey:DSPFilenameHistoryKey].mutableCopy;
	
	_screenshotQuery = [[NSMetadataQuery alloc] init];
	_screenshotQuery.predicate = [NSPredicate predicateWithFormat:@"kMDItemIsScreenCapture = 1"];
	NSString *desktopPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	_screenshotQuery.searchScopes = @[ [NSURL fileURLWithPath:desktopPath] ];
	
	[NSNotificationCenter.defaultCenter addObserverForName:NSMetadataQueryDidUpdateNotification object:_screenshotQuery queue:nil usingBlock:^(NSNotification *note) {
		for (NSMetadataItem *item in [note.userInfo objectForKey:(NSString *)kMDQueryUpdateAddedItems]) {
			NSString *screenShotPath = [item valueForAttribute:NSMetadataItemPathKey];
			NSURL *oldURL = [NSURL fileURLWithPath:screenShotPath];
			
			__strong id args[1];
			args[0] = screenShotPath;
			NSTask *task = [NSTask launchedTaskWithLaunchPath:@"/sbin/lsof" arguments:[NSArray arrayWithObjects:(__strong id*)args count:1]];
			[task waitUntilExit];
			
			NSURL *newURL = [NSURL fileURLWithPath:DPSUniqueFilenameForDirectory(self.filepath, self.filename.stringByDeletingPathExtension, [NSUserDefaults.standardUserDefaults boolForKey:DSPAddsTimestampKey])];
			[NSFileManager.defaultManager moveItemAtURL:oldURL toURL:newURL error:nil];
		}
	}];
	
	[_screenshotQuery startQuery];
	
	return self;
}

- (void)addFilenameToHistory:(NSString *)filename {
	if (self.filenameHistory.count == 5) {
		[self.filenameHistory removeLastObject];
	}
	[self.filenameHistory insertObject:filename.copy atIndex:0];
	[NSUserDefaults.standardUserDefaults setObject:self.filenameHistory forKey:DSPFilenameHistoryKey];
}

#pragma mark - NSTableViewDatasource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return self.filenameHistory.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	return [self.filenameHistory objectAtIndex:row];
}

#pragma mark - Internal

+ (NSDateFormatter *)dateFormatter {
	static NSDateFormatter *dateFormatter = nil;
	if (!dateFormatter) {
		dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
		dateFormatter.dateFormat = @" yyyy-MM-dd 'at' HH.mm.ss a";
	}
	return dateFormatter;
}

static NSString *DPSUniqueFilenameForDirectory(NSString *relativePath, NSString *filename, BOOL timestamp) {
	NSError *error;
	NSSet *allURLs = [NSSet setWithArray:[NSFileManager.defaultManager contentsOfDirectoryAtPath:relativePath error:&error]];
	if (error) return nil;
	
	NSString *retVal = nil;
	if (timestamp) {
		filename = [filename stringByAppendingString:[[DSPMainViewModel dateFormatter] stringFromDate:NSDate.date]];
	}
	if (![allURLs containsObject:[NSString stringWithFormat:@"%@.png", filename]]) {
		return [relativePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", filename]];
	}
	for (NSUInteger i = 0; i < DPSUniqueFilenameDepthLimit; i++) {
		NSString *temp = [NSString stringWithFormat:@"%@-%lu.png", filename, i];
		if (![allURLs containsObject:temp]) {
			retVal = temp;
			break;
		}
	}
	return [relativePath stringByAppendingPathComponent:retVal];
}

@end
