//
//  SinaSelectImageView.h
//  SinaApp_MVC
//
//  Created by SuperWang on 16/6/3.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import <UIKit/UIKit.h>
//微博发送界面,选中的图片小控件
@interface SinaSelectImageView : UIImageView
//删除按钮
@property(nonatomic,strong) UIButton*deleteButton;
@property(nonatomic,assign) BOOL isAddButton;//是否是addbutton
@end








