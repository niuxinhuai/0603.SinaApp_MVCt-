//
//  SinaPickerPhotoViewController.h
//  SinaApp_MVC
//
//  Created by SuperWang on 16/6/2.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SinaPickerPhotoViewControllerDelegate <NSObject>
-(void)pickerPhotoDidSelectedPhotos:(NSArray*)selectPhotos;
@end
//自定义图片查看
@interface SinaPickerPhotoViewController : UIViewController
@property(nonatomic,assign)id<SinaPickerPhotoViewControllerDelegate>delegate;
@property(nonatomic,strong)NSMutableArray *pickePhotosArr;//选中
@end










