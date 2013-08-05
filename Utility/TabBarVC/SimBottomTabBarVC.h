//
//  SimBottomTabBarVC.h
//
//  Created by Xubin Liu on 12-7-11.
//

#import <UIKit/UIKit.h>
#import "SimSegmentBarDelegate.h"

/*
 底部的TabBar效果。基于系统的UITabBarController。
 显示上使用SimSegmentBar来配置。
 可设置Badge，Hide,Transparent等属性。
 */

@class SimSegmentBar;
@interface SimBottomTabBarVC : UITabBarController<SimSegmentBarDelegate>
{
	SimSegmentBar* _segmentBar;
}

@property(nonatomic,retain) SimSegmentBar *tabBarView;
@property(nonatomic,assign) BOOL tabBarHide;
@property(nonatomic,assign) BOOL tabBarTransparent;

- (void)setTabBarHide:(BOOL)hide animated:(BOOL)animated;
- (void)setBadgeValue:(NSString *)value forIndex:(NSInteger)index;
- (NSString *)badgeValueForIndex:(NSInteger)index;
- (void)updateContainerViewFrame;

@end
