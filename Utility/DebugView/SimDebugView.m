//
//  SimDebugView.m
//
//  Created by Xubin Liu on 12-1-13.
//

#import "SimDebugView.h"
#import <QuartzCore/QuartzCore.h>

#define MAX_SIZE 280

SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(SimDebugView);
@implementation SimDebugView
SYNTHESIZE_SINGLETON_FOR_CLASS(SimDebugView);

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.alpha = 0.8;
        self.textColor = [UIColor greenColor];
        self.backgroundColor = [UIColor blackColor];
        self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.scrollEnabled = YES;
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        self.editable = NO;
    }
    return self;
}

- (void)cleanText{
    self.text = @"";
}

+ (void)addDebugView{
    dispatch_async(dispatch_get_main_queue(), ^{
        SimDebugView *_debugView = [SimDebugView sharedInstance];
        UIWindow *_windows = [SimDebugView getTopWindow:NO];
        if (_debugView.superview != _windows) {
            [SimDebugView reomveDebugView];
            _debugView.frame = CGRectMake(_windows.frame.size.width/2-MAX_SIZE/2, _windows.frame.size.height/2-MAX_SIZE/2, MAX_SIZE, MAX_SIZE);
            [_windows addSubview:_debugView];
            _debugView.contentOffset = CGPointMake(0, _debugView.contentSize.height - _debugView.frame.size.height);
        }
    });
}


+ (void)reomveDebugView{
    SimDebugView *_debugView = [SimDebugView sharedInstance];
    if (_debugView.superview) {
        [_debugView removeFromSuperview];
    }
}

+ (void)debugInfo:(NSString *)info{
    dispatch_async(dispatch_get_main_queue(), ^{
        SimDebugView *_debugView = [SimDebugView sharedInstance];
        
        BOOL _shouldScrollToBottom = NO;
        if (_debugView.superview){
            if (_debugView.contentSize.height > _debugView.frame.size.height) {
                _shouldScrollToBottom = YES;
            }
        }
        
        NSString *_str = [[NSString alloc] initWithFormat:@"%@\n%@", _debugView.text,info];
        _debugView.text = _str;
        [_str release], _str = nil;

        
        if (_shouldScrollToBottom) {
            _debugView.contentOffset = CGPointMake(0, _debugView.contentSize.height - _debugView.frame.size.height);
        }
    });
}

//top window except alertView if belowAlert is YES.
+ (UIWindow *)getTopWindow:(BOOL)belowAlert{
	int topWindowsIdx = -1;
	float maxWindowsLevel = -1;
    
    NSArray *_windows = [UIApplication sharedApplication].windows;
    int i = 0;
	for (UIWindow *window in _windows) {
		if (window.windowLevel > maxWindowsLevel && !window.hidden){
            if (!belowAlert ||  window.windowLevel <= 2 ) {
                maxWindowsLevel = window.windowLevel;
                topWindowsIdx = i;
            }
		}
		i++;
	}
    
    if (topWindowsIdx == -1) {
        return nil;
    }
    
	return [_windows objectAtIndex:topWindowsIdx];
	
}

@end
