//
//  HaHaMenuBaseNavController.m
//  KDCP
//
//  Created by Maker on 2019/3/6.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "HaHaNavController.h"

@interface HaHaNavController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic ,strong) id popDelegate;
@end

@implementation HaHaNavController

// 设置导航栏的主题
+ (void)load {
    
    // 设置导航样式
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    navBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    
//    [self.navigationBar setShadowImage:[UIImage new]]; // 去除navBar下的1px的横线
//    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Medim" size:17]}];
    // 设置导航控制器的代理
    self.delegate = self;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count == 1) { // 根控制器
       
        // 如果是根控制器,设回手势代理
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = YES; //viewController是将要被push的控制器
    }
    if (self.childViewControllers.count) { // 非根控制器
        viewController.hidesBottomBarWhenPushed = YES;
        UIImage *backImage = [[UIImage imageNamed:@"nav_back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:0 target:self action:@selector(back)];
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

#pragma mark - 转屏控制
// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return [self.visibleViewController shouldAutorotate];
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.visibleViewController supportedInterfaceOrientations];
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

#pragma mark - 状态栏控制
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.visibleViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.visibleViewController;
}
@end
