 //
//  SimSegmentBar.m
//
//  Created by Xubin Liu on 12-7-11.
//

#import "SimSegmentBar.h"


@interface SimSegmentBar ()
@property(nonatomic, retain) NSArray *items;
@property (nonatomic, assign) SimTabBarItem *curItem;
@end

@implementation SimSegmentBar

@synthesize delegate;
@synthesize dataSource;
@synthesize selectedIndex = _selectedIndex;
@synthesize divideLineColor = _divideLineColor;
@synthesize items = _items;
@synthesize curItem = _curItem;
@synthesize divideViews = _divideViews;


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _selectedIndex = -1;
        self.initIndex = 0;
        self.divideLineColor = HEXRGBCOLOR(0xcfd3de);
    }
    return self;
}

- (void)dealloc{
    self.delegate = nil;
    self.dataSource = nil;
    self.items = nil;
    self.divideLineColor = nil;
    self.curItem = nil;
    self.divideViews = nil;
    [super dealloc];
}


- (void)reloadData{
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    
    NSInteger count = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfBarItems:)]) {
        count = [self.dataSource numberOfBarItems:self];
    }

    if (count == 0) {
        return;
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(backgroudViewOfSegmentBar:)]) {
        UIView *bgView = [self.dataSource backgroudViewOfSegmentBar:self];
        if (bgView) {
            [self addSubview:bgView];
        }
    }
    
    CGSize unitSize = CGSizeMake(self.frame.size.width/count, self.frame.size.height);
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(unitSizeOfBarItems:)]) {
        unitSize = [self.dataSource unitSizeOfBarItems:self];
    }
    
    CGPoint startPoint = CGPointMake((self.frame.size.width - unitSize.width*count) / (count+1), (self.frame.size.height - unitSize.height)/2);
    CGFloat itemsGap = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(startPointOfBarItems:)]) {
        startPoint = [self.dataSource startPointOfBarItems:self];
        if (![self.dataSource respondsToSelector:@selector(unitGapOfBarItems:)]) {
            if (count > 1) {
                itemsGap = (self.frame.size.width - startPoint.x * 2 - unitSize.width * count) / (count - 1);
            }
        }
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(unitGapOfBarItems:)]) {
        itemsGap = [self.dataSource unitGapOfBarItems:self];
        if (![self.dataSource respondsToSelector:@selector(startPointOfBarItems:)]) {
            if (count > 1) {
                startPoint.x = (self.frame.size.width - unitSize.width*count - itemsGap*(count -1)) / 2;
            }
        }
    }
    
    UIControlEvents controlEvents = UIControlEventTouchUpInside;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(selectControlEventsForSegmentBar:)]) {
        controlEvents = [self.dataSource selectControlEventsForSegmentBar:self];
    }
    
    NSMutableArray *_array = [[NSMutableArray alloc] initWithCapacity:count];
    CGRect _frame = CGRectMake(0, 0, unitSize.width, unitSize.height);
    for (int i = 0; i < count; i++) {
        _frame.origin = CGPointMake(startPoint.x+i*(unitSize.width+itemsGap), startPoint.y);
        SimTabBarItem *_item = [[SimTabBarItem alloc] initWithFrame:_frame];
        [_item addTarget:self action:@selector(selectItem:) forControlEvents:controlEvents];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(segmentBar:defaultItem:atIndex:)]) {
            [self.dataSource segmentBar:self defaultItem:_item atIndex:i];
        }
        _item.selected = (_selectedIndex == i);
        [_array addObject:_item];
        
        if ([self.dataSource respondsToSelector:@selector(backgroudViewForSegmentBar:atIndex:)]) {
            UIView *bgView = [self.dataSource backgroudViewForSegmentBar:self atIndex:i];
            if (bgView) {
                bgView.frame = _item.frame;
                [self addSubview:bgView];
            }
        }
        
        [self addSubview:_item];
        PLSafeRelease(_item);
    }
    self.items = [NSArray arrayWithArray:_array];
    
    if ([self.dataSource respondsToSelector:@selector(divideViewForSegmentBar:atIndex:)]){
        NSMutableArray* divideViewArray = [NSMutableArray arrayWithCapacity:count];
        for (int i = 1; i < self.items.count; i++) {
            SimTabBarItem *_item = [_items objectAtIndex:i];
            UIView *divideView = [self.dataSource divideViewForSegmentBar:self atIndex:i];
            if (divideView) {
                divideView.left = _item.frame.origin.x;
                [self addSubview:divideView];
                [divideViewArray addObject:divideView];
            }
        }
        self.divideViews = [NSArray arrayWithArray:divideViewArray];
    }
    
    if (self.divideViews.count == 0 && self.divideLineColor) {
        for (int i = 1; i < self.items.count; i++) {
            SimTabBarItem *_item = [_items objectAtIndex:i];
            UIView *divideView = [[UIView alloc] initWithFrame:CGRectMake(_item.frame.origin.x-0.5, 0, 1, _item.frame.size.height)];
            divideView.backgroundColor = self.divideLineColor;
            [self addSubview:divideView];
            PLSafeRelease(divideView);
        }
    }
    
    
    if (self.barType == BarType_HighlightSelected) {
        if (_selectedIndex < 0 || _selectedIndex >= _items.count) {
            self.selectedIndex = self.initIndex;
        }
        else{
            [self refreshItemState];
        }
    }
    
    
    PLSafeRelease(_array);
}

- (void)refreshItemState{
    for (int i = 0; i < _items.count; i++) {
        SimTabBarItem *_item = [_items objectAtIndex:i];
        if (i == _selectedIndex) {
            _item.selected = YES;
            _item.userInteractionEnabled = NO;
        }
        else{
            _item.selected = NO;
            _item.userInteractionEnabled = YES;
        }
    }
}

- (void)selectItem:(SimTabBarItem *)item{
    self.selectedIndex = [self.items indexOfObject:item];
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

- (void)setSelectedIndex:(NSInteger)newIndex{
    if (self.barType == BarType_HighlightSelected) {
        BOOL shouldSelectSame = NO;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(segmentBarShouldSelectSameIndex:)]) {
            shouldSelectSame = [self.dataSource segmentBarShouldSelectSameIndex:self];
        }
        
        BOOL shouldSelect = shouldSelectSame ? YES : (newIndex != self.selectedIndex);
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(segmentBar:shouldSelectIndex:preIndex:)]) {
            shouldSelect = [self.dataSource segmentBar:self shouldSelectIndex:newIndex preIndex:self.selectedIndex];
        }
        
        if (shouldSelect) {
            NSInteger _previousIndex = self.selectedIndex;
            if (_previousIndex >= 0 && _previousIndex < self.items.count) {
                SimTabBarItem *_preItem = (SimTabBarItem *)[self.items objectAtIndex:_previousIndex];
                _preItem.selected = NO;
                if (!shouldSelectSame) {
                    _preItem.userInteractionEnabled = YES;
                }
            }
            
            _selectedIndex = newIndex;
            if (newIndex >= 0 && newIndex < self.items.count) {
                _curItem = (SimTabBarItem *)[self.items objectAtIndex:newIndex];
                _curItem.selected = YES;
                if (!shouldSelectSame) {
                    _curItem.userInteractionEnabled = NO;
                }
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(segmentBar:didSelectIndex:preIndex:)]) {
                    [self.delegate segmentBar:self didSelectIndex:newIndex preIndex:_previousIndex];
                }
            }
        }
    }
    else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentBar:didSelectIndex:preIndex:)]) {
            [self.delegate segmentBar:self didSelectIndex:newIndex preIndex:-1];
        }

    }
}

- (NSArray*)getAllItems{
    return self.items;
}

@end
