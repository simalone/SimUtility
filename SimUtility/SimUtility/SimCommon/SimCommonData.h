//
//  SimCommonData.h
//
//  Created by Xubin Liu on 13-12-17.
//  Copyright (c) 2013年 Xubin Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimCommonData : NSObject

NSString* HOME_PATH();
NSString* DOCUMENT_PATH();
NSString* LIBRARY_PATH();
NSString* CACHE_PATH();
NSString* DOCUMENT_APPENDPATH(NSString *appendPath);

+ (float)systemFloatVersion;
+ (NSString*)uuid;

+ (NSString *)updateAppHttpUrl:(NSString *)appId;
+ (NSString *)updateAppUrl:(NSString *)appId;
+ (NSString *)rateAppUrl:(NSString *)appId;

@end
