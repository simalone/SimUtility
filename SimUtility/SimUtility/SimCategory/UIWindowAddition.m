//
//  UIWindowAddition.m
//  piano
//
//  Created by Xubin Liu on 13-12-1.
//  Copyright (c) 2013年 Liu Xubin. All rights reserved.
//

#import "UIWindowAddition.h"

@implementation UIWindow(SimCategory)

//top window except alertView, keyboard etc.
+ (UIWindow *)getTopWindow{
	int topWindowsIdx = -1;
	float maxWindowsLevel = -1;
	int i = 0;
    
    NSArray *_windows = [UIApplication sharedApplication].windows;
	for ( UIWindow *window in _windows) {
		if (window.windowLevel > maxWindowsLevel && !window.hidden && window.windowLevel <= 2) {
			maxWindowsLevel = window.windowLevel;
			topWindowsIdx = i;
		}
		i++;
	}
    
    if (topWindowsIdx == -1) {
        return nil;
    }
    
	return [_windows objectAtIndex:topWindowsIdx];
	
}

@end
