//
//  SinaCustomTableViewCell.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/19.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import "SinaCustomTableViewCell.h"
#import "UIColor+Hex.h"

@implementation SinaCustomTableViewCell
//重写初始化方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //头像
        _headImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _headImgButton.frame  = CGRectMake(10, 10, 35, 35);
        [self.contentView addSubview:_headImgButton];
        //切圆角
        //圆角半径
        _headImgButton.layer.cornerRadius = 17.5;
        //设置
        _headImgButton.layer.masksToBounds = YES;
        
        //_headImgButton.clipsToBounds = YES;
        //        _headImgButton.layer.borderColor = [UIColor whiteColor].CGColor;
        //        _headImgButton.layer.borderWidth = 1;
        
        
        //title
        _titleLabel = [[UILabel alloc]init];
        //16进制色值转换成UIcolor
        _titleLabel.textColor = [UIColor colorWithHexString:@"#f57723"];
        
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_headImgButton.frame)+10, CGRectGetMinY(_headImgButton.frame), CGRectGetWidth([[UIScreen mainScreen]bounds])-CGRectGetWidth(_headImgButton.frame)-30, 20);
        //_titleLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_titleLabel];
        
        //source
        _sourceLabel = [[UILabel alloc]init];
        _sourceLabel.font = [UIFont systemFontOfSize:10];
        _sourceLabel.textColor = [UIColor colorWithHexString:@"#939393"];
        _sourceLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(_titleLabel.frame), CGRectGetHeight(_titleLabel.frame));
        //_sourceLabel.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_sourceLabel];
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        _contentLabel.frame = CGRectMake(CGRectGetMinX(_headImgButton.frame), CGRectGetMaxY(_headImgButton.frame)+10, CGRectGetWidth([[UIScreen mainScreen]bounds])-20, 30);
        [self.contentView addSubview:_contentLabel];
        
        //初始化 showView
        _showImagesView = [[SinaShowImageView alloc]initWithFrame:
    CGRectMake(0,
               CGRectGetMaxY(_contentLabel.frame),
               CGRectGetWidth([[UIScreen mainScreen]bounds]), 0)];
        //设置为非转发
        _showImagesView.isRetweeted = NO;
        [self.contentView addSubview:_showImagesView];
        
        //转发视图
        _retweetedView = [[SinaRetweetedView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_showImagesView.frame), CGRectGetWidth(_showImagesView.frame), 0)];
        [self.contentView addSubview:_retweetedView];
    }
    return self;
}

//根据动态文字的大小获得cell的高度
-(CGFloat)getCellHeightWithTextHeight:(NSNumber*)textH
{
    
    CGFloat maxY = CGRectGetMaxY(self.sourceLabel.frame)+10+textH.floatValue;
    return maxY;
}




@end











