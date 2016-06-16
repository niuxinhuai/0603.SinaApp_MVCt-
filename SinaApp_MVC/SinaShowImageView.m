//
//  SinaShowImageView.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/23.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

//显示微博cell上图片的自定义View

#import "SinaShowImageView.h"
#import "DataModels.h"
#import <UIImageView+WebCache.h>


@implementation SinaShowImageView
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //debug code
        //CGFloat maxY = 0;
        
        for (int i = 0; i<9; i++) {
            
            UIImageView *imageView = [[UIImageView alloc]init];
            //调试UI的常见方式,给视图添加背景颜色
            imageView.backgroundColor = [UIColor blackColor];
            //一开始创建的时候,图片的默认初始状态应该是隐藏的
            imageView.hidden = YES;
            [self addSubview:imageView];
            
            //计算9宫格
            imageView.frame =
            CGRectMake(GAP+(IMG_WIDTH+GAP)*(i%3),
                       GAP+(IMG_WIDTH+GAP)*(i/3), IMG_WIDTH, IMG_WIDTH);
            //设置tag值,方便以后赋值
            imageView.tag = i + TAG_ADD;
            
            //得到最终高度-debug code
            //maxY = CGRectGetMaxY(imageView.frame)+GAP;
            imageView.userInteractionEnabled = YES;
            //添加手势
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
            [imageView addGestureRecognizer:tapGesture];
        }
        
        //debug code
        //self.backgroundColor = [UIColor redColor];
        //frame.size.height = maxY;
        //self.frame = frame;
    }
    return self;
}

//手势触发
-(void)tapGestureAction:(UITapGestureRecognizer*)gesture
{
    if ([_delegate respondsToSelector:@selector(tapShowImage:imgViewTag:)]) {
        
        [_delegate tapShowImage:self imgViewTag:gesture.view.tag-TAG_ADD];
    }
    
    NSLog(@"tap !!!");
}

//根据图片url的数组进行赋值
//根据图片的数量,改变showImageView的高度
-(void)setImagesWithArray:(NSArray*)picArray
{
    //防止被重用是出现界面混乱,在赋值之前先还原控件的默认状态
    for (UIImageView *imageView in self.subviews) {
        imageView.hidden = YES;
    }
    
    //1,将所有的图片的进行初始化:隐藏
    __block CGFloat maxY = 0;
    
    [picArray enumerateObjectsUsingBlock:^(NSObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *urlStr = nil;
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//            
//            urlStr = ((NSDictionary*)obj)[@"thumbnail_pic"];
//            
//        }else if ([obj isKindOfClass:[SinaPicUrls class]]){
        
            urlStr = ((SinaPicUrls*)obj).thumbnailPic;
//        }
        
        //1,通过tag获得imageView
        UIImageView *imageView = (UIImageView*)[self viewWithTag:idx+TAG_ADD];
        //2,赋值显示图片
        imageView.hidden = NO;
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        
        //根据图片的数量,获得图片最大y轴的数值
        maxY = CGRectGetMaxY(imageView.frame)+GAP;
    }];
    
    //3,改变showImageView的高度(图片内容发生了改变,showImageView的高度应该跟图片的高度保持一致)
    //showImageView的初始高度是零
    CGRect frame = self.frame;
    frame.size.height = maxY;
    self.frame = frame;
    
}
@end












