//
//  SinaPickerPhotoViewController.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/6/2.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import "SinaPickerPhotoViewController.h"
#import "SinaPhotoCollectionViewCell.h"
#import "SinaPhotoModel.h"
//@import 官方推荐导入库的方式 ,不需要手动引入系统库,会自动引入.
@import AssetsLibrary;
//#import <AssetsLibrary/AssetsLibrary.h>
@interface SinaPickerPhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *_photosDataSource;//数据源
    NSMutableArray *_selectImgUrls;
    UICollectionView *_collectionView;//显示collectionView
}
@end

@implementation SinaPickerPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _photosDataSource = [[NSMutableArray alloc]init];
    if (!_pickePhotosArr) {
        _pickePhotosArr = [[NSMutableArray alloc]init];
    }
    
    
    _selectImgUrls = [[NSMutableArray alloc]init];
    for (SinaPhotoModel *model in self.pickePhotosArr) {
        [_selectImgUrls addObject:model.url];
    }
    
    
    [self loadPhotos];
    [self optionCollectionView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(navItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - optionView
-(void)optionCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 4;
    flowLayout.minimumInteritemSpacing = 4;
    
    CGFloat itemWidth = (CGRectGetWidth(self.view.frame)-16)/3;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    //注册cell
    [_collectionView registerClass:[SinaPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [_collectionView addGestureRecognizer:gesture];
}

#pragma mark - 获取图片
-(void)loadPhotos
{
    //assetLibray 获得所有的图片
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    //通过遍历获得相册和相册内的照片
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        //group 就是相册
        if (group == nil) {
            //遍历结束
            NSLog(@"遍历结束");
            [_collectionView reloadData];
            
        }else{
            //先过滤相册
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            //再遍历相册
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                //ALAsset 表示一张照片
                //从ALAsset里面取数据
                //缩略图每次得到的内存地址不一样
                //url 图像的唯一标示
                NSURL *imgUrl = [result valueForProperty:ALAssetPropertyAssetURL];
                
                if (!result.thumbnail) {
                    return ;
                }
                //model赋值
                SinaPhotoModel *model = [[SinaPhotoModel alloc]init];
                model.url = imgUrl;
                model.image = [UIImage imageWithCGImage:result.thumbnail];
                model.fullScreenImage = [UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
                
                [_photosDataSource addObject:model];
            }];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    
}
#pragma mark - ButtonAction
-(void)longPressAction:(UILongPressGestureRecognizer*)gestuer
{
    switch (gestuer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [_collectionView beginInteractiveMovementForItemAtIndexPath:[_collectionView indexPathForItemAtPoint:[gestuer locationInView:gestuer.view]]];
            ;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [_collectionView updateInteractiveMovementTargetPosition:[gestuer locationInView:gestuer.view]];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [_collectionView endInteractiveMovement];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            [_collectionView cancelInteractiveMovement];
        }
            
        default:
            break;
    }
}

-(void)navItemAction
{
    if ([_delegate respondsToSelector:@selector(pickerPhotoDidSelectedPhotos:)]) {
        
        [_delegate pickerPhotoDidSelectedPhotos:_pickePhotosArr];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)collectViewCellButtonAction:(UIButton*)sender
{
    if (_pickePhotosArr.count==9&&!sender.selected) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"信息"
                                                                       message:@"最多选择9张."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"好吧!" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    sender.selected = !sender.selected;
    //先取出mode
    SinaPhotoModel *model = _photosDataSource[sender.tag];
    
    //如果已经有了,说明选中状态改为未选中,删除
    if ([_selectImgUrls containsObject:model.url]) {
        
        [_pickePhotosArr removeObjectAtIndex:[_selectImgUrls indexOfObject:model.url]];
        [_selectImgUrls removeObject:model.url];
        
    }else{
        
        [_pickePhotosArr addObject:model];
        [_selectImgUrls addObject:model.url];
    }
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photosDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SinaPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    //设置tag的目的,为了点击的时候获得数据源
    cell.pickButton.tag = indexPath.row;
    
    [cell.pickButton addTarget:self action:@selector(collectViewCellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.pickButton.selected = NO;
    
    //获得model
    SinaPhotoModel *model = _photosDataSource[indexPath.item];
    
    if ([_selectImgUrls containsObject:model.url]) {
        cell.pickButton.selected = YES;
    }
    cell.imageView.image = model.image;
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    SinaPhotoModel *model = _photosDataSource[sourceIndexPath.item];
    [_photosDataSource removeObject:model];
    [_photosDataSource insertObject:model atIndex:destinationIndexPath.item];
}

@end











