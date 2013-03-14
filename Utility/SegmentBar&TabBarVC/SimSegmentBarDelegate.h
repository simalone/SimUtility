//
//  SimSegmentBarDelegate.h
//
//  Created by Liu Xubin on 12-11-1.
//

#import <Foundation/Foundation.h>

@class SimSegmentBar;
@protocol SimSegmentBarDelegate<NSObject>

@optional
- (BOOL)segmentBar:(SimSegmentBar*)bar shouldSelectIndex:(NSInteger)index preIndex:(NSInteger)preIndex;

- (void)segmentBar:(SimSegmentBar*)bar didSelectIndex:(NSInteger)index preIndex:(NSInteger)preIndex;

@end
