//
//  CollectionImageViewController.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/24.
//  Copyright © 2016年 SuperWang. All rights reserved.
//
#import "SinaCustomCollectionViewCell.h"
#import "CollectionImageViewController.h"
#import <UIImageView+WebCache.h>
#import "DataModels.h"
#import <MBProgressHUD.h>//进度条
#import <SDWebImageManager.h>//下载的图片管理类

@interface CollectionImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SinaCustomCollectionViewCellDelegate>

@end

@implementation CollectionImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1,layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.minimumLineSpacing = 0;
    //设置单个item的大小
    flowLayout.itemSize = [[UIScreen mainScreen]bounds].size;
    //设置滚动方向-横向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //item的间距
    flowLayout.minimumInteritemSpacing = 0;
    
    //2,collectionView
    _collectionView = [[UICollectionView alloc]initWithFrame:[[UIScreen mainScreen]bounds] collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    _collectionView.pagingEnabled = YES;
    //注册cell
    [_collectionView registerClass:[SinaCustomCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    //根据tag值,修改collectionView的偏移量
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.tag inSection:0] atScrollPosition:0 animated:NO];
    //为了动画效果现将collectionView隐藏
    _collectionView.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    if (!_animationImgView) {
        _animationImgView = [[UIImageView alloc]init];
        [self.view addSubview:_animationImgView];
    }
    
    SinaPicUrls *picModel = self.picUrls[self.tag];
    //通过sdwebimage获得图片
    [_animationImgView sd_setImageWithURL:[NSURL URLWithString:picModel.thumbnailPic]];
    //位置
    //1,初始位置
    NSValue *beginValue = self.picFrames[self.tag];
    CGRect imgRect = beginValue.CGRectValue;
    _animationImgView.frame = imgRect;
    
    //2,结束位置
    imgRect = [self imageRectWithImageSize:_animationImgView.image.size];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _animationImgView.frame = imgRect;
        _animationImgView.center = self.view.center;
        
    } completion:^(BOOL finished) {
        
        _animationImgView.hidden = YES;
        _collectionView.hidden = NO;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 等比缩放
-(CGRect)imageRectWithImageSize:(CGSize)imgSize
{
    //使用等比例缩放,获得结束位置
    //获得图片的原始大小
    
    CGRect imgRect  = CGRectZero;
    //计算比例
    CGFloat imgScale = imgSize.width/imgSize.height;
    
    CGFloat viewScale = CGRectGetWidth(self.view.frame)/CGRectGetHeight(self.view.frame);
    
    if (imgScale>viewScale) {
        //固定宽度
        //宽度和屏幕的宽度保持一致
        imgRect.size.width = CGRectGetWidth(self.view.frame);
        imgRect.size.height = CGRectGetWidth(self.view.frame)/imgScale;
    }else{
        //固定高度
        //高度跟view的高度一致,宽度根据比例计算
        imgRect.size.height = CGRectGetHeight(self.view.frame);
        imgRect.size.width = CGRectGetHeight(self.view.frame)*imgScale;
    }
    
    return imgRect;
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.picUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SinaCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    
    SinaPicUrls *model =self.picUrls[indexPath.row];
    

    //1,将url的地址替换成高清图的地址
    NSString *largeUrl = [model.thumbnailPic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
    //获得高清图之后直接复制给model
    model.largePic = largeUrl;
    //检查有没有缩略图
    SDImageCache *imgCach = [SDWebImageManager sharedManager].imageCache;
    
    //根据图片的url取出缓存里面的图片
    UIImage *thumImg = [imgCach imageFromMemoryCacheForKey:model.thumbnailPic];
    
    if (!thumImg) {
        
        thumImg = [imgCach imageFromDiskCacheForKey:model.thumbnailPic];
    }
    
    if (!thumImg) {
        thumImg = [UIImage imageNamed:@"默认图片"];
    }
    
    UIImage *largeImage = [imgCach imageFromMemoryCacheForKey:largeUrl];
    if (!largeImage) {
        
        largeImage = [imgCach imageFromDiskCacheForKey:largeUrl];
    }
    if (!largeImage) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        //原型的进度条
        hud.mode = MBProgressHUDModeDeterminate;
        
        //如果本地和内存都没有开始下载
        [cell.picImgView sd_setImageWithURL:[NSURL URLWithString:largeUrl] placeholderImage:thumImg options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            hud.progress = (float)receivedSize/(float)expectedSize;
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [hud hide:YES];
        }];
    }
    else
    {
        cell.picImgView.image = largeImage;
    }
    
//    [cell.picImgView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailPic]];
    [cell resetFrame];
    return cell;
}


#pragma mark - UIScrollViewDelegate
//滑动结束,并且减速结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //根据偏移量更新,tag的值
    self.tag = scrollView.contentOffset.x/CGRectGetWidth(self.view.frame);
}

#pragma mark - SinaCustomCollectionViewCellDelegate
-(void)collectionViewDidTap
{
    //1,将animationImgView 添加到前面那个视图上
    
    //更新动画视图的图片
    SinaPicUrls *model = self.picUrls[self.tag];
    [_animationImgView sd_setImageWithURL:[NSURL URLWithString:model.largePic]];
    
    //设置动画视图的初始位置
    _animationImgView.frame = [self imageRectWithImageSize:_animationImgView.image.size];
    _animationImgView.center = self.view.center;
    
    
    //显示动画视图
    _animationImgView.hidden =NO;
    
    //添加到前面的视图中
    if ([_delegate respondsToSelector:@selector(tapCollectionImageWithAnimationView:)]) {
        [_delegate tapCollectionImageWithAnimationView:_animationImgView];
    }
    
    //2,在dismiss结束后做变换的动画
    [self dismissViewControllerAnimated:NO completion:^{
        
        if ([_delegate respondsToSelector:@selector(tapCollectionImageWithAnimationView:toFrame:)]) {
            
            NSValue *rectValue = self.picFrames[self.tag];
            
            [_delegate tapCollectionImageWithAnimationView:_animationImgView toFrame:rectValue.CGRectValue];
        }
        
    }];
}
@end







