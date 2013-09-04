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
@property (nonatomic, strong) NSMutableArray *filenameHistory;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSMetadataQuery *metadataQuery;
@end

@implementation DSPMainViewModel {
	NSUInteger previousChangeCount;
}

#pragma mark - Lifecycle

- (id)init {
	self = [super init];
	
	_filenameHistory = [NSUserDefaults.standardUserDefaults arrayForKey:DSPFilenameHistoryKey].mutableCopy;
	_startDate = NSDate.date;
	
	_metadataQuery = [[NSMetadataQuery alloc] init];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"kMDItemIsScreenCapture = YES"];
	_metadataQuery.predicate = predicate;
	_metadataQuery.searchScopes = @[ DSPScreenCaptureLocation() ];
	_metadataQuery.notificationBatchingInterval = 0.1f;
	_metadataQuery.delegate = self;
	[_metadataQuery startQuery];
	
	return self;
}

- (id)metadataQuery:(NSMetadataQuery *)query replacementObjectForResultObject:(NSMetadataItem *)result {
	if (!result) return result;
	NSDate *fsCreationDate = [result valueForAttribute:(__bridge NSString *)kMDItemFSCreationDate];
	NSDate *itemLastUseDate = [result valueForAttribute:(__bridge NSString *)kMDItemLastUsedDate];
	if ([fsCreationDate timeIntervalSinceDate:_startDate] < 0.0f || itemLastUseDate != nil) {
		return result;
	}
	if (itemLastUseDate != nil) return result;
	NSString *name = [result valueForAttribute:@"kMDItemDisplayName"];
	if (!name) return result;
	NSString *filePath = [result valueForAttribute:(__bridge NSString *)kMDItemPath];
	if (!filePath) return result;
	if (![NSFileManager.defaultManager fileExistsAtPath:filePath]) {
		return result;
	}
	
	NSURL *newURL = [NSURL fileURLWithPath:DPSUniqueFilenameForDirectory(self.filepath, self.filename.stringByDeletingPathExtension, [NSUserDefaults.standardUserDefaults boolForKey:DSPAddsTimestampKey])];
	NSURL *oldURL = [NSURL fileURLWithPath:filePath];
	NSError *err = nil;
	[NSFileManager.defaultManager moveItemAtURL:oldURL toURL:newURL error:&err];
	
	return result;
}

- (void)dealloc {
	[_metadataQuery stopQuery];
}

#pragma mark - Actions

- (void)addFilenameToHistory:(NSString *)filename {
	if (self.filenameHistory.count == 5) {
		[self.filenameHistory removeLastObject];
	}
	__block NSUInteger c = NSUIntegerMax;
	[self.filenameHistory enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
		if ([filename isEqualToString:obj]) {
			*stop = YES;
			c = idx;
		}
	}];
	if (c == NSUIntegerMax) [self.filenameHistory insertObject:filename.copy atIndex:0];
	[NSUserDefaults.standardUserDefaults setObject:self.filenameHistory forKey:DSPFilenameHistoryKey];
}

#pragma mark - Overrides

- (void)setFilepath:(NSString *)filepath {
	_filepath = filepath;
	[NSUserDefaults.standardUserDefaults setObject:filepath forKey:DSPDefaultFilePathKey];
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
	BOOL directory;
	BOOL fileExists = [NSFileManager.defaultManager fileExistsAtPath:relativePath isDirectory:&directory];
	if (!fileExists) [NSFileManager.defaultManager createDirectoryAtPath:relativePath withIntermediateDirectories:YES attributes:nil error:nil];
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

static NSString *DSPScreenCaptureLocation(void) {
	NSString *screenCapturePrefs = [DSPScreenCapturePrefs() objectForKey:@"location"];
	if (screenCapturePrefs) {
		if ([screenCapturePrefs.stringByExpandingTildeInPath hasSuffix:@"/"]) {
			return screenCapturePrefs;
		}
		return [screenCapturePrefs stringByAppendingString:@"/"];
	}
	return [[@"~/Desktop" stringByExpandingTildeInPath] stringByAppendingString:@"/"];
}

static NSDictionary *DSPScreenCapturePrefs(void) {
	return [NSUserDefaults.standardUserDefaults persistentDomainForName:@"com.apple.screencapture"];
}

@end
