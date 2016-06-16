//
//  SinaMenuViewController.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/27.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import "SinaMenuViewController.h"
#import "SendMessageViewController.h"
#import "AppDelegate.h"
#define TAG_ADD 100

@interface EffectButton : UIButton
@property(nonatomic,assign)CGPoint startPoint;
@property(nonatomic,assign)CGPoint endPoint;
@property(nonatomic,assign)CGPoint farPoint;
@end

@implementation EffectButton

@end



@interface SinaMenuViewController ()
{
    NSInteger _flag;//按钮的当前索引
    NSInteger _currentFlag;
    NSTimer *_timer;
    NSMutableArray *_menusArr;
}
@end

@implementation SinaMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _menusArr = [[NSMutableArray alloc]init];
    [self blurEffectView];
    [self optionsEffectButton];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self isShow:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)optionsEffectButton
{
    
    CGFloat btnW = 81;
    CGFloat gap = CGRectGetWidth(self.view.frame)/4;
    for (int i = 0; i<6; i++) {
        
        EffectButton *btn = [EffectButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + TAG_ADD;
        [btn addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [_menusArr addObject:btn];
        //大小+图片+文字
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab-%d",i]] forState:UIControlStateNormal];
        [btn setTitle:@"aaa" forState:UIControlStateNormal];
        //图片和文字,都有一个edge距上下左右的边距
        //图片的上左下是依据button的,右是依据label
        //label上右下是依据button的,左是依据imgView的
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(80, -81, -10, 0)];
        
        //图片大小 71
        //还有文字,按钮的大小不能小于71
        btn.bounds = CGRectMake(0, 0, btnW, btnW);
        
        CGFloat viewH = CGRectGetHeight(self.view.frame)/2;
        CGFloat offsetY = (i/3==0)?viewH-btnW:viewH+btnW;
        //计算位置 - 开始 - 结束 - 远端
        btn.startPoint = CGPointMake((i%3+1)*gap, CGRectGetHeight(self.view.frame)+btnW);
        
        btn.endPoint = CGPointMake((i%3+1)*gap,offsetY);
        
        btn.farPoint = CGPointMake((i%3+1)*gap,offsetY-30);
        
        btn.center = btn.startPoint;
        
    }
}

//毛玻璃效果
-(void)blurEffectView
{
    //1,效果对象
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    //2,创建一个用于显示效果的view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    effectView.frame = self.view.frame;
    [self.view addSubview:effectView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self isShow:NO];
    [self performSelector:@selector(dismissViewControllerAnimated:completion:) withObject:nil afterDelay:0.5];
//    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)menuButtonAction:(EffectButton*)sender
{
    _currentFlag = sender.tag;
    [self enlargeWithButton:sender];
    
    for (EffectButton *btn in _menusArr) {
        if (btn==sender) {
            continue;
        }
        [self smallWithButton:btn];
    }
}

#pragma mark - 动画
-(void)isShow:(BOOL)isShow
{
    //根据是否显示,判断flag的初始值
    _flag = isShow?0:5;
    //根据是否显示,判断调用动画的方法
    SEL select = isShow?@selector(show):@selector(hide);
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:select userInfo:nil repeats:YES];
    }
    
    
}

//显示menu
-(void)show{
    
    //NSLog(@"==========");
    if (_flag == 5) {
        //销毁timer
        [_timer invalidate];
        _timer = nil;
    }
    
    EffectButton *btn = [self.view viewWithTag:_flag+TAG_ADD];
    //动画 - position
    CAKeyframeAnimation *showAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    showAn.removedOnCompletion = NO;
    showAn.fillMode = kCAFillModeForwards;
    showAn.duration = 0.5;
    
    //添加一个动画路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, btn.startPoint.x, btn.startPoint.y);
    CGPathAddLineToPoint(path, NULL, btn.farPoint.x, btn.farPoint.y);
    CGPathAddLineToPoint(path, NULL, btn.endPoint.x, btn.endPoint.y);
    showAn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    showAn.path = path;
    [btn.layer addAnimation:showAn forKey:@"show"];
    btn.center = btn.endPoint;
    _flag++;
    
}


//隐藏menu
-(void)hide{
    
    if (_flag == 0) {
        //销毁timer
        [_timer invalidate];
        _timer = nil;
    }
    
    EffectButton *btn = [self.view viewWithTag:_flag+TAG_ADD];
    
    //动画 - position
    CAKeyframeAnimation *showAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    showAn.removedOnCompletion = NO;
    showAn.fillMode = kCAFillModeForwards;
    showAn.duration = 0.3;
    
    //添加一个动画路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, btn.endPoint.x, btn.endPoint.y);
    CGPathAddLineToPoint(path, NULL, btn.startPoint.x, btn.startPoint.y);
    
    showAn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    showAn.path = path;
    [btn.layer addAnimation:showAn forKey:@"hide"];
    btn.center = btn.startPoint;
    //动画
    _flag -- ;
}


-(void)enlargeWithButton:(EffectButton*)button
{
    CABasicAnimation *base = [CABasicAnimation animationWithKeyPath:@"transform"];
    base.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.toValue = @(0);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.duration = 0.3;
    group.animations = @[base,opacity];
    group.delegate = self;
    [button.layer addAnimation:group forKey:@"enlarge"];
}

-(void)smallWithButton:(EffectButton*)button
{
    CABasicAnimation *base = [CABasicAnimation animationWithKeyPath:@"transform"];
    base.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
    base.removedOnCompletion = NO;
    base.fillMode = kCAFillModeForwards;
    base.duration = 0.3;
    [button.layer addAnimation:base forKey:@"small"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    EffectButton *btn = [self.view viewWithTag:_currentFlag];
    
    CAAnimation *an =
    [btn.layer animationForKey:@"enlarge"];
    if (an == anim) {
        
        [self dismissViewControllerAnimated:NO completion:^{
            
            SendMessageViewController *sendCtr = [[SendMessageViewController alloc]init];
            UINavigationController *navCtr = [[UINavigationController alloc]initWithRootViewController:sendCtr];
            
            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [delegate.window.rootViewController presentViewController:navCtr animated:YES completion:nil];
        }];
    }
    
}

@end








