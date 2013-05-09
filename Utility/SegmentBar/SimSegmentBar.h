//
//  SimSegmentBar.h
//
//  Created by Xubin Liu on 12-7-11.
//

#import <UIKit/UIKit.h>
#import "SimSegmentBarDelegate.h"
#import "SimTabBarItem.h"

typedef enum {
    BarType_HighlightSelected, //默认
    BarType_Normal,
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
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) UIColor *divideLineColor;
@property (nonatomic, assign) BarType barType;

 
- (void)reloadData;
- (void)setBadgeValue:(NSString *)value forIndex:(NSInteger)index;
- (NSString *)badgeValueForIndex:(NSInteger)index;


@end
