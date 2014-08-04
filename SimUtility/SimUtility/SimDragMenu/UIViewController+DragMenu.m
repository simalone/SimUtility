//
//  UIViewController+DragMenu.m
//  InfoBroadcast
//
//  Created by Xubin Liu on 14-8-4.
//  Copyright (c) 2014年 Xubin Liu. All rights reserved.
//

#import "UIViewController+DragMenu.h"

@implementation UIViewController (DragMenu)

- (BOOL)shouldBeginDragGesture:(UIGestureRecognizer *)gesture receiveTouch:(UITouch *)touch
{
    return NO;
}

@end
