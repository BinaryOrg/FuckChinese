//
//  AppDelegate.m
//  HAHA
//
//  Created by HaHa on 2019/3/29.
//  Copyright © 2019 HaHa. All rights reserved.
//

#import "HaHaAppDelegate.h"

#import "TEMPSDKManager.h"
#import "TEMPLaunchManager.h"
@interface HaHaAppDelegate ()

@end

@implementation HaHaAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[TEMPSDKManager defaultManager] launchInWindow:self.window options:launchOptions];
    [[TEMPLaunchManager defaultManager] launchInWindow:self.window];
    return YES;
}

@end
