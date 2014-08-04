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
- (BOOL)segmentBar:(SimSegmentBar*)bar shouldSelectIndex:(NSInteger)index preIndex:(NSInteger)preIndex;
@end

@protocol SimSegmentBarDateSource<NSObject>
- (NSInteger)numberOfBarItems;
@optional
- (CGSize)unitSizeOfBarItems;
- (CGPoint)startPointOfBarItems;
- (void)segmentBar:(SimSegmentBar*)bar defaultItem:(SimTabBarItem *)item atIndex:(NSInteger)index;
@end


