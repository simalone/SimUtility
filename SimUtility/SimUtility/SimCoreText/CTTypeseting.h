//
//  CTTypeseting.h
//  Wenku
//
//  Created by Liu Xubin on 12-10-19.
//  Copyright (c) 2012年 baidu.com. All rights reserved.
//

#import "GeneralBookProvider.h"
#import <CoreText/CoreText.h>


@interface CTTypeseting : NSObject

BOOL isBlank(NSString *text, NSUInteger i);
BOOL isReturn(NSString *text, NSUInteger i);

CGSize framesetterFit(CTFramesetterRef framesetter,
                      CFRange stringRange,
                      CFDictionaryRef frameAttributes,
                      CGSize constraints,
                      CFRange* fitRange );



//判断缩进文本实际开始位置
+ (NSUInteger)fixIndentAtPosition:(NSUInteger)startPosition text:(NSString *)text;

//向下判断段落尾后面的无内容段落
+ (NSUInteger)nextPragraphEndFromPosition:(NSUInteger)position text:(NSString *)text;

//向上判断段落尾后面的无内容段落
+ (NSUInteger)prePragraphEndFromPosition:(NSUInteger)position text:(NSString *)text;

//获取段落的范围，\r\n 替换为 \n\n
+ (void)getLineStart:(NSUInteger *)startPtr end:(NSUInteger *)lineEndPtr forPos:(NSUInteger)startPos text:(NSString **)text;

//获取上一页的文本信息
+ (NSArray *)getPrePageInfoFrom:(NSUInteger)end contentSize:(CGSize)contentSize text:(NSString *)text paragraphStyleRef:(CTParagraphStyleRef)paragraghStyle fontRef:(CTFontRef)fontRef;

//获取下一页的文本信息
+ (NSArray *)getNextPageInfoFrom:(NSUInteger)start contentSize:(CGSize)contentSize text:(NSString *)text paragraphStyleRef:(CTParagraphStyleRef)paragraghStyle fontRef:(CTFontRef)fontRef;

//获取指定位置的所在行的行首
+ (NSUInteger)getLineStartFrom:(NSUInteger)start contentSize:(CGSize)contentSize text:(NSString *)text paragraphStyleRef:(CTParagraphStyleRef)paragraghStyle fontRef:(CTFontRef)fontRef;

//修复一个段落的首尾的无用换行或空白
+ (NSString *)fixPragraphHeaderTail:(NSString *)paragraphText;


@end
