//
//  SimBottomTabBarVC.m
//
//  Created by Xubin Liu on 12-7-11.
//

#import "SimBottomTabBarVC.h"
#import "SimSegmentBar.h"

@interface SimBottomTabBarVC ()

- (void)updateContainerViewFrame;

@end

@implementation SimBottomTabBarVC

@synthesize tabBarView = _segmentBar;
@synthesize tabBarHide;


- (void)setTabBarView:(SimSegmentBar *)tabbarView{
	if (_segmentBar != tabbarView) {
		[_segmentBar release];
		_segmentBar = [tabbarView retain];
		_segmentBar.delegate = self;
	}
	
    CGRect frame = _segmentBar.frame;
	frame.origin = CGPointZero;
    _segmentBar.frame = frame;
    [self.tabBar addSubview:_segmentBar];
    _segmentBar.selectedIndex = 0;
    
	float offset = _segmentBar.frame.size.height - self.tabBar.frame.size.height;
    frame = self.tabBar.frame;
	frame.origin.y -= offset;
	frame.size.height += offset;
    self.tabBar.frame = frame;
    
    [self updateContainerViewFrame];
}

- (void)updateContainerViewFrame{
    UIView *mainContainer = (UIView *)[self.view.subviews objectAtIndex:0];
    CGRect containerFrame = mainContainer.frame;
    if (self.tabBarHide) {
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

- (void)dealloc{
	[_segmentBar release], _segmentBar = nil;
	[super dealloc];
}

- (void)setSelectedIndex:(NSUInteger)index
{
	[super setSelectedIndex:index];
	[self.tabBar bringSubviewToFront:_segmentBar];
	_segmentBar.selectedIndex = index;
}

#pragma mark - BWXSegmentBarDelegate
- (void)segmentBar:(SimSegmentBar*)bar didSelectIndex:(NSInteger)index preIndex:(NSInteger)preIndex{
    self.selectedIndex = index;

}


@end
