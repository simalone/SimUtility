//
//  UIButton+SimAddition.h
//  Wenku
//
//  Created by Xubin Liu on 12-7-19.
//  Copyright (c) 2012年 baidu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SimAddition)

- (void)setBackgroundImageByColor:(UIColor *)backgroundColor forState:(UIControlState)state;
+ (UIButton *)buttonWithText:(NSString *)string target:(id)target action:(SEL)sel bgImageName:(NSArray *)backImageNames;


@end
