//
//  UIViewController+SimAddition.h
//
//  Created by Xubin Liu on 12-7-17.
//  Copyright (c) 2012年 baidu.com. All rights reserved.
//

typedef enum {
    LeftItem = 0,
    RightItem,
}ItemPos; 

#import <UIKit/UIKit.h>

/*
提供ViewConroller一些扩展方法，主要用于navItem的设置。
作用：统一navItem的风格，减少navItem的实现代码。
 */

@interface UIViewController (SimAddition)

- (void)doPopBack;
- (void)doDismissModel;
- (void)updateItemAt:(ItemPos)pos barButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;

- (void)cleanItemAt:(ItemPos)pos;
- (void)addBackItem;
- (void)addBackItemByStr:(NSString *)backStr;
- (void)addBackItem:(NSArray *)images;
- (void)addCancelItem;
- (void)addCancelItemByStr:(NSString *)str;
- (void)setCustomTitle:(NSString *)tilte;


- (void)updateItemAt:(ItemPos)pos forText:(NSString *)string target:(id)target action:(SEL)sel;
- (void)updateItemAt:(ItemPos)pos forText:(NSString *)string target:(id)target action:(SEL)sel animated:(BOOL)animated;
- (void)updateItemAt:(ItemPos)pos forText:(NSString *)string target:(id)target action:(SEL)sel bgImageName:(NSArray *)backImageNames  animated:(BOOL)animated;

- (void)updateItemAt:(ItemPos)pos forTexts:(NSArray *)strings targets:(NSArray *)targets actions:(NSArray *)sels animated:(BOOL)animated;

+ (UIBarButtonItem *)barButtonItemForText:(NSString *)string target:(id)target action:(SEL)sel bgImageName:(NSArray *)backImageNames;


@end
