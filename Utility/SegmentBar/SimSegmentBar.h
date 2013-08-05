//
//  SimSegmentBar.h
//
//  Created by Xubin Liu on 12-7-11.
//


/*
使用delegate和dataSource的代理方式实现配置。
配图或纯色均适用。
适用于所有的位置均分的Segment的UI.
 */

#import <UIKit/UIKit.h>
#import "SimSegmentBarDelegate.h"
#import "SimTabBarItem.h"

typedef enum {
    BarType_HighlightSelected, //默认
    BarType_NotHighlightSlected,
}BarType;

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
}

@property (nonatomic, assign) id<SimSegmentBarDelegate> delegate;
@property (nonatomic, assign) id<SimSegmentBarDateSource> dataSource;
@property (nonatomic, assign) BarType barType;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger initIndex;  //显示时默认选择的index, 默认为0
@property (nonatomic, retain) UIColor *divideLineColor;
@property (nonatomic, retain) NSArray* divideViews;
 
- (void)reloadData;  //通过dataSource重刷bar的UI
- (void)setBadgeValue:(NSString *)value forIndex:(NSInteger)index;
- (NSString *)badgeValueForIndex:(NSInteger)index;
- (NSArray*)getAllItems;


@end
