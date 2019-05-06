//
//  HaHaTabBarController.m
//  Template
//
//  Created by 张冬冬 on 2019/2/19.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "HaHaTabBarController.h"
#import "ZDDThemeConfiguration.h"
#import "TEMPMacro.h"

#import "HaHaNavController.h"

#import "HaHaThridController.h"
#import "HaHaSecondController.h"
#import "HaHaFirstController.h"
#import "HaHaFirstBaseController.h"

@interface HaHaTabBarController ()
<
UITabBarControllerDelegate
>
@end

@implementation HaHaTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZDDThemeConfiguration *theme = [ZDDThemeConfiguration defaultConfiguration];
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: theme.selectTabColor} forState:UIControlStateSelected];
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: theme.normalTabColor} forState:UIControlStateNormal];
    [self setupChildViewControllers];
    self.delegate = self;

}

- (void)setupChildViewControllers {
    
    HaHaFirstController *one = [[HaHaFirstController alloc] init];
    [self addChileVcWithTitle:@"笑笑" vc:one imageName:@"lauth_unSelected" selImageName:@"lauth_selected"];
    
//    HaHaFirstBaseController *second = [[HaHaFirstBaseController alloc] init];
//    [self addChileVcWithTitle:@"笑笑" vc:second imageName:@"video_unSelected" selImageName:@"video_selected"];
   
//    YMHLVideoFlowViewController *second = [[YMHLVideoFlowViewController alloc] init];
//    [self addChileVcWithTitle:@"视频" vc:second imageName:@"video_unSelected" selImageName:@"video_selected"];
    
    
    HaHaSecondController *three = [[HaHaSecondController alloc] init];
    [self addChileVcWithTitle:@"动态" vc:three imageName:@"dynamic_unSelected" selImageName:@"dynamic_selected"];
    
    
    HaHaThridController *four = [[HaHaThridController alloc] init];
    [self addChileVcWithTitle:@"我的" vc:four imageName:@"mine_unSelected" selImageName:@"mine_selected"];
    
}

- (void)addChileVcWithTitle:(NSString *)title vc:(UIViewController *)vc imageName:(NSString *)imageName selImageName:(NSString *)selImageName {
    [vc.tabBarItem setTitle:title];
    if (title.length) {
        vc.title = title;
        [vc.tabBarItem setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [vc.tabBarItem setSelectedImage:[[UIImage imageNamed:selImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }
    HaHaNavController *navVc = [[HaHaNavController alloc] initWithRootViewController:vc];
    [self addChildViewController:navVc];
}

@end
