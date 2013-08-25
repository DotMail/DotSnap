//
//  DSPMainViewModel.h
//  DotSnap
//
//  Created by Robert Widmann on 7/25/13.
//
//

#import <Foundation/Foundation.h>

@interface DSPMainViewModel : NSObject <NSTableViewDataSource, NSMetadataQueryDelegate>

@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *filepath;

@property (nonatomic, strong, readonly) NSMutableArray *filenameHistory;

- (void)addFilenameToHistory:(NSString *)filename;

@end
