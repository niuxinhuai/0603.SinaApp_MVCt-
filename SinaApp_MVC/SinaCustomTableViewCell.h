//
//  SinaCustomTableViewCell.h
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/19.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaShowImageView.h"
#import "SinaRetweetedView.h"

@interface SinaCustomTableViewCell : UITableViewCell
//头像
@property(strong,nonatomic) UIButton *headImgButton;
//标题
@property(strong,nonatomic) UILabel *titleLabel;
//来源+时间
@property(strong,nonatomic) UILabel *sourceLabel;
//内容
@property(strong,nonatomic) UILabel *contentLabel;
//图片展示
@property(strong,nonatomic) SinaShowImageView *showImagesView;

//转发视图
@property(strong,nonatomic) SinaRetweetedView *retweetedView;


//计算cell的高度
-(CGFloat)getCellHeightWithTextHeight:(NSNumber*)textH;
@end










