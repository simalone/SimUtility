//
//  SimBottomTabBarVC.h
//
//  Created by Xubin Liu on 12-7-11.
//

#import <UIKit/UIKit.h>
#import "SimSegmentBarDelegate.h"

@class SimSegmentBar;
@interface SimBottomTabBarVC : UITabBarController<SimSegmentBarDelegate>
{
	SimSegmentBar* _segmentBar;
}
@property(nonatomic,retain) SimSegmentBar *tabBarView;
@property(nonatomic,assign) BOOL tabBarHide;

- (void)setTabBarHide:(BOOL)hide animated:(BOOL)animated;
- (void)setBadgeValue:(NSString *)value forIndex:(NSInteger)index;
- (NSString *)badgeValueForIndex:(NSInteger)index;

@end
