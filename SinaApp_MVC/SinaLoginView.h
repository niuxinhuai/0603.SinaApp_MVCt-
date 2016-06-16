//
//  SinaLoginView.h
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/18.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import <UIKit/UIKit.h>

//1,将授权web页面显示
//2,获得code

@class SinaLoginView;

@protocol SinaLoginViewDelegate <NSObject>
//必须的
@required

//可选的
@optional
//获得codeStirng
-(void)loginView:(SinaLoginView*)loginView didGetCodeString:(NSString*)codeString;

//获得请求Error
-(void)loginView:(SinaLoginView*)loginView didFailWithError:(NSError*)error;
@end


@interface SinaLoginView : UIView<UIWebViewDelegate>
//显示授权页面的webView
@property(strong,nonatomic)UIWebView *sinaWebView;
@property(assign,nonatomic)id<SinaLoginViewDelegate>delegate;

-(void)startOauthRequest:(NSURLRequest*)request;
@end












