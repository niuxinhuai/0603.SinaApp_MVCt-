//
//  AppDelegate.m
//  SinaApp_MVC
//
//  Created by SuperWang on 16/5/18.
//  Copyright © 2016年 SuperWang. All rights reserved.
//

#import "AppDelegate.h"

#import "SinaViewController.h"
#import "MessageViewController.h"
#import "SearchViewController.h"
#import "SettingViewController.h"
#import "SinaMenuViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [self setUpTabBarItemTextAttributes];
    UITabBarController *rootTabBarController = [[UITabBarController alloc]init];
    //sina
    SinaViewController *sinaViewController = [[SinaViewController alloc]init];
    sinaViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[[UIImage imageNamed:@"tabbar_home_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    //message
    MessageViewController *messageViewController = [[MessageViewController alloc]init];
    messageViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"消息" image:[UIImage imageNamed:@"tabbar_message_center"] selectedImage:[[UIImage imageNamed:@"tabbar_message_center_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    //search
    SearchViewController *searchViewController = [[SearchViewController alloc]init];
    searchViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"发现" image:[UIImage imageNamed:@"tabbar_discover"] selectedImage:[[UIImage imageNamed:@"tabbar_discover_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //setting
    SettingViewController *settingViewController = [[SettingViewController alloc]init];
    settingViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我" image:[UIImage imageNamed:@"tabbar_profile"] selectedImage:[[UIImage imageNamed:@"tabbar_profile_highlighted"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //中间的
    SettingViewController *midController = [[SettingViewController alloc]init];
    midController.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:nil selectedImage:nil];
    
    //填充
    rootTabBarController.viewControllers = @[sinaViewController,messageViewController,midController,searchViewController,settingViewController];
    //中间默认图片
    UIImage *image = [UIImage imageNamed:@"tabbar_compose_button"];
    
    //高亮图片
    UIImage *image1 = [UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [btn setImage:[image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    btn.center = rootTabBarController.tabBar.center;
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (image.size.height>CGRectGetHeight(rootTabBarController.tabBar.frame))
    {
        CGFloat dff = image.size.height - CGRectGetHeight(rootTabBarController.tabBar.frame);
        btn.center = CGPointMake(rootTabBarController.tabBar.center.x, rootTabBarController.tabBar.center.y-dff);
    }
    [rootTabBarController.view addSubview:btn];
    
    
    self.window.rootViewController = rootTabBarController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}
//中间按钮的点击事件
-(void)btnClick
{
    SinaMenuViewController *menuCtr = [[SinaMenuViewController alloc]init];
    //判断系统版本
    if ([UIDevice currentDevice].systemVersion.floatValue>=8) {
        
        menuCtr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }else{
        menuCtr.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    
    [self.window.rootViewController presentViewController:menuCtr animated:NO completion:nil];
}
//设置文字颜色
-(void)setUpTabBarItemTextAttributes
{
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    
    //设置文字属性
    UITabBarItem *tabBar =[UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
