//
//  SimDebugToolPad.m
//
//  Created by Xubin Liu on 12-1-14.
//

#import "SimDebugToolPad.h"
#import <QuartzCore/QuartzCore.h>
#import "SimDebugView.h"

#define PAD_SIZE 40
#define PAD_INSET 5
#define PAD_BOUNCE_INSET 20
#define PAD_ZOOMTIME 0.6f

static BOOL _enableDeubgView = NO;

typedef enum {
    kSimToolPadNone,
    kSimToolPadEnable,
    kSimToolPadBar
    
}ToolPadState ;

@interface SimDebugToolPad(){
    BOOL _enable;
    BOOL _bTouchMove;
    CGRect _padFrame;
    UIButton *_zoomBtn;
    ToolPadState _state;
}

@property(nonatomic, readonly) ToolPadState state;

- (void)zoomInOut;
+ (void)addDebugToolPad;
+ (void)reomveDebugToolPad;

@end

SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(SimDebugToolPad);
@implementation SimDebugToolPad
SYNTHESIZE_SINGLETON_FOR_CLASS(SimDebugToolPad);

@synthesize state = _state;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appWillResignActive)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        self.alpha = 0.8;
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.frame = CGRectMake(-PAD_SIZE, 0, PAD_SIZE, PAD_SIZE);
        _state = kSimToolPadNone;
        
        _zoomBtn = [[UIButton alloc] initWithFrame:CGRectMake(PAD_INSET, PAD_INSET, PAD_SIZE-2*PAD_INSET, PAD_SIZE-2*PAD_INSET)];   
        _zoomBtn.enabled = NO;
        [_zoomBtn setBackgroundColor:[UIColor whiteColor]];
        [_zoomBtn setTitle:@"Z" forState:UIControlStateNormal];
        [_zoomBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_zoomBtn addTarget:self action:@selector(zoomInOut) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_zoomBtn];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_zoomBtn release], _zoomBtn = nil;
    [super dealloc];
}

#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{   
    [super touchesBegan:touches withEvent:event];
    _bTouchMove = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
    CGPoint point1 = [touch previousLocationInView:self];

    CGRect frame = self.frame;
    CGFloat _deltaX = point.x-point1.x;
    CGFloat _deltaY = point.y-point1.y;
    if (pow(_deltaX, 2) + pow(_deltaY, 2) > 1) {
        _bTouchMove = YES;
    }
    frame.origin.x += _deltaX;
    frame.origin.y += _deltaY;
    
    if (frame.origin.x < -PAD_BOUNCE_INSET) {
        frame.origin.x = -PAD_BOUNCE_INSET;
    }
    else  if (frame.origin.x > self.superview.frame.size.width-PAD_BOUNCE_INSET) {
        frame.origin.x = self.superview.frame.size.width-PAD_BOUNCE_INSET;
    }
    
    if (frame.origin.y < PAD_BOUNCE_INSET) {
        frame.origin.y = PAD_BOUNCE_INSET;
    }
    else if (frame.origin.y > self.superview.frame.size.height-PAD_BOUNCE_INSET) {
        frame.origin.y = self.superview.frame.size.height-PAD_BOUNCE_INSET;
    }    
    
    self.frame = frame; 
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event{
    [super touchesEnded:touches withEvent:event];
    
    if (_bTouchMove) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.frame;
            if (frame.origin.x < self.superview.frame.size.width/2-frame.size.width/2) { 
                frame.origin.x = 0;
            }
            else{
                frame.origin.x = self.superview.frame.size.width-frame.size.width;
            }
            self.frame = frame;        
        }];
    }
    else{
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        if (CGRectContainsPoint(_zoomBtn.frame, point)) {
            [self performSelector:@selector(zoomInOut)];
        }
    }
}

#pragma mark - private

- (void)cleanText{
    SimDebugView *_debugView = [SimDebugView sharedInstance];
    [_debugView cleanText];
}

- (void)zoomInOut{
    if (_state == kSimToolPadNone || _state == kSimToolPadEnable) {
        _padFrame = self.frame;
        [SimDebugView addDebugView];
        SimDebugView *_debugView = [SimDebugView sharedInstance];
        
        UIButton *_cleanBtn = [[UIButton alloc] initWithFrame:_zoomBtn.frame];
        [_cleanBtn setBackgroundColor:[UIColor whiteColor]];
        [_cleanBtn setTitle:@"C" forState:UIControlStateNormal];
        [_cleanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cleanBtn addTarget:self action:@selector(cleanText) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cleanBtn];
        [_cleanBtn release];
        
        UIButton *_enableBtn = [[UIButton alloc] initWithFrame:_zoomBtn.frame];
        [_enableBtn setBackgroundColor:[UIColor whiteColor]];
        [_enableBtn setTitle:@"E" forState:UIControlStateNormal];
        [_enableBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_enableBtn addTarget:self action:@selector(enablePad:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_enableBtn];
        [_enableBtn release];
        
        [_debugView setTransform:CGAffineTransformMakeScale(2.0, 0.01)];
        [UIView animateWithDuration:PAD_ZOOMTIME
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             CGRect _tempRect =_zoomBtn.frame;

                             [_debugView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                             CGRect _superFrame = self.superview.frame;
                             self.frame = CGRectMake(_superFrame.size.width*0.2, _superFrame.size.height*0.8, _superFrame.size.width*0.6, PAD_SIZE);
                             _tempRect.origin.x = self.frame.size.width/2-PAD_SIZE/2-PAD_SIZE-PAD_INSET;
                             _zoomBtn.frame = _tempRect;
                             
                             _cleanBtn.frame = CGRectMake(self.frame.size.width/2-PAD_SIZE/2, PAD_INSET, PAD_SIZE-2*PAD_INSET, PAD_SIZE-2*PAD_INSET);
                             _enableBtn.frame = CGRectMake(self.frame.size.width/2+PAD_SIZE/2+PAD_INSET, PAD_INSET, PAD_SIZE-2*PAD_INSET, PAD_SIZE-2*PAD_INSET);
                         }
                         completion:^(BOOL finished) {
                             _zoomBtn.enabled = YES;
                             [self.superview bringSubviewToFront:self];
                             _state = kSimToolPadBar;
                         }
         ];

    }
    else{
        SimDebugView *_debugView = [SimDebugView sharedInstance];
        [UIView animateWithDuration:PAD_ZOOMTIME
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             [_debugView setTransform:CGAffineTransformMakeScale(2.0, 0.01)];
                             self.frame = _padFrame;
                             for (UIView *_subView in [self subviews]) {
                                 if (_subView != _zoomBtn) {
                                     _subView.alpha = 0;
                                 }
                             }
                             
                             _zoomBtn.center = CGPointMake(_padFrame.size.width/2, _padFrame.size.height/2);
                         }
                         completion:^(BOOL finished) {
                             for (UIView *_subView in [self subviews]) {
                                 if (_subView != _zoomBtn) {
                                     [_subView removeFromSuperview];
                                 }
                             }
                             [_debugView removeFromSuperview];
                             
                             _zoomBtn.enabled = NO;
                             _state = kSimToolPadEnable;
                         }
         ];
    }
}


- (void)enablePad:(UIButton *)btn{
    SimDebugView *_debugView = [SimDebugView sharedInstance];
   _debugView.userInteractionEnabled = !_debugView.userInteractionEnabled;
    if (_debugView.userInteractionEnabled) {
        [btn setTitle:@"E" forState:UIControlStateNormal];
    }
    else{
        [btn setTitle:@"D" forState:UIControlStateNormal];
    }
}

+(void)addDebugToolPad{
    dispatch_async(dispatch_get_main_queue(), ^{
        SimDebugToolPad *_padView = [SimDebugToolPad sharedInstance];
        UIWindow *_windows = [SimDebugView getTopWindow:NO];
        if (_padView.superview != _windows) {
            [SimDebugToolPad reomveDebugToolPad];
            [_windows addSubview:_padView];
        }
        CGRect _frame = _padView.frame;
        if (_frame.origin.x < 0) {
            _frame.origin = CGPointMake(_windows.frame.size.width-_frame.size.width, _windows.frame.size.height*0.8-PAD_SIZE/2);
            _padView.frame = _frame;
        }
    });
}

+(void)reomveDebugToolPad{
    SimDebugToolPad *_padView = [SimDebugToolPad sharedInstance];
    if (_padView.superview) {
        [_padView removeFromSuperview];
    }
}


#pragma mark - public
+ (void)enable{
    _enableDeubgView = YES;
    [SimDebugToolPad addDebugToolPad];
}

+ (void)disable{
    _enableDeubgView = NO;
    [SimDebugToolPad reomveDebugToolPad];
}



+ (void)debugInfo:(NSString *)info{
    if (_enableDeubgView) {
        [SimDebugView debugInfo:info];
    }
}


#pragma mark - notification
- (void)appDidBecomeActive{
    [SimDebugToolPad addDebugToolPad];
}

- (void)appWillResignActive{
    SimDebugToolPad *_padView = [SimDebugToolPad sharedInstance];
    if (_padView.state == kSimToolPadBar) {
        [_padView zoomInOut];
    }
}


@end
