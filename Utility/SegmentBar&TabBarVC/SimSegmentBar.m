//
//  SimSegmentBar.m
//
//  Created by Xubin Liu on 12-7-11.
//

#import "SimSegmentBar.h"
#import "SimTabBarItem.h"


@interface SimSegmentBar ()
@property(nonatomic, retain) NSArray *items;
@end

@implementation SimSegmentBar

@synthesize delegate;
@synthesize selectedIndex = _selectIndex;
@synthesize belowStrokes = _belowStrokes;
@synthesize items = _items;

- (void)dealloc{
    self.items = nil;
    [super dealloc];
}

- (void)setItemCount:(NSInteger)count {
    NSAssert(count != 0, @"images.count != 0");
    
    CGSize _unitSize = CGSizeMake(self.frame.size.width/count, self.frame.size.height);
    CGPoint _startPoint = CGPointZero;
    [self setItemCount:count unitSize:_unitSize startPoint:_startPoint];
}

//invoke after init befor setting
- (void)setItemCount:(NSInteger)count unitSize:(CGSize)unitSize startPoint:(CGPoint)startPoint{
    [self setItemCount:count unitSize:unitSize startPoint:startPoint itemsGap:0];
}

- (void)setItemCount:(NSInteger)count unitSize:(CGSize)unitSize startPoint:(CGPoint)startPoint itemsGap:(CGFloat)itemsGap{
    NSMutableArray *_array = [[NSMutableArray alloc] initWithCapacity:count];
    CGRect _frame = CGRectMake(0, 0, unitSize.width, unitSize.height);
    for (int i = 0; i < count; i++) {
        _frame.origin = CGPointMake(startPoint.x+i*(unitSize.width+itemsGap), startPoint.y);
        SimTabBarItem *_item = [[SimTabBarItem alloc] initWithFrame:_frame];
        [_item addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchDown];
        [_array addObject:_item];
        [self addSubview:_item];
        SimSafeRelease(_item);
    }
    
    self.items = [NSArray arrayWithArray:_array];
    self.selectedIndex = NSNotFound;
    SimSafeRelease(_array);
}

- (void)setImages:(NSArray *)images selectedImages:(NSArray *)selectImages{
    NSAssert(images.count != 0, @"images.count != 0");
    [self setImages:images selectedImages:selectImages offTop:CGFLOAT_MIN];
}

- (void)setImages:(NSArray *)images selectedImages:(NSArray *)selectImages offTop:(CGFloat)offTop{
    NSAssert(images.count == selectImages.count, @"images.count == selectImages.count");
    
    if (!self.items) {
        [self setItemCount:images.count];
    }
    
    for (int i = 0; i < [images count]; i++) {
        SimTabBarItem *_item = [self.items objectAtIndex:i];
        UIImageView *_imageView = [[UIImageView alloc] initWithImage:UIImageNamed([images objectAtIndex:i]) highlightedImage:UIImageNamed([selectImages objectAtIndex:i])];
        _item.iconImage = _imageView;
        CGRect frame = _imageView.frame;
        if (offTop != CGFLOAT_MIN) {
            frame.origin.y = offTop;
        }
        else{
            frame.origin.y = _item.frame.size.height/2 - frame.size.height/2;
        }
        frame.origin.x = _item.frame.size.width/2 - frame.size.width/2;
        _imageView.frame = frame;
        SimSafeRelease(_imageView);
	}
}

/*
 * @pram offBottom 如果值是CGFLOAT_MIN，则设置Label垂直方向居中，否则值是设置Label底部距离Item底部的高度
 */

- (void)setText:(NSArray *)texts textColor:(UIColor *)color selectColor:(UIColor *)selectColor font:(UIFont *)font offBottom:(CGFloat)offBottom {
    if (!self.items) {
        [self setItemCount:texts.count];
    }
    
    for (int i = 0; i < texts.count; i++) {
        SimTabBarItem *_item = [self.items objectAtIndex:i];
        UILabel *_lable = [[UILabel alloc] initWithFrame:CGRectZero];
        _lable.backgroundColor = [UIColor clearColor];
        _lable.textAlignment = NSTextAlignmentCenter;
        _lable.textColor = color;
        _lable.highlightedTextColor = selectColor;
        _lable.font = font;
        _lable.text = [texts objectAtIndex:i];
        [_lable sizeToFit];
        _item.title = _lable;
        
        CGRect frame = _lable.frame;
        if (offBottom != CGFLOAT_MIN) {
            frame.origin.y = _item.frame.size.height - offBottom - frame.size.height;
        }
        else{
            frame.origin.y = _item.frame.size.height/2 - frame.size.height/2;
        }
        frame.origin.x = _item.frame.size.width/2 - frame.size.width/2;
        _lable.frame = frame;
        SimSafeRelease(_lable);
    }
}

- (void)setBgColor:(UIColor *)color selectColor:(UIColor *)selectColor{
    NSAssert(self.items.count != 0, @"self.items.count != 0");
    
    for (SimTabBarItem *_item in self.items) {
        [_item setColor:color highlightedColor:selectColor];
    }
}

- (void)setBorderColor:(UIColor *)color highlightedBorderColor:(UIColor *)selectColor{
    NSAssert(self.items.count != 0, @"self.items.count != 0");
    
    for (SimTabBarItem *_item in self.items) {
        [_item setBorderColor:color highlightedBorderColor:selectColor];
    }
}

- (void)setSelectedIndex:(NSInteger)newIndex{
    if (newIndex != self.selectedIndex ) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentBar:shouldSelectIndex:preIndex:)]) {
            BOOL _rt = [self.delegate segmentBar:self shouldSelectIndex:newIndex preIndex:self.selectedIndex];
            if (!_rt) {
                return;
            }
        }
        
        NSInteger _previousIndex = self.selectedIndex;
        if (_previousIndex != NSNotFound) {
            SimTabBarItem *_preItem = (SimTabBarItem *)[self.items objectAtIndex:_previousIndex];
            _preItem.selected = NO;
            _preItem.userInteractionEnabled = YES;
        }
        
        _selectIndex = newIndex;
        if (newIndex != NSNotFound) {
            SimTabBarItem *_curItem = (SimTabBarItem *)[self.items objectAtIndex:newIndex];
            _curItem.selected = YES;
            _curItem.userInteractionEnabled = NO;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentBar:didSelectIndex:preIndex:)]) {
            [self.delegate segmentBar:self didSelectIndex:newIndex preIndex:_previousIndex];
        }
    }
}

- (void)selectItem:(SimTabBarItem *)item{
    self.selectedIndex = [self.items indexOfObject:item];
}
    
    
- (UIView *)belowStrokes{
    if (!_belowStrokes) {
        _belowStrokes = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
        [self addSubview:_belowStrokes];
        [_belowStrokes release];
    }
    
    return _belowStrokes;
}

- (void)setBadgeValue:(NSString *)value forIndex:(NSInteger)index{
    if (index >= 0 && index < self.items.count) {
        SimTabBarItem *_item = [self.items objectAtIndex:index];
        [_item setBadge:value];
    }
}

- (NSString *)badgeValueForIndex:(NSInteger)index{
    if (index >= 0 && index < self.items.count) {
        SimTabBarItem *_item = [self.items objectAtIndex:index];
        return _item.badge;
    }
    
    return nil;
}


@end
