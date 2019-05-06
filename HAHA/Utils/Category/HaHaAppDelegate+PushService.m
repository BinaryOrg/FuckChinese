//
//  ZTWAppDelegate+PushService.m
//  ZhiYun
//
//  Created by 张冬冬 on 2019/2/12.
//  Copyright © 2019 张冬冬. All rights reserved.
//

#import "HaHaAppDelegate+PushService.h"

#import <JPush/JPUSHService.h>
@implementation HaHaAppDelegate (PushService)

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

@end
