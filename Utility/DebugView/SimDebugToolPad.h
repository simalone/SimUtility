//
//  SimDebugToolPad.h
//
//  Created by Xubin Liu on 12-1-14.
//

#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"

@interface SimDebugToolPad : UIView{
}

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(SimDebugToolPad)

+ (void)enable;
+ (void)disable;
+ (void)debugInfo:(NSString *)info;

@end
