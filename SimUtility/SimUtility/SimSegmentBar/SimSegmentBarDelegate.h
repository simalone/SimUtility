//
//  SimSegmentBarDelegate.h
//
//  Created by Liu Xubin on 12-11-1.
//

#import <Foundation/Foundation.h>

@class SimSegmentBar;
@class SimTabBarItem;

@protocol SimSegmentBarDelegate<NSObject>
- (void)segmentBar:(SimSegmentBar*)bar didSelectIndex:(NSInteger)index preIndex:(NSInteger)preIndex;
@optional
@end

@protocol SimSegmentBarDateSource<NSObject>
- (NSInteger)numberOfBarItems:(SimSegmentBar*)bar;
@optional
- (CGSize)unitSizeOfBarItems:(SimSegmentBar*)bar;
- (CGPoint)startPointOfBarItems:(SimSegmentBar*)bar;
- (CGFloat)unitGapOfBarItems:(SimSegmentBar*)bar;
- (void)segmentBar:(SimSegmentBar*)bar defaultItem:(SimTabBarItem *)item atIndex:(NSInteger)index;
- (UIView *)backgroudViewOfSegmentBar:(SimSegmentBar*)bar;
- (UIView *)divideViewForSegmentBar:(SimSegmentBar*)bar atIndex:(NSInteger)index;
- (UIView *)backgroudViewForSegmentBar:(SimSegmentBar*)bar atIndex:(NSInteger)index;
- (UIControlEvents)selectControlEventsForSegmentBar:(SimSegmentBar*)bar;
- (BOOL)segmentBar:(SimSegmentBar*)bar shouldSelectIndex:(NSInteger)index preIndex:(NSInteger)preIndex;
- (BOOL)segmentBarShouldSelectSameIndex:(SimSegmentBar*)bar;


@end


