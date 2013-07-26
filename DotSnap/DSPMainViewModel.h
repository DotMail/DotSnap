//
//  DSPMainViewModel.h
//  DotSnap
//
//  Created by Robert Widmann on 7/25/13.
//
//

#import <Foundation/Foundation.h>

@interface DSPMainViewModel : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *filepath;

- (void)addFilenameToHistory:(NSString *)filename;

@end
