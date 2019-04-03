//
//  AppDelegate.m
//  HAHA
//
//  Created by ZDD on 2019/3/29.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import "TEMPAppDelegate.h"

#import "TEMPSDKManager.h"
#import "TEMPLaunchManager.h"
@interface TEMPAppDelegate ()

@end

@implementation TEMPAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[TEMPSDKManager defaultManager] launchInWindow:self.window options:launchOptions];
    [[TEMPLaunchManager defaultManager] launchInWindow:self.window];
    return YES;
}

@end
