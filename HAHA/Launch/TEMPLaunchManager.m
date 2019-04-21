//
//  TEMPLaunchManager.m
//  Template
//
//  Created by 张冬冬 on 2019/3/5.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "TEMPLaunchManager.h"
#import "UIColor+ZDDColor.h"

#import "ZDDThemeConfiguration.h"
#import "ZDDTabBarController.h"

#import "UIColor+CustomColors.h"
#import "GODWebViewController.h"
#import "YMHLVideoFlowViewController.h"

@implementation TEMPLaunchManager
+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static TEMPLaunchManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)launchInWindow:(UIWindow *)window {
    
    
    
    
    
    ZDDThemeConfiguration *theme = [ZDDThemeConfiguration defaultConfiguration];

//    只需要在这里修改如下5个主题颜色即可，注意颜色搭配和理性:
    theme.naviTitleColor = [UIColor colorWithRed:51 green:51 blue:51];
////    theme.naviTintColor =
    theme.themeColor = [UIColor colorWithRed:250 green:227 blue:79];
    theme.normalTabColor = [UIColor colorWithRed:151 green:151 blue:151];
    theme.selectTabColor = theme.naviTitleColor;
    theme.addButtonColor = [UIColor whiteColor];
    //NavigationBar 和 TabBar 偏好设置
    NSDictionary *dict = [NSDictionary dictionaryWithObject:theme.naviTitleColor forKey:NSForegroundColorAttributeName];
    [UINavigationBar appearance].titleTextAttributes = dict;
    [[UINavigationBar appearance] setTintColor:theme.naviTintColor];
    [[UINavigationBar appearance] setBarTintColor:theme.themeColor];
    [[UITabBar appearance] setBarTintColor:theme.themeColor];
    
    [[UITabBar appearance] setTintColor:theme.selectTabColor];
    if (@available(iOS 10.0, *)) {
        [[UITabBar appearance] setUnselectedItemTintColor:theme.normalTabColor];
    } else {
        // Fallback on earlier versions
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    ZDDTabBarController *tabBarController = [[ZDDTabBarController alloc] initWithCenterButton:NO];
    window.rootViewController = tabBarController;
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    
    
}
@end
