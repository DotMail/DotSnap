//
//  DSPMainViewController.h
//  DotSnap
//
//  Created by Robert Widmann on 7/24/13.
//
//

@interface DSPMainViewController : NSViewController <NSTableViewDelegate, NSTextFieldDelegate> {
	CGRect _contentFrame;
}

- (id)initWithContentRect:(CGRect)rect;
- (void)reset;

@end
