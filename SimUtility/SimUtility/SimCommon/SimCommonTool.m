//
//  SimCommonTool.m
//  TKnowBox
//
//  Created by Xubin Liu on 14-9-17.
//  Copyright (c) 2014年 Xubin Liu. All rights reserved.
//

#import "SimCommonTool.h"

@implementation SimCommonTool

+ (BOOL)skipICloud:(NSString*)urlString{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.1")) {
        if([[NSFileManager defaultManager] fileExistsAtPath:urlString]){
            NSURL *url = [NSURL fileURLWithPath:urlString];
            if (!url) {
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                url = [NSURL fileURLWithPath:urlString];
            }
            
            if(url){
                NSError *error = nil;
                BOOL success = [url setResourceValue: [NSNumber numberWithBool: YES]
                                              forKey: NSURLIsExcludedFromBackupKey error: &error];
                if(!success){
                    NSLog(@"Error excluding %@ from backup %@", [urlString lastPathComponent], error);
                }
                return success;
            }
        }
    }
    else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0.1")){
        const char* filePath = [urlString fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    return NO;
}


@end
