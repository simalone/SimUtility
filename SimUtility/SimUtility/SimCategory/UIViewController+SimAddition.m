//
//  UIViewController+SimAddition.m
//  Wenku
//
//  Created by Xubin Liu on 12-7-17.
//  Copyright (c) 2012年 baidu.com. All rights reserved.
//

#define kDefaultBgImageNames [NSArray arrayWithObjects:@"bt_titlebar_cancel_normal", @"bt_titlebar_cancel_press", nil]
#define kBackImageNames [NSArray arrayWithObjects:@"bt_titlebar_return_button_normal", @"bt_titlebar_return_button_press", nil]
#define kCancelImageNames [NSArray arrayWithObjects:@"bt_titlebar_cancel_normal", @"bt_titlebar_cancel_press", nil]


#import "UIViewController+SimAddition.h"
#import "UIButtonAdditions.h"
#import "UIViewAdditions.h"

@implementation UIViewController (SimAddition)

- (void)cleanItemAt:(ItemPos)pos{
    [self updateItemAt:pos forText:nil target:nil action:nil];
        
}

- (void)addBackItem{
    if (kBackImageNames) {
        [self addBackItemByStr:@""];
    }
    else{
        [self addBackItemByStr:@"返回"];
    }
}

- (void)addBackItemByStr:(NSString *)backStr{
    [self updateItemAt:LeftItem forText:backStr target:self action:@selector(doPopBack) bgImageName:kBackImageNames animated:YES];
}

- (void)addBackItem:(NSArray *)images{
    self.navigationItem.hidesBackButton = YES;
    [self updateItemAt:LeftItem forText:@"返回" target:self action:@selector(doPopBack) bgImageName:images animated:YES];
}

- (void)addCancelItem{
    [self addCancelItemByStr:@"取消"];
}

- (void)addCancelItemByStr:(NSString *)str{
    if (kCancelImageNames) {
        [self updateItemAt:LeftItem forText:str target:self action:@selector(doDismissModel) bgImageName:kCancelImageNames animated:YES];
    }
    else{
        [self updateItemAt:LeftItem forText:str target:self action:@selector(doDismissModel)];
    }

}

- (void)updateItemAt:(ItemPos)pos barButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated{
    if (pos == RightItem) {
        [self.navigationItem setRightBarButtonItem:item animated:animated];
    }
    else{
        [self.navigationItem setLeftBarButtonItem:item animated:animated];
    }
}


- (void)updateItemAt:(ItemPos)pos forText:(NSString *)string target:(id)target action:(SEL)sel{
    [self updateItemAt:pos forText:string target:target action:sel animated:YES];
}

- (void)updateItemAt:(ItemPos)pos forText:(NSString *)string target:(id)target action:(SEL)sel animated:(BOOL)animated{
    [self updateItemAt:pos forText:string target:target action:sel bgImageName:kDefaultBgImageNames animated:animated];
}

- (void)updateItemAt:(ItemPos)pos forText:(NSString *)string target:(id)target action:(SEL)sel bgImageName:(NSArray *)backImageNames  animated:(BOOL)animated{
    UIBarButtonItem *_item = nil;
    if (string.length > 0) {
         _item = [UIViewController barButtonItemForText:string target:target action:sel bgImageName:backImageNames];
    }
    
    if (!_item && pos == LeftItem) {
        self.navigationItem.hidesBackButton = YES;
    }
    [self updateItemAt:pos barButtonItem:_item animated:animated];
}


//just for right item
- (void)updateItemAt:(ItemPos)pos forTexts:(NSArray *)strings targets:(NSArray *)targets actions:(NSArray *)sels animated:(BOOL)animated{
    NSAssert(strings.count == targets.count && targets.count == sels.count, @"Array count need be equal");

    int _rightOffset = 0;
    int _gap = 5;
    UIView * rightButtonParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    rightButtonParentView.backgroundColor = [UIColor clearColor];
    for (int i = 0; i < strings.count; i++) {
        NSString *_text = [strings objectAtIndex:i];
        id _target = [targets objectAtIndex:i];
        SEL _sel = NSSelectorFromString([sels objectAtIndex:i]);   
        UIButton *_button = [UIButton buttonWithText:_text target:_target action:_sel bgImageName:nil];
        _button.left = _rightOffset + _gap;
        _button.centerY = rightButtonParentView.height/2;
        [rightButtonParentView addSubview:_button];
        _rightOffset = _button.right;
        if (i == strings.count - 1) {
            rightButtonParentView.width = _rightOffset;
        }
    }
    
    rightButtonParentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIBarButtonItem *_item = [[UIBarButtonItem alloc] initWithCustomView:rightButtonParentView];
    if (pos == RightItem) {
        [self updateItemAt:pos barButtonItem:_item animated:animated];
    }
    else if(pos == LeftItem){
        self.navigationItem.leftBarButtonItem = nil;
        rightButtonParentView.width = 320;
        self.navigationItem.titleView = rightButtonParentView;    
    }
}


- (void)doPopBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doDismissModel{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)setCustomTitle:(NSString *)titleStr{ 
    if ([self.navigationItem.titleView isKindOfClass:[UILabel class]]) {
        UILabel *_lb = (UILabel *)self.navigationItem.titleView;
        _lb.text = titleStr;
        [_lb sizeToFit];
    }
    else{
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectZero];
        t.font = [UIFont boldSystemFontOfSize:18];
        t.textAlignment = UITextAlignmentCenter;
        t.textColor = [UIColor whiteColor];
        t.backgroundColor = [UIColor clearColor];
        t.text = titleStr;
        [t sizeToFit];
        self.navigationItem.titleView = t;

    }
}

+ (UIBarButtonItem *)barButtonItemForText:(NSString *)string target:(id)target action:(SEL)sel bgImageName:(NSArray *)backImageNames{    
    if (string.length > 0) {
        UIButton *_button = [UIButton buttonWithText:string target:target action:sel bgImageName:backImageNames];
        return  [[UIBarButtonItem alloc] initWithCustomView:_button];
    } 
    
    return nil;
}



@end


