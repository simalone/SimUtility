//
//  SimImageCache.m
//  TingIPhone
//
//  Created by Xubin Liu on 13-12-14.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "SimImageCache.h"

void SwizzelInstanceMethods(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}


void SwizzleClassMethods(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getClassMethod(c, orig);
    Method newMethod = class_getClassMethod(c, new);
    c = object_getClass((id)c);
    
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}


@interface UIImage(Theme)
+ (UIImage *)simImageNamed:(NSString *)name;
+ (UIImage *)simImageWithContentsOfFile:(NSString *)name;
@end

@implementation UIImage(Theme)
+ (UIImage *)simImageNamed:(NSString *)name{
    return [SimImageCache imageNamed:name cache:YES];
}
+ (UIImage *)simImageWithContentsOfFile:(NSString *)filePath{
    return [SimImageCache imageAtFilePath:filePath];
}
@end

@implementation SimImageCache


+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SwizzleClassMethods([UIImage class], @selector(imageNamed:), @selector(simImageNamed:));
        SwizzleClassMethods([UIImage class], @selector(imageWithContentsOfFile:), @selector(simImageWithContentsOfFile:));

    });
}


+ (SimImageCache *)sharedInstance{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (id)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning:(NSNotification *)noti{
    [SimImageCache removeAllImageCache];
}

+ (UIImage *)imageNamed:(NSString *)name{
    return [self imageNamed:name];
}

+ (UIImage *)fileImageName:(NSString *)name{
    return [self fileImageName:name];
}

+ (UIImage *)imageAtFilePath:(NSString *)filePath{
    return [[UIImage alloc] initWithContentsOfFile:filePath];
}

//include jpg and png
+ (UIImage *)imageNamed:(NSString *)name cache:(BOOL)shouldCache{
    BOOL isHighResolution = NO;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([UIScreen mainScreen].scale > 1) {
            isHighResolution = YES;
        }
    }
    
    NSString *noExtFileName = [name stringByDeletingPathExtension];
    if (isHighResolution) {
        if (![noExtFileName hasSuffix:@"@2x"]) {
            noExtFileName = [noExtFileName stringByAppendingString:@"@2x"];
        }
    }

    UIImage *image = nil;
    if (shouldCache) {
        SimImageCache *cache = [self sharedInstance];
        image = [cache objectForKey:noExtFileName];
        if (!image) {
            NSString *filePath = [self existPathForNoExtName:noExtFileName ext:[name pathExtension]];
            if (filePath.length == 0) {
                //非高清的图片补充
                if (!isHighResolution) {
                    if (![noExtFileName hasSuffix:@"@2x"]) {
                        noExtFileName = [noExtFileName stringByAppendingString:@"@2x"];
                    }
                    filePath = [self existPathForNoExtName:noExtFileName ext:[name pathExtension]];
                }
            }
            if (filePath) {
                image = [self imageAtFilePath:filePath];
                if (image) {
                    [cache setObject:image forKey:noExtFileName];
                }
            }
        }
    }
    else{
        NSString *filePath = [self existPathForNoExtName:noExtFileName ext:[name pathExtension]];
        image = [self imageAtFilePath:filePath];
    }
    
    return image;
    
}

+ (void)removeAllImageCache{
    [[self sharedInstance] removeAllObjects];
}

+ (NSString *)existPathForNoExtName:(NSString *)noExtName ext:(NSString *)ext{
    NSString *path = nil;
    if (ext.length > 0) {
        path =  [[NSBundle mainBundle] pathForResource:noExtName ofType:ext];
        return path;
    }
    else{
        path = [self existPathForNoExtName:noExtName ext:@"png"];
        if (path.length > 0) {
            return path;
        }
        
        return [self existPathForNoExtName:noExtName ext:@"jpg"];
    }
    
    return nil;
}

@end
