//
//  WKGroupCell.m
//
//  Created by Xubin Liu on 12-7-19.
//  Copyright (c) 2012年 baidu.com. All rights reserved.
//

#import "SimGroupCell.h"
#import "UIImage+GaussianBlur.h"


typedef enum {
    GroupCellTop = 1 << 1,
    GroupCellCenter =  1 << 2,
    GroupCellBottom = 1 << 3
}GroupCellPos;

@interface SimGroupCell(){
    GroupCellPos _cellPos;
}

@property(nonatomic) GroupCellPos cellPos;
@property(nonatomic, retain) NSArray *images;
@property(nonatomic, retain) NSArray *selectImages;
@end


@implementation SimGroupCell

@synthesize cellPos = _cellPos;
@synthesize images;
@synthesize selectImages;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc{
    self.highlightMaskColor = nil;
    self.images = nil;
    self.selectImages = nil;
    [super dealloc];
}

- (void)setCellPos:(GroupCellPos)cellPos{
    if (_cellPos != cellPos) {
        _cellPos = cellPos;
        self.backgroundView = nil;
        self.selectedBackgroundView = nil;
    }
}

- (void)setImages:(NSArray *)newImages selectedImages:(NSArray *)newSelectImages{
    NSAssert(newImages.count == newSelectImages.count, @"images.count == selectImages.count");
    NSAssert(newImages.count > 3, @"images must have top, center, bottom or only singe");
    self.images = newImages;
    self.selectImages = newSelectImages;
}


- (void)setIndexPath:(NSIndexPath *)path totalCount:(NSInteger)count{
    if (count == 1) {
        self.cellPos = GroupCellBottom | GroupCellTop;
    }
    else{
        if (path.row == 0) {
            self.cellPos = GroupCellTop;
        }
        else if (path.row == count-1) {
            self.cellPos = GroupCellBottom;
        }
        else{
            self.cellPos = GroupCellCenter; 
        }
    }
    [self layoutCellBgView:NO];
    [self layoutCellBgView:YES];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}


- (void)layoutCellBgView:(BOOL)seleted{
    UIView *_curView = seleted ? self.selectedBackgroundView : self.backgroundView;
    
    UIImageView *_imageView = (UIImageView *)[_curView viewWithTag:10000];
    if (!_imageView) {
        UIView *_bgView = [[UIView alloc] initWithFrame:self.bounds];
        if (seleted) {
            self.selectedBackgroundView = _bgView;
        }
        else{
            self.backgroundView = _bgView;
        }
        [_bgView release];

        _imageView = [[UIImageView alloc] initWithFrame:_bgView.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.tag = 10000;
        [_bgView addSubview:_imageView];
        [_imageView release];
    }
    
    NSArray *curImages = seleted ? self.selectImages : self.images;
    NSString *_imagesName = nil;
    if ((self.cellPos & GroupCellTop) && (self.cellPos & GroupCellBottom)) {
        _imagesName = [curImages objectAtIndex:3];
    }
    else if (self.cellPos & GroupCellTop) {
        _imagesName = [curImages objectAtIndex:0];
    }
    else if (self.cellPos & GroupCellCenter){
        _imagesName = [curImages objectAtIndex:1];
    }
    else {
        _imagesName = [curImages objectAtIndex:2];
    }
    
    UIImage *image = [UIImage imageNamed:_imagesName];
    if (self.highlightMaskColor && seleted) {
        image = [image getImageWithMaskColor:self.highlightMaskColor];
    }
    _imageView.image = image;
    _imageView.height = self.height;
}

- (void)addCommonAccessoryBtn{
    UIImage *_accessoryImg = [UIImage imageNamed:@"arrow.png"];
    self.accessoryBtn.size = _accessoryImg.size;
    [self.accessoryBtn setBackgroundImage:_accessoryImg forState:UIControlStateNormal];
}


- (UIButton *)accessoryBtn{
    if (_accessoryBtn == nil) {
        _accessoryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _accessoryBtn.userInteractionEnabled = NO;
        self.accessoryView = _accessoryBtn;
        [_accessoryBtn release];
    }
    
    return _accessoryBtn;
}

- (UILabel *)textLb{
    if (!_textLb) {
        _textLb = [[UILabel alloc] initWithFrame:self.bounds];
        _textLb.textColor = RGBCOLOR(51,51,51);
        _textLb.backgroundColor = [UIColor clearColor];
        _textLb.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:_textLb];
        [_textLb release];
    }
    
    return _textLb;
}

- (void)setDisabled:(BOOL)disabled{
    if (disabled) {
        self.textLb.textColor = RGBCOLOR(184,184,184);
    }
    else{
        self.textLb.textColor = RGBCOLOR(51,51,51);
        
    }
}

@end
