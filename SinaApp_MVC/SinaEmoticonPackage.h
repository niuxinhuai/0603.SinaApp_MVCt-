//
//  SinaEmoticonPackage.h
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/31.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

//表情包对象
#import <Foundation/Foundation.h>

//定义表情类型宏定义
typedef enum : NSUInteger {
    KEmoticonImageType = 0,//图片类型
    KEmoticonEmojiType,//emoji
    KEmoticonDeleteType,//删除类型
    KEmoticonOtherType,//其他类型
} KEmoticonType;


//表情对象
@interface SinaEmoticon : NSObject
//每个表情对应的文字
@property(nonatomic,copy)NSString *chs;
@property(nonatomic,copy)NSString *cht;

//emoji 表情 code
@property(nonatomic,copy)NSString *emoji;

//图片的表情的图片名字
@property(nonatomic,copy)NSString *png;
@property(nonatomic,copy)NSString *gif;
@property(nonatomic,copy)NSString *type;

+(SinaEmoticon*)modelWithDictionary:(NSDictionary*)dic;
@end





@interface SinaEmoticonPackage : NSObject
//包的id
@property(nonatomic,copy) NSString *packageId;
//包的name
@property(nonatomic,copy)NSString *packageName;
//包内所有的表情
@property(nonatomic,strong)NSArray *emoticons;

+(SinaEmoticonPackage*)modelWithDictionary:(NSDictionary*)dic;
@end









