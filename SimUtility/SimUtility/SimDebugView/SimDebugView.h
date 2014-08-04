//
//  SimDebugView.h
//
//  Created by Xubin Liu on 12-1-13.
//

#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"

/*
 将Log输出到一个View上，可用于APP中调出直接浏览。
 支持禁用，清空日志，缩放到边缘等功能。
 */


@interface SimDebugView : UITextView{
}

- (void)cleanText;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(SimDebugView)

+ (void)addDebugView;
+ (void)reomveDebugView;
+ (void)debugInfo:(NSString *)info;

+ (UIWindow *)getTopWindow:(BOOL)belowAlert;

@end
