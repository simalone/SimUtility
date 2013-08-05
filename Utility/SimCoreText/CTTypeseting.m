//
//  CTTypeseting.m
//  Wenku
//
//  Created by Liu Xubin on 12-10-19.
//  Copyright (c) 2012年 baidu.com. All rights reserved.
//

#import "CTTypeseting.h"
#import "ParagraphInfo.h"

#define kStepMax 20



@implementation CTTypeseting


BOOL isBlank(NSString *text, NSUInteger i){
    NSString *str = [text substringWithRange:NSMakeRange(i, 1)];
    if ([str isEqualToString:@"　"]  ||  //Unicode空格
        [str isEqualToString:@" "]  ||
        [str isEqualToString:@"\n"] ||
        [str isEqualToString:@"\f"] ||
        [str isEqualToString:@"\r"] ||
        [str isEqualToString:@"\t"] ||
        [str isEqualToString:@"\b"] ) {
        return YES;
    }
  
    
    return NO;
}


BOOL isReturn(NSString *text, NSUInteger i){
    NSString *str = [text substringWithRange:NSMakeRange(i, 1)];
    if ([str isEqualToString:@"\f"] ||
        [str isEqualToString:@"\n"] ||
        [str isEqualToString:@"\r"] ) {
        return YES;
    }
    
    return NO;
}

CGSize framesetterFit(CTFramesetterRef framesetter,
                      CFRange stringRange,
                      CFDictionaryRef frameAttributes,
                      CGSize constraints,
                      CFRange* fitRange ){
    CGSize sz = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, stringRange, frameAttributes,constraints,fitRange);
    return CGSizeMake( floorf(sz.width+1) , floorf(sz.height+1) );
}


//判断缩进文本实际开始位置
+ (NSUInteger)fixIndentAtPosition:(NSUInteger)startPosition text:(NSString *)text{
    for (int i = startPosition; i < text.length; i++) {
        if (!isBlank(text, i)) {
            return i;
        }
    }
    return text.length;
}


//向下判断段落尾后面的无内容段落
+ (NSUInteger)nextPragraphEndFromPosition:(NSUInteger)position text:(NSString *)text{    
    NSUInteger _rtPos = position;
    for (NSUInteger i = _rtPos; i < text.length; i++) {
        if (!isBlank(text, i)) {
            return _rtPos;
        }
        
        else if (isReturn(text, i)) {
            _rtPos = i+1;
        }
    }
    return text.length;
}

//向上判断段落尾后面的无内容段落
+ (NSUInteger)prePragraphEndFromPosition:(NSUInteger)position text:(NSString *)text{    
    NSUInteger _rtPos = position;
    for (NSUInteger i = _rtPos - 1; ; --i) {
        if (!isBlank(text, i)) {
            return _rtPos;
        }
        
        else if (isReturn(text, i)) {
            _rtPos = i+1;
        }
        
        if (i == 0) {
            return 0;
        }
    }
    
    //will not here, just for warning
    return _rtPos;
}

//获取段落的范围，\r\n 替换为 \n\n
+ (void)getLineStart:(NSUInteger *)startPtr end:(NSUInteger *)lineEndPtr forPos:(NSUInteger)startPos text:(NSString **)text{
    startPos = MIN([*text length]-1, startPos);
    [*text getLineStart:startPtr end:lineEndPtr contentsEnd:nil forRange:NSMakeRange(startPos, 1)];
    
    if (*lineEndPtr - *startPtr >= 2) {
        NSRange range = NSMakeRange(*lineEndPtr-2, 2);
        NSString *string = [*text substringWithRange:range];
        if ([string isEqualToString:@"\r\n"]) {
            *text = [*text stringByReplacingCharactersInRange:range
                                                   withString:@"\n\n"];
            *lineEndPtr -= 1;
        }
    }
}


//获取上一页的文本信息
+ (NSArray *)getPrePageInfoFrom:(NSUInteger)end contentSize:(CGSize)contentSize text:(NSString *)text paragraphStyleRef:(CTParagraphStyleRef)paragraghStyle fontRef:(CTFontRef)fontRef{
    NSMutableArray *_pageInfoArray = [[NSMutableArray alloc] init];
    @autoreleasepool {
        NSUInteger _paragraphStart, _paragraphEnd, _actualParagraphStart;
        NSString *_paraStr;
        NSRange _range;
        CGFloat _contentHeight = 0;
        CGSize _paraSize;
        NSMutableAttributedString *_attributedString;
        CTFramesetterRef framesetter;
        BOOL _bStop = NO;
        
        while (_contentHeight < contentSize.height && !_bStop && end > 0) {
            
            ParagraphInfo *_paragraphInfo = [[ParagraphInfo alloc] init];
            _paragraphInfo.actualEnd = end;
            
            //获得实际文本尾
            end = [CTTypeseting prePragraphEndFromPosition:end text:text];
            
            //如果到文本头或第一个字符为无内容，则没有必要再计算，直接返回此页起始为0的内容即可
            if (end <= 1) {
                _paragraphInfo.actualStart = 0;
                [_pageInfoArray insertObject:_paragraphInfo atIndex:0];
                SafeRelease(_paragraphInfo);
                break;
            }
            
            _bStop = NO;
            //获取段落位置
            [CTTypeseting getLineStart:&_actualParagraphStart end:&_paragraphEnd forPos:end-2 text:&text];
            //[text getLineStart:&_actualParagraphStart end:&_paragraphEnd contentsEnd:nil forRange:NSMakeRange(end-2, 1)];
            
            if (_paragraphEnd < end) { //getLineStart对段尾做了处理
                _paragraphEnd = end;
            }
            
            //修复缩进，得实际的段落开始位置
            _paragraphStart = [CTTypeseting fixIndentAtPosition:_actualParagraphStart text:text];
            
            //段落在文本中的Range，进而获得段落的Framesetter
            _paragraphInfo.paragraphStart = _paragraphStart;
            _paragraphInfo.paragraphLength = _paragraphEnd - _paragraphStart;
            _range = NSMakeRange(_paragraphInfo.paragraphStart, _paragraphInfo.paragraphLength);
            _paraStr = [text substringWithRange:_range];
            
            _attributedString = [[NSMutableAttributedString alloc] initWithString:_paraStr];
            [_attributedString addAttribute:(id)kCTParagraphStyleAttributeName
                                      value:(id)paragraghStyle
                                      range:NSMakeRange(0 , [_attributedString length])];
            [_attributedString addAttribute:(id)kCTFontAttributeName
                                      value:(id)fontRef
                                      range:NSMakeRange(0,[_attributedString length])];

            framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedString);
            
            //判断段落高度是否在绘制高度中， _range.length是调整缩进后的段落长度
            _paraSize = framesetterFit(framesetter,CFRangeMake(0, end - _paragraphStart),NULL,CGSizeMake(contentSize.width, CGFLOAT_MAX), NULL);
            if (_paraSize.height+_contentHeight <= contentSize.height) {
                //在绘制高度中，完成些段落判断
                _contentHeight += _paraSize.height;
                _paragraphInfo.actualStart = _actualParagraphStart;
                _paragraphInfo.renderStart = 0;
                _paragraphInfo.renderLength = end - _paragraphStart;
                
                CGFloat _paraGragraphHeight;
                CTParagraphStyleGetValueForSpecifier(paragraghStyle,
                                                     kCTParagraphStyleSpecifierParagraphSpacing,
                                                     sizeof(CGFloat),
                                                     &_paraGragraphHeight);
                _contentHeight += _paraGragraphHeight;
                
                //从下到上的高度，最后需根据顶部差值，重新纠下得从上向下的高度
                _paragraphInfo.yPos = contentSize.height - _contentHeight;
            }
            else{
                _bStop = YES;
                //段落高度超过绘制高度， 计算在高度外的段落范围。 注：从头向前算，才能保证前一页的最后一行是格的
                CGFloat _paragraphHeight = _paraSize.height;
                CGFloat _restHeight = contentSize.height - _contentHeight;
                NSInteger _step = kStepMax, _length = 0;
                while (_step != 0 ) {
                    if (_length+_step > _range.length) {
                        _step /= 2;
                    }
                    else{
                        _paraSize = framesetterFit(framesetter,CFRangeMake(0, _length+_step),NULL,CGSizeMake(contentSize.width, CGFLOAT_MAX), NULL);
                        if (_paragraphHeight - _paraSize.height > _restHeight) {
                            _length += _step;
                        }
                        else{
                            _step /= 2;
                        }
                    }
                }
                
                //［0，_length＋1］的高度是刚好使剩余内容在_restHeight的范围内，所以还需要算一行，这一行也不在此页中
                _restHeight = _paraSize.height;
                _step = kStepMax;
                while (_step != 0 ) {
                    if (_length+_step > _range.length) {
                        _step /= 2;
                    }
                    else{
                        _paraSize = framesetterFit(framesetter,CFRangeMake(0, _length+_step),NULL,CGSizeMake(contentSize.width, CGFLOAT_MAX), NULL);
                        if (_paraSize.height == _restHeight) {
                            _length += _step;
                        }
                        else{
                            _step /= 2;
                        }
                    }
                }

                //前一段有内容到此页
                if (_length != _range.length) {
                    _paraSize = framesetterFit(framesetter,CFRangeMake(_length, _range.length-_length),NULL,CGSizeMake(contentSize.width, CGFLOAT_MAX), NULL);
                    _contentHeight += _paraSize.height;
                    _paragraphInfo.actualStart = _paragraphInfo.paragraphStart+_length;
                    _paragraphInfo.renderStart = _length;
                    _paragraphInfo.yPos = contentSize.height - _contentHeight;
                }
                _paragraphInfo.renderLength = _range.length-_length;
            }
            
            NSAssert(_paragraphInfo.renderStart+_paragraphInfo.renderLength <= _range.length, @"_paragraphInfo must in length");
            
            end = _paragraphInfo.actualStart;
            if (_paragraphInfo.renderLength != 0) {
                [_pageInfoArray insertObject:_paragraphInfo atIndex:0];
            }
            CFRelease(framesetter);
            SafeRelease(_attributedString);
            SafeRelease(_paragraphInfo);
        }
        
        //如果此页不是第一页，且第一个yPos不为0，则调整ParagraphInfo的yPos
        CGFloat _offY = contentSize.height - _contentHeight;
        for (int i = 0; i < _pageInfoArray.count; i++) {
            ParagraphInfo *_info = [_pageInfoArray objectAtIndex:i];
            if (i == 0 && _info.actualStart != 0 &&  _info.yPos == 0 ) {
                break;
            }
            _info.yPos -= _offY;
            
        }
    }
    
    return [_pageInfoArray autorelease];
}

//获取下一页的文本信息
+ (NSArray *)getNextPageInfoFrom:(NSUInteger)start contentSize:(CGSize)contentSize text:(NSString *)text paragraphStyleRef:(CTParagraphStyleRef)paragraghStyle fontRef:(CTFontRef)fontRef{
    NSMutableArray *_pageInfoArray = [[NSMutableArray alloc] init];
    @autoreleasepool {
        NSUInteger _paragraphStart, _paragraphEnd;
        NSString *_paraStr;
        NSRange _range;
        CGFloat _contentHeight = 0;
        CGSize _paraSize;
        NSMutableAttributedString *_attributedString;
        CTFramesetterRef framesetter;
        BOOL _bStop = NO;
        
        while (_contentHeight < contentSize.height && !_bStop && start < text.length) {
            _bStop = NO;
            ParagraphInfo *_paragraphInfo = [[ParagraphInfo alloc] init];
            _paragraphInfo.actualStart = start;
            _paragraphInfo.yPos = _contentHeight;
            
            //去除前面可能的换行
            start = [CTTypeseting nextPragraphEndFromPosition:start text:text];

            //获取段落位置
            [CTTypeseting getLineStart:&_paragraphStart end:&_paragraphEnd forPos:start text:&text];
            //[text getLineStart:&_paragraphStart end:&_paragraphEnd contentsEnd:nil forRange:NSMakeRange(start, 1)];
            
            //段首开始，需要修复缩进，得实际的段落开始位置， start为绘制开始位置
            if (_paragraphStart == start) {
                _paragraphStart = [CTTypeseting fixIndentAtPosition:_paragraphStart text:text];
                start = _paragraphStart;
            }
            
            //段落在文本中的Range，进而获得段落的Framesetter
            _paragraphInfo.paragraphStart = _paragraphStart;
            _paragraphInfo.paragraphLength = _paragraphEnd - _paragraphStart;
            _range = NSMakeRange(_paragraphInfo.paragraphStart, _paragraphInfo.paragraphLength);
            _paraStr = [text substringWithRange:_range];
            _attributedString = [[NSMutableAttributedString alloc] initWithString:_paraStr];
            [_attributedString addAttribute:(id)kCTParagraphStyleAttributeName
                                      value:(id)paragraghStyle
                                      range:NSMakeRange(0 , [_attributedString length])];
            [_attributedString addAttribute:(id)kCTFontAttributeName
                                      value:(id)fontRef
                                      range:NSMakeRange(0,[_attributedString length])];
            framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedString);
            
            //在段落的中绘制起始位置
            _paragraphInfo.renderStart = start - _paragraphStart;
            
            //判断绘制的”剩余“段落高度是否在绘制高度中， _range.length是调整缩进后的段落长度
            _paraSize = framesetterFit(framesetter,CFRangeMake(_paragraphInfo.renderStart, _range.length - _paragraphInfo.renderStart),NULL,CGSizeMake(contentSize.width, CGFLOAT_MAX), NULL);
            if (_paraSize.height+_contentHeight <= contentSize.height) {
                //在绘制高度中，完成些段落判断
                _contentHeight += _paraSize.height;
                _paragraphInfo.renderLength = _range.length - _paragraphInfo.renderStart;
                _paragraphInfo.actualEnd = _paragraphEnd;
                
                CGFloat _paraGragraphHeight;
                CTParagraphStyleGetValueForSpecifier(paragraghStyle,
                                                     kCTParagraphStyleSpecifierParagraphSpacing,
                                                     sizeof(CGFloat),
                                                     &_paraGragraphHeight);
                _contentHeight += _paraGragraphHeight;

            }
            else{
                _bStop = YES;
                
                //段落高度超过绘制高度， 计算在绘制高度中的段落范围
                NSInteger _step = kStepMax, _length = 0;
                while (_step != 0 ) {
                    if (_paragraphInfo.renderStart + _step + _length > _range.length) {
                        _step /= 2;
                    }
                    else{
                        _paraSize = framesetterFit(framesetter,CFRangeMake(_paragraphInfo.renderStart, _step + _length),NULL,CGSizeMake(contentSize.width, CGFLOAT_MAX), NULL);
                        if (_paraSize.height+_contentHeight <= contentSize.height) {
                            _length += _step;
                        }
                        else{
                            _step /= 2;
                        }
                    }
                }
                
                _paraSize = framesetterFit(framesetter,CFRangeMake(_paragraphInfo.renderStart, _length),NULL,CGSizeMake(contentSize.width, CGFLOAT_MAX), NULL);
                _contentHeight += _paraSize.height;
                _paragraphInfo.renderLength = _length;
                _paragraphInfo.actualEnd = _paragraphStart+_paragraphInfo.renderStart+_length;
            }
            //如果计算到段落尾，在开始下一段计算前，先判断下面无内容的段落，加入到本段落的实际位置位置
            if (_paragraphInfo.actualEnd == _paragraphEnd) {
                _paragraphInfo.actualEnd = [CTTypeseting nextPragraphEndFromPosition:_paragraphEnd text:text];
                
            }
            
            start = _paragraphInfo.actualEnd;
            if (_paragraphInfo.renderLength != 0) {
                [_pageInfoArray addObject:_paragraphInfo];
            }
            CFRelease(framesetter);
            SafeRelease(_attributedString);
            SafeRelease(_paragraphInfo);
        }
    }
    return [_pageInfoArray autorelease];
}

//获取指定位置的所在行的行首
+ (NSUInteger)getLineStartFrom:(NSUInteger)start contentSize:(CGSize)contentSize text:(NSString *)text paragraphStyleRef:(CTParagraphStyleRef)paragraghStyle fontRef:(CTFontRef)fontRef{
    NSUInteger _paragraphStart, _paragraphEnd;
    [CTTypeseting getLineStart:&_paragraphStart end:&_paragraphEnd forPos:start text:&text];
    NSRange _range = NSMakeRange(_paragraphStart, start - _paragraphStart);
    NSString *_paraStr = [text substringWithRange:_range];
    NSMutableAttributedString* _attributedString = [[NSMutableAttributedString alloc] initWithString:_paraStr];
    [_attributedString addAttribute:(id)kCTParagraphStyleAttributeName
                              value:(id)paragraghStyle
                              range:NSMakeRange(0 , [_attributedString length])];
    [_attributedString addAttribute:(id)kCTFontAttributeName
                              value:(id)fontRef
                              range:NSMakeRange(0,[_attributedString length])];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedString);
    CGSize _paraSize = framesetterFit(framesetter,CFRangeMake(0, start - _paragraphStart),NULL,CGSizeMake(contentSize.width, CGFLOAT_MAX), NULL);
    CGFloat _curHeight = _paraSize.height;
    NSInteger _step = -4;
    while (_step != 0 ) {
        if (start + _step  < _paragraphStart) {
            _step /= 2;
        }
        else{
            _paraSize = framesetterFit(framesetter,CFRangeMake(0, start + _step - _paragraphStart),NULL,CGSizeMake(contentSize.width, CGFLOAT_MAX), NULL);
            if (_paraSize.height < _curHeight) {
                start += _step;
            }
            else{
                _step /= 2;
            }
        }
    }
    
    SafeRelease(_attributedString);
    CFRelease(framesetter);
    
    return start;
}

//修复一个段落的首尾的无用换行或空白
+ (NSString *)fixPragraphHeaderTail:(NSString *)paragraphText{
    NSMutableString *musString = [[[NSMutableString alloc] init] autorelease];
    NSUInteger paragraphStart, paragraphEnd;

    for (NSUInteger start = 0; start < paragraphText.length;) {
        //去除前面可能的换行
        start = [CTTypeseting nextPragraphEndFromPosition:start text:paragraphText];
        
        //获取段落位置
        [CTTypeseting getLineStart:&paragraphStart end:&paragraphEnd forPos:start text:&paragraphText];
        
        //段首开始，需要修复缩进，得实际的段落开始位置， start为绘制开始位置
        if (paragraphStart == start) {
            paragraphStart = [CTTypeseting fixIndentAtPosition:paragraphStart text:paragraphText];
            start = paragraphStart;
        }
        
        [musString appendString:[paragraphText substringWithRange:NSMakeRange(start, paragraphEnd-start) ]];
        
        start = [CTTypeseting nextPragraphEndFromPosition:paragraphEnd text:paragraphText];
    }
 
    return musString;
}

@end
