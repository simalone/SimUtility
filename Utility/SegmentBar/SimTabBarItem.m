//
//  SimTabBarItem.m
//
//  Created by Xubin Liu on 12-7-12.
//

#import "SimTabBarItem.h"
#import <QuartzCore/QuartzCore.h>
#import "SimBadgeView.h"

#define kBadgePadding 5

@interface SimTabBarItem (){
    SimBadgeView *_badgeView;
}

@property(nonatomic, retain) UIView *belowStrokeView;

@end

@implementation SimTabBarItem
@synthesize bgColor;
@synthesize selectedBgColor;
@synthesize borderColor;
@synthesize selectedBorderColor;
@synthesize belowStrokeColor;
@synthesize selectedBelowStrokeColor;
@synthesize belowStrokeView = _belowStrokeView;
@synthesize badge;

- (void)dealloc{
    self.bgColor = nil;
    self.selectedBgColor = nil;
    self.borderColor = nil;
    self.selectedBgColor = nil;
    self.belowStrokeColor = nil;
    self.selectedBelowStrokeColor = nil;
    self.belowStrokeView = nil;
    
    SafeRelease(_badgeView);    
    [super dealloc];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    if (![self.bgColor isEqual:backgroundColor]) {
        self.bgColor = backgroundColor;
    }
    [super setBackgroundColor:backgroundColor];
}

- (void)setSelected:(BOOL)selected{    
    if (selected) {
        if (self.selectedBorderColor) {
            self.layer.borderWidth = 1;
            self.layer.borderColor = [self.selectedBorderColor CGColor];
        }
        else{
            self.layer.borderWidth = 0;
        }
        
        self.backgroundColor = self.selectedBgColor;
        [self belowStrokeView].backgroundColor = self.selectedBelowStrokeColor;

    }
    else {
        if (self.bgColor){
        }
        
        if (self.borderColor) {
            self.layer.borderWidth = 1;
            self.layer.borderColor = [self.borderColor CGColor];
        }
        else{
            self.layer.borderWidth = 0;
        }
        self.backgroundColor = self.bgColor;
        [self belowStrokeView].backgroundColor = self.belowStrokeColor;
    }
    [super setSelected:selected];
}

- (UIView *)belowStrokeView{
    if (!_belowStrokeView) {
        _belowStrokeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
        [self addSubview:_belowStrokeView];
    }
    
    return _belowStrokeView;
}

- (void)setBadge:(NSString *)newBadge{
    if (newBadge.length > 0) {
        if (!_badgeView) {
            _badgeView = [[SimBadgeView alloc] init];
            [self addSubview:_badgeView];
        }
        
        _badgeView.badgeValue = newBadge;
        CGRect frame = _badgeView.frame;
        frame.origin.x = self.frame.size.width - frame.size.width - kBadgePadding;
        frame.origin.y = kBadgePadding;
        _badgeView.frame = frame;
    }
    else{
        if (_badgeView) {
            [_badgeView removeFromSuperview];
            [_badgeView release], _badgeView = nil;
        }
    }
}

- (NSString *)badge{
    if (_badgeView) {
        return _badgeView.badgeValue;
    }
    
    return nil;
}



@end
