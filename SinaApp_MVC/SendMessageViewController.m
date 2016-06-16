//
//  SendMessageViewController.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/27.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import "SinaPhotoModel.h"
#import "SinaTool.h"
#import "SinaEmojiLayout.h"
#import "SinaEmojiCollectionViewCell.h"
#import "SinaSelectImageView.h"
#import "SendMessageViewController.h"
#import "SinaPickerPhotoViewController.h"
#import "SinaEmoticonManager.h"
#import "SinaEmoticonPackage.h"
#import <objc/runtime.h>
#import "UIColor+Hex.h"

//给NSTextAttachment添加类别
@interface NSTextAttachment (emoji)
//类别中不能添加属性,
//如果要添加属性,自己实现它的setter和getter方法
//通常都会用runtime中的方法来实现
@property(nonatomic,copy)NSString *chs;

@end

@implementation NSTextAttachment (emoji)
-(void)setChs:(NSString *)chs{
    //使用runtime 给对象挂载一个值
    //用CHS key挂载一个对象
    objc_setAssociatedObject(self, @"CHS", chs, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)chs{
    //用CHS key 取得挂载的对象
    return objc_getAssociatedObject(self, @"CHS");
}

@end



@interface SendMessageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SinaPickerPhotoViewControllerDelegate>
{
    UITextView *_sinaTextView;
    UICollectionView *_emojiCollectionView;//表情
    UIView *_toolBar;//工具条
    UIView *_selectImgsBackgroundView;//选中图片承载view
    
    CGPoint _startPoint;//手势开始的位置
    CGPoint _startCenter;//其实中心点
    
    NSMutableArray *_selectImageViews;//选中图片的数组
    NSMutableArray *_selectImageAllViews;
}
//获得选中图片
@property(nonatomic,strong)NSMutableArray *receivePhotos;
@end

@implementation SendMessageViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_sinaTextView becomeFirstResponder];
    //[self emojiKeyBoardIsHide:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectImageViews = [[NSMutableArray alloc]init];
    _selectImageAllViews =[[NSMutableArray alloc]init];
    _receivePhotos = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //注册键盘弹出的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self optionNavItems];
    [self optionTextView];
    [self optionToolBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Option Views
-(void)optionNavItems
{
    //导航栏的左右按钮
    UIBarButtonItem *rigthItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendAction)];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rigthItem;
}

-(void)optionTextView
{
    //iOS7.0以后
    //如果有导航栏,并且第一个视图是UIScrollView,那么会自动让ScrollView的内容展示区域,向下偏移64.
    //可以通过一个属性设置,取消掉这个偏移量
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    //textView
    _sinaTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 74, CGRectGetWidth([[UIScreen mainScreen]bounds])-20, 150)];
    _sinaTextView.font = [UIFont systemFontOfSize:17];
    _sinaTextView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_sinaTextView];
}

-(void)optionToolBar
{
    CGFloat height = 49;
    _toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-height, CGRectGetWidth(self.view.frame), height)];
    [self.view addSubview:_toolBar];

    //样式调整
    _toolBar.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    _toolBar.layer.borderWidth = 0.5;
    _toolBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    //添加按钮
    CGFloat buttonW = CGRectGetWidth(self.view.frame)/5;
    for (int i = 0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Tool_0%d",i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Tool_%dH",i]] forState:UIControlStateHighlighted];
//        //键盘和表情切换
//        if (i == 3) {
//            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Tool_0%dE",i]] forState:UIControlStateSelected];
//        }
        //位置
        button.frame = CGRectMake(buttonW*i, 0, buttonW, height);
        //绑定事件
        [button addTarget:self action:@selector(toolBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        
        [_toolBar addSubview:button];
    }
}

#pragma mark - NavItemAction
-(void)sendAction
{
    //将textView富文本的图片,替换成响应的chs文字
    NSLog(@"%@",_sinaTextView.attributedText.string);
    NSMutableString *mStr = [[NSMutableString alloc]initWithString:_sinaTextView.attributedText.string];
    
    //遍历富文本里面的图片附件
    [_sinaTextView.attributedText enumerateAttributesInRange:NSMakeRange(0, _sinaTextView.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        
        NSLog(@"%@",attrs);
        //attrs 给富文本添加的属性
        //range 这段文字在富文本中的位置和长度
        //BOOL *stop 跳出循环的标志 *stop = YES;
        //赋值为YES作用就是直接跳出循环
        //拿到附件对象
        NSTextAttachment *attachment = attrs[@"NSAttachment"];
        
        if (attachment) {
            
            //将图片替换成chs文字
            [mStr replaceCharactersInRange:range withString:attachment.chs];
        }
    }];
    
    NSLog(@"%@",mStr);

    if (mStr.length>0)
    {
        SinaTool *sinaTool = [[SinaTool alloc]init];
        [sinaTool sendSinaStatusWith:mStr];
    }
    
}

-(void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ToolBarAction
-(void)toolBarButtonAction:(UIButton*)sender
{
    switch (sender.tag) {
        case 0:{
            
            [self pushToPickerPhotoViewController];
            break;
        }
        case 1:{
            
            break;
        }
        case 2:{
            
            break;
        }
        case 3:{
            
            NSString *imgName = nil;
            NSString *imgNameH = nil;
            if (_sinaTextView.inputView) {
                //表情+键盘
                [self emojiKeyBoardIsHide:YES];
                imgName = @"Tool_03";
                imgNameH = @"Tool_3H";
            }else{
                [self emojiKeyBoardIsHide:NO];
                imgName = @"Tool_03E";
                imgNameH = @"Tool_3HE";
            }
            
            [sender setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:imgNameH] forState:UIControlStateHighlighted];
            
            
            break;
        }
        case 4:{
            
            break;
        }
            
            
        default:
            break;
    }
    
}

#pragma mark - KeyBoard
-(void)keyBoardChangeFrame:(NSNotification*)notification
{
    NSLog(@"键盘-修改");
    NSDictionary *dic = notification.userInfo;
    //取出键盘的frame
    CGRect keyBoardFrame = [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //动画
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         //动画速率
                         [UIView setAnimationCurve:7];
                         
                         CGRect frame = _toolBar.frame;
                         frame.origin.y = keyBoardFrame.origin.y-CGRectGetHeight(frame);
                         
                         _toolBar.frame = frame;
                     }];
}


//设置表情键盘的隐藏和显示
-(void)emojiKeyBoardIsHide:(BOOL)hide
{
    if (!_emojiCollectionView) {
        
        //创建自定义layout
        SinaEmojiLayout *emojiLayout = [[SinaEmojiLayout alloc]init];
        
        _emojiCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200) collectionViewLayout:emojiLayout];
        
        _emojiCollectionView.backgroundColor = [UIColor whiteColor];
        
        _emojiCollectionView.delegate = self;
        _emojiCollectionView.dataSource = self;
        _emojiCollectionView.pagingEnabled = YES;
        //注册自定义单元格
        [_emojiCollectionView registerClass:[SinaEmojiCollectionViewCell class
         ] forCellWithReuseIdentifier:@"cell"];
    }
    //系统的第一响应去掉
    [_sinaTextView resignFirstResponder];
    
    if (!hide) {
        _sinaTextView.inputView = _emojiCollectionView;
    }else{
        _sinaTextView.inputView = nil;
    }
    
    [_sinaTextView becomeFirstResponder];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //注销第一响应
    if ([_sinaTextView canResignFirstResponder]) {
        
        [_sinaTextView resignFirstResponder];
    }
}

#pragma mark - SinaPickerPhotoViewController Methods
-(void)pushToPickerPhotoViewController
{
    SinaPickerPhotoViewController *ctr = [[SinaPickerPhotoViewController alloc]init];
    ctr.delegate = self;
    ctr.pickePhotosArr = self.receivePhotos;
    NSLog(@"传出%@",self.receivePhotos);
    [self.navigationController pushViewController:ctr animated:YES];
}

-(void)deleteImageButtonAction:(UIButton*)sender
{
    if (sender.tag == self.receivePhotos.count) {
        [self pushToPickerPhotoViewController];
    }else{
        
        [self.receivePhotos removeObjectAtIndex:sender.tag];
        [_selectImageViews removeObjectAtIndex:sender.tag];
        [self resetSelectImageData];
    }
    
    
}

-(void)resetSelectImageData
{
    //选中的图片数组清空
    //[_selectImageViews removeAllObjects];
    
    for (SinaSelectImageView *imgView in _selectImgsBackgroundView.subviews){
        
        if ([imgView isKindOfClass:[SinaSelectImageView class]]) {
            
            if (imgView.tag<=self.receivePhotos.count) {
                
                imgView.hidden = NO;
                imgView.isAddButton = NO;
                
                if (imgView.tag == self.receivePhotos.count) {
                    imgView.image = [UIImage imageNamed:@"compose_pic_add_highlighted"];
                    imgView.isAddButton = YES;
                    continue;
                }
                SinaPhotoModel *model = self.receivePhotos[imgView.tag];
                imgView.image = model.image;
                
                if (![_selectImageViews containsObject:imgView]) {
                    //选中的图片添加到数组中
                    [_selectImageViews addObject:imgView];
                }
                
            }else{
                
                imgView.hidden = YES;
            }
        }
    }
    
    NSLog(@"重置%@",_selectImageViews);
}

-(void)pickerPhotoDidSelectedPhotos:(NSArray*)selectPhotos
{
    
    if (selectPhotos.count != 0) {
        
        [self.receivePhotos setArray:selectPhotos];
        NSLog(@"传入%@",self.receivePhotos);
        //懒加载
        if (!_selectImgsBackgroundView) {
            
            CGFloat bgW = CGRectGetWidth(self.view.frame);
            _selectImgsBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_sinaTextView.frame)+10, bgW, bgW)];
            
            [self.view insertSubview:_selectImgsBackgroundView belowSubview:_toolBar];
            
            //添加图片
            CGFloat imgW = (bgW-20)/3;
            for (int i = 0; i<9; i++) {
                
                CGFloat offsetX = (i%3)*(imgW+5)+5;
                CGFloat offsetY = (i/3)*(imgW+5);
                
                SinaSelectImageView *imgView = [[SinaSelectImageView alloc]initWithFrame:CGRectMake(offsetX, offsetY, imgW, imgW)];
                imgView.tag = i;
                imgView.deleteButton.tag = i;
                [imgView.deleteButton addTarget:self action:@selector(deleteImageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [_selectImgsBackgroundView addSubview:imgView];
                //给单个的imageView添加长按手势
                UILongPressGestureRecognizer *gestrue = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureAction:)];
                [imgView addGestureRecognizer:gestrue];
            }
        }
        
        //根据数据,处理图片的显示和隐藏
        [self resetSelectImageData];
    }
}
//长按手势触发
-(void)longPressGestureAction:(UILongPressGestureRecognizer*)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            //将手势控制的视图放在最上面
            [gesture.view.superview bringSubviewToFront:gesture.view];
            
            //效果:放大+透明
            [UIView animateWithDuration:0.3 animations:^{
                gesture.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
                gesture.view.alpha = 0.8;
            }];
            
            //开始
            _startPoint = [gesture locationInView:self.view];
            //视图起始的center
            _startCenter = gesture.view.center;
            
            break;
        }
        case UIGestureRecognizerStateChanged:{
            
            //手指在view上的位置
            CGPoint location = [gesture locationInView:self.view];
            
            //实时偏移量
            //location.x-_startPoint.x
            //开始的中心点+实时偏移量=更新后的中心点
            CGPoint center = gesture.view.center;
            center.x = _startCenter.x + (location.x-_startPoint.x);
            center.y = _startCenter.y + (location.y-_startPoint.y);
            
            gesture.view.center = center;
            
            //默认-1
            __block NSInteger rIndex = -1;
            
            //遍历数组,寻找被替换的对象
            [_selectImageViews enumerateObjectsUsingBlock:^(SinaSelectImageView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                //排除移动视图
                if (obj != gesture.view) {
                
                    //判断,移动视图的中心点,是否被其他某个视图所包含,如果包含表示移动视图要替换
                    if (CGRectContainsPoint(obj.frame, gesture.view.center)) {
                        //这个idx就是被替换的view的位置
                        NSLog(@"%ld",idx);
                        rIndex = idx;
                        //得到索引之后就跳出循环
                        *stop = YES;
                    }
                }
            }];
            
            //替换+移动
            if (rIndex!=-1) {
                //拿到原来的数据源
                NSInteger idx = [_selectImageViews indexOfObject:gesture.view];
                SinaPhotoModel *model = self.receivePhotos[idx];
                
                //更新数据源位置
                [self.receivePhotos removeObject:model];
                [self.receivePhotos insertObject:model atIndex:rIndex];
                
                //操作数组的替换
                [_selectImageViews removeObject:gesture.view];
                [_selectImageViews insertObject:gesture.view atIndex:rIndex];
                
                NSLog(@"更新后%@",_selectImageViews);
                
                //遍历数组,从新计算view的frame
                [UIView animateWithDuration:0.3 animations:^{
                    
                    [_selectImageViews enumerateObjectsUsingBlock:^(SinaSelectImageView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                       
    //先计算其他view的frame
    //排除当前拿起来的view
    if (obj != gesture.view) {
     
        CGRect frame = obj.frame;
        CGFloat imgW = CGRectGetWidth(frame);
        frame.origin.x =(idx%3)*(imgW+5)+5;
        frame.origin.y =(idx/3)*(imgW+5);
        obj.frame = frame;
        obj.tag = idx;//更新tag
        obj.deleteButton.tag = idx;
    }
                    }];
                }];
            }
            
            break;
        }
        case UIGestureRecognizerStateEnded:{
            //还原视图的默认状态
            [UIView animateWithDuration:0.3 animations:^{
                gesture.view.transform = CGAffineTransformIdentity;
                gesture.view.alpha = 1;
                
                //将操作的view'放在该放的位置
                NSInteger idx = [_selectImageViews indexOfObject:gesture.view];
                
                CGRect frame = gesture.view.frame;
                CGFloat imgW = CGRectGetWidth(frame);
                frame.origin.x =(idx%3)*(imgW+5)+5;
                frame.origin.y =(idx/3)*(imgW+5);
                gesture.view.frame = frame;
                gesture.view.tag = idx;//更新tag
                ((SinaSelectImageView*)gesture.view).deleteButton.tag = idx;
            }];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [SinaEmoticonManager shareManager].emoticonPackages.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    SinaEmoticonPackage *package = [SinaEmoticonManager shareManager].emoticonPackages[section];
    return package.emoticons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SinaEmojiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    SinaEmoticonPackage *package = [SinaEmoticonManager shareManager].emoticonPackages[indexPath.section];
    
    SinaEmoticon *emoticon = package.emoticons[indexPath.row];
    
    //1,现将cell状态置空
    cell.imageView.hidden = YES;
    cell.emojiLabel.hidden = YES;
    
    if (emoticon.type.integerValue == KEmoticonImageType ) {
        
        NSString *pngPath =
        [[[SinaEmoticonManager shareManager].bundlePath stringByAppendingPathComponent:package.packageId] stringByAppendingPathComponent:emoticon.png];
        cell.imageView.hidden = NO;
        cell.imageView.image = [UIImage imageWithContentsOfFile:pngPath];
        
    }else if (emoticon.type.integerValue == KEmoticonEmojiType){
        
        cell.emojiLabel.hidden = NO;
        cell.emojiLabel.text = emoticon.emoji;
        
    }else if (emoticon.type.integerValue == KEmoticonDeleteType){
        cell.imageView.hidden = NO;
        cell.imageView.image =[UIImage imageNamed:emoticon.png] ;
        
    }else if (emoticon.type.integerValue == KEmoticonOtherType){
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SinaEmoticonPackage *package = [SinaEmoticonManager shareManager].emoticonPackages[indexPath.section];
    
    SinaEmoticon *emoticon = package.emoticons[indexPath.row];
    
    switch (emoticon.type.integerValue) {
        case KEmoticonEmojiType:{
            //添加文字
            //表情的富文本
            NSAttributedString *emojiStr = [[NSAttributedString alloc]initWithString:emoticon.emoji];
            //获得当前文字的富文本
            NSMutableAttributedString *mAtStr = [[NSMutableAttributedString alloc]initWithAttributedString:_sinaTextView.attributedText];
            
            NSRange range = _sinaTextView.selectedRange;
            
            [mAtStr replaceCharactersInRange:range withAttributedString:emojiStr];
            
            _sinaTextView.attributedText = mAtStr;
            
            
            _sinaTextView.selectedRange = NSMakeRange(range.location+emoticon.emoji.length, 0);
            break;
        }
        case KEmoticonImageType:{
            //添加图片
            //创建一个附件代图片
            NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
            
            NSString *pngPath =
            [[[SinaEmoticonManager shareManager].bundlePath stringByAppendingPathComponent:package.packageId] stringByAppendingPathComponent:emoticon.png];
            
            //给附件添加图片
            attachment.image = [UIImage imageWithContentsOfFile:pngPath];
            //给附件添加chs(表情文字表示)
            attachment.chs = emoticon.chs;
            
            //设置大小
            attachment.bounds = CGRectMake(0, 0, 20, 20);
            //根据附件创建富文本
            NSAttributedString *atStr = [NSAttributedString attributedStringWithAttachment:attachment];
            //获得当前文字的富文本
            NSMutableAttributedString *mAtStr = [[NSMutableAttributedString alloc]initWithAttributedString:_sinaTextView.attributedText];
            
            //获得光标的位置
            NSRange range = _sinaTextView.selectedRange;
            //替换
            [mAtStr replaceCharactersInRange:range withAttributedString:atStr];
            
            //更新当前的展示内容
            _sinaTextView.attributedText = mAtStr;
            //更新光标的位置
            //光标的location是光标的位置
            //光标的length是选中文字的长度
            _sinaTextView.selectedRange = NSMakeRange(range.location+1, 0);
            
            break;
        }
        case KEmoticonDeleteType:{
            //删除操作
            [_sinaTextView deleteBackward];
            break;
        }
        case KEmoticonOtherType:{
            //空的
            break;
        }
        default:
            break;
    }
    
}




@end
