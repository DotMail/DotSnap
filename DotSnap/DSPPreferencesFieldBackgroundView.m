//
//  DSPPreferencesFieldBackgroundView.m
//  DotSnap
//
//  Created by Robert Widmann on 8/14/13.
//
//

#import "DSPPreferencesFieldBackgroundView.h"

@implementation DSPPreferencesFieldBackgroundView

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	CGContextSetRGBFillColor(ctx, 0.912, 0.905, 0.951, 1.000);
	CGContextFillRect(ctx, CGRectMake(0, NSHeight(self.bounds) - 2, NSWidth(self.bounds), 1));
	
	CGContextSetRGBFillColor(ctx, 0.889, 0.927, 0.941, 1.000);
	CGContextFillRect(ctx, CGRectMake(1, 0, 1, NSHeight(self.bounds)));
	CGContextFillRect(ctx, CGRectMake(NSWidth(self.bounds) - 2, 0, 1, NSHeight(self.bounds)));
}

@end
