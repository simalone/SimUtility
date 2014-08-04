//
//  SimDragMenu.m
//
//  Created by Xubin Liu on 13-12-15.
//  Copyright (c) 2013年 Xubin Liu. All rights reserved.
//

#import "SimDragMenu.h"
#import "AccelerationAnimation.h"
#import "Evaluate.h"
#import "UIViewController+DragMenu.h"

#define kShowDuration 0.4
#define kAniStep  99

@interface SimDragMenu () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, strong) UIView *dragMaskView;
@property (nonatomic, assign) CGFloat dragStartTranslationX;
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic ,assign) CGFloat dragRadio;

@property (nonatomic, weak) UIWindow *window;
@property (nonatomic, strong) UIImageView *screenShotView;
@property (nonatomic, assign) BOOL isShowMenu;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation SimDragMenu

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.window = [[[UIApplication sharedApplication] delegate] window];
        self.viewLeftX = 0;
        self.viewRightX = self.window.frame.size.width - 70;
        self.viewLeftScale = 1.0f;
        self.viewRightScale = 0.6f;
        self.dragRadio = (self.viewRightX - self.viewLeftX) / (self.viewRightScale - self.viewLeftScale);
        
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        self.panGestureRecognizer.delegate = self;
        [self.view addGestureRecognizer:self.panGestureRecognizer];
    }
    
    return self;
}

- (void)loadView{
    [super loadView];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (!self.menuView) {
        self.menuView = [[UITableView alloc] initWithFrame:CGRectMake(10, self.view.height/4, self.view.width - 80, self.view.height/2)];
        self.menuView.showsHorizontalScrollIndicator = NO;
        self.menuView.showsVerticalScrollIndicator = NO;
        self.menuView.delegate = self;
        self.menuView.scrollEnabled = NO;
        self.menuView.dataSource = self;
        self.menuView.backgroundView = nil;
        self.menuView.backgroundColor = [UIColor clearColor];
        self.menuView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBar.hidden = YES;
    UIView *transitionView = [[self.view subviews] objectAtIndex:0];
    transitionView.height += self.tabBar.height;
    self.view.frame = CGRectMake(0 , 0, self.window.width, self.window.height);
}

#pragma mark - Public Accessor
- (void)showMenu:(BOOL)show{
    [self showMenu:show animated:YES];
}

- (void)showMenu:(BOOL)show animated:(BOOL)animated{
    if (show != self.isShowMenu) {
        [self beginDraging];
        [self willEndDragWithXPos:show ? self.viewRightX : self.viewLeftX
                        velocityX:(self.window.frame.size.width-self.viewLeftX) / kShowDuration
                         animated:animated];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated{
    if (!animated || self.selectedIndex == selectedIndex) {
        [super setSelectedIndex:selectedIndex];
        [self.menuView reloadData];
        [self showMenu:NO];
    }
    else{
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.screenShotView.frame = [self dragViewFramByXPos:self.window.width];
                         } completion:^(BOOL finished) {
                             [super setSelectedIndex:selectedIndex];
                             [self.menuView reloadData];
                             self.screenShotView.image = [self capture:self.view];
                             [self showMenu:NO];
                         }];
    }
}

- (void)switchToMenuIndex:(NSUInteger)menuIndex{
    [self setSelectedIndex:menuIndex animated:YES];
}

#pragma makr - Private Accessor
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setMenuBgImageView:(UIImageView *)menuBgImageView{
    if (_menuBgImageView != menuBgImageView) {
        if (_menuBgImageView) {
            [_menuBgImageView removeFromSuperview];
        }
        
        if (_menuBgImageView && menuBgImageView) {
            menuBgImageView.frame = self.window.bounds;
            [self.window insertSubview:menuBgImageView belowSubview:self.menuView];
        }
        
        _menuBgImageView = menuBgImageView;
    }
    
}

#pragma mark -  UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //tableView.allowsSelection = NO;
    [self switchToMenuIndex:indexPath.row];
}


#pragma mark -  UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewControllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MenuCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    
    cell.textLabel.text = [[self.viewControllers[indexPath.row] tabBarItem] title];
    
    return cell;
}

#pragma mark - util method
- (UIImage *)capture:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    CGContextClipToRect(UIGraphicsGetCurrentContext(), CGRectMake(0, kApplicationTop, view.width, view.height-kApplicationTop));
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return img;
}

- (void)addAnimation:(NSString *)path view:(UIView *)view startValue:(double)startValue endValue:(double)endValue{
    AccelerationAnimation *animation = [AccelerationAnimation animationWithKeyPath:path
                                                                        startValue:startValue
                                                                          endValue:endValue
                                                                  evaluationObject:[[ExponentialDecayEvaluator alloc] initWithCoefficient:6.0]
                                                                 interstitialSteps:kAniStep];
    animation.removedOnCompletion = NO;
    [view.layer addAnimation:animation forKey:path];
}

- (CGRect)dragViewFramByXPos:(CGFloat)xPos{
    xPos = MAX(0, xPos);
    xPos = MIN(self.view.width, xPos);

    CGFloat currentScale = [self scaleForXPos:xPos];
    
    CGRect frame = self.screenShotView.frame;
    frame.size.width = self.window.width * currentScale;
    frame.size.height = self.window.height * currentScale;
    frame.origin.x = xPos;
    frame.origin.y = (self.window.height - frame.size.height) / 2;
    return frame;
}

- (CGFloat)scaleForXPos:(CGFloat)xPos{
    CGFloat currentScale = self.viewLeftScale + ((xPos - self.viewLeftX) / self.dragRadio);
    currentScale = MAX(0, currentScale);
    currentScale = MIN(1.0f, currentScale);
    return currentScale;
}

- (void)updateMenuZoomForxPos:(CGFloat)xPos{
    CGFloat curScale = [self scaleForXPos:xPos];
    CGFloat maxScale = [self scaleForXPos:self.viewLeftX];
    CGFloat minScale = [self scaleForXPos:self.viewRightX];
    CGFloat zoomScale = 1.0f + (curScale - minScale) / (maxScale - minScale);
    //NSLog(@"zoomScale:%f", zoomScale);
    zoomScale = MAX(1.0f, zoomScale);
    zoomScale = MIN(zoomScale, 2.0f);
    self.menuBgImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, zoomScale, zoomScale);
    self.menuView.transform = CGAffineTransformScale(CGAffineTransformIdentity, zoomScale, zoomScale);
    self.menuView.alpha = 1.0f - 2 * (curScale - minScale) / (maxScale - minScale);
}

- (void)setViewControllers:(NSArray *)viewControllers{
    [super setViewControllers:viewControllers];
}

#pragma mark - Drag Logic
- (void)beginDraging{
    [[NSNotificationCenter defaultCenter] postNotificationName:kWillBeginDragMenu object:@(self.isShowMenu)];

    if (!self.isShowMenu) {
        if (!self.menuBgImageView) {
            self.menuBgImageView = [[UIImageView alloc] initWithFrame:self.window.bounds];
            self.menuBgImageView.userInteractionEnabled = YES;
            self.menuBgImageView.image = UIImageNamed(@"channel_img_bg");
        }
        [self.window addSubview:self.menuBgImageView];

        self.menuView.transform = CGAffineTransformIdentity;
        [self.window addSubview:self.menuView];
        
        if (!self.screenShotView) {
            self.screenShotView = [[UIImageView alloc] initWithImage:[self capture:self.view]];
            self.screenShotView.layer.anchorPoint = CGPointMake(0, 0);
            [self.screenShotView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        }
        self.screenShotView.frame = self.window.bounds;
        [self.window addSubview:self.screenShotView];
    }
    if(!self.dragMaskView){
        self.dragMaskView = [[UIButton alloc] initWithFrame:self.window.bounds];
    }
    [self.window addSubview:self.dragMaskView];

    
    self.isDragging = YES;
    self.screenShotView.frame = [self dragViewFramByXPos:self.screenShotView.left];
}



- (void)willEndDragWithXPos:(CGFloat)xPos velocityX:(CGFloat)velocityX animated:(BOOL)animated{
    BOOL showMenu = YES;
    if (velocityX <= -1500.0f) {
        showMenu = NO;
    }
    else if(velocityX <= 1500.f){
        if(!self.isShowMenu && xPos < self.viewLeftX + (self.viewRightX-self.viewLeftX)*1/4){
            showMenu = NO;
        }
        else if(self.isShowMenu && xPos < self.viewLeftX + (self.viewRightX-self.viewLeftX)*3/4){
            showMenu = NO;
        }
    }
    
    CGFloat destX = showMenu ? self.viewRightX : self.viewLeftX;
    CGRect destRect = [self dragViewFramByXPos:destX];
    if (animated) {
        NSTimeInterval duration = kShowDuration; //MIN((fabsf(self.screenShotView.frame.origin.x-destX)/velocityX), kShowDuration);
        [CATransaction begin];
        [CATransaction setValue:[NSNumber numberWithFloat:duration] forKey:kCATransactionAnimationDuration];
        [self addAnimation:@"position.x" view:self.screenShotView startValue:self.screenShotView.left endValue:destRect.origin.x];
        [self addAnimation:@"position.y" view:self.screenShotView startValue:self.screenShotView.top endValue:destRect.origin.y];
        [self addAnimation:@"bounds.size.width" view:self.screenShotView startValue:self.screenShotView.width endValue:destRect.size.width];
        [self addAnimation:@"bounds.size.height" view:self.screenShotView startValue:self.screenShotView.height endValue:destRect.size.height];
        self.screenShotView.layer.position = destRect.origin;
        self.screenShotView.layer.bounds = CGRectMake(0, 0, destRect.size.width, destRect.size.height);
        [CATransaction commit];
        [self performSelector:@selector(didEndDrag) withObject:nil afterDelay:duration];
        
        [UIView animateWithDuration:showMenu ? kShowDuration-0.1 : kShowDuration
                         animations:^{
            [self updateMenuZoomForxPos:destX];
        }];
    }
    else{
        self.screenShotView.frame = [self dragViewFramByXPos:destX];
        [self updateMenuZoomForxPos:destX];
        [self didEndDrag];
    }
}

- (void)setIsShowMenu:(BOOL)isShowMenu{
    if (_isShowMenu != isShowMenu) {
        _isShowMenu = isShowMenu;
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuStatusChanged object:@(self.isShowMenu)];
    }
}

- (void)didEndDrag{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidEndDragMenu object:@(self.isShowMenu)];
    self.isShowMenu = self.screenShotView.frame.origin.x == self.viewRightX;;
    if (!self.isShowMenu) {
        [self.menuBgImageView removeFromSuperview];
        [self.menuView removeFromSuperview];
        [self.screenShotView removeFromSuperview];
        IgnoreException([self.screenShotView removeObserver:self forKeyPath:@"frame"];);
        self.screenShotView = nil;
        [self.view addGestureRecognizer:self.panGestureRecognizer];
    }
    else{
        self.screenShotView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.screenShotView addGestureRecognizer:tapGestureRecognizer];
        
        [self.view removeGestureRecognizer:self.panGestureRecognizer];
        [self.screenShotView addGestureRecognizer:self.panGestureRecognizer];
    }
    
    [self.dragMaskView removeFromSuperview];
    self.dragMaskView = nil;
    self.isDragging = NO;
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"frame"]) {
        if (self.screenShotView) {
            [self updateMenuZoomForxPos:self.screenShotView.left];
        }
    }
}


#pragma mark - UIPanGestureRecognizer
- (void)dragOnViewDidBegin:(UIPanGestureRecognizer *)gesture{
    self.isDragging = NO;
    self.screenShotView.userInteractionEnabled = NO;
    self.dragStartTranslationX = self.screenShotView.left - [gesture translationInView:self.view].x;
}

- (void)dragOnViewIsDragging:(UIPanGestureRecognizer *)gesture{
    if (!self.isDragging) {
        [self beginDraging];
    }
    self.screenShotView.frame = [self dragViewFramByXPos:self.dragStartTranslationX + [gesture translationInView:self.view].x];
}

- (void)dragOnViewDidEnd:(UIPanGestureRecognizer *)gesture{
    if(self.isDragging){
        CGPoint velocity = [gesture velocityInView:gesture.view];
        [self willEndDragWithXPos:self.screenShotView.left
                         velocityX:velocity.x
                         animated:YES];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self dragOnViewDidBegin:recognizer];
          break;
        case UIGestureRecognizerStateChanged:
            [self dragOnViewIsDragging:recognizer];
           break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            [self dragOnViewDidEnd:recognizer];
            break;
        default:
            break;
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gesture{
    if (self.isShowMenu) {
        if (self.isShowMenu) {
            CGPoint pt = [gesture locationInView:self.view];
            if (CGRectContainsPoint(self.screenShotView.frame, pt)) {
                [self showMenu:NO];
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.panGestureRecognizer == gestureRecognizer) {
        UIViewController *vc = self.selectedViewController;
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc visibleViewController];
        }
        
        if ([vc respondsToSelector:@selector(shouldBeginDragGesture:receiveTouch:)]) {
            return [vc shouldBeginDragGesture:gestureRecognizer receiveTouch:touch];
        }
    }
    
    return YES;
}

@end
