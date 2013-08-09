//
//  DSPSpinningSettingsButton.h
//  DotSnap
//
//  Created by Robert Widmann on 7/27/13.
//
//

typedef NS_ENUM(NSUInteger, DSPSpinningSettingsButtonStyle) {
	DSPSpinningSettingsButtonStyleGrey = 0,
	DSPSpinningSettingsButtonStyleWhite = 1
};

@interface DSPSpinningSettingsButton : NSButton

- (id)initWithFrame:(NSRect)frameRect style:(DSPSpinningSettingsButtonStyle)style;

- (void)spinOut;

@end
