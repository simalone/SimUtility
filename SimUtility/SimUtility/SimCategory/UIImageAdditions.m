//
//  UIImageAdditions.m
//  SecretCamera
//
//  Created by Xubin Liu on 14-4-29.
//  Copyright (c) 2014年 Xubin Liu. All rights reserved.
//

#import "UIImageAdditions.h"

@implementation UIImage (SimCategory)

- (UIImage *)createThumbSize:(CGSize )thumbSize percent:(float)percent toPath:(NSString *)thumbPath{
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleFactor = 0.0;
    CGPoint thumbPoint = CGPointMake(0.0,0.0);
    CGFloat widthFactor = thumbSize.width / width;
    CGFloat heightFactor = thumbSize.height / height;
    if (widthFactor > heightFactor)  {
        scaleFactor = widthFactor;
    }
    else {
        scaleFactor = heightFactor;
    }
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    if (widthFactor > heightFactor)
    {
        thumbPoint.y = (thumbSize.height - scaledHeight) * 0.5;
    }
    else if (widthFactor < heightFactor)
    {
        thumbPoint.x = (thumbSize.width - scaledWidth) * 0.5;
    }
    
    UIGraphicsBeginImageContext(thumbSize);
    CGRect thumbRect = CGRectZero;
    thumbRect.origin = thumbPoint;
    thumbRect.size.width  = scaledWidth;
    thumbRect.size.height = scaledHeight;
    [self drawInRect:thumbRect];
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (thumbPath) {
        NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, percent);
        [thumbImageData writeToFile:thumbPath atomically:NO];
    }
    return thumbImage;
}

@end
