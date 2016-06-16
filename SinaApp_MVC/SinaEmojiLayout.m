//
//  SinaEmojiLayout.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/6/1.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import "SinaEmojiLayout.h"

//自定义layout 需要重写3个系统方法
//1,prepareLayout 在这个方法里面,需要计算出每个item的frame
//2,collectViewContextsize ,返回collectionView的可滑动区域
//3,-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
//返回当前可见区域,每个item的属性(属性里包含的其实是item的frame)
@implementation SinaEmojiLayout

//item的frame
-(void)prepareLayout{
    
    _attributesArr = [[NSMutableArray alloc]init];
    
    CGFloat itemW = (CGRectGetWidth([[UIScreen mainScreen]bounds])-80)/7;
    
    //获得item的索引
    NSInteger sections = self.collectionView.numberOfSections;
    
    //遍历section,获得每个section的row
    for (NSInteger section = 0; section<sections; section++) {
        //获得指定section的row的个数
        NSInteger rows = [self.collectionView numberOfItemsInSection:section];
        //遍历计算item的frame
        CGFloat gap = 10;
        CGFloat screenW = CGRectGetWidth([[UIScreen mainScreen]bounds]);
        for (NSInteger row = 0; row<rows; row++) {
            
            //_contentWidth 上一个section的宽度,作为下一个section的起始位置
            CGFloat itemX = (itemW+gap)*(row%7)+gap+screenW*(row/21)+_contentWidth;
            CGFloat itemY = (itemW+gap)*((row/7)%3)+gap;
            
            //需要将计算好itemframe 封装成layoutAttribute对象,layout才可以使用
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            //将frame放在属性里面
            attributes.frame = CGRectMake(itemX, itemY, itemW, itemW);
            
            [_attributesArr addObject:attributes];
        }
        
        //+20 如果只有一个也是1页
        _contentWidth += (rows+20)/21*screenW;
    }
}

//可滑动区域
-(CGSize)collectionViewContentSize
{
    //上下不能滑动,可以左右滑动
    return CGSizeMake(_contentWidth, self.collectionView.frame.size.height);
}

//
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //返回所有应该展示在rect区域的item的
    //UICollectionViewLayoutAttributes
    //重用的时候,item从重用队列里面拿出来
    //通过这个方法得到item的位置.
    
    NSMutableArray *resArr = [[NSMutableArray alloc]init];
    [_attributesArr enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //判断item是否在当前可见区域
        if (CGRectIntersectsRect(rect, obj.frame)) {
            [resArr addObject:obj];
        }
    }];
    
    return resArr;
}
@end


















