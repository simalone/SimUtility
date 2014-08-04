//
//  UIImageAdditions.h
//  SecretCamera
//
//  Created by Xubin Liu on 14-4-29.
//  Copyright (c) 2014年 Xubin Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (SimCategory)

- (UIImage *)createThumbSize:(CGSize )thumbSize percent:(float)percent toPath:(NSString *)thumbPath;

@end
