//
//  UIViewController+DragMenu.h
//  InfoBroadcast
//
//  Created by Xubin Liu on 14-8-4.
//  Copyright (c) 2014年 Xubin Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DragMenu)

- (BOOL)shouldBeginDragGesture:(UIGestureRecognizer *)gesture receiveTouch:(UITouch *)touch;

@end
