//
//  NSString+Addtion.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/19.
//  Copyright © 2016年 SuperWang. All rights reserved.
//
#import "SinaEmoticonManager.h"
#import "NSString+Addtion.h"
#import "UIColor+Hex.h"
@implementation NSString (Addtion)
-(NSString*)sinaSourceString
{
    //<a href="http://app.weibo.com/t/feed/3auC5p" rel="nofollow">皮皮时光机
    //</a>
    
    //1,获得>的range
    NSRange signRange = [self rangeOfString:@">"];
    
    if (signRange.location != NSNotFound) {
        
        //获得signRange的范围大小
        NSMaxRange(signRange);
        
        //根据这个范围大小,作为要截取的字符的起点
        //要截取的Range
        //4 表示</a>的长度,是html中固定结束标签长度不会变化
        NSRange sourceRange = NSMakeRange(NSMaxRange(signRange), self.length-NSMaxRange(signRange)-4);
        //根据算出来的范围截取字符串
        NSString *sourceStr = [self substringWithRange:sourceRange];
        
        return sourceStr;
    }
    
    return nil;
}

-(NSString*)timeString
{
    //Thu May 19 15:00:05 +0800 2016
    //eee MMM d HH:mm:ss Z yyyy
    
    //将服务放回的字符串转换成NSDate,需要用到时间格式化对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //设置格式化--显示样式
    [formatter setDateFormat:@"eee MMM d HH:mm:ss Z yyyy"];
    //将时间字符串转换成NSDate
    NSDate *timeDate = [formatter dateFromString:self];
    
    //只有转换成Date对象,才可以和当前的时间进行对比
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    
    //已经发布多久了
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    
    //将得到的秒数进行转换
    NSString *timeString = nil;
    //一小时之内
    if (timeInterval<60) {
        
        timeString = @"刚刚";
        
    }else if (timeInterval<60*60) {
        //计算分钟
        timeString = [NSString stringWithFormat:@"%.f分钟前发布",timeInterval/60];
        
    }else{
        //超过一小时使用 HH:mm:ss 格式显示
        [formatter setDateFormat:@"HH:mm:ss"];
        timeString = [formatter stringFromDate:timeDate];
    }

    return timeString;
}

//使用正则表达式检索字符串中符合规则的字符
-(NSArray<NSTextCheckingResult *>*)matchStringWithPattern:(NSString*)pattern
{
    //正则表达式的对象
    NSError *error = nil;
    //根据正则表达式样式创建对象
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (regularExpression){
        //根据正则检索字符串
        NSArray<NSTextCheckingResult *> *resultArray =
        [regularExpression matchesInString:self options:0 range:NSMakeRange(0, self.length)];
        return resultArray;
    }
    
    return nil;
}

//将NSString变化成富文本NSAttributedString
-(NSAttributedString*)sinaString
{
    //1,先根据原有字符串创建富文本
    NSMutableAttributedString *attributString = [[NSMutableAttributedString alloc]initWithString:self];
    //2,使用正则过滤字符串,得到字符串的位置信息
    //正则表达式使用的时候可以在网上搜索,也可以自己写
    NSString *pattern = @"(@\\w+)|(#\\w+#)|(http(s)?://([A-Za-z0-9._-]+(/)?)*)";
    
    //使用正则表达式,检索字符位置
    NSArray *resArray = [self matchStringWithPattern:pattern];
    
    //遍历结果数组
    [resArray enumerateObjectsUsingBlock:^(NSTextCheckingResult *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //获取检索出来的字符串的range
        NSRange resRange = obj.range;
        
        //给attributString 添加属性
        [attributString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4f7cae"] range:resRange];
    }];
    
    //将表情的文字使用正则表达式替换成图片
    pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+]";
    resArray = [self matchStringWithPattern:pattern];
    
    //记录表情文字,造成字符串长度的变化数值
    __block NSInteger emoticonLength = 0;
    
    [resArray enumerateObjectsUsingBlock:^(NSTextCheckingResult*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //获得表情文字
        NSString *chs = [self substringWithRange:obj.range];
        //根据文字获得图片的地址
        NSString *pngPath = [[SinaEmoticonManager shareManager].allEmoticonDic objectForKey:chs];
        
        //富文本-附件
        NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
        //给附件添加图片
        attachment.image = [UIImage imageWithContentsOfFile:pngPath];
        //设置附件的大小
        attachment.bounds = CGRectMake(0, 0, 20, 20);
        
        //根据附件,创建富文本字符串
        NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:attachment];
        
        NSRange range = NSMakeRange(obj.range.location-emoticonLength, obj.range.length);
        
        //替换
        [attributString replaceCharactersInRange:range withAttributedString:attStr];
        
        //[哈哈]1234567890[哈哈]1234567890 --长度28
        //第一表情range (0,4) 第二个表情 range(14,4)
        //1234567890[哈哈]1234567890 长度
        //range(10,4)
        
        //表情汉字替换成表情图片,数据长度有变化
        emoticonLength +=obj.range.length-1;
    }];

    return attributString;
}


@end












