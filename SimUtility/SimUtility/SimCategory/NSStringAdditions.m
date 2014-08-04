//
//  NSStringAdditions.m
//  PrettyMusic
//
//  Created by Xubin Liu on 14-3-12.
//  Copyright (c) 2014年 Xubin Liu. All rights reserved.
//

#import "NSStringAdditions.h"

@implementation  NSString (SimCategory)



- (NSString*)encodeURLWithEncoding:(NSStringEncoding)encoding{
    CFStringRef str = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(encoding));
	NSString *newString = CFBridgingRelease(str);
	if (newString) {
		return newString;
	}
	return @"";
}

@end


