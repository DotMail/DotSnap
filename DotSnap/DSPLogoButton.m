//
//  DSPLogoButton.m
//  DotSnap
//
//  Created by Robert Widmann on 8/18/13.
//
//

#import "DSPLogoButton.h"

@interface DSPLogoButton ()
@property (nonatomic, copy) void (^viewDidMoveToWindowBlock)();
@end

@implementation DSPLogoButton

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	
	self.layer = CALayer.layer;
	self.wantsLayer = YES;
	
	self.bordered = NO;
	self.buttonType = NSMomentaryChangeButton;
	
	CALayer *logoLayer = CALayer.layer;
	logoLayer.frame = self.bounds;
	[self.layer addSublayer:logoLayer];
	
	self.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal return:input];
	}];
	
	@weakify(self);
	self.viewDidMoveToWindowBlock = ^{
		@strongify(self);
		CGFloat scaleFactor = self.window.backingScaleFactor;
		logoLayer.contentsScale = scaleFactor;
		logoLayer.contents = [NSImage imageNamed:@"PreferencesLogo"];
	};
	
	return self;
}

- (void)resetCursorRects {
	[self addCursorRect:self.bounds cursor:NSCursor.pointingHandCursor];
}

- (void)viewDidMoveToWindow {
	[super viewDidMoveToWindow];
	self.viewDidMoveToWindowBlock();
}

@end
