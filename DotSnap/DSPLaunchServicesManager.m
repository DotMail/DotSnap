//
//  DMLaunchServicesManager.m
//  Puissant
//
//  Created by Robert Widmann on 7/12/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "DSPLaunchServicesManager.h"

#if MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_6
static NSString * const kLSSharedFileListLoginItemHidden = @"com.apple.loginitem.HideOnLaunch";
#endif

@interface DSPLaunchServicesManager ()
@property (nonatomic, copy) NSString *bundlePath;
@property (nonatomic, copy) NSString *bundleID;
@end

@implementation DSPLaunchServicesManager

+ (instancetype)defaultManager {
	static DSPLaunchServicesManager *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[DSPLaunchServicesManager alloc]init];
	});
	return instance;
}

- (id)init {
	self = [super init];
	
	_bundlePath = NSBundle.mainBundle.bundlePath;
	_bundleID = NSBundle.mainBundle.bundleIdentifier;

	return self;
}

- (void)insertCurrentApplicationInStartupItems:(BOOL)hideAtLaunch {
	CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:_bundlePath];
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	if (loginItems) {
		NSDictionary *propertiesToSet = @{ (__bridge id)kLSSharedFileListLoginItemHidden : @(hideAtLaunch) };
		LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemLast, NULL, NULL, url, (__bridge CFDictionaryRef)propertiesToSet, NULL);
		if (item){
			CFRelease(item);
		}
	}
	CFRelease(loginItems);
}

- (void)removeCurrentApplicationFromStartupItems {
	CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:_bundlePath];
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	
	if (loginItems) {
		UInt32 seedValue;
		NSArray  *loginItemsArray = (__bridge NSArray *)LSSharedFileListCopySnapshot(loginItems, &seedValue);
		for(int i = 0; i< [loginItemsArray count]; i++){
			LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)[loginItemsArray objectAtIndex:i];
			if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &url, NULL) == noErr) {
				NSString * urlPath = [(__bridge NSURL *)url path];
				if ([urlPath compare:_bundlePath] == NSOrderedSame){
					LSSharedFileListItemRemove(loginItems,itemRef);
				}
			}
		}
	}
}

@end
