//
//  DSPPreferencesViewController.h
//  DotSnap
//
//  Created by Robert Widmann on 7/25/13.
//
//

@class RACSubject;

@interface DSPPreferencesViewController : NSViewController {
	CGRect _contentRect;
}

- (id)initWithContentRect:(CGRect)rect;

@property (nonatomic, weak) NSWindow *presentingWindow;
@property (nonatomic) BOOL exemptForAnimation;

@end
