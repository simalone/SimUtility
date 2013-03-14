//
//  SimDebugView.h
//
//  Created by Xubin Liu on 12-1-13.
//

#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"

@interface SimDebugView : UITextView{
}

- (void)cleanText;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(SimDebugView)

+ (void)addDebugView;
+ (void)reomveDebugView;
+ (void)debugInfo:(NSString *)info;

+ (UIWindow *)getTopWindow:(BOOL)belowAlert;

@end
