//
//  SimPullDownTextField.h
//  SimPullDownTextField
//
//  Created by Xubin Liu on 14-9-25.
//
//

#import <UIKit/UIKit.h>

@interface SimPullDownTextField : UITextField

@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) CAShapeLayer *triangleLayer;
@property (nonatomic, strong) UIColor *highlightedColor;


@end
