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

#import <AVOSCloud/AVOSCloud.h>
#import <XHLaunchAd.h>
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
    
    
    
    [AVOSCloud setApplicationId:@"rN3UH4G0QkLlbKJ7eieJO4qO-gzGzoHsz" clientKey:@"pkFdKBOmTbhkykbhLobM9fVE"];

    
    
    ZDDThemeConfiguration *theme = [ZDDThemeConfiguration defaultConfiguration];

//    只需要在这里修改如下5个主题颜色即可，注意颜色搭配和理性:
    theme.naviTitleColor = [UIColor colorWithRed:51 green:51 blue:51];
////    theme.naviTintColor =
    theme.themeColor = [UIColor colorWithRed:19 green:142 blue:158];
    theme.normalTabColor = theme.naviTitleColor;
    theme.selectTabColor = theme.naviTitleColor;
    theme.addButtonColor = [UIColor whiteColor];
    //NavigationBar 和 TabBar 偏好设置
    NSDictionary *dict = [NSDictionary dictionaryWithObject:theme.naviTitleColor forKey:NSForegroundColorAttributeName];
    [UINavigationBar appearance].titleTextAttributes = dict;
    [[UINavigationBar appearance] setTintColor:theme.naviTintColor];
    [[UINavigationBar appearance] setBarTintColor:theme.themeColor];
    [[UITabBar appearance] setBarTintColor:theme.themeColor];
    [[UITabBar appearance] setTintColor:theme.selectTabColor];
    [[UITabBar appearance] setUnselectedItemTintColor:theme.normalTabColor];
    BOOL isDark = [theme.themeColor isDarkColor];
    [UIApplication sharedApplication].statusBarStyle = isDark ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
    
    
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchScreen];
    [XHLaunchAd setWaitDataDuration:5];
    
//    [MFNETWROK get:@"advertisement" params:nil success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
//        NSLog(@"%@", result);
//        if (![result[@"code"] integerValue]) {
//            GODAdModel *model = [GODAdModel yy_modelWithJSON:result];
//            //配置广告数据
//            XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
//            imageAdconfiguration.duration = 5;
//            imageAdconfiguration.frame = [UIScreen mainScreen].bounds;
//            imageAdconfiguration.imageNameOrURLString = [NSString stringWithFormat:@"%@%@",BASE_AVATAR_URL, model.urlString];
//            imageAdconfiguration.GIFImageCycleOnce = NO;
//            imageAdconfiguration.imageOption = XHLaunchAdImageCacheInBackground;
//            imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
//            imageAdconfiguration.showFinishAnimate = ShowFinishAnimateLite;
//            imageAdconfiguration.showFinishAnimateTime = 0.8;
//            imageAdconfiguration.skipButtonType = SkipTypeTimeText;
//            imageAdconfiguration.showEnterForeground = NO;
//            //显示开屏广告
//            [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
//        }else {
//            XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
//            imageAdconfiguration.imageNameOrURLString = @"ad.jpg";
//            [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
//        }
//    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
//        XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
//        imageAdconfiguration.imageNameOrURLString = @"ad.jpg";
//        [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
//    }];
    
    
    AVQuery *query = [AVQuery queryWithClassName:@"Config"];
    [query orderByDescending:@"createdAt"];
    // owner 为 Pointer，指向 _User 表
    [query includeKey:@"type"];
    // image 为 File
    [query includeKey:@"urlString"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            AVObject *testObject = objects.firstObject;
            NSInteger type = [[testObject objectForKey:@"type"] integerValue];
            NSString *urlString = [testObject objectForKey:@"urlString"];
            
            if (type && urlString.length) {
                GODWebViewController *webController = [[GODWebViewController alloc] init];
                webController.urlString = urlString;
                UINavigationController *webNavi = [[UINavigationController alloc] initWithRootViewController:webController];
                window.rootViewController = webNavi;
                window.backgroundColor = [UIColor whiteColor];
                [window makeKeyAndVisible];
            }else {
                ZDDTabBarController *tabBarController = [[ZDDTabBarController alloc] initWithCenterButton:NO];
                window.rootViewController = tabBarController;
                window.backgroundColor = [UIColor whiteColor];
                [window makeKeyAndVisible];
            }
        }else {
            ZDDTabBarController *tabBarController = [[ZDDTabBarController alloc] initWithCenterButton:YES];
            window.rootViewController = tabBarController;
            window.backgroundColor = [UIColor whiteColor];
            [window makeKeyAndVisible];
        }
    }];
    
    
    
    
}
@end
