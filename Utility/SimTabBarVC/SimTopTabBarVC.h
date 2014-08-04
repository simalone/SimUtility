//
//  SimTopTabBarVC.h
//
//  Created by Xubin Liu on 12-7-11.
//

#import "SimSegmentBarDelegate.h"

/*
 类似于系统的UITabBarController。位置在头部。
 显示上使用SimSegmentBar来配置。
 切换tab调用viewWillAppear和viewDidAppear。
 顶部可多层次使用。
 */

@class SimSegmentBar;
@interface SimTopTabBarVC : UIViewController<SimSegmentBarDelegate>
{
    SimSegmentBar* _segmentBar;
    
    NSArray *_viewControllers;
	UIView *_containerView;
    BOOL    _isNavTitleView;
}

@property(nonatomic,retain) SimSegmentBar *tabBarView;
@property(nonatomic,retain) NSArray *viewControllers;
@property(nonatomic,assign) NSInteger selectedIndex;
@property(nonatomic,assign) BOOL    isNavTitleView;
@property(nonatomic,readonly) UIViewController *selectedVC;

@end
