//
//  SimPullDownTextField.m
//  SimPullDownTextField
//
//  Created by Xubin Liu on 14-9-25.
//
//

#import "SimPullDownTextField.h"

@interface SimPullDownTextField() <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, weak) UIView *preSuperView;
@property (nonatomic) BOOL show;
@property (nonatomic) NSInteger selectedIndex;

@end

@implementation SimPullDownTextField

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _highlightedColor = _tableView.tintColor;
        _selectedIndex = -1;
        
        CGFloat triangleSize = frame.size.height / 4;
        _triangleLayer = [self triangleLayerForSize:CGSizeMake(triangleSize, triangleSize)];
        _triangleLayer.position = CGPointMake(frame.size.width - triangleSize , frame.size.height/2);
        [self.layer addSublayer:_triangleLayer];
    }
    
    return self;
}


- (UIControl *)overlayView {
    if(!_overlayView) {
        _overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_overlayView addTarget:self action:@selector(clickOnOverlayView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _overlayView;
}

- (void)setHighlightedColor:(UIColor *)newColor
{
    if (_highlightedColor != newColor) {
        _highlightedColor = newColor;
        _tableView.tintColor = newColor;
    }
}

- (void)clickOnOverlayView
{
    [self showList:NO animated:YES];
}


- (void)showList:(BOOL)show animated:(BOOL)animated
{
    CGFloat tableViewHeight = 0;
    if (show) {
        if(!self.overlayView.superview){
            NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
            
            for (UIWindow *window in frontToBackWindows)
                if (window.windowLevel == UIWindowLevelNormal) {
                    [window addSubview:self.overlayView];
                    break;
                }
        }
        _overlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        
        self.preSuperView = self.superview;
        self.center = [self.preSuperView convertPoint:self.center toView:_overlayView];
        [_overlayView addSubview:self];
        [self.tableView reloadData];
        
        
        CGRect frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), 0);
        CGFloat maxHeight = CGRectGetHeight(_overlayView.frame)-frame.origin.y;
        CGFloat cellHeight = [self tableView:self.tableView numberOfRowsInSection:0]*[self tableView:self.tableView heightForRowAtIndexPath:nil];
        tableViewHeight = MIN(cellHeight, maxHeight);
        self.tableView.frame = frame;
        [_overlayView addSubview:self.tableView];
    }
    else{
        self.center = [_overlayView convertPoint:self.center toView:self.preSuperView];
        [self.preSuperView addSubview:self];
        self.preSuperView = nil;
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         if (show) {
                             CGRect frame = self.tableView.frame;
                             frame.size.height = tableViewHeight;
                             self.tableView.frame = frame;
                             
                             self.triangleLayer.transform = CATransform3DMakeScale(1, -1, 1);
                             _overlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
                         }
                         else{
                             CGRect frame = self.tableView.frame;
                             frame.size.height = 0;
                             self.tableView.frame = frame;

                             
                             self.triangleLayer.transform = CATransform3DMakeScale(1, 1, 1);
                             _overlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
                         }
                     } completion:^(BOOL finished) {
                         if (!show) {
                             [self.overlayView removeFromSuperview];
                         }
                     }];
}


- (CAShapeLayer *)triangleLayerForSize:(CGSize)size
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, size.height)];
    [path addLineToPoint:CGPointMake(size.width/2, 0)];
    [path addLineToPoint:CGPointMake(size.width, size.height)];
    [path closePath];
    layer.path = path.CGPath;
    layer.frame = CGRectMake(0, 0, size.width, size.height);
    return layer;
}

#pragma mark - UITableViewDataSource && Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = self.font;
    }
    
    cell.textLabel.text = _dataList[indexPath.row];
    
    if (_selectedIndex == indexPath.row) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [cell.textLabel setTextColor:[tableView tintColor]];
    }
    else{
        [cell.textLabel setTextColor:[UIColor grayColor]];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
    self.text = self.dataList[indexPath.row];
    [self showList:NO animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self showList:!_overlayView.superview animated:YES];
    return NO;
    
}




@end
