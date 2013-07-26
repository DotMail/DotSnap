//
//  DMLaunchServicesManager.h
//  Puissant
//
//  Created by Robert Widmann on 7/12/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSPLaunchServicesManager : NSObject

+ (instancetype)defaultManager;

- (void)insertCurrentApplicationInStartupItems:(BOOL)hideAtLaunch;
- (void)removeCurrentApplicationFromStartupItems;

@end
