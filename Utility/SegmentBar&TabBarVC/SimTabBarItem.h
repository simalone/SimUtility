//
//  SimTabBarItem.h
//
//  Created by Xubin Liu on 12-7-12.
//

#import <UIKit/UIKit.h>
#import "SimBadgeView.h"

@interface SimTabBarItem : UIControl{
    UIImageView *_iconImage;
    UILabel *_titleLb;
    
    UIColor *_bgColor;
    UIColor *_highlightedColor;
    
    UIColor *_borderColor;
    UIColor *_highlightedBorderColor;
    
    SimBadgeView *_badgeView;
}

@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UIImageView *iconImage;
@property (nonatomic, copy) NSString *badge;

+ (SimTabBarItem *)item;
- (void)setColor:(UIColor *)color highlightedColor:(UIColor *)highlightedColor;
- (void)setBorderColor:(UIColor *)color highlightedBorderColor:(UIColor *)highlightedColor;



@end
