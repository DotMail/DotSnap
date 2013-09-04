//
//  DMLaunchServicesManager.m
//  Puissant
//
//  Created by Robert Widmann on 7/12/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "DSPLaunchServicesManager.h"
#import <ServiceManagement/ServiceManagement.h>

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
	SMLoginItemSetEnabled((__bridge CFStringRef)(NSBundle.mainBundle.bundleIdentifier), true);
}

- (void)removeCurrentApplicationFromStartupItems {
	SMLoginItemSetEnabled((__bridge CFStringRef)(NSBundle.mainBundle.bundleIdentifier), false);
}

@end
