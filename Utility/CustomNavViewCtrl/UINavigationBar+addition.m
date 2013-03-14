//
//  UINavigationBar+addition.m
//
//  Created by Xubin Liu on 12-7-3.
//

#import "UINavigationBar+addition.h"
#import <objc/runtime.h>

#define BG_IMAGE_KEY @"BG_IMAGE_KEY"

@implementation UINavigationBar (SimUINavigationBarCategory)

- (UIImage *)backgroundImage{
    if ([self respondsToSelector:@selector(backgroundImageForBarMetrics:)]) {
        return [self backgroundImageForBarMetrics:UIBarMetricsDefault];
    }
    else{
        UIImageView * _backView = (UIImageView *)[self viewWithTag:100100];
        if (_backView) {
            return _backView.image;
        }
    }
    return nil;
}

- (void)setBackgroundImage:(UIImage*)image
{
    UIImage *preViewImage = self.backgroundImage;
    if(preViewImage != image){
        UIImage *preSaveImage = objc_getAssociatedObject(self, BG_IMAGE_KEY);
        if (preSaveImage != image) {
            objc_setAssociatedObject(self, BG_IMAGE_KEY, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
            [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        }
        else{
            UIImageView * _backView = ( UIImageView *)[self viewWithTag:100100];
            if(image == nil && _backView){
                [_backView removeFromSuperview];
            }
            else if(image != nil && _backView.image != image){
                if (!_backView) {
                    _backView = [[UIImageView alloc] initWithImage:image];
                    _backView.backgroundColor = [UIColor clearColor];
                    _backView.tag = 100100;
                    [self addSubview:_backView];
                    _backView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                    [self sendSubviewToBack:_backView];
                    [_backView release];
                }
                else{
                    _backView.image = image;
                }
                _backView.frame = CGRectMake(0.f, 0.f, self.frame.size.width, image.size.height);
            }
        }
    }
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    [super insertSubview:view atIndex:index];
    UIImageView * _backView = (UIImageView *)[self viewWithTag:100100];
    if (_backView) {
        [self sendSubviewToBack:_backView];
    }
    
}

- (CGFloat)actualBarHeight{
    UIImage *_image = self.backgroundImage;
    if (_image) {
        return _image.size.height;
    }
    
    return self.frame.size.height;
}

//预防有些NavigationBar不是通过自定义NavCtrl生成时所产生的问题. 注：这个方法不能实现投影
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
    
    if (self.backgroundImage == nil) {
        UIImage *saveImage = objc_getAssociatedObject(self, BG_IMAGE_KEY);
        self.backgroundImage = saveImage;
    }
}

@end
