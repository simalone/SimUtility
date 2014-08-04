//
//  SimCoreTextView.m
//  Wenku
//
//  Created by Liu Xubin on 12-10-30.
//  Copyright (c) 2012年 baidu.com. All rights reserved.
//

#import "SimCoreTextView.h"

#ifndef kSampleStr
#define kSampleStr @"样本"
#endif

@interface SimCoreTextView(){
    NSMutableAttributedString* _attributedText;
}
@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) CGColorRef textColorRef;
@property (nonatomic, assign) CTFontRef fontRef;
@property (nonatomic, assign) CTParagraphStyleRef paragraghStyle;

- (void)resetAttributedText;

@end

@implementation SimCoreTextView

@synthesize indentSize;
@synthesize font;
@synthesize text;
@synthesize range;
@synthesize alignment;
@synthesize textColor;
@synthesize lineHeightRatio;
@synthesize paragraphHeightRatio;
@synthesize paragraghStyle;
@synthesize fontRef;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alignment = kCTTextAlignmentJustified;
        self.range = NSMakeRange(NSNotFound, 0);
        self.font = [UIFont systemFontOfSize:12];
        self.backgroundColor = [UIColor clearColor];
        self.lineHeightRatio = 1.0f;
        self.paragraphHeightRatio = 0.0f;
        self.textColor = [UIColor blackColor];
    }
    return self;
}

- (void)dealloc{
    SafeRelease(font);
    SafeRelease(textColor);
    SafeRelease(_attributedText);
    if (fontRef) {
        CFRelease(fontRef);
    }
    if (paragraghStyle) {
        CFRelease(paragraghStyle);
    }
    [super dealloc];
}

#pragma amrk - setter && getter
- (void)setFrame:(CGRect)f{
    if (self.width != f.size.width) {
        [self setNeedsDisplay];
    }
    
    [super setFrame:f];
}


- (void)setFont:(UIFont*)f {
    if (![f isEqual:font]) {
        SafeRelease(font);
        font = [f retain];
        self.indentSize = [kSampleStr sizeWithFont:font];
        self.fontRef = nil;
        self.paragraghStyle = nil;
        [self setNeedsDisplay];
    }
}

- (void)setAlignment:(CTTextAlignment)a{
    if (alignment != a) {
        alignment = a;
        self.paragraghStyle = nil;
        [self setNeedsDisplay];
    }
}

- (void)setLineHeightRatio:(CGFloat)lineRatio{
    if (lineHeightRatio != lineRatio) {
        lineHeightRatio = lineRatio;
        self.paragraghStyle = nil;
        [self setNeedsDisplay];
    }
}

- (void)setParagraphHeightRatio:(CGFloat)paragraphRatio{
    if (paragraphHeightRatio != paragraphRatio) {
        paragraphHeightRatio = paragraphRatio;
        self.paragraghStyle = nil;
        [self setNeedsDisplay];
    }
}

- (void)setText:(NSString *)t{
    if (![_attributedText.string isEqual:t]) {
        SafeRelease(_attributedText);
        _attributedText = [[NSMutableAttributedString alloc] initWithString:t];
        self.range = NSMakeRange(NSNotFound, 0);
        self.paragraghStyle = nil;
        self.textColorRef = nil;
        self.fontRef = nil;
        [self setNeedsDisplay];
    }
}

- (void)setTextColor:(UIColor *)tc{
    if (![textColor isEqual:tc]) {
        SafeRelease(textColor);
        textColor = [tc retain];
        self.textColorRef = nil;
        [self setNeedsDisplay];
    }
}

- (void)setText:(NSString *)t renderStart:(NSUInteger)startPos renderLen:(NSUInteger)len{
    self.text = t;
    self.range = NSMakeRange(startPos, len);
    [self setNeedsDisplay];
}

- (NSString *)text{
    return _attributedText.string;
}


- (NSRange)range{
    if (range.length == 0) {
        range = NSMakeRange(0, _attributedText.length);
    }

    return range;
}

- (void)setParagraghStyle:(CTParagraphStyleRef)pStyle{
    if ( !pStyle || !paragraghStyle || !CFEqual(paragraghStyle, pStyle)){
        if (paragraghStyle) {
            CFRelease(paragraghStyle);
        }
        paragraghStyle = pStyle;
    }
}

- (void)setFontRef:(CTFontRef)fRef{
    if (!fRef || !fontRef || !CFEqual(fontRef, fRef)){
        if (fontRef) {
            CFRelease(fontRef);
        }
        fontRef = fRef;
    }
}

#pragma mark - methods

- (void)heightToFit{
    if (_attributedText.length == 0) {
        self.height = 0;
    }
    [self resetAttributedText];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedText);
	CGSize sz = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,CFRangeMake(0,0),NULL,CGSizeMake(self.width, CGFLOAT_MAX), NULL);
    sz = CGSizeMake( floorf(sz.width+1) , floorf(sz.height+1) );
	if (framesetter)
        CFRelease(framesetter);
	self.height = sz.height;
}

- (void)resetAttributedText{
    NSRange totalRange = NSMakeRange(0 , [_attributedText length]);

    if (!self.fontRef) {
        if (!self.font) {
            return;
        }
        self.fontRef = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
        [_attributedText removeAttribute:(id)kCTFontAttributeName range:totalRange];
        [_attributedText addAttribute:(id)kCTFontAttributeName
                                value:(id)self.fontRef
                                range:totalRange];
        if (!self.fontRef) return;
    }
    
    if (!self.paragraghStyle) {
        CGFloat lineSpace = self.indentSize.height * self.lineHeightRatio;
        CTTextAlignment align = self.alignment;
        CGFloat minLineHeight = lineSpace;
        CGFloat maxLineHeight = lineSpace;
        CGFloat paragraphSpacing = self.indentSize.height*self.paragraphHeightRatio;
        CGFloat paragraphSpacingBefore = 0;
        CGFloat firstLineHeadIndent = indentSize.width;
        
        CTParagraphStyleSetting altSettings[] =
        {
            { kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minLineHeight},
            { kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight},
            { kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineHeadIndent},
            { kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing},
            { kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore},
            { kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &align},
        };
        self.paragraghStyle = CTParagraphStyleCreate(altSettings ,sizeof(altSettings) / sizeof(CTParagraphStyleSetting));
        
        [_attributedText removeAttribute:(id)kCTParagraphStyleAttributeName range:totalRange];
        
        [_attributedText addAttribute:(id)kCTParagraphStyleAttributeName
                                value:(id)self.paragraghStyle
                                range:totalRange];
        
    }
    
    if (!self.textColorRef) {
        self.textColorRef = self.textColor.CGColor;
        [_attributedText addAttribute:(id)kCTForegroundColorAttributeName
                                value:(id)self.textColorRef
                                range:NSMakeRange(0 , [_attributedText length])];
    }
}

#pragma mark - draw

- (void)drawRect:(CGRect)rect{
    if (_attributedText.length == 0) {
        return;
    }
    [self resetAttributedText];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextClipToRect(context, rect);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // rect pos(UIKit)          //text draw in rect     //Vertical Mirror
    // (0,0)........            (0,0)........           (0,0)........
    // ..(x,y)......            .[......xyz].           .............
    // .............            .............           .............
    // .............            .....efg.....           .............
    // ......(w,h)..            .[abc......].           ..abc........
    // .............            .............           .....efg.....
    // .............            .............           .............
    // .............            .............           ........xyz..
    // ....(320,480)            ....(320,480)           ....(320,480)
    
    CFRange cfRange = CFRangeMake(self.range.location, self.range.length);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedText);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, cfRange, path, NULL);
    
    CTFrameDraw(frame, context);
    
    if (framesetter)
        CFRelease(framesetter);

    CFRelease(frame);
    CFRelease(path);
}

+ (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width lineRadio:(CGFloat)lineRatio paraRadio:(CGFloat)paraRatio text:(NSString *)text{
     NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange totalRange = NSMakeRange(0 , [text length]);
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    [attributedText addAttribute:(id)kCTFontAttributeName
                            value:(id)fontRef
                            range:totalRange];
    CFRelease(fontRef);
    
    CGSize indentSize = [kSampleStr sizeWithFont:font];
    CGFloat lineSpace = indentSize.height * lineRatio;
    CTTextAlignment align = kCTTextAlignmentJustified;
    CGFloat minLineHeight = lineSpace;
    CGFloat maxLineHeight = lineSpace;
    CGFloat paragraphSpacing = indentSize.height*paraRatio;
    CGFloat paragraphSpacingBefore = 0;
    CGFloat firstLineHeadIndent = indentSize.width;
    CTParagraphStyleSetting altSettings[] =
    {
        { kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minLineHeight},
        { kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight},
        { kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineHeadIndent},
        { kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing},
        { kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore},
        { kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &align},
    };
    CTParagraphStyleRef paragraghStyle = CTParagraphStyleCreate(altSettings ,sizeof(altSettings) / sizeof(CTParagraphStyleSetting));
    [attributedText addAttribute:(id)kCTParagraphStyleAttributeName
                           value:(id)paragraghStyle
                           range:totalRange];
    CFRelease(paragraghStyle);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedText);
	CGSize sz = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,CFRangeMake(0,0),NULL,CGSizeMake(width, CGFLOAT_MAX), NULL);
    sz = CGSizeMake( floorf(sz.width+1) , floorf(sz.height+1) );
	if (framesetter)
        CFRelease(framesetter);
    SafeRelease(attributedText);
    
    return sz.height;
}

@end
