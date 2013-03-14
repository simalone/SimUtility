//
//  BWXTopTabBarVC.h
//
//  Created by Xubin Liu on 12-7-11.
//

#import "SimSegmentBarDelegate.h"


@class SimSegmentBar;
@interface SimTopTabBarVC : UIViewController<SimSegmentBarDelegate>
{
    SimSegmentBar* _segmentBar;
    
    NSArray *_viewControllers;
	UIView *_containerView;
	UIView *_transitionView;
    BOOL    _isNavTitleView;
}

@property(nonatomic,retain) SimSegmentBar *tabBarView;
@property(nonatomic,retain) NSArray *viewControllers;
@property(nonatomic,assign) NSInteger selectedIndex;
@property(nonatomic,assign) BOOL    isNavTitleView;
@property(nonatomic,readonly) UIViewController *selectedVC;

@end
