//
//  DSPBackgroundView.h
//  DotSnap
//
//  Created by Robert Widmann on 8/11/13.
//
//

#import <Cocoa/Cocoa.h>

@interface DSPBackgroundView : NSView
@property (nonatomic, strong) NSColor *backgroundColor;
@end

@interface DSPBackgroundTrackingView : DSPBackgroundView
@end