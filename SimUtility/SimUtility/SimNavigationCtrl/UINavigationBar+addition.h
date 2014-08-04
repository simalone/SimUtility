//
//  UINavigationBar+addition.h
//
//  Created by Xubin Liu on 12-7-3.
//  Copyright (c) 2012年 Liu Xubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINavigationBar (SimUINavigationBarCategory)

@property (nonatomic, retain) UIImage *backgroundImage;

- (CGFloat)actualBarHeight;


@end