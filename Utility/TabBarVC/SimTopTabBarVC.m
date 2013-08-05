//
//  SimTopTabBarVC.m
//
//  Created by Xubin Liu on 12-7-11.
//

#import "SimTopTabBarVC.h"
#import "SimSegmentBar.h"

@interface SimTopTabBarVC ()

@property (nonatomic, retain) UIView *transitionView;
@end

@implementation SimTopTabBarVC

@synthesize tabBarView = _segmentBar;
@synthesize viewControllers = _viewControllers;
@synthesize isNavTitleView = _isNavTitleView;
@synthesize selectedVC;

- (void)dealloc{
    self.viewControllers = nil;
    self.tabBarView = nil;
    self.transitionView = nil;
    [super dealloc];
}


//warning: selectedVC viewWillAppear, viewWillDisappear etc.
//will invoked more than once, and difference for ios 4.3 and ios 5.0 ...
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.selectedVC viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.selectedVC viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.selectedVC viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.selectedVC viewDidDisappear:animated];
}

- (void)setTabBarView:(SimSegmentBar *)tabbarView{
	if (_segmentBar != tabbarView) {
		[_segmentBar release];
		_segmentBar = [tabbarView retain];
		_segmentBar.delegate = self;
        
        CGRect _frame = _segmentBar.frame;
        _frame.origin = CGPointZero;
        _segmentBar.frame = _frame;
        if (self.isNavTitleView) {
            self.navigationItem.titleView = _segmentBar;
        }
        else{
            [self.view addSubview:_segmentBar];
        }
        
        if (self.transitionView) {
            [self.transitionView removeFromSuperview];
            self.transitionView = nil;
        }
        
        if (self.isNavTitleView) {
            _frame = self.view.bounds;
        }
        else {
            _frame = CGRectMake(0, _segmentBar.frame.size.height, self.view.frame.size.width,self.view.frame.size.height - _segmentBar.frame.size.height);
        }
        _transitionView = [[UIView alloc] initWithFrame:_frame];
        _transitionView.clipsToBounds = YES;
        [_transitionView setNeedsLayout];
        _transitionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_transitionView];
        
        _containerView = nil;
        if (self.viewControllers.count > 0) {
            self.selectedIndex = 0;
        }
	}
}

- (void)setViewControllers:(NSArray *)viewControllers{
    [_viewControllers release];
    _viewControllers = [viewControllers retain];
    
    if (self.tabBarView) {
        self.selectedIndex = 0;
    }
}


- (void)setIsNavTitleView:(BOOL)isNavTitleView{
    _isNavTitleView = isNavTitleView;
    if (_isNavTitleView) {
        if (self.tabBarView) {
            [self.tabBarView removeFromSuperview];
            self.navigationItem.titleView = self.tabBarView;
            
            CGRect frame = _transitionView.frame;
            frame.origin.y = 0;
            frame.size.height = self.view.frame.size.height;
            _transitionView.frame = frame;
        }
    }
}

- (void)setSelectedIndex:(NSInteger )index
{
    self.tabBarView.selectedIndex = index;
}

- (NSInteger)selectedIndex{
    if (self.tabBarView) {
        return self.tabBarView.selectedIndex;
    }
    return NSNotFound;
}

- (void)loadView {
    [super loadView];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


- (UIViewController*)selectedVC
{
    if (self.selectedIndex != NSNotFound) {
        return [self.viewControllers objectAtIndex:self.selectedIndex];
    }
    
    return nil;
}

#pragma mark - BWXSegmentBarDelegate
- (BOOL)segmentBar:(SimSegmentBar*)bar shouldSelectIndex:(NSInteger)index preIndex:(NSInteger)preIndex{
    if (preIndex != NSNotFound) {
        UIViewController *_curVC = [self.viewControllers objectAtIndex:preIndex];
        [_curVC viewWillDisappear:NO];
    }
    
    if (index != NSNotFound) {
        UIViewController *_nextVC = [self.viewControllers objectAtIndex:index];
        [_nextVC viewWillAppear:NO];
    }
    
    
    return (index != preIndex);
}

- (void) segmentBar:(SimSegmentBar*)bar didSelectIndex:(NSInteger)index preIndex:(NSInteger)preIndex{
    if (preIndex != NSNotFound) {
        UIViewController *_preVC = [self.viewControllers objectAtIndex:preIndex];
        [_containerView removeFromSuperview];
        [_preVC viewDidDisappear:NO];
    }

    
    if (self.viewControllers.count > index) {
        UIViewController *_nextVC = [self.viewControllers objectAtIndex:index];
        _containerView =_nextVC.view;
        CGRect frame = _containerView.frame;
        frame.origin = CGPointZero;
        frame.size.height = _transitionView.frame.size.height;
        _containerView.frame = frame;
        [_transitionView addSubview:_containerView];
        [_nextVC viewDidAppear:NO];
    }
}

@end
