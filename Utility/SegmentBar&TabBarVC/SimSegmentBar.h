//
//  SimSegmentBar.h
//
//  Created by Xubin Liu on 12-7-11.
//

#import <UIKit/UIKit.h>
#import "SimSegmentBarDelegate.h"

typedef enum{
    BarItem_Image               = 0,        //array of image name str
    BarItem_SelectImage         = 1 << 0,   //array of image name str
    BarItem_ImageFrame          = 1 << 1,   //CGRect
    BarItem_Title               = 1 << 2,   //array of title 
    BarItem_TitleColor          = 1 << 3,   //UIColor
    BarItem_TitleSelectColor    = 1 << 4,   //UIColor
    BarItem_TitleFont           = 1 << 5,   //UIFont
    BarItem_TitleFrame          = 1 << 6    //CGRect
}BWXBarItemSet;

@interface SimSegmentBar : UIView{
    NSArray *_items;
    NSInteger _selectIndex;
    
    UIView *_belowStrokes; //default is nil;
}

@property (nonatomic, assign) id<SimSegmentBarDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, readonly) UIView *belowStrokes;

- (void)setItemCount:(NSInteger)count;
- (void)setItemCount:(NSInteger)count unitSize:(CGSize)unitSize startPoint:(CGPoint)startPoint;
- (void)setItemCount:(NSInteger)count unitSize:(CGSize)unitSize startPoint:(CGPoint)startPoint itemsGap:(CGFloat)itemsGap;

- (void)setImages:(NSArray *)images selectedImages:(NSArray *)selectImages;
- (void)setImages:(NSArray *)images selectedImages:(NSArray *)selectImages offTop:(CGFloat)offTop;

- (void)setText:(NSArray *)texts textColor:(UIColor *)color selectColor:(UIColor *)selectColor font:(UIFont *)font offBottom:(CGFloat)offBottom;
- (void)setBgColor:(UIColor *)color selectColor:(UIColor *)selectColor;
- (void)setBorderColor:(UIColor *)color highlightedBorderColor:(UIColor *)selectColor;

- (void)setBadgeValue:(NSString *)value forIndex:(NSInteger)index;
- (NSString *)badgeValueForIndex:(NSInteger)index;


@end
