//
//  SinaEmoticonManager.h
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/31.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

//表情单例
#import <Foundation/Foundation.h>

@interface SinaEmoticonManager : NSObject
//表示读取到bundle所有的表情包
@property(nonatomic,strong)NSMutableArray *emoticonPackages;

//将所有的表情的chs和png匹配到一个字典中
@property(nonatomic,strong)NSMutableDictionary *allEmoticonDic;

@property(nonatomic,copy)NSString *bundlePath;
+(instancetype)shareManager;
@end








