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

- (id)initWithContentRect:(CGRect)rect canFireSubject:(RACSubject *)canFireSubject;
- (void)orderOut;

@property (nonatomic, weak) RACSubject *canFireSubject;
@property (nonatomic, weak) NSWindow *presentingWindow;

@end
