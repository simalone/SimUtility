//
//  SimTabBarItem.m
//
//  Created by Xubin Liu on 12-7-12.
//

#import "SimTabBarItem.h"
#import <QuartzCore/QuartzCore.h>
#import "SimBadgeView.h"

#define kBadgePadding 5

@interface SimTabBarItem ();

@property(nonatomic, retain) UIColor *bgColor;
@property(nonatomic, retain) UIColor *highlightedColor;
@property(nonatomic, retain) UIColor *borderColor;
@property(nonatomic, retain) UIColor *highlightedBorderColor;


@end

@implementation SimTabBarItem

@synthesize title = _titleLb;
@synthesize iconImage = _iconImage;

@synthesize bgColor = _bgColor;
@synthesize highlightedColor = _highlightedColor;
@synthesize borderColor = _borderColor;
@synthesize highlightedBorderColor = _highlightedBorderColor;
@synthesize badge;

- (void)dealloc{
    self.title = nil;
    self.iconImage = nil;
    SimSafeRelease(_bgColor);
    SimSafeRelease(_highlightedColor);
    SimSafeRelease(_borderColor);
    SimSafeRelease(_highlightedBorderColor);
    SimSafeRelease(_badgeView);
    
    [super dealloc];
}

+ (SimTabBarItem *)item{
    return [[[SimTabBarItem alloc] initWithFrame:CGRectZero] autorelease];
}

- (void)setTitle:(UILabel *)title{
    [_titleLb removeFromSuperview];
    SimSafeRelease(_titleLb);
    
    _titleLb = [title retain];
    [self addSubview:title];
}

- (void)setSelected:(BOOL)selected{
    _iconImage.highlighted = selected;
    _titleLb.highlighted = selected;
    
    if (selected) {
        if (self.highlightedColor) {
            self.backgroundColor = self.highlightedColor;
        }
        if (self.highlightedBorderColor) {
            self.layer.borderWidth = 1;
            self.layer.borderColor = [self.highlightedBorderColor CGColor];
        }
        else{
            self.layer.borderWidth = 0;
        }
    }
    else {
        if (self.bgColor){
            self.backgroundColor = self.bgColor;
        }
        
        if (self.borderColor) {
            self.layer.borderWidth = 1;
            self.layer.borderColor = [self.borderColor CGColor];
        }
        else{
            self.layer.borderWidth = 0;
        }

    }
    
    [super setSelected:selected];
}

- (void)setIconImage:(UIImageView *)iconImage{
    [_iconImage removeFromSuperview];
    SimSafeRelease(_iconImage);
    
    _iconImage = [iconImage retain];
    [self addSubview:_iconImage];
}

- (void)setColor:(UIColor *)color highlightedColor:(UIColor *)highlightedColor{
    self.backgroundColor = color;
    self.bgColor = color;
    self.highlightedColor = highlightedColor;
}

- (void)setBorderColor:(UIColor *)color highlightedBorderColor:(UIColor *)highlightedColor{
    self.borderColor = color;
    self.highlightedBorderColor = highlightedColor;
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
