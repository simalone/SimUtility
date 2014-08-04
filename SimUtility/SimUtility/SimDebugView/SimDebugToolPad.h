//
//  SimDebugToolPad.h
//
//  Created by Xubin Liu on 12-1-14.
//

#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"

/*
 将Log输出到一个View上，可用于APP中调出直接浏览。
 支持禁用，清空日志，缩放到边缘等功能。
 */


@interface SimDebugToolPad : UIView{
}

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(SimDebugToolPad)

+ (void)enable;     //开启日志输出，界面将会出现一个可拖的黑方块，点击可看到debugInfo输出的日志。
+ (void)disable;    //关闭日志输出。       
+ (void)debugInfo:(NSString *)info;  //输出日志到View上。

@end
