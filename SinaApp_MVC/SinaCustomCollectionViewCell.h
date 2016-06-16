//
//  SinaCustomCollectionViewCell.h
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/24.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SinaCustomCollectionViewCell;
@protocol SinaCustomCollectionViewCellDelegate <NSObject>
-(void)collectionViewDidTap;
@end

@interface SinaCustomCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>
@property(nonatomic,strong)UIImageView *picImgView;
@property(nonatomic,assign)id<SinaCustomCollectionViewCellDelegate>delegate;
@property(nonatomic,strong)UIScrollView *picScrollView;//用于展示缩放图片的
-(void)resetFrame;
@end










