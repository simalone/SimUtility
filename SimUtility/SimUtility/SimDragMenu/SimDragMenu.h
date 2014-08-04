//
//  SimDragMenu.h
//
//  Created by Xubin Liu on 13-12-15.
//  Copyright (c) 2013年 Xubin Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWillBeginDragMenu          @"kWillBeginDragMenu"
#define kDidEndDragMenu             @"kDidEndDragMenu"
#define kShowMenuStatusChanged      @"kShowMenuStatusChanged"

@interface SimDragMenu : UITabBarController<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *menuView;
@property (nonatomic, strong) UIImageView *menuBgImageView;

@property (nonatomic, assign) CGFloat viewLeftX;
@property (nonatomic, assign) CGFloat viewRightX;
@property (nonatomic, assign) CGFloat viewLeftScale;
@property (nonatomic, assign) CGFloat viewRightScale;

- (void)switchToMenuIndex:(NSUInteger)menuIndex;
- (void)showMenu:(BOOL)show;
- (void)showMenu:(BOOL)show animated:(BOOL)animated;
- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

@end
