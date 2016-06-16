//
//  SinaTool.h
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/18.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import <Foundation/Foundation.h>

//sinaTool所有的sina相关的业务封装

//1,获得授权
//2,判断Token是否过期
//3,是否登录
//4,跟新浪相关的API请求:发微博,查homeline

@class SinaTool;
@protocol SinaToolDelegate <NSObject>

@optional
//获得token
-(void)sinaTool:(SinaTool*)sinaTool didGetToken:(NSString*)token;
//获得数据
-(void)sinaTool:(SinaTool*)sinaTool didGetHomeLine:(NSArray*)array;
//获得error
-(void)sinaTool:(SinaTool*)sinaTool didFailedWithError:(NSError*)error;
@end

@interface SinaTool : NSObject
@property(assign,nonatomic)id<SinaToolDelegate>delegate;

//获得token
-(NSString*)getToken;
//是否登录
-(BOOL)isLogin;
//判断是否过期
-(BOOL)isValid;
//请求授权
-(NSURLRequest*)oauthRequest;
//获得授权
-(void)getAccessTokenWithCode:(NSString*)code;

//获取微博 homeTimeline
-(void)getHomeTimeLineWithToken:(NSString*)tokenString;
//发布微博
-(void)sendSinaStatusWith:(NSString*)statu;
@end












