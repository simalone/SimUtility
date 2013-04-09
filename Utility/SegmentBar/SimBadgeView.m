//
//  SimBadgeView.m
//
//  Created by Liu Xubin on 13-1-14.
//

#import "SimBadgeView.h"
#import <QuartzCore/QuartzCore.h>

#define kBadgeLeftPading 6
#define kBadgeTopPading  3

@interface SimBadgeView ()

- (void)updateDisplay;
- (void) drawRoundedRect:(CGRect)rrect inContext:(CGContextRef)context;

@end

@implementation SimBadgeView
@synthesize badgeValue;
@synthesize font;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont boldSystemFontOfSize:11];
    }
    return self;
}

- (void)dealloc{
    self.font = nil;
    self.badgeValue = nil;
    [super dealloc];
}

- (void)setBadgeValue:(NSString *)value{
    if (badgeValue != value) {
        [badgeValue release];
        badgeValue = [value copy];
        
        [self updateDisplay];
    }
}

- (void)setFont:(UIFont *)f{
    if (font != f) {
        [font release];
        font = [f retain];
        [self updateDisplay];
    }
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.badgeValue.length == 0 || self.font == nil) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    //绘制底部投阴效果
    /*CGContextSaveGState(context);
    CGContextClearRect(context, self.bounds);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 3), 2, [[UIColor blackColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    [self drawRoundedRect:CGRectInset(self.bounds, 2, 2) inContext:context];
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);*/

	//绘制背景
	CGContextSaveGState(context);
	CGContextSetAllowsAntialiasing(context, true);
	CGContextSetAlpha(context, 1.0);
	CGContextSetLineWidth(context, 2.0);
	CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
	CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
	[self drawRoundedRect:CGRectInset(self.bounds, 2, 2) inContext:context ];
	CGContextDrawPath(context, kCGPathFillStroke);
	CGContextRestoreGState(context);
    
	//绘制文字
	CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
	[self.badgeValue drawAtPoint:CGPointMake(kBadgeLeftPading, kBadgeTopPading) withFont:self.font];
    

	//绘制文字上的高亮效果
    CGContextSaveGState(context);
    CGRect bounds = self.bounds;
    CGRect ovalRect = CGRectMake(2, 1, bounds.size.width-4, bounds.size.height /2);
	CGContextSetAlpha(context, 1.0);
	CGContextBeginPath (context);
	CGFloat minx = CGRectGetMinX(ovalRect), midx = CGRectGetMidX(ovalRect),
	maxx = CGRectGetMaxX(ovalRect);
	CGFloat miny = CGRectGetMinY(ovalRect), midy = CGRectGetMidY(ovalRect),
	maxy = CGRectGetMaxY(ovalRect);
    CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, 8);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, 8);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, 4);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, 4);
	CGContextClosePath(context);
	CGContextClip (context);
    
    CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
	CGPoint start = CGPointMake(bounds.origin.x, bounds.origin.y);
	CGPoint end = CGPointMake(bounds.origin.x, bounds.size.height*1.5);
    size_t num_locations = 9;
	CGFloat locations[] = { 0.0, 0.10, 0.25, 0.40, 0.45, 0.50, 0.65, 0.75, 1.00 };
    CGFloat components[36] = {
                            1.0, 1.0, 1.0, 1.00,
                            1.0, 1.0, 1.0, 0.55,
                            1.0, 1.0, 1.0, 0.20,
                            1.0, 1.0, 1.0, 0.20,
                            1.0, 1.0, 1.0, 0.15,
                            1.0, 1.0, 1.0, 0.10,
                            1.0, 1.0, 1.0, 0.10,
                            1.0, 1.0, 1.0, 0.05,
                            1.0, 1.0, 1.0, 0.05 };
    CGGradientRef glossGradient = CGGradientCreateWithColorComponents(rgbColorspace,
                                                                      components, locations, num_locations);
	CGContextDrawLinearGradient(context, glossGradient, start, end, 0);
	CGGradientRelease(glossGradient);
	CGColorSpaceRelease(rgbColorspace);
    
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    
	CGContextRestoreGState(context);
	
    
}

- (void)updateDisplay{
    if (self.badgeValue.length == 0 || self.font == nil) {
        return;
    }
    
    CGSize valueSize = [self.badgeValue sizeWithFont:self.font];
    self.frame = CGRectMake(0 , 0, valueSize.width + kBadgeLeftPading * 2 , valueSize.height + kBadgeTopPading * 2);
    [self setNeedsDisplay];
}

- (void) drawRoundedRect:(CGRect)rrect inContext:(CGContextRef)context{
	
	CGFloat
    minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
	maxx = CGRectGetMaxX(rrect);
	
	CGFloat
    miny = CGRectGetMinY(rrect),
    midy = CGRectGetMidY(rrect),
	maxy = CGRectGetMaxY(rrect);
    
    CGFloat radius = rrect.size.width > rrect.size.height ? rrect.size.height / 2 : rrect.size.width / 2;
	
    CGContextBeginPath (context);
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
}

@end
