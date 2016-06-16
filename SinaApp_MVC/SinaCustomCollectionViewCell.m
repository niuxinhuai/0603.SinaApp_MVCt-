//
//  SinaCustomCollectionViewCell.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/24.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import "SinaCustomCollectionViewCell.h"

@implementation SinaCustomCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _picImgView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        _picImgView.contentMode = UIViewContentModeScaleAspectFit;
        //[self.contentView addSubview:_picImgView];
        
        //缩放
        _picScrollView = [[UIScrollView alloc]initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_picScrollView];
        //将图片添加到scrollView上
        [_picScrollView addSubview:_picImgView];
        
        //做缩放给scrollView设置几个属性
        _picScrollView.delegate =self;
        _picScrollView.minimumZoomScale = 0.5;
        _picScrollView.maximumZoomScale = 3;
        
        
        //给imageView添加一个tap手势
        _picImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collectionCellTapAction:)];
        [_picImgView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction)];
        
        [_picImgView addGestureRecognizer:longPress];
    }
    return self;
}
-(void)resetFrame
{
    _picImgView.frame = self.contentView.frame;
    _picImgView.contentMode = UIViewContentModeScaleAspectFit;
    [_picScrollView setContentSize:CGSizeZero];
}

-(void)collectionCellTapAction:(UITapGestureRecognizer*)gesture
{
    if ([_delegate respondsToSelector:@selector(collectionViewDidTap)]) {
        
        [_delegate collectionViewDidTap];
        
    }
}

-(void)longPressAction
{
    if (_picImgView.image) {
        
        UIImageWriteToSavedPhotosAlbum(_picImgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"保存成功");
}
#pragma mark - UIScrollViewDelegate
//放回放大缩小的视图
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.picImgView;
}

//缩放过程
-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //缩小
    if (scrollView.contentSize.width<scrollView.frame.size.width)
    {
        self.picImgView.center = scrollView.center;
    }
    else if (scrollView.contentSize.width>scrollView.frame.size.width)
    {
        self.picImgView.center = CGPointMake(scrollView.contentSize.width/2, scrollView.contentSize.height/2);
    }
}

@end










