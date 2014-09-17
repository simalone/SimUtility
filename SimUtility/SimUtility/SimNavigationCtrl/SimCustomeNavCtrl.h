//
//  SimCustomeNavCtrl.h
//
//  Created by Liu Xubin on 12-11-29.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 实现自定义的UINavigationCtrl的navigationBar的效果。
 扩展一些接口。
 */

@interface SimCustomeNavCtrl : UINavigationController<UINavigationControllerDelegate> {
    
}

@property (nonatomic, weak) UIImage *navBarImage;
@property (nonatomic, strong) UIImage *defaultNavBarImage;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, assign) BOOL isCustomBar;


- (void)restoreDefaultBarImage;
- (UIViewController*)popViewController;
- (UIView *)customNavBarView;

- (void)updateNavBar;
- (void)updateNavBarForVc:(UIViewController *)currentVc forceRefresh:(BOOL)forceRefresh;

@end
