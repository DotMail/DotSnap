//
//  DSPPNGFormatter.m
//  DotSnap
//
//  Created by Robert Widmann on 7/28/13.
//
//

#import "DSPPNGFormatter.h"

@implementation DSPPNGFormatter

- (NSString *)stringForObjectValue:(NSString *)string {
	if (string.length == 0) {
		string = @"Screen Shot";
	}
	NSString *stringToAttribute = string;
	if (![string hasSuffix:@".png"]) {
		stringToAttribute = [string stringByAppendingPathExtension:@"png"];
	}
	return stringToAttribute;
}

- (NSString *)editingStringForObjectValue:(NSString *)obj {
	return obj.stringByDeletingPathExtension;
}

- (NSAttributedString *)attributedStringForObjectValue:(NSString *)string withDefaultAttributes:(NSDictionary *)attrs {
	if (string.length == 0) {
		string = @"Screen Shot";
	}
	NSString *stringToAttribute = string;
	if ([string hasPrefix:@".png"]) {
		stringToAttribute = [string stringByAppendingPathExtension:@"png"];
	}
	NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:stringToAttribute attributes:nil];
	
	return attributedString;
}

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error {
	*obj = [self appendSuffixIfNecessary:string];
	return YES;
}

- (NSString *)appendSuffixIfNecessary:(NSString *)candidateString {
	NSString *stringToAttribute = candidateString;
	if (![candidateString hasSuffix:@".png"]) {
		stringToAttribute = [candidateString stringByAppendingPathExtension:@"png"];
	}
	return stringToAttribute;
}



@end
