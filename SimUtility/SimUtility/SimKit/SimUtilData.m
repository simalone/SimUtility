//
//  SimUtilData.m
//
//  Created by Xubin Liu on 13-12-17.
//  Copyright (c) 2013年 Xubin Liu. All rights reserved.
//

#import "SimUtilData.h"

@implementation SimUtilData


NSString* HOME_PATH(){
    static NSString* path = nil;
    if (path.length == 0) {
        path = NSHomeDirectory();
    };
    
    return path;
}

NSString* DOCUMENT_PATH(){
    static NSString* path = nil;
    if (path.length == 0) {
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    
    return path;
    
}

NSString* LIBRARY_PATH(){
    static NSString* path = nil;
    if (path.length == 0) {
        path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    
    return path;
}

NSString* CACHE_PATH(){
    static NSString* path = nil;
    if (path.length == 0) {
        path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    
    return path;
}


NSString* DOCUMENT_APPENDPATH(NSString *appendPath){
    return[DOCUMENT_PATH() stringByAppendingPathComponent:appendPath];
}


static float systemVersion = -1.0f;
+ (float)systemFloatVersion{
    if (systemVersion < 0) {
        systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    }
    
    return systemVersion;
}

static NSString *appPath = nil;
+ (NSString *)appPath{
    if (!appPath) {
        appPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    
    return appPath;
}

static NSString *uuid = nil;
+(NSString*)uuid{
    if (!uuid) {
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuidStringRef= CFUUIDCreateString(NULL, uuidRef);
        
        CFRelease(uuidRef);
        uuid = [NSString stringWithString:(__bridge NSString*)uuidStringRef];
        CFRelease(uuidStringRef);
    }
    
    return uuid;
}

+ (NSUInteger)uuidHash{
    return [[self uuid] hash];
}

+ (NSString *)updateAppHttpUrl:(NSString *)appId{
    NSString *str = nil;
    if ([SimUtilData systemFloatVersion] >= 7.0) {
        str = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", appId];
    }
    else{
        str = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8", appId];
    }
    return str;

}

+ (NSString *)updateAppUrl:(NSString *)appId{
    NSString *str = nil;
    if ([SimUtilData systemFloatVersion] >= 7.0) {
        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appId];
    }
    else{
        str = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8", appId];
    }
    return str;
}


+ (NSString *)rateAppUrl:(NSString *)appId{
    NSString *str = nil;
    if ([SimUtilData systemFloatVersion] >= 7.0) {
        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appId];
    }
    else{
        str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId];
    }
    return str;
}

@end
