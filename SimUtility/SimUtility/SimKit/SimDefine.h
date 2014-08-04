//
//  SimDefine.h
//
//  Created by Liu Xubin on 13-8-30.
//  Copyright (c) 2013年 Liu Xubin. All rights reserved.
//

#ifndef SimDefine_h
#define SimDefine_h

//#define APP_DELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//Color
#ifndef RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define HEXRGBCOLOR(h) RGBCOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF))
#define HEXRGBACOLOR(h,a) RGBACOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF), a)
#endif

//System version
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IOS_VERSION_FLOAT [[[UIDevice currentDevice] systemVersion] floatValue]
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define kApplicationTop (IOS7 ? 0 : 20)  //App显示，对于屏幕的实际Y坐标。
#define kAppRenderTop (IOS7 ? 20 : 0)    //View的绘制需要的起始Y坐标

#define IOS7  (IOS_VERSION_FLOAT >= 7.0)
#define IOS6  (IOS_VERSION_FLOAT >= 6.0)



//Image
#define UIImageNamed(_fileName_)            [UIImage imageNamed:_fileName_]
#define UIImageViewNamed(_fileName_)        [[UIImageView alloc] initWithImage:UIImageNamed(_fileName_)]

//Array
#define ObjectsArray(...) [NSArray arrayWithObjects:__VA_ARGS__, nil]
#define ObjectsMutArray(...) [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]

//Notification
#define DECL_NOTIFICATION(notification) extern NSString* notification;
#define IMPL_NOTIFICATION(notification) NSString* notification = @#notification;

//Class
#define CLASS_NAME NSStringFromClass([self class])

//Memory
#define SafeRelease(_obj_) [_obj_ release], _obj_ = nil;
#define InvalidateTime(_timer_) [_timer_ invalidate], _timer_ = nil;

//Warning
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


//Exception
#define IgnoreException(Stuff)\
@try { \
Stuff \
} \
@catch (NSException *exception) {}

//Block
typedef void(^FinishBlock)(void);
typedef void(^CompleteBlock)(BOOL success);



#endif
