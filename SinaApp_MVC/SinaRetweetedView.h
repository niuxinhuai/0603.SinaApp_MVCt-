//
//  SinaRetweetedView.h
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/23.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

//展示转发文字和图片

#import <UIKit/UIKit.h>
#import "SinaShowImageView.h"
@interface SinaRetweetedView : UIView
//转发文字
@property(strong,nonatomic) UILabel *retContentLable;
//转发图片
@property(strong,nonatomic) SinaShowImageView *retShowImageView;
@end











