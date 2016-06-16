//
//  SinaRetweetedView.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/23.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import "SinaRetweetedView.h"
#import "UIColor+Hex.h"
@implementation SinaRetweetedView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //文字
        _retContentLable = [[UILabel alloc]init];
        [self addSubview:_retContentLable];
        
        _retContentLable.font = [UIFont systemFontOfSize:15];
        _retContentLable.numberOfLines = 0;
        _retContentLable.lineBreakMode = NSLineBreakByTruncatingTail;
        
        //初始frame
        _retContentLable.frame = CGRectMake(GAP, GAP, CGRectGetWidth([[UIScreen mainScreen]bounds])-20, 30);
        
        //图片
        _retShowImageView = [[SinaShowImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_retContentLable.frame), CGRectGetWidth([[UIScreen mainScreen]bounds]), 0)];
        //设置为转发视图
        _retShowImageView.isRetweeted = YES;
        [self addSubview:_retShowImageView];
        
    }
    self.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    return self;
}
@end











