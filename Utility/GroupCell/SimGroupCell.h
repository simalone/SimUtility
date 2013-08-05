//
//  SimGroupCell.h
//
//  Created by Xubin Liu on 12-7-19.
//  Copyright (c) 2012年 simalone. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
可自定义效果的GroupCell
接口可设置图片和按下图片，accessoryView，按下背景色。
 */


@interface SimGroupCell : UITableViewCell{
    UIButton *_accessoryBtn;
    UILabel *_textLb;
}

@property(nonatomic, readonly) UIButton *accessoryBtn;
@property(nonatomic, readonly) UILabel *textLb;
@property(nonatomic, retain) UIColor *highlightMaskColor;  //按下的高亮颜色，通过mask设置的highlighted的颜色得到显示效果。

- (void)setImages:(NSArray *)images selectedImages:(NSArray *)selectImages;
- (void)setIndexPath:(NSIndexPath *)path totalCount:(NSInteger)count;
- (void)addCommonAccessoryBtn;
- (void)setDisabled:(BOOL)disabled;  //设置不可用的时的效果

@end
