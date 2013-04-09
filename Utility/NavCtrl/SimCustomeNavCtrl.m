//
//  SimCustomeNavCtrl.m
//
//  Created by Liu Xubin on 12-11-29.
//

#import "SimCustomeNavCtrl.h"
#import "UINavigationBar+addition.h"

@implementation SimCustomeNavCtrl
@synthesize navBarImage;
@synthesize defaultNavBarImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.navBarImage == nil) {
        if (self.defaultNavBarImage != nil) {
            self.navBarImage = self.defaultNavBarImage;
        }
    }
}

- (UIImage *)navBarImage{
    return self.navigationBar.backgroundImage;
}

- (void)setNavBarImage:(UIImage *)barImage{
    self.navigationBar.backgroundImage = barImage;
}

- (void)restoreDefaultBarImage{
    self.navBarImage = self.defaultNavBarImage;
}

- (void)dealloc{
    self.defaultNavBarImage = nil;
    [super dealloc];
}

@end

