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
@property (nonatomic, weak) RACSubject *canFireSubject;

@end
