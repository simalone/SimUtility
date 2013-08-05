//
//  SimBottomTabBarVC.m
//
//  Created by Xubin Liu on 12-7-11.
//

#import "SimBottomTabBarVC.h"
#import "SimSegmentBar.h"

@interface SimBottomTabBarVC ()
@end

@implementation SimBottomTabBarVC

@synthesize tabBarView = _segmentBar;


- (void)dealloc{
	self.tabBarView = nil;
	[super dealloc];
}


- (void)setTabBarView:(SimSegmentBar *)tabbarView{
	if (_segmentBar != tabbarView) {
		[_segmentBar release];
		_segmentBar = [tabbarView retain];
		_segmentBar.delegate = self;
	}
    
    if (!self.tabBarTransparent) {
        CGRect frame = _segmentBar.frame;
        frame.origin = CGPointZero;
        _segmentBar.frame = frame;
        [self.tabBar addSubview:_segmentBar];
        
        float offset = _segmentBar.frame.size.height - self.tabBar.frame.size.height;
        frame = self.tabBar.frame;
        frame.origin.y -= offset;
        frame.size.height += offset;
        self.tabBar.frame = frame;
    }
    else{
        CGRect frame = self.tabBarView.frame;
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        self.tabBarView.frame = frame;
        [self.view addSubview:self.tabBarView];
        
        CGRect tabFrame = self.tabBar.frame;
        tabFrame.origin.y = self.view.frame.size.height;
        tabFrame.size.height = 0.1f;
        self.tabBar.frame = tabFrame;
    }
    
    [self updateContainerViewFrame];
}

- (void)updateContainerViewFrame{
    UIView *mainContainer = (UIView *)[self.view.subviews objectAtIndex:0];
    CGRect containerFrame = mainContainer.frame;
    if (self.tabBarHide || self.tabBarTransparent) {
        containerFrame.size.height = self.view.frame.size.height;
    }
    else{
        containerFrame.size.height = self.view.frame.size.height - self.tabBar.frame.size.height;
    }
    mainContainer.frame = containerFrame;
}

- (void)setTabBarHide:(BOOL)hide {    
    CGRect tabFrame = self.tabBar.frame;
    if (hide) {
        tabFrame.origin.y = self.view.frame.size.height;
    }
    else{
        tabFrame.origin.y = self.view.frame.size.height - self.tabBar.frame.size.height;
    }
    self.tabBar.frame = tabFrame;

    [self updateContainerViewFrame];
}

- (BOOL)tabBarHide{
    return (self.tabBar.frame.origin.y ==  self.view.frame.size.height);
}

- (void)setTabBarTransparent:(BOOL)tabBarTransparent{
    _tabBarTransparent = tabBarTransparent;
    
    if (self.tabBarView) {
        CGRect frame = self.tabBarView.frame;
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        self.tabBarView.frame = frame;
        [self.tabBarView removeFromSuperview];
        [self.view addSubview:self.tabBarView];
    }
    
    [self updateContainerViewFrame];
}


- (void)setTabBarHide:(BOOL)hide animated:(BOOL)animated{
    if (!animated) {
        self.tabBarHide = hide;
    }
    else{
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.tabBarHide = hide;
                         }];
    }
}

- (void)setBadgeValue:(NSString *)value forIndex:(NSInteger)index{
    if ([value integerValue] <= 0) {
        [self.tabBarView setBadgeValue:@"" forIndex:index];
    }
    else{
        [self.tabBarView setBadgeValue:value forIndex:index];
    }
}

- (NSString *)badgeValueForIndex:(NSInteger)index{
    NSString *value = [self.tabBarView badgeValueForIndex:index];
    if ([value integerValue] <= 0) {
        return @"";
    }
    
    return value;
}


- (void)setSelectedIndex:(NSUInteger)index{
    BOOL sameVc = self.selectedIndex == index;
    if (sameVc) {
        if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
        }
    }
	[super setSelectedIndex:index];
    if (_segmentBar.selectedIndex != index) {
        if (!self.tabBarTransparent) {
            //使Tab前置，防止系统的在上面。
            [_segmentBar.superview bringSubviewToFront:_segmentBar];
        }
        _segmentBar.selectedIndex = index;
    }
}


#pragma mark - BWXSegmentBarDelegate
- (void)segmentBar:(SimSegmentBar*)bar didSelectIndex:(NSInteger)index preIndex:(NSInteger)preIndex{
    self.selectedIndex = index;
}


@end
