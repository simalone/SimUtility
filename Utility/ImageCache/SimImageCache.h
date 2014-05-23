//
//  SimImageCache.h
//  TingIPhone
//
//  Created by Xubin Liu on 13-12-14.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimImageCache : NSCache

+ (SimImageCache *)sharedInstance;

+ (void)removeAllImageCache;
+ (UIImage *)imageAtFilePath:(NSString *)filePath;
+ (UIImage *)imageNamed:(NSString *)name cache:(BOOL)shouldCache;

@end
