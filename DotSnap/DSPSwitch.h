//
//  DSPSwitch.h
//  DotSnap
//
//  Created by Robert Widmann on 7/25/13.
//
//

@interface DSPSwitch : NSControl

- (id)initWithFrame:(NSRect)frameRect;
- (void)setOn:(BOOL)on animated:(BOOL)animated;

@property(nonatomic, getter=isOn) BOOL on;

@end
