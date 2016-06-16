//
//  CollectionImageViewController.h
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/24.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionImageViewControllerDelegate <NSObject>
//将animationview传递出去
-(void)tapCollectionImageWithAnimationView:(UIImageView*)animationView;

-(void)tapCollectionImageWithAnimationView:(UIImageView *)animationView toFrame:(CGRect)toRect;

@end

@interface CollectionImageViewController : UIViewController
{
    //临时动画,对象
    UIImageView *_animationImgView;
    UICollectionView *_collectionView;
}
@property(nonatomic,assign)id<CollectionImageViewControllerDelegate>delegate;
//数据源
@property(nonatomic,strong)NSArray *picUrls;
//坐标数组
@property(nonatomic,strong)NSArray *picFrames;
@property(nonatomic,assign)NSInteger tag;
@end










