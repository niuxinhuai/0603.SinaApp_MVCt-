//
//  SinaTool.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/18.
//  Copyright © 2016年 SuperWang. All rights reserved.
//
#define APP_KEY @"980324780"
#define APP_SECRET @"5bdaff02161133015d1adabce78c015b"
#define REDIRECT_URL @"http://www.baidu.com"

#define TOKEN_KEY @"access_token"
#define TOKEN_TIME_KEY @"expires_in"

#import "SinaTool.h"
#import "AFNetworking.h"
#import "DataModels.h"
@implementation SinaTool

-(NSString*)getToken
{
    return
    [[NSUserDefaults standardUserDefaults]objectForKey:TOKEN_KEY];
    
}

//是否登录
-(BOOL)isLogin
{
    //判断是否有token
    NSString *tokenString = [[NSUserDefaults standardUserDefaults]objectForKey:TOKEN_KEY];
    NSLog(@"%@",tokenString);
    //如果存在证明登录过
    if (!tokenString) {
        return NO;
    }
    return YES;
}

//判断是否过期
-(BOOL)isValid
{
    //先取出时间
    NSDate *tokenDate = [[NSUserDefaults standardUserDefaults]objectForKey:TOKEN_TIME_KEY];
    
    //距离现在时间的秒数
    NSTimeInterval interval = [tokenDate timeIntervalSinceNow];
    
    if (interval<=0) {
        return NO;
    }
    return YES;
}



#pragma mark - 新浪API
//请求授权
-(NSURLRequest*)oauthRequest
{
    NSString *urlString =
    [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",APP_KEY,REDIRECT_URL];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *reqesut = [NSURLRequest requestWithURL:url];
    
    return reqesut;
}

//获得授权
-(void)getAccessTokenWithCode:(NSString*)code
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //参数
    NSDictionary *parametersDic = @{@"client_id":APP_KEY,@"client_secret":APP_SECRET,@"grant_type":@"authorization_code",@"code":code,@"redirect_uri":REDIRECT_URL};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];;
    //post请求
    [manager POST:@"https://api.weibo.com/oauth2/access_token" parameters:parametersDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        /*
         {
         "access_token": "ACCESS_TOKEN",
         "expires_in": 1234,
         "remind_in":"798114",
         "uid":"12341234"
         }
         */
        //获得token
        //取出token
        NSString *tokenString = [responseObject objectForKey:TOKEN_KEY];
        
        //将token传递出去
        if ([_delegate respondsToSelector:@selector(sinaTool:didGetToken:)]) {
            
            [_delegate sinaTool:self didGetToken:tokenString];
        }
        
        //取出过期时间
        NSString *timeString = [responseObject objectForKey:TOKEN_TIME_KEY];
        
        NSDate *tokenDate = [NSDate dateWithTimeIntervalSinceNow:timeString.doubleValue];
        
        //将授权过的token和过期时间保持到本地
        [[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:TOKEN_KEY];
        
        [[NSUserDefaults standardUserDefaults]setObject:tokenDate forKey:TOKEN_TIME_KEY];
        //同步
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //传递error
        if ([_delegate respondsToSelector:@selector(sinaTool:didFailedWithError:)]) {
            
            [_delegate sinaTool:self didFailedWithError:error];
        }
    }];
}


//homeLineData
-(void)getHomeTimeLineWithToken:(NSString*)tokenString
{
//    https://api.weibo.com/2/statuses/home_timeline.json
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:@{TOKEN_KEY:tokenString} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //将字典转换成model
        SinaHomeLineModel *model = [SinaHomeLineModel modelObjectWithDictionary:responseObject];
        
        //将微博数组传递出去
        if ([_delegate respondsToSelector:@selector(sinaTool:didGetHomeLine:)]) {
            
            [_delegate sinaTool:self didGetHomeLine:model.statuses];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //传递error
        if ([_delegate respondsToSelector:@selector(sinaTool:didFailedWithError:)]) {
            
            [_delegate sinaTool:self didFailedWithError:error];
        }
        
    }];
}


-(void)sendSinaStatusWith:(NSString*)statu
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"https://api.weibo.com/2/statuses/update.json" parameters:@{TOKEN_KEY:[self getToken],@"status":statu} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        //传递error
        if ([_delegate respondsToSelector:@selector(sinaTool:didFailedWithError:)]) {
            
            [_delegate sinaTool:self didFailedWithError:error];
        }
        
    }];
}















@end
