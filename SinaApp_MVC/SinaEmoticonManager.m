//
//  SinaEmoticonManager.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/31.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import "SinaEmoticonManager.h"
#import "SinaEmoticonPackage.h"
@implementation SinaEmoticonManager
+(instancetype)shareManager
{
    static SinaEmoticonManager *manager = nil;
    static dispatch_once_t onceToken;
    
    //保证block只会执行一次
    dispatch_once(&onceToken, ^{
        manager = [[SinaEmoticonManager alloc]init];
    });
    
    return manager;
}

//单例初始化的时候解析emoticonBundle,将里面的数据解析成model
-(instancetype)init{
    self = [super init];
    if (self) {
        
        //表情匹配字典
        _allEmoticonDic = [[NSMutableDictionary alloc]init];
        
        //bundle
        //1,先获得bundle的路径(把bundle看做成一个文件夹来取里面的东西)
        NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"Emoticons" ofType:@"bundle"];
        _bundlePath = bundlePath;
        
        //2,获得emoticons.plist路径
        NSString *emoticonsPlistPath = [bundlePath stringByAppendingPathComponent:@"emoticons.plist"];
        
        //3,根据路径获得内容
        NSDictionary *plistDic = [[NSDictionary alloc]initWithContentsOfFile:emoticonsPlistPath];
        NSArray *packagesArr = plistDic[@"packages"];
        
        _emoticonPackages = [[NSMutableArray alloc]init];
        //从数组里面取
        for (NSDictionary *dic in packagesArr) {
            NSString *packagesId = dic[@"id"];
            //表情文件夹的路径
            NSString *packagePath = [bundlePath stringByAppendingPathComponent:packagesId];
            NSString *infoPlistPath = [packagePath stringByAppendingPathComponent:@"info.plist"];
            //根据表情包的plist文件,取数据
            NSDictionary *infoDic = [[NSDictionary alloc]initWithContentsOfFile:infoPlistPath];
            //____________________________匹配
            NSArray *emoticons = infoDic[@"emoticons"];
            for (NSDictionary *emoticonDic in emoticons) {
                
                //表情文字
                NSString *chs = emoticonDic[@"chs"];
                //表情图片
                NSString *png = emoticonDic[@"png"];
                
                //bundle里面的图片不能通过imageName:方法获得,所有这个地方表情文字需要与表情图片的地址进行匹配
                //图片的路径
                NSString *pngPath = [packagePath stringByAppendingPathComponent:png];
                if (chs != nil) {
                
                    [_allEmoticonDic setObject:pngPath forKey:chs];
                }
            }
            
            //____________________________解析
            //根据infoPlist文件解析成包对象
            SinaEmoticonPackage *package = [SinaEmoticonPackage modelWithDictionary:infoDic];
            
            //添加表情包对象到数组中
            [_emoticonPackages addObject:package];
        }
    }
    return self;
}
@end













