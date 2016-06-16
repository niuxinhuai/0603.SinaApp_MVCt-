//
//  SinaLoginView.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/18.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import "SinaLoginView.h"

@implementation SinaLoginView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//开始授权
-(void)startOauthRequest:(NSURLRequest*)request
{
    //webView的初始化
    if (!_sinaWebView) {
        _sinaWebView = [[UIWebView alloc]initWithFrame:self.frame];
    }
    //先设置代理
    [_sinaWebView setDelegate:self];
    //加载request
    [_sinaWebView loadRequest:request];
    
    [self addSubview:_sinaWebView];
}

#pragma mark - UIWebViewDelegate
//webViewRequest
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //截取url中code
    NSString *urlString = request.URL.absoluteString;
    
    //检查string中是否包含code=
    NSString *cutString = @"code=";
    
    NSRange codeRange = [urlString rangeOfString:cutString];
    
    if (codeRange.length>0) {
        //如果有code进行截取
        NSArray *subStrings = [urlString componentsSeparatedByString:cutString];
        
        //获得code
        NSString *codeString = [subStrings lastObject];
        //通过delegate的方式将codeString传递出去
        if ([_delegate respondsToSelector:@selector(loginView:didGetCodeString:)]) {
            [_delegate loginView:self didGetCodeString:codeString];
        }
    
        //备注:因为loginView是view即使拿到code也不能在这里写逻辑代码,必须将codeString传递出去
        //开发过程中常用的传递数据的方式有
        //1,Delegate(常用)
        //2,Block(常用)
        //3,Notification
        //4,KVO
        
        //将webView移除
        [webView removeFromSuperview];
        
        //停止继续加载webView的request
        return NO;
    }
    return YES;
}

//错误信息
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    //通过delegate将error传递出去
    if ([_delegate respondsToSelector:@selector(loginView:didFailWithError:)]) {
        [_delegate loginView:self didFailWithError:error];
    }
    
}








@end











