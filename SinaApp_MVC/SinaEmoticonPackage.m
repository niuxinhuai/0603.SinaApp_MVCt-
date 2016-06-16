//
//  SinaEmoticonPackage.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/31.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

#import "SinaEmoticonPackage.h"

@implementation SinaEmoticon
+(SinaEmoticon*)modelWithDictionary:(NSDictionary*)dic
{
    return [[self alloc]initWithDictionary:dic];
}

-(instancetype)initWithDictionary:(NSDictionary*)dic{
    
    self = [super init];
    if (self) {
        _type = dic[@"type"];
        
        //图片类型的表情
        if (self.type.integerValue == KEmoticonImageType) {
            
            _chs = dic[@"chs"];
            _cht = dic[@"cht"];
            _png = dic[@"png"];
            _gif = dic[@"gif"];

        }else if (self.type.integerValue == KEmoticonEmojiType){
            
            //codeStr是emoji表情的16进制字符串
            //需要将他转换成16进制的数字,然后转换成UTF-8编码的字符串,UTF-8的字符串才可以正常使用.
            NSString *codeStr = dic[@"code"];
            
            //得到长整形的数
            //strtol函数会将参数nptr字符串根据参数base来转换成长整型数。
            long sym = EMOJI_CODE_TO_SYMBOL(strtol(codeStr.UTF8String, NULL, 16));
            
            _emoji = [[NSString alloc]initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
            NSLog(@"%@",_emoji);
        }
        
    }
    return self;
}
@end


@implementation SinaEmoticonPackage
+(SinaEmoticonPackage*)modelWithDictionary:(NSDictionary*)dic{
    
    return [[self alloc]initWithDictionary:dic];
}

-(instancetype)initWithDictionary:(NSDictionary*)dic{
    
    self = [super init];
    if (self) {
        _packageName = dic[@"group_name_cn"];
        _packageId = dic[@"id"];
        
        NSArray *array = dic[@"emoticons"];
        NSMutableArray *emoticonsArr = [[NSMutableArray alloc]init];
        
        for (NSDictionary *emDic in array) {
            //插入删除表情
            if (emoticonsArr.count != 0 && (emoticonsArr.count+1)%21 == 0) {
                //该加第21个,插入删除表情
                SinaEmoticon *deleteEmoticon = [[SinaEmoticon alloc]init];
                deleteEmoticon.type =[NSString stringWithFormat:@"%ld",KEmoticonDeleteType];
                deleteEmoticon.png = @"emotion_delete";
                
                [emoticonsArr addObject:deleteEmoticon];
            }
            
            SinaEmoticon *emoticonModel = [SinaEmoticon modelWithDictionary:emDic];
            [emoticonsArr addObject:emoticonModel];
        }
        
        //最后一页,不够补全
        //获得最后一页的个数
        NSInteger count = emoticonsArr.count%21;
        if (count != 0) {
            for (NSInteger i = count; i<20; i++) {
                //空的
                SinaEmoticon *emoticon = [[SinaEmoticon alloc]init];
                emoticon.type = [NSString stringWithFormat:@"%ld",KEmoticonOtherType];
                //补
                [emoticonsArr addObject:emoticon];
            }
            
            //最后在加个删除
            SinaEmoticon *deleteEmoticon = [[SinaEmoticon alloc]init];
            deleteEmoticon.type =[NSString stringWithFormat:@"%ld",KEmoticonDeleteType];
            deleteEmoticon.png = @"emotion_delete";
            
            [emoticonsArr addObject:deleteEmoticon];
        }
        
        
        
        
        
        _emoticons = emoticonsArr;
    }
    return self;
}
@end






