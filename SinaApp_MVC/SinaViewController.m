//
//  SinaViewController.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/18.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import "SinaViewController.h"
#import "SinaLoginView.h"
#import "SinaTool.h"
#import "DataModels.h"
#import "UIButton+WebCache.h"
#import "NSString+Addtion.h"
#import "SinaCustomTableViewCell.h"
#import "CollectionImageViewController.h"
#import <MJRefresh.h>
@interface SinaViewController ()<SinaLoginViewDelegate,SinaToolDelegate,UITableViewDelegate,UITableViewDataSource,SinaShowImageViewDelegate,CollectionImageViewControllerDelegate>
{
    SinaTool *_sinaTool;
    UITableView *_myTableView;
    SinaCustomTableViewCell *_sinaCell;
    
}
@property(strong,nonatomic)NSArray *homeLineArray;
//@property(strong,nonatomic)NSMutableArray *textHightArray;
@end

@implementation SinaViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    //self.textHightArray = [[NSMutableArray alloc]init];
    
    _myTableView = [[UITableView alloc]init];
    _myTableView.frame = self.view.frame;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    [_myTableView registerClass:[SinaCustomTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //1,先判断是否登录
    _sinaTool = [[SinaTool alloc]init];
    _sinaTool.delegate = self;
    
    //已经登录,并且token没过期
    if ([_sinaTool isLogin]&&[_sinaTool isValid]){
        
        //添加下拉刷新
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //请求homeline,请求新浪api
            [_sinaTool getHomeTimeLineWithToken:[_sinaTool getToken]];
        }];
        
        [_myTableView.mj_header beginRefreshing];
        
    }
    else
    {
        self.tabBarController.tabBar.hidden = YES;
        //登录
        SinaLoginView *loginView = [[SinaLoginView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        //设置代理
        loginView.delegate = self;
        
        [self.view addSubview:loginView];
        
        //开始授权
        [loginView startOauthRequest:[_sinaTool oauthRequest]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//计算cell高度
-(CGFloat)cellHeightWithTextHeigth:(NSNumber*)textH
{
    if (!_sinaCell) {
        _sinaCell = [[SinaCustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }
    
    return [_sinaCell getCellHeightWithTextHeight:textH];
}
#pragma mark -
#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@-%ld",NSStringFromSelector(_cmd),(long)indexPath.row);
    
    //cell 当前的高度 = cellSubView maxY
    SinaStatuses *model = self.homeLineArray[indexPath.row];
    return [self cellHeightWithTextHeigth:@(model.textHeight+model.showImageHeight+model.retTextHeight+model.retShowImageHeight)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.homeLineArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SinaCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    SinaStatuses *statuesesModel = self.homeLineArray[indexPath.row];
    
    [cell.headImgButton sd_setBackgroundImageWithURL:[NSURL URLWithString:statuesesModel.user.profileImageUrl] forState:UIControlStateNormal];
    cell.titleLabel.text = statuesesModel.user.name;
    
    //NSLog(@"%@",statuesesModel.createdAt);
    
    //使用类别中封装的截取方法,进行截取
    cell.sourceLabel.text = [NSString stringWithFormat:@"%@ 来自%@",[statuesesModel.createdAt timeString],[statuesesModel.source sinaSourceString]];
    
//    cell.contentLabel.text = statuesesModel.text;
    cell.contentLabel.attributedText = [statuesesModel.text sinaString];
    
    //给showImageView赋值
    [cell.showImagesView setImagesWithArray:statuesesModel.picUrls];
    cell.showImagesView.delegate = self;
    cell.showImagesView.indexPath = indexPath;
    
    //修改contentLabel的高度
    CGRect contentRect = cell.contentLabel.frame;
    contentRect.size.height = statuesesModel.textHeight;
    cell.contentLabel.frame = contentRect;
    
    //修改显示图片的View的y值,因为contentlabel的高度发生了改变,根据相对坐标,showImageView的y值也要改变
    CGRect showImageRect = cell.showImagesView.frame;
    showImageRect.origin.y = CGRectGetMaxY(cell.contentLabel.frame);
    cell.showImagesView.frame = showImageRect;
    
    
    //还原初始状态
    cell.retweetedView.hidden = YES;
    cell.retweetedView.retContentLable.text = nil;
    [cell.retweetedView.retShowImageView setImagesWithArray:nil];
    
    if (statuesesModel.retweetedStatus) {
        
        cell.retweetedView.hidden = NO;
        //赋值
        cell.retweetedView.retContentLable.attributedText = [statuesesModel.retweetedStatus.text sinaString];
        
        [cell.retweetedView.retShowImageView setImagesWithArray:statuesesModel.retweetedStatus.picUrls];
        cell.retweetedView.retShowImageView.delegate =self;
        cell.retweetedView.retShowImageView.indexPath = indexPath;
        
        //修改frame
        //文字
        CGRect retContextTextRect = cell.retweetedView.retContentLable.frame;
        retContextTextRect.size.height = statuesesModel.retTextHeight;
        cell.retweetedView.retContentLable.frame = retContextTextRect;
        //图片
        CGRect retShowImageRect =
        cell.retweetedView.retShowImageView.frame;
        retShowImageRect.origin.y = CGRectGetMaxY(retContextTextRect);
        retShowImageRect.size.height = statuesesModel.retShowImageHeight;
        cell.retweetedView.retShowImageView.frame = retShowImageRect;
        
        //修改转发View
        CGRect retweetedRect = cell.retweetedView.frame;
        retweetedRect.origin.y = CGRectGetMaxY(cell.showImagesView.frame);
        retweetedRect.size.height = CGRectGetMaxY(retShowImageRect);
        cell.retweetedView.frame = retweetedRect;
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
#pragma mark - SinaLoginViewDelegate
//获得codeStirng
-(void)loginView:(SinaLoginView*)loginView didGetCodeString:(NSString*)codeString
{
    //获得code之后,移除loginView
    [loginView removeFromSuperview];
    self.tabBarController.tabBar.hidden = NO;
    //获取授权
    [_sinaTool getAccessTokenWithCode:codeString];
    
}

//获得请求Error
-(void)loginView:(SinaLoginView*)loginView didFailWithError:(NSError*)error
{
    NSLog(@"%@",error);
}

#pragma mark - SinaToolDelegate
//获得token
-(void)sinaTool:(SinaTool*)sinaTool didGetToken:(NSString*)token;
{
    NSLog(@"Token:%@",token);
    //第一次获得token的时候,请求timeline
    [sinaTool getHomeTimeLineWithToken:token];
    
}
//获得数据
-(void)sinaTool:(SinaTool *)sinaTool didGetHomeLine:(NSArray *)array
{
    //跟新数据源
    self.homeLineArray = array;
    
    //得到数据之后对text的高度进行计算
    for (SinaStatuses *model in array){
        
        if (model.text.length >0){
            
            CGRect textRect =
            [model.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
            
            //@{} 字典
            //@[] 数组
            //@() number
            
            //根据数据源计算图的高度
            NSInteger row = (model.picUrls.count+2)/3;
            CGFloat showImageHeight = row*(IMG_WIDTH+GAP)+GAP;
            
            //将高度记录在model中
            model.textHeight = CGRectGetHeight(textRect);
            model.showImageHeight = showImageHeight;
            
            //判断是否有转发
            if (model.retweetedStatus) {
                
                //文字高度
                textRect =
                [model.retweetedStatus.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
                
                model.retTextHeight = CGRectGetHeight(textRect);
                
                //图片的高度
                NSInteger row = (model.retweetedStatus.picUrls.count+2)/3;
                showImageHeight = row*(IMG_WIDTH+GAP)+GAP;
                model.retShowImageHeight = showImageHeight;
            }
            
        }else{
            
            NSLog(@"微博内容为空");
        }
    }
    //结束刷新
    [_myTableView.mj_header endRefreshing];
    [_myTableView reloadData];
}

//获得error
-(void)sinaTool:(SinaTool*)sinaTool didFailedWithError:(NSError*)error;
{
    NSLog(@"%@",error);
}


#pragma mark - SinaShowImageViewDelegate
-(void)tapShowImage:(SinaShowImageView*)showImageView imgViewTag:(NSInteger)tag
{
    //1,获得pic_urls数组
    //2,从statusModel获取(从数据源获取)
    //3,根据cell的indexpath获取每个cell的model
    
    NSLog(@"indexPath:%ld",showImageView.indexPath.row);
    SinaStatuses *model = self.homeLineArray[showImageView.indexPath.row];
    
    CollectionImageViewController *showImgCtr = [[CollectionImageViewController alloc]init];
    
    //将点击的图片的tag传递给显示图片的ctr
    showImgCtr.tag = tag;
    //赋值
    showImgCtr.picUrls = model.picUrls;
    
    if (showImageView.isRetweeted) {
        //赋值
        showImgCtr.picUrls = model.retweetedStatus.picUrls;
    }
    
    NSMutableArray *rectArray = [[NSMutableArray alloc]init];
    //获得cell内部图片,转换过后的坐标系
    for (UIImageView *subView in showImageView.subviews) {
        
        //只要显示的图片位置
        if (subView.hidden == YES) {
            continue;
        }
        
        CGRect subViewRect = [subView.superview convertRect:subView.frame toView:self.view];
        //将结构体,转换成oc的对象,使用NSValue
        //原理跟NSNumber一样
        NSValue *value = [NSValue valueWithCGRect:subViewRect];
        [rectArray addObject:value];
    }
    
    showImgCtr.picFrames = rectArray;
    showImgCtr.delegate = self;
    [self presentViewController:showImgCtr animated:NO completion:nil];
}


#pragma mark - CollectionImageViewControllerDelegate
//dismiss之前调用
-(void)tapCollectionImageWithAnimationView:(UIImageView *)animationView
{
    [self.view addSubview:animationView];
}
//dismiss结束调用
-(void)tapCollectionImageWithAnimationView:(UIImageView *)animationView toFrame:(CGRect)toRect
{
    [UIView animateWithDuration:0.3 animations:^{
        
        animationView.frame = toRect;
        
    } completion:^(BOOL finished) {
        
        [animationView removeFromSuperview];
    }];
    
    
    
}
@end
