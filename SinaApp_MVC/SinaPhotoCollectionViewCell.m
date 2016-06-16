//
//  SinaPhotoCollectionViewCell.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/6/2.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import "SinaPhotoCollectionViewCell.h"

@implementation SinaPhotoCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]initWithFrame:self.contentView.frame];
        [self.contentView addSubview:_imageView];
        
        _pickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnW = 44;
        _pickButton.frame = CGRectMake(CGRectGetWidth(self.contentView.frame)-btnW, 0, btnW, btnW);
        [self.contentView addSubview:_pickButton];
        //设置图片-默认-选中
        [_pickButton setImage:[UIImage imageNamed:@"photo_normal"] forState:UIControlStateNormal];
        [_pickButton setImage:[UIImage imageNamed:@"photo_selected"] forState:UIControlStateSelected];
    }
    return self;
}
@end










