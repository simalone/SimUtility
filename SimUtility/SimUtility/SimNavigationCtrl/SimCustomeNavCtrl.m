//
//  SimCustomeNavCtrl.m
//
//  Created by Liu Xubin on 12-11-29.
//

#import "SimCustomeNavCtrl.h"
#import "UINavigationBar+addition.h"

#define kBarItemMargin 10
#define kNavBarHeight 44

@interface CustomBarView : UIView
@property (nonatomic, weak) UIImage *backgroudImage;
@property (nonatomic, strong) UIImageView *backgroudImageView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@end

@implementation CustomBarView
@synthesize backgroudImage = _backgroudImage;
@synthesize backgroudImageView = _backgroudImageView;
@synthesize titleView = _titleView, leftView = _leftView, rightView = _rightView;

- (UIImage *)backgroudImage{
    return self.backgroudImageView.image;
}

- (void)setBackgroudImage:(UIImage *)backgroudImage{
    if (self.backgroudImageView.image != backgroudImage) {
        if (backgroudImage) {
            if (!_backgroudImageView) {
                _backgroudImageView = [[UIImageView alloc] initWithImage:backgroudImage];
                [self insertSubview:_backgroudImageView atIndex:0];
            }
            else{
                _backgroudImageView.image = backgroudImage;
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
        if (_leftView) {
            IgnoreException([_leftView removeObserver:self forKeyPath:@"frame"];)
            [_leftView removeFromSuperview];
            _leftView = nil;
        }
        
        _leftView = leftView;
        [_leftView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        [self setNeedsLayout];

    }
}

- (void)setRightView:(UIView *)rightView{
    if (![_rightView isEqual:rightView]) {
        if (_rightView) {
            IgnoreException([_rightView removeObserver:self forKeyPath:@"frame"];)
            [_rightView removeFromSuperview];
            _rightView = nil;
        }
        
        _rightView = rightView;
        [_rightView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        [self setNeedsLayout];
    }
}

- (void)setTitleView:(UIView *)titleView{
    if (![_titleView isEqual:titleView]) {
        if (_titleView) {
            [_titleView removeFromSuperview];
        }
        _titleView = titleView;
        [_titleView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat leftMargin = kBarItemMargin;
    CGFloat rightMargin = kBarItemMargin;
    CGFloat centerY = self.height - kNavBarHeight/2;
    if (self.leftView) {
        if (self.leftView.superview != self) {
            [self insertSubview:self.leftView atIndex:3];
        }
        self.leftView.left = kBarItemMargin;
        self.leftView.centerY = centerY;
        leftMargin = self.leftView.right + kBarItemMargin;
    }
    
    if (self.rightView) {
        if (self.rightView.superview != self) {
            [self insertSubview:self.rightView atIndex:2];
        }
        self.rightView.right = self.width - kBarItemMargin;
        self.rightView.centerY = centerY;
        rightMargin += self.width - self.rightView.left;
    }
    
    if (self.titleView) {
        if (self.titleView.superview != self) {
            [self insertSubview:self.titleView atIndex:1];
        }
        CGFloat sideMargin = MAX(leftMargin, rightMargin);
        self.titleView.width = (self.width - 2 * sideMargin);
        self.titleView.left = sideMargin;
        self.titleView.centerY = centerY;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"frame"]) {
        CGFloat centerY = self.height - kNavBarHeight/2;
        if ([object isEqual:self.leftView]) {
            if (self.leftView.left != kBarItemMargin) {
                self.leftView.left = kBarItemMargin;
            }
            if (self.leftView.centerY != centerY) {
                self.leftView.centerY = centerY;
            }
        }
        else if ([object isEqual:self.rightView]) {
            if (self.rightView.right != self.width - kBarItemMargin) {
                self.rightView.right = self.width - kBarItemMargin;
            }
            if (self.rightView.centerY != centerY) {
                self.rightView.centerY = centerY;
            }

        }
        else if ([object isEqual:self.titleView]) {
            CGPoint centerPoint = CGPointMake(self.width/2, centerY);
            if (!CGPointEqualToPoint(self.titleView.center, centerPoint)) {
                self.rightView.center = centerPoint;
            }
        }
    }
}

- (void)dealloc{
    IgnoreException([self.rightView removeObserver:self forKeyPath:@"frame"];)
    IgnoreException([self.leftView removeObserver:self forKeyPath:@"frame"];)
}


@end

@interface SimCustomeNavCtrl ()
@property (nonatomic, strong) CustomBarView *customBarView;
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

- (void)updateNavBar {
    [self updateNavBarForVc:self.topViewController forceRefresh:NO];
}

- (void)updateNavBarForVc:(UIViewController *)currentVc forceRefresh:(BOOL)forceRefresh{
    if (self.isCustomBar) {
        if (!self.customBarView) {
            CGRect navigationBarFrame = self.navigationBar.frame;
            navigationBarFrame.size.height += navigationBarFrame.origin.y;
            navigationBarFrame.origin.y = 0;
            self.customBarView = [[CustomBarView alloc] initWithFrame:navigationBarFrame];
            if ([self.navigationBar respondsToSelector:@selector(setShadowImage:)]) {
                UIImage *blankImage = [[UIImage alloc] init];
                [[UINavigationBar appearance] setBackgroundImage:blankImage forBarMetrics:UIBarMetricsDefault];
                [[UINavigationBar appearance] setShadowImage:blankImage];
                blankImage = nil;
            }
        }
        [self.navigationBar.superview addSubview:self.customBarView];
        
        if (currentVc.navigationItem.titleView) {
            self.customBarView.titleView = currentVc.navigationItem.titleView;
        }
        else{
            if (currentVc.navigationItem.title.length > 0) {
                if (![self.customBarView.titleView isKindOfClass:[UILabel class]]) {
                    UILabel *titleView = [[UILabel alloc] initWithFrame:self.navigationBar.bounds];
                    titleView.backgroundColor = [UIColor clearColor];
                    titleView.font = [UIFont systemFontOfSize:16.0];
                    titleView.textAlignment = UITextAlignmentCenter;
                    titleView.textColor = [UIColor whiteColor];
                    self.customBarView.titleView = titleView;
                }
                else{
                    [(UILabel *)self.customBarView.titleView setText:self.navigationItem.title];
                }
            }
        }
        
        if([self.viewControllers count] > 1 && !currentVc.navigationItem.leftBarButtonItem.customView){
            if ([self.backBtn allTargets].count == 0) {
                [self.backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
            }
            self.customBarView.leftView = self.backBtn;
            self.customBarView.rightView = currentVc.navigationItem.rightBarButtonItem.customView;
        }
        else{
            self.customBarView.leftView = currentVc.navigationItem.leftBarButtonItem.customView;
            self.customBarView.rightView = currentVc.navigationItem.rightBarButtonItem.customView;
        }
    }
    
    if ((self.navBarImage == nil && self.defaultNavBarImage != nil) || forceRefresh) {
        self.navBarImage = self.defaultNavBarImage;
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (![navigationController isKindOfClass:[SimCustomeNavCtrl class]]) {
        return;
    }
    [self updateNavBarForVc:viewController forceRefresh:NO];
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
    UIViewController *visibleVc = self.visibleViewController;
    return [visibleVc doPopBack];
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (self.customBarView) {
        [self.navigationBar.superview sendSubviewToBack:self.navigationBar];
    }
}

@end

