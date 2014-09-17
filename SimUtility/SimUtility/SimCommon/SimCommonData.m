//
//  SimCommonData.m
//
//  Created by Xubin Liu on 13-12-17.
//  Copyright (c) 2013年 Xubin Liu. All rights reserved.
//

#import "SimCommonData.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

@implementation SimCommonData


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

static NSString *uuidStr = nil;
+ (NSString*)uuid{
    if (uuidStr == nil) {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, uuid);
        const char *cStr = CFStringGetCStringPtr(cfstring,CFStringGetFastestEncoding(cfstring));
        unsigned char result[16];
        CC_MD5( cStr, strlen(cStr), result );
        CFRelease(uuid);
        
        uuidStr = ([NSString stringWithFormat:
                     @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08x",
                     result[0], result[1], result[2], result[3],
                     result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11],
                     result[12], result[13], result[14], result[15],
                     (arc4random_uniform(NSUIntegerMax))]);
    }
    
    return uuidStr;
}


+ (NSString *)updateAppHttpUrl:(NSString *)appId{
    NSString *str = nil;
    if ([SimCommonData systemFloatVersion] >= 7.0) {
        str = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", appId];
    }
    else{
        str = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8", appId];
    }
    return str;

}

+ (NSString *)updateAppUrl:(NSString *)appId{
    NSString *str = nil;
    if ([SimCommonData systemFloatVersion] >= 7.0) {
        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appId];
    }
    else{
        str = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8", appId];
    }
    return str;
}


+ (NSString *)rateAppUrl:(NSString *)appId{
    NSString *str = nil;
    if ([SimCommonData systemFloatVersion] >= 7.0) {
        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appId];
    }
    else{
        str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId];
    }
    return str;
}

@end
