//
//  DSPHistoryCell.m
//  DotSnap
//
//  Created by Robert Widmann on 7/26/13.
//
//

#import "DSPHistoryRowView.h"

@interface DSPHistoryRowView ()
@property (nonatomic, strong) NSTextField *textField;
@end

@implementation DSPHistoryRowView {
	NSTrackingArea *trackingArea;
}

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	self.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
	
	_textField = [[NSTextField alloc]initWithFrame:(NSRect){ .origin.x = 30, .origin.y = 16, .size = { NSWidth(self.bounds), 34 } }];
	_textField.bezeled = NO;
	_textField.editable = NO;
	_textField.drawsBackground = NO;
	_textField.font = [NSFont fontWithName:@"HelveticaNeue" size:16.f];
	_textField.textColor = [NSColor colorWithCalibratedRed:0.437 green:0.517 blue:0.559 alpha:1.000];
	_textField.focusRingType = NSFocusRingTypeNone;
	[self addSubview:_textField];
	
	[_textField rac_liftSelector:@selector(setStringValue:) withSignals:[RACObserve(self,title) filter:^BOOL(id value) {
		return value != nil;
	}], nil];
	
	return self;
}

- (void)drawBackgroundInRect:(NSRect)dirtyRect {
	
	[self.highlighted ? NSColor.whiteColor : [NSColor colorWithCalibratedRed:0.917 green:0.936 blue:0.946 alpha:1.000]set];
	NSRectFill(dirtyRect);
}

- (void)setHighlighted:(BOOL)highlighted {
	_highlighted = highlighted;
	if (highlighted) {
		self.textField.textColor = [NSColor colorWithCalibratedRed:0.160 green:0.181 blue:0.215 alpha:1.000];
		[self.textField.animator setFrame:(NSRect){ .origin.x = 45, .origin.y = 16, .size = { NSWidth(self.bounds), 34 } }];
		[self setNeedsDisplay:YES];
	} else {
		self.textField.textColor = [NSColor colorWithCalibratedRed:0.437 green:0.517 blue:0.559 alpha:1.000];
		[self.textField.animator setFrame:(NSRect){ .origin.x = 30, .origin.y = 16, .size = { NSWidth(self.bounds), 34 } }];
		[self setNeedsDisplay:YES];
	}
}

- (void)drawSeparatorInRect:(NSRect)dirtyRect {
	NSRect drawingRect = [self frame];
	drawingRect.origin.y = drawingRect.size.height - 1.0;
	drawingRect.size.height = 1.0;

	[[NSColor colorWithCalibratedRed:0.766 green:0.807 blue:0.830 alpha:1.000] set];
	NSRectFill(drawingRect);
}

- (void)ensureTrackingArea {
	if (!trackingArea) {
		trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:NSTrackingInVisibleRect | NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
	}
}

- (void)updateTrackingAreas {
	[super updateTrackingAreas];
	[self ensureTrackingArea];
	if (![[self trackingAreas] containsObject:trackingArea]) {
		[self addTrackingArea:trackingArea];
	}
}

- (void)mouseEntered:(NSEvent *)theEvent {
	self.highlighted = YES;
	[self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
	self.highlighted = NO;
	[self setNeedsDisplay:YES];
}

- (void)resetCursorRects {
	[self addCursorRect:self.bounds cursor:NSCursor.pointingHandCursor];
}

@end
