//
//  SimCoreTextView.h
//  Wenku
//
//  Created by Liu Xubin on 12-10-30.
//  Copyright (c) 2012年 baidu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

/*
 使用CoreText实现文本优化排版显示，结合CTTypeseting
 */

@interface SimCoreTextView : 
 UIView{
}

- (void)setText:(NSString *)text renderStart:(NSUInteger)startPos renderLen:(NSUInteger)len;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, assign) CGFloat lineHeightRatio;
@property (nonatomic, assign) CTTextAlignment alignment;
@property (nonatomic, assign) CGFloat paragraphHeightRatio;
@property (nonatomic, assign) CGSize indentSize;

- (void)heightToFit;

+ (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width lineRadio:(CGFloat)lineRatio paraRadio:(CGFloat)paraRatio text:(NSString *)text;


@end
