//
//  DSPView.m
//  DotSnap
//
//  Created by Robert Widmann on 7/24/13.
//
//

#import "DSPMainView.h"

@implementation DSPMainView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];

	self.layer = CALayer.layer;
	self.layer.doubleSided = YES;
    self.wantsLayer = YES;
	
    return self;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
	self.layer.backgroundColor = backgroundColor.CGColor;
	[self.layer setNeedsDisplay];
}

@end
