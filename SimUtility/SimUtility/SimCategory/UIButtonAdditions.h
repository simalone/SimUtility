//
//  UIButtonAdditions.h
//  piano
//
//  Created by Liu Xubin on 13-9-7.
//  Copyright (c) 2013年 Liu Xubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton (SimCategory)

+ (UIButton *)btnWithImageNames:(NSArray *)imageNames;


+ (UIButton *)buttonWithText:(NSString *)string target:(id)target action:(SEL)sel bgImageName:(NSArray *)backImageNames;

- (void)setBackgroundImageByColor:(UIColor *)backgroundColor forState:(UIControlState)state;


@end
