//
//  SimDefine.h
//  SimUtility
//
//  Created by Liu Xubin on 13-3-14.
//
//

#ifndef SimUtility_SimDefine_h
#define SimUtility_SimDefine_h

//Memory
#define SimSafeRelease(__obj__) [__obj__ release], __obj__ = nil;

//Image
#define UIImageNamed(_fileName_)            [UIImage imageNamed:_fileName_]
#define UIImageViewNamed(_fileName_)        [[[UIImageView alloc] initWithImage:UIImageNamed(_fileName_)] autorelease]

//Array
#define ObjectsArray(...) [NSArray arrayWithObjects:__VA_ARGS__, nil]
#define ObjectsMutArray(...) [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]

//Color
#ifndef RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define HEXRGBCOLOR(h) RGBCOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF))
#define HEXRGBACOLOR(h,a) RGBACOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF), a)
#endif


#endif
