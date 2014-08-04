//
//  SimCustomeNavCtrl.h
//
//  Created by Liu Xubin on 12-11-29.
//  Copyright (c) 2012年 Liu Xubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimCustomeNavCtrl : UINavigationController<UINavigationControllerDelegate> {
    
}

@property (nonatomic, assign) UIImage *navBarImage;
@property (nonatomic, retain) UIImage *defaultNavBarImage;

- (void)restoreDefaultBarImage;


@end
