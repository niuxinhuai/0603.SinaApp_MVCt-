//
//  SinaShowImageView.h
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/23.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define GAP 10
#define IMG_WIDTH ([[UIScreen mainScreen]bounds].size.width - 4*GAP)/3

#define TAG_ADD 100
@class SinaShowImageView;
@protocol SinaShowImageViewDelegate <NSObject>
-(void)tapShowImage:(SinaShowImageView*)showImageView imgViewTag:(NSInteger)tag;
@end

@interface SinaShowImageView : UIView
@property(nonatomic,assign)id<SinaShowImageViewDelegate>delegate;
//cell的indexPath
@property(nonatomic,strong)NSIndexPath *indexPath;
//是否是转发
@property(nonatomic,assign)BOOL isRetweeted;
-(void)setImagesWithArray:(NSArray*)picArray;
@end









