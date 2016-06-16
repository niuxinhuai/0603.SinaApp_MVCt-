//
//  SinaEmojiCollectionViewCell.h
//  SinaApp_MVC
//
//  Created by SuperWang on 16/6/1.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

//表情collectionView的自定义cell
//需要显示图片表情和emoji表情

#import <UIKit/UIKit.h>

@interface SinaEmojiCollectionViewCell : UICollectionViewCell
//显示图片表情
@property(nonatomic,strong)UIImageView *imageView;
//显示emoji表情
@property(nonatomic,strong)UILabel *emojiLabel;
@end











