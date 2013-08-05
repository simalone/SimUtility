//
//  SimCustomeNavCtrl.m
//
//  Created by Liu Xubin on 12-11-29.
//

#import "SimCustomeNavCtrl.h"
#import "UINavigationBar+addition.h"

#define KNavBarViewTag 201362

@interface CustomBarView : UIView
@property (nonatomic, assign) UIImage *backgroudImage;
@property (nonatomic, retain) UIImageView *backgroudImageView;
@property (nonatomic, retain) UIView *titleView;
@property (nonatomic, retain) UIView *leftView;
@property (nonatomic, retain) UIView *rightView;
@end

@implementation CustomBarView
- (void)dealloc{
    self.titleView = nil;
    self.leftView = nil;
    self.rightView = nil;
    self.backgroudImageView = nil;
    [super dealloc];
}

- (void)setBackgroudImage:(UIImage *)backgroudImage{
    if (self.backgroudImageView.image != backgroudImage) {
        if (backgroudImage) {
            if (!_backgroudImageView) {
                _backgroudImageView = [[UIImageView alloc] initWithImage:backgroudImage];
                [self insertSubview:_backgroudImageView atIndex:0];
            }
        }
        else{
            self.backgroudImageView = nil;
        }
        
        self.backgroudImageView.frame = self.bounds;
    }
}

- (void)setLeftView:(UIView *)leftView{
    if (![_leftView isEqual:leftView]) {
        [_leftView removeFromSuperview];
        [_leftView release];
        _leftView = [leftView retain];
        if (self.leftView.superview != self) {
            [self insertSubview:_leftView atIndex:2];
        }
    }
}

- (void)setRightView:(UIView *)rightView{
    if (![_rightView isEqual:rightView]) {
        [_rightView removeFromSuperview];
        [_rightView release];
        _rightView = [rightView retain];
        [self insertSubview:_rightView atIndex:3];
    }
}

- (void)setTitleView:(UIView *)titleView{
    if (![_titleView isEqual:titleView]) {
        [_titleView removeFromSuperview];
        [_titleView release];
        _titleView = [titleView retain];
        [self insertSubview:self.titleView atIndex:1];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat leftMargin = 10;
    CGFloat rightMargin = 10;
    if (self.leftView) {
        self.leftView.left = 10;
        self.leftView.centerY = self.height/2;
        leftMargin += self.leftView.width+10;
    }
    
    if (self.rightView) {
        if (self.rightView.superview != self) {
            [self insertSubview:self.rightView atIndex:3];
        }
        self.rightView.right = self.width - 10;
        self.rightView.centerY = self.height/2;
        rightMargin += self.rightView.width+10;
    }
    
    if (self.titleView) {
        if (self.titleView.superview != self) {
            [self insertSubview:self.titleView atIndex:1];
        }
        CGFloat sideMargin = leftMargin > rightMargin ? leftMargin : rightMargin;
        self.titleView.width = (self.width - 2 * sideMargin);
        self.titleView.left = sideMargin ;
    }
}

@end

@interface SimCustomeNavCtrl ()
@property (nonatomic, retain) CustomBarView *customBarView;
@end

@implementation SimCustomeNavCtrl
@synthesize navBarImage;
@synthesize defaultNavBarImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
        self.isCustomBar = YES;
    }
    return self;
}

- (UIView *)customNavBarView{
    return self.customBarView;
}

- (void)updateNavBar{
    if (self.navBarImage == nil) {
        if (self.defaultNavBarImage != nil) {
            self.customBarView.backgroudImage = self.defaultNavBarImage;
        }
    }
    
    UIViewController *visibleVc = self.visibleViewController;
    if (self.isCustomBar) {
        if (visibleVc.navigationItem.titleView) {
            self.customBarView.titleView = visibleVc.navigationItem.titleView;
        }
        else{
            self.customBarView.titleView = self.titleView;
        }
        
        if([self.viewControllers count] > 1 && !visibleVc.navigationItem.leftBarButtonItem.customView){
            if ([self.backBtn allTargets].count == 0) {
                [self.backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
            }
            self.customBarView.leftView = self.backBtn;
            self.customBarView.rightView = visibleVc.navigationItem.rightBarButtonItem.customView;
        }
        else{
            self.customBarView.leftView = visibleVc.navigationItem.leftBarButtonItem.customView;
            self.customBarView.rightView = visibleVc.navigationItem.rightBarButtonItem.customView;
        }
        [self.customBarView setNeedsLayout];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (![navigationController isKindOfClass:[SimCustomeNavCtrl class]]) {
        return;
    }
    
    if (self.isCustomBar) {
        if (!_customBarView) {
            _customBarView = [[CustomBarView alloc] initWithFrame:self.navigationBar.frame];
        }
        if (![self.navigationBar.superview viewWithTag:KNavBarViewTag]) {
            self.customBarView.tag = KNavBarViewTag;
            [self.navigationBar.superview addSubview:self.customBarView];
        }
        else{
            [self.navigationBar.superview bringSubviewToFront:self.customBarView];
        }
        self.customBarView.frame = self.navigationBar.frame;
        if (viewController.navigationItem.titleView) {
            self.customBarView.titleView = viewController.navigationItem.titleView;
        }
        else{
            self.customBarView.titleView = self.titleView;
        }
        
        if (self.navBarImage == nil) {
            if (self.defaultNavBarImage != nil) {
                self.customBarView.backgroudImage = self.defaultNavBarImage;
            }
        }
        
        if([navigationController.viewControllers count] > 1){
            if ([self.backBtn allTargets].count == 0) {
                [self.backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
            }
            
            self.customBarView.leftView = self.backBtn;
            self.customBarView.rightView = viewController.navigationItem.rightBarButtonItem.customView;
        }
        else{
            self.customBarView.leftView = viewController.navigationItem.leftBarButtonItem.customView;
            self.customBarView.rightView = viewController.navigationItem.rightBarButtonItem.customView;
        }
        [self.customBarView setNeedsLayout];
    }
    else{
        if (self.navBarImage == nil) {
            if (self.defaultNavBarImage != nil) {
                self.navBarImage = self.defaultNavBarImage;
            }
        }
    }
    
}

- (UIImage *)navBarImage{
    if (self.isCustomBar) {
        return self.customBarView.backgroudImage;
    }
    else{
        return self.navigationBar.backgroundImage;
    }
}

- (void)setNavBarImage:(UIImage *)barImage{
    if (self.isCustomBar) {
        self.customBarView.backgroudImage = barImage;
    }
    else{
        self.navigationBar.backgroundImage = barImage;
    }
}

- (void)restoreDefaultBarImage{
    self.navBarImage = self.defaultNavBarImage;
}

- (UIViewController*)popViewController{
    return [self popViewControllerAnimated:YES];
}


- (void)dealloc{
    self.titleView = nil;
    self.customBarView = nil;
    self.backBtn = nil;
    self.defaultNavBarImage = nil;
    [super dealloc];
}

@end

