//
//  UINavigationBar+addition.h
//
//  Created by Xubin Liu on 12-7-3.
//

#import <Foundation/Foundation.h>

/*
 实现自定义的UINavigationCtrl的navigationBar的效果。
 */

@interface UINavigationBar (SimUINavigationBarCategory)

@property (nonatomic, retain) UIImage *backgroundImage;

- (CGFloat)actualBarHeight;


@end